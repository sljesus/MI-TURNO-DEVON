-- Crear función para asignar secuencia diaria de turnos
-- Migración: 20250208000002_create_set_turn_day_seq_function.sql
-- Configurado para zona horaria de México (CDT/CST)

CREATE OR REPLACE FUNCTION set_turn_day_seq()
RETURNS TRIGGER AS $$
DECLARE
    last_seq BIGINT;
    today_date DATE := CURRENT_DATE AT TIME ZONE 'America/Mexico_City';
BEGIN
    -- Obtener el último número de secuencia para el día actual (México)
    SELECT COALESCE(MAX(day_seq), 0) INTO last_seq
    FROM public.turns
    WHERE turn_date = today_date;
    
    -- Asignar la siguiente secuencia
    NEW.day_seq := last_seq + 1;
    
    -- Asegurar que la fecha del turno use zona horaria de México
    IF NEW.turn_date IS NULL THEN
        NEW.turn_date := CURRENT_DATE AT TIME ZONE 'America/Mexico_City';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger para asignar automáticamente la secuencia diaria
DROP TRIGGER IF EXISTS turns_set_day_seq_trg ON public.turns;

CREATE TRIGGER turns_set_day_seq_trg
BEFORE INSERT ON public.turns
FOR EACH ROW
EXECUTE FUNCTION set_turn_day_seq();

-- Comentario para documentar la función
COMMENT ON FUNCTION set_turn_day_seq() IS 'Función para asignar secuencia diaria de turnos - Configurada para zona horaria de México (America/Mexico_City)';
