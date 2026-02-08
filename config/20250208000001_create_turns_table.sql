-- Crear tabla de turnos
-- Migración: 20250208000001_create_turns_table.sql
-- Configurado para zona horaria de México (CDT/CST)

CREATE TABLE IF NOT EXISTS public.turns (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now() AT TIME ZONE 'America/Mexico_City',
  payload jsonb NULL,
  turn_date date NOT NULL DEFAULT (now() AT TIME ZONE 'America/Mexico_City')::date,
  day_seq bigint NULL,
  CONSTRAINT turns_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;

-- Crear índice para optimizar consultas por fecha y secuencia
CREATE INDEX IF NOT EXISTS turns_turn_date_day_seq_idx 
ON public.turns USING btree (turn_date, day_seq) 
TABLESPACE pg_default;

-- Comentario para indicar zona horaria configurada
COMMENT ON TABLE public.turns IS 'Tabla de turnos para veterinaria - Configurado para zona horaria de México (America/Mexico_City)';
