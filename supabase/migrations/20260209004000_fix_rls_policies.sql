-- Configurar políticas RLS correctas para el sistema de turnos

-- Eliminar políticas existentes
DROP POLICY IF EXISTS "Enable read access for all users" ON public.turns;
DROP POLICY IF EXISTS "Enable insert for all users" ON public.turns;
DROP POLICY IF EXISTS "Enable update for all users" ON public.turns;

-- Políticas simplificadas que permiten todo a usuarios anónimos
CREATE POLICY "Enable all access for anonymous users" ON public.turns
  FOR ALL USING (true) WITH CHECK (true);

-- También dar permisos explícitos en el nivel de tabla
GRANT ALL ON public.turns TO anon;
GRANT ALL ON public.turns TO authenticated;

-- Para debugging: permitir todo temporalmente
ALTER TABLE public.turns DISABLE ROW LEVEL SECURITY;

-- Recrear las funciones RPC asegurando que funcionen con las políticas correctas
DROP FUNCTION IF EXISTS public.fn_join_queue(TEXT, TEXT);

CREATE OR REPLACE FUNCTION public.fn_join_queue(
  p_pet_name TEXT,
  p_owner_name TEXT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_id BIGINT;
BEGIN
  INSERT INTO public.turns (pet_name, owner_name, status)
  VALUES (p_pet_name, p_owner_name, 'waiting')
  RETURNING id INTO v_id;
  
  RETURN v_id;
END;
$$;