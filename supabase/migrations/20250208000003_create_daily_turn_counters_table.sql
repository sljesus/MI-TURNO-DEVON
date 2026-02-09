-- Crear tabla de contadores diarios de turnos
-- Migración: 20250208000003_create_daily_turn_counters_table.sql
-- Configurado para zona horaria de México (CDT/CST)

CREATE TABLE IF NOT EXISTS public.daily_turn_counters (
  turn_date date NOT NULL,
  last_counter bigint NOT NULL,
  CONSTRAINT daily_turn_counters_pkey PRIMARY KEY (turn_date)
) TABLESPACE pg_default;

-- Crear índice para búsquedas rápidas por fecha
CREATE INDEX IF NOT EXISTS daily_turn_counters_turn_date_idx 
ON public.daily_turn_counters USING btree (turn_date) 
TABLESPACE pg_default;

-- Insertar contador inicial para el día actual (México) si no existe
INSERT INTO public.daily_turn_counters (turn_date, last_counter)
SELECT CURRENT_DATE AT TIME ZONE 'America/Mexico_City', 0
WHERE NOT EXISTS (
    SELECT 1 FROM public.daily_turn_counters 
    WHERE turn_date = CURRENT_DATE AT TIME ZONE 'America/Mexico_City'
);

-- Comentario para indicar zona horaria configurada
COMMENT ON TABLE public.daily_turn_counters IS 'Tabla de contadores diarios de turnos - Configurada para zona horaria de México (America/Mexico_City)';
