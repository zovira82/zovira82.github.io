-- 川滇黔省际毗邻区生态经济人口数据库：Supabase / PostgreSQL 结构草案
-- 仅供预览和评审，本文件尚未在任何线上数据库执行。
-- 现有 public.messages 留言表及其权限不做修改。

create extension if not exists pgcrypto;

create table if not exists public.regions (
  id uuid primary key default gen_random_uuid(),
  province text not null check (province in ('贵州','云南','四川')),
  prefecture text not null,
  name text not null,
  admin_level text not null default '县级',
  longitude numeric(9,6),
  latitude numeric(9,6),
  is_survey_area boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (province, name)
);

create table if not exists public.indicators (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('人口','经济','生态','产业','社会')),
  code text not null unique,
  name text not null,
  default_unit text not null,
  definition text,
  comparability_note text,
  created_at timestamptz not null default now()
);

create table if not exists public.data_sources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  publisher text not null,
  source_url text not null,
  published_on date,
  source_type text not null default '统计公报',
  source_level text not null default '政府公开来源',
  archived_url text,
  checked_at timestamptz,
  unique (source_url)
);

create table if not exists public.observations (
  id uuid primary key default gen_random_uuid(),
  region_id uuid not null references public.regions(id) on delete restrict,
  indicator_id uuid not null references public.indicators(id) on delete restrict,
  source_id uuid not null references public.data_sources(id) on delete restrict,
  statistical_year smallint not null check (statistical_year between 1900 and 2100),
  value numeric not null,
  unit text not null,
  statistical_scope text,
  note text,
  verification_status text not null default '待复核' check (verification_status in ('待复核','已核验','需修订')),
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (region_id, indicator_id, statistical_year, source_id, statistical_scope)
);

create index if not exists observations_region_year_idx on public.observations(region_id, statistical_year desc);
create index if not exists observations_indicator_year_idx on public.observations(indicator_id, statistical_year desc);
create index if not exists observations_publish_idx on public.observations(is_published, verification_status);

alter table public.regions enable row level security;
alter table public.indicators enable row level security;
alter table public.data_sources enable row level security;
alter table public.observations enable row level security;

drop policy if exists "公开读取调研地区" on public.regions;
create policy "公开读取调研地区" on public.regions for select to anon, authenticated using (is_survey_area = true);

drop policy if exists "公开读取指标字典" on public.indicators;
create policy "公开读取指标字典" on public.indicators for select to anon, authenticated using (true);

drop policy if exists "公开读取已发布来源" on public.data_sources;
create policy "公开读取已发布来源" on public.data_sources for select to anon, authenticated using (
  exists (select 1 from public.observations o where o.source_id = data_sources.id and o.is_published = true)
);

drop policy if exists "公开读取已核验观测值" on public.observations;
create policy "公开读取已核验观测值" on public.observations for select to anon, authenticated using (
  is_published = true and verification_status = '已核验'
);

-- 写入、修改、审核、发布权限将在正式迁移前绑定现有管理员账号；
-- 评审版不开放任何匿名写入，也不在此处复制管理员 UUID。

insert into public.regions (province, prefecture, name, longitude, latitude) values
  ('贵州','毕节市','金沙县',106.220000,27.460000),
  ('贵州','黔西南州','兴义市',104.900000,25.090000),
  ('贵州','毕节市','赫章县',104.730000,27.120000),
  ('云南','曲靖市','罗平县',104.310000,24.880000),
  ('云南','曲靖市','宣威市',104.100000,26.220000),
  ('云南','昆明市','东川区',103.190000,26.080000),
  ('四川','泸州市','合江县',105.830000,28.810000),
  ('四川','泸州市','江阳区',105.450000,28.880000),
  ('四川','宜宾市','叙州区',104.530000,28.690000),
  ('四川','宜宾市','珙县',104.710000,28.440000),
  ('四川','凉山州','布拖县',102.810000,27.710000)
on conflict (province, name) do update set
  prefecture = excluded.prefecture,
  longitude = excluded.longitude,
  latitude = excluded.latitude,
  updated_at = now();

