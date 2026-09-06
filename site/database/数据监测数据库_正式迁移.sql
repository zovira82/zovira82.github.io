-- 在 Supabase SQL Editor 中执行一次。
-- 不修改现有 public.messages 表，继续沿用原留言管理功能。

create extension if not exists pgcrypto;

create table if not exists public.monitoring_data (
  id uuid primary key default gen_random_uuid(),
  record_key text not null unique,
  scope_type text not null check (scope_type in ('调研区','全国','省级','调查期','石漠化程度')),
  province text,
  region text not null,
  statistical_year smallint check (statistical_year between 1900 and 2100),
  period_label text not null,
  category text not null,
  indicator text not null,
  value numeric not null,
  unit text not null,
  source_title text not null default '',
  source_org text not null default '',
  source_url text not null default '',
  caliber text not null default '',
  verification_status text not null default '待复核'
    check (verification_status in ('待复核','已核验','需修订')),
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists monitoring_data_scope_idx
  on public.monitoring_data(scope_type, region, statistical_year desc);
create index if not exists monitoring_data_indicator_idx
  on public.monitoring_data(indicator, unit, statistical_year desc);
create index if not exists monitoring_data_public_idx
  on public.monitoring_data(is_published, verification_status);

create or replace function public.monitoring_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists monitoring_data_touch_updated_at on public.monitoring_data;
create trigger monitoring_data_touch_updated_at
before update on public.monitoring_data
for each row execute function public.monitoring_touch_updated_at();

alter table public.monitoring_data enable row level security;

grant select on public.monitoring_data to anon, authenticated;
grant insert, update, delete on public.monitoring_data to authenticated;

drop policy if exists "公开读取已发布监测数据" on public.monitoring_data;
create policy "公开读取已发布监测数据"
on public.monitoring_data
for select
to anon, authenticated
using (is_published = true and verification_status = '已核验');

drop policy if exists "管理员读取全部监测数据" on public.monitoring_data;
create policy "管理员读取全部监测数据"
on public.monitoring_data
for select
to authenticated
using (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);

drop policy if exists "管理员新增监测数据" on public.monitoring_data;
create policy "管理员新增监测数据"
on public.monitoring_data
for insert
to authenticated
with check (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);

drop policy if exists "管理员修改监测数据" on public.monitoring_data;
create policy "管理员修改监测数据"
on public.monitoring_data
for update
to authenticated
using (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid)
with check (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);

drop policy if exists "管理员删除监测数据" on public.monitoring_data;
create policy "管理员删除监测数据"
on public.monitoring_data
for delete
to authenticated
using (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);

comment on table public.monitoring_data is '数据监测页统一数据表：包含11个调研区及全国、省级、调查期数据';
comment on column public.monitoring_data.record_key is '前端生成的稳定去重键，用于批量导入和覆盖更新';
