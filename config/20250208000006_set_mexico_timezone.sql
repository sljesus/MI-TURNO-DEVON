-- Configurar zona horaria de México para la base de datos
-- Migración: 20250208000006_set_mexico_timezone.sql

-- Establecer zona horaria por defecto para la sesión
SET timezone = 'America/Mexico_City';

-- Crear función para obtener fecha/hora actual de México
CREATE OR REPLACE FUNCTION get_mexico_now()
RETURNS timestamp with time zone AS $$
BEGIN
    RETURN now() AT TIME ZONE 'America/Mexico_City';
END;
$$ LANGUAGE plpgsql;

-- Crear función para obtener fecha actual de México
CREATE OR REPLACE FUNCTION get_mexico_date()
RETURNS date AS $$
BEGIN
    RETURN CURRENT_DATE AT TIME ZONE 'America/Mexico_City';
END;
$$ LANGUAGE plpgsql;

-- Comentarios para documentar las funciones
COMMENT ON FUNCTION get_mexico_now() IS 'Retorna timestamp actual en zona horaria de México (America/Mexico_City)';
COMMENT ON FUNCTION get_mexico_date() IS 'Retorna fecha actual en zona horaria de México (America/Mexico_City)';

-- Actualizar configuración de la base de datos para México
ALTER DATABASE SET timezone = 'America/Mexico_City';
