-- ============================================================
-- Helios Finance — views agregat & RPC (DASH-1, BUD-4, prd.md)
-- Jalankan SETELAH schema.sql: Dashboard → SQL Editor → New query → paste → Run.
-- Idempoten: aman dijalankan berulang.
-- Semua view memakai filter user_id = auth.uid() eksplisit sehingga
-- tetap aman meski view dieksekusi dengan hak pemilik (definer).
-- ============================================================

-- ------------------------------------------------------------
-- 1. Arus kas bulanan 12 bulan terakhir (DASH-7, DASH-8)
--    Bentuk baris: { month: date, income_total, expense_total }
-- ------------------------------------------------------------
create or replace view public.v_monthly_cashflow as
with months as (
  select generate_series(
    date_trunc('month', (now() at time zone 'Asia/Jakarta')::date) - interval '11 months',
    date_trunc('month', (now() at time zone 'Asia/Jakarta')::date),
    interval '1 month'
  )::date as month
),
agg as (
  select
    date_trunc('month', t.transaction_date)::date as month,
    coalesce(sum(t.amount) filter (where t.type = 'income'), 0)::numeric(18, 2) as income_total,
    coalesce(sum(t.amount) filter (where t.type = 'expense'), 0)::numeric(18, 2) as expense_total
  from public.transactions t
  where t.user_id = auth.uid()
  group by 1
)
select
  m.month,
  coalesce(a.income_total, 0)::numeric(18, 2) as income_total,
  coalesce(a.expense_total, 0)::numeric(18, 2) as expense_total
from months m
left join agg a on a.month = m.month;

-- ------------------------------------------------------------
-- 2. Distribusi pengeluaran per kategori, bulan berjalan (DASH-5)
-- ------------------------------------------------------------
create or replace view public.v_category_distribution as
select
  t.category_id,
  coalesce(sum(t.amount), 0)::numeric(18, 2) as total
from public.transactions t
where t.user_id = auth.uid()
  and t.type = 'expense'
  and t.transaction_date >= date_trunc('month', (now() at time zone 'Asia/Jakarta')::date)
  and t.transaction_date <  date_trunc('month', (now() at time zone 'Asia/Jakarta')::date) + interval '1 month'
group by t.category_id;

-- ------------------------------------------------------------
-- 3. Ringkasan anggaran: batas + realisasi bulan berjalan (BUD-4)
--    spent_amount dihitung, tidak disimpan (lihat schema.sql).
-- ------------------------------------------------------------
create or replace view public.v_budget_summary as
with spent as (
  select
    t.category_id,
    coalesce(sum(t.amount), 0)::numeric(18, 2) as total
  from public.transactions t
  where t.user_id = auth.uid()
    and t.type = 'expense'
    and t.transaction_date >= date_trunc('month', (now() at time zone 'Asia/Jakarta')::date)
    and t.transaction_date <  date_trunc('month', (now() at time zone 'Asia/Jakarta')::date) + interval '1 month'
  group by t.category_id
)
select
  b.category_id,
  b.monthly_limit,
  coalesce(s.total, 0)::numeric(18, 2) as spent_amount
from public.budgets b
left join spent s on s.category_id = b.category_id
where b.user_id = auth.uid();

