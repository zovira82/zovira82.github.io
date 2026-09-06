grant update, delete on public.messages to authenticated;

drop policy if exists "管理员读取全部寄语" on public.messages;
drop policy if exists "管理员修改寄语" on public.messages;
drop policy if exists "管理员删除寄语" on public.messages;

create policy "管理员读取全部寄语"
on public.messages
for select
to authenticated
using (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);

create policy "管理员修改寄语"
on public.messages
for update
to authenticated
using (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid)
with check (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);

create policy "管理员删除寄语"
on public.messages
for delete
to authenticated
using (auth.uid() = '1a6bd99c-f493-432b-9d5c-c71150e0f369'::uuid);
