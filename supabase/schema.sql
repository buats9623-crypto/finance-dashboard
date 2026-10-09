-- ============================================================
-- Helios Finance — skema Supabase
-- Jalankan: Dashboard → SQL Editor → New query → paste → Run.
-- Idempoten: aman dijalankan berulang.
-- Frontend memakai kunci anon/publishable saja; service_role
-- TIDAK diperlukan dan tidak boleh disimpan di frontend.
-- ============================================================

create extension if not exists pgcrypto;

-- ------------------------------------------------------------
-- 1. PROFILES (PROF-1, PROF-2, AUTH-4)
--    Satu baris per pengguna, dibuat otomatis saat signup.
-- ------------------------------------------------------------
create table if not exists public.profiles (
  user_id          uuid primary key references auth.users (id) on delete cascade,
  full_name        text not null default '',
  email            text,
  currency_code    text not null default 'IDR',
  theme_preference text not null default 'dark'
                   check (theme_preference in ('dark', 'light')),
  created_at       timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (user_id, email, full_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', '')
  )
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- backfill profil untuk user yang sudah terdaftar sebelum trigger ada
insert into public.profiles (user_id, email)
select id, email from auth.users
on conflict (user_id) do nothing;

-- ------------------------------------------------------------
-- 2. CATEGORIES — katalog global (bukan per pengguna)
--    id memakai vocabulary aplikasi (cat-makan, dst) agar
--    DATA mock dan pemanggilan frontend tidak berubah.
-- ------------------------------------------------------------
create table if not exists public.categories (
  id         text primary key,
  name       text not null unique,
  type       text not null check (type in ('expense', 'income')),
  icon_name  text not null,
  color_code text not null,
  created_at timestamptz not null default now()
);

insert into public.categories (id, name, type, icon_name, color_code) values
  ('cat-makan',      'Makanan dan Minuman',   'expense', 'food',     'caution'),
  ('cat-transport',  'Transportasi',          'expense', 'transport','brand'),
  ('cat-hiburan',    'Hiburan',               'expense', 'play',     'negative'),
  ('cat-tagihan',    'Tagihan dan Utilitas',  'expense', 'bill',     'brand-muted'),
  ('cat-pendidikan', 'Pendidikan',            'expense', 'book',     'positive'),
  ('cat-kesehatan',  'Kesehatan',             'expense', 'health',   'ink-subtle'),
  ('cat-gaji',       'Gaji',                  'income',  'salary',   'positive'),
  ('cat-freelance',  'Freelance',             'income',  'freelance','brand'),
  ('cat-keluarga',   'Kontribusi keluarga',   'income',  'family',   'caution')
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 3. TRANSACTIONS (TRX-1..TRX-6)
-- ------------------------------------------------------------
create table if not exists public.transactions (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null default auth.uid()
                   references auth.users (id) on delete cascade,
  type             text not null check (type in ('expense', 'income')),
  amount           numeric(18, 2) not null check (amount > 0),
  transaction_date date not null default current_date,
  description      text not null default '',
  category_id      text not null references public.categories (id),
  payment_method   text not null default '',
  notes            text not null default '',
  created_at       timestamptz not null default now()
);

create index if not exists transactions_user_date_idx
  on public.transactions (user_id, transaction_date desc);

-- ------------------------------------------------------------
-- 4. BUDGETS (BUD-1..BUD-6)
--    spent_amount TIDAK disimpan — dihitung dari transaksi.
-- ------------------------------------------------------------
create table if not exists public.budgets (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid()
               references auth.users (id) on delete cascade,
  category_id  text not null references public.categories (id),
  monthly_limit numeric(18, 2) not null check (monthly_limit > 0),
  created_at   timestamptz not null default now(),
  unique (user_id, category_id)
);

-- ------------------------------------------------------------
-- 5. SAVINGS_GOALS (SAV-1..SAV-5)
--    current_amount dikelola aplikasi (sumber kebenaran),
--    di-sync oleh aplikasi saat mencatat kontribusi.
-- ------------------------------------------------------------
create table if not exists public.savings_goals (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null default auth.uid()
                 references auth.users (id) on delete cascade,
  goal_name      text not null,
  target_amount  numeric(18, 2) not null check (target_amount > 0),
  current_amount numeric(18, 2) not null default 0
                 check (current_amount >= 0),
  target_date    date,
  status         text not null default 'in_progress'
                 check (status in ('in_progress', 'completed')),
  created_at     timestamptz not null default now()
);

-- ------------------------------------------------------------
-- 6. SAVINGS_CONTRIBUTIONS — log mutasi dana target
-- ------------------------------------------------------------
create table if not exists public.savings_contributions (
  id                uuid primary key default gen_random_uuid(),
  goal_id           uuid not null references public.savings_goals (id) on delete cascade,
  user_id           uuid not null default auth.uid()
                    references auth.users (id) on delete cascade,
  amount            numeric(18, 2) not null check (amount > 0),
  contribution_date date not null default current_date,
  notes             text not null default '',
  created_at        timestamptz not null default now()
);

create index if not exists savings_contributions_goal_idx
  on public.savings_contributions (goal_id);

-- ------------------------------------------------------------
-- ROW LEVEL SECURITY — per pengguna
-- ------------------------------------------------------------
alter table public.profiles              enable row level security;
alter table public.categories            enable row level security;
alter table public.transactions          enable row level security;
alter table public.budgets               enable row level security;
alter table public.savings_goals         enable row level security;
alter table public.savings_contributions enable row level security;

-- profiles: hanya milik sendiri
drop policy if exists "profil milik sendiri" on public.profiles;
create policy "profil milik sendiri"
  on public.profiles for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- categories: katalog publik, baca-saja (ditulis lewat SQL Editor)
drop policy if exists "kategori dapat dibaca" on public.categories;
create policy "kategori dapat dibaca"
  on public.categories for select
  to anon, authenticated
  using (true);

-- transactions / budgets / savings_goals: milik sendiri
drop policy if exists "transaksi milik sendiri" on public.transactions;
create policy "transaksi milik sendiri"
  on public.transactions for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "anggaran milik sendiri" on public.budgets;
create policy "anggaran milik sendiri"
  on public.budgets for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "target milik sendiri" on public.savings_goals;
create policy "target milik sendiri"
  on public.savings_goals for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- kontribusi: milik sendiri DAN goal-nya harus milik sendiri
drop policy if exists "kontribusi milik sendiri" on public.savings_contributions;
create policy "kontribusi milik sendiri"
  on public.savings_contributions for all
  to authenticated
  using (user_id = auth.uid())
  with check (
    user_id = auth.uid()
    and exists (
      select 1 from public.savings_goals g
      where g.id = goal_id and g.user_id = auth.uid()
    )
  );

-- ------------------------------------------------------------
-- 7. HAK AKSES — pastikan role authenticated cukup.
--    Defensif & idempoten: aman dijalankan berulang. Tanpa
--    grant eksplisit, tabel yang dibuat lewat SQL Editor
--    bisa tidak terbaca role authenticated (default grants
--    tidak selalu ikut), sehingga seluruh modul memuat kosong
--    atau galat RLS/permission.
-- ------------------------------------------------------------
grant select, insert, update, delete on public.profiles to authenticated;
grant select on public.categories to authenticated;
grant select, insert, update, delete on public.transactions to authenticated;
grant select, insert, update, delete on public.budgets to authenticated;
grant select, insert, update, delete on public.savings_goals to authenticated;
grant select, insert, update, delete on public.savings_contributions to authenticated;