-- ------------------------------------------------------------
-- 4. Ringkasan dashboard (DASH-1 — RPC/Database View wajib)
--    Satu baris selalu dikembalikan, termasuk untuk akun tanpa data.
--    total_balance = total pemasukan − total pengeluaran seluruh riwayat.
--    delta_*       = perubahan bulan berjalan vs bulan sebelumnya.
-- ------------------------------------------------------------
create or replace view public.v_dashboard_summary as
with bounds as (
  select date_trunc('month', (now() at time zone 'Asia/Jakarta')::date)::date as month_start
),
tx as (
  select t.type, t.amount, t.transaction_date
  from public.transactions t
  where t.user_id = auth.uid()
),
all_time as (
  select
    coalesce(sum(amount) filter (where type = 'income'), 0)::numeric(18, 2) as income_total,
    coalesce(sum(amount) filter (where type = 'expense'), 0)::numeric(18, 2) as expense_total
  from tx
),
this_month as (
  select
    coalesce(sum(tx.amount) filter (where tx.type = 'income'), 0)::numeric(18, 2) as income_month,
    coalesce(sum(tx.amount) filter (where tx.type = 'expense'), 0)::numeric(18, 2) as expense_month
  from tx cross join bounds
  where tx.transaction_date >= bounds.month_start
),
prev_month as (
  select
    coalesce(sum(tx.amount) filter (where tx.type = 'income'), 0)::numeric(18, 2) as prev_income,
    coalesce(sum(tx.amount) filter (where tx.type = 'expense'), 0)::numeric(18, 2) as prev_expense
  from tx cross join bounds
  where tx.transaction_date >= bounds.month_start - interval '1 month'
    and tx.transaction_date <  bounds.month_start
)
select
  (at.income_total - at.expense_total)::numeric(18, 2) as total_balance,
  tm.income_month,
  tm.expense_month,
  (tm.income_month - tm.expense_month)::numeric(18, 2) as net_cashflow,
  (tm.income_month - tm.expense_month)::numeric(18, 2) as delta_balance,
  coalesce(
    round((tm.income_month - tm.expense_month) / nullif(at.income_total - at.expense_total - (tm.income_month - tm.expense_month), 0) * 100, 2),
    0
  )::numeric(18, 2) as delta_balance_pct,
  coalesce(
    round((tm.income_month - pm.prev_income) / nullif(pm.prev_income, 0) * 100, 2),
    0
  )::numeric(18, 2) as delta_income_pct,
  (tm.expense_month - pm.prev_expense)::numeric(18, 2) as delta_expense,
  coalesce(
    round((tm.expense_month - pm.prev_expense) / nullif(pm.prev_expense, 0) * 100, 2),
    0
  )::numeric(18, 2) as delta_expense_pct,
  ((tm.income_month - tm.expense_month) - (pm.prev_income - pm.prev_expense))::numeric(18, 2) as delta_net,
  coalesce(
    round(
      ((tm.income_month - tm.expense_month) - (pm.prev_income - pm.prev_expense))
      / nullif(pm.prev_income - pm.prev_expense, 0) * 100,
      2
    ),
    0
  )::numeric(18, 2) as delta_net_pct
from all_time at, this_month tm, prev_month pm;

-- ------------------------------------------------------------
-- 5. RPC — kontribusi target secara atomik (prd.md asumsi DB):
--    menambah catatan kontribusi, memperbarui saldo target, dan
--    menyetel status tercapai dalam SATU transaksi database.
-- ------------------------------------------------------------
create or replace function public.add_contribution(
  p_goal_id uuid,
  p_amount numeric,
  p_contribution_date date,
  p_notes text default null
)
returns public.savings_goals
language plpgsql
security definer
set search_path = public
as $$
declare
  v_goal public.savings_goals;
begin
  if p_amount is null or p_amount <= 0 then
    raise exception 'Nominal setoran harus lebih besar dari nol.';
  end if;

  select * into v_goal
  from public.savings_goals
  where id = p_goal_id and user_id = auth.uid()
  for update;

  if not found then
    raise exception 'Target tabungan tidak ditemukan.';
  end if;

  insert into public.savings_contributions (goal_id, user_id, amount, contribution_date, notes)
  values (p_goal_id, auth.uid(), p_amount, p_contribution_date, coalesce(p_notes, ''));

  update public.savings_goals
  set current_amount = current_amount + p_amount,
      status = case
        when current_amount + p_amount >= target_amount then 'completed'
        else 'in_progress'
      end
  where id = p_goal_id
  returning * into v_goal;

  return v_goal;
end;
$$;

-- ------------------------------------------------------------
-- 6. Hak akses — hanya authenticated; anon dicabut.
--    (Supabase memberi grant default ke anon; cabut di sini.)
-- ------------------------------------------------------------
grant select on public.v_monthly_cashflow, public.v_category_distribution,
  public.v_budget_summary, public.v_dashboard_summary
  to authenticated;

revoke select on public.v_monthly_cashflow, public.v_category_distribution,
  public.v_budget_summary, public.v_dashboard_summary
  from anon;

revoke execute on function public.add_contribution(uuid, numeric, date, text) from public, anon;
grant  execute on function public.add_contribution(uuid, numeric, date, text) to authenticated;
