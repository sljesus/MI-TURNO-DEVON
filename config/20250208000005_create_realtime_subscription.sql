-- Crear función y publicación para suscripciones en tiempo real
-- Migración: 20250208000005_create_realtime_subscription.sql

-- Publicar la tabla de turnos para suscripciones en tiempo real
DROP PUBLICATION IF EXISTS supabase_realtime;

CREATE PUBLICATION supabase_realtime 
FOR TABLE public.turns,
     public.daily_turn_counters;
