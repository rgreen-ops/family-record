-- =====================================================================
--  Family Record — Supabase schema
--  Paste this whole file into the Supabase SQL Editor and press Run.
-- =====================================================================

-- 1. Who is allowed in. Only these email addresses can see or edit anything.
create table if not exists allowed_emails (
  email text primary key,
  note  text
);

-- 2. One row per person in the tree. The person's fields live in `data`.
create table if not exists people (
  id         text primary key,
  data       jsonb not null,
  updated_at timestamptz not null default now(),
  updated_by text
);

-- 3. Tree-level settings (currently just which person the chart is centred on).
create table if not exists meta (
  id   text primary key,
  data jsonb not null
);

alter table allowed_emails enable row level security;
alter table people         enable row level security;
alter table meta           enable row level security;

-- Helper: is the signed-in user on the allow list?
create or replace function is_family() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from allowed_emails
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

drop policy if exists "family can see the allow list" on allowed_emails;
create policy "family can see the allow list" on allowed_emails
  for select using (is_family());

drop policy if exists "family read people"  on people;
drop policy if exists "family write people" on people;
create policy "family read people"  on people for select using (is_family());
create policy "family write people" on people for all
  using (is_family()) with check (is_family());

drop policy if exists "family read meta"  on meta;
drop policy if exists "family write meta" on meta;
create policy "family read meta"  on meta for select using (is_family());
create policy "family write meta" on meta for all
  using (is_family()) with check (is_family());

-- Live updates to every open browser
alter publication supabase_realtime add table people;

-- =====================================================================
--  4. ADD YOUR FAMILY HERE. Nobody else can get in, whatever they try.
--     Add a line per person, then press Run again.
-- =====================================================================
insert into allowed_emails (email, note) values
  ('you@example.com',      'me'),
  ('someone@example.com',  'add a line per family member')
on conflict (email) do nothing;
