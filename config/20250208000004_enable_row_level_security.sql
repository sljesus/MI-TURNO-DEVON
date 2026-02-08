-- Habilitar Row Level Security (RLS) para la tabla de turnos
-- Migración: 20250208000004_enable_row_level_security.sql

-- Habilitar RLS en la tabla de turnos
ALTER TABLE public.turns ENABLE ROW LEVEL SECURITY;

-- Política para permitir a los usuarios ver todos los turnos (para la cola pública)
CREATE POLICY "Enable read access for all users" ON public.turns
    FOR SELECT USING (true);

-- Política para permitir a los usuarios insertar sus propios turnos
CREATE POLICY "Enable insert for users" ON public.turns
    FOR INSERT WITH CHECK (true);

-- Política para permitir a los usuarios actualizar sus propios turnos
CREATE POLICY "Enable update for own turns" ON public.turns
    FOR UPDATE USING (auth.uid() = user_id);

-- Política para permitir a los usuarios eliminar sus propios turnos
CREATE POLICY "Enable delete for own turns" ON public.turns
    FOR DELETE USING (auth.uid() = user_id);

-- Habilitar RLS en la tabla de contadores diarios
ALTER TABLE public.daily_turn_counters ENABLE ROW LEVEL SECURITY;

-- Política para permitir lecturas de contadores (solo lectura pública)
CREATE POLICY "Enable read access for counters" ON public.daily_turn_counters
    FOR SELECT USING (true);
