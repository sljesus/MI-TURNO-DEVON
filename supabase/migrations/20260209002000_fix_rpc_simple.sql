-- Crear versión simplificada y correcta de fn_join_queue
-- que trabaje con la estructura actual de la tabla

DROP FUNCTION IF EXISTS public.fn_join_queue(bigint, text);

CREATE OR REPLACE FUNCTION public.fn_join_queue(
  p_pet_name text,
  p_owner_name text default null
)
returns bigint
language plpgsql
security definer
as $$
declare
  v_id bigint;
begin
  -- Insertar turno en la tabla con la estructura correcta
  insert into public.turns (pet_name, owner_name, status, created_at)
  values (p_pet_name, p_owner_name, 'waiting', now())
  returning id into v_id;
  
  return v_id;
exception
  when others then
    -- Log del error para debugging
    raise notice 'Error en fn_join_queue: %', SQLERRM;
    raise exception 'No se pudo crear el turno: %', SQLERRM;
end;
$$;

-- También crear fn_advance_queue simplificada
CREATE OR REPLACE FUNCTION public.fn_advance_queue(
  p_secret_code text
)
returns json
language plpgsql
security definer
as $$
declare
  v_current_id bigint;
  v_next_id bigint;
  v_next_pet text;
begin
  -- Validación de seguridad
  if p_secret_code != 'DEVON_VET' then
    raise exception 'Acceso denegado: Código incorrecto';
  end if;

  -- Marcar current serving como completed
  update public.turns
  set status = 'completed'
  where status = 'serving';

  -- Encontrar siguiente waiting
  select id, pet_name into v_next_id, v_next_pet
  from public.turns
  where status = 'waiting'
  order by created_at asc, id asc
  limit 1;

  -- Si existe, marcar como serving
  if v_next_id is not null then
    update public.turns
    set status = 'serving'
    where id = v_next_id;
  end if;

  return json_build_object(
    'now_serving_id', v_next_id,
    'now_serving_pet', v_next_pet
  );
end;
$$;