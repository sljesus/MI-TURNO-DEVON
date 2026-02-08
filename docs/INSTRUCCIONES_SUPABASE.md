# Configuración de Supabase para Devon Turnos

Sigue estos pasos para activar tu backend gratuito en menos de 5 minutos.

## Paso 1: Crear Proyecto
1. Ve a [Supabase.com](https://supabase.com) y regístrate (o inicia sesión).
2. Haz clic en **"New Project"**.
3. Elige tu organización, ponle nombre (ej: `devon-turnos`) y una contraseña de base de datos segura.
4. Elije la región más cercana a ti (ej: Sao Paulo, US East).
5. Dale a **"Create new project"** y espera unos minutos a que se configure.

## Paso 2: Ejecutar el Script de Base de Datos
1. En el menú lateral izquierdo, busca el ícono de **SQL Editor** (parece una terminal `>_`).
2. Haz clic en **"New query"**.
3. Copia TODO el contenido del archivo `supabase/migrations/20240101000000_initial_schema.sql` que tienes en tu carpeta de proyecto.
4. Pégalo en el editor de Supabase.
5. Haz clic en el botón verde **"Run"** (abajo a la derecha).
   - Debería decir "Success" en la parte inferior.

## Paso 3: Conectar el Frontend
1. En el menú lateral izquierdo, ve a **Project Settings** (el ícono de engranaje ⚙️ abajo del todo).
2. Haz clic en **"API"**.
3. Aquí verás dos recuadros importantes:
   - **Project URL**: (ej: `https://xyzxyzxyz.supabase.co`)
   - **Project API keys** -> **anon** / **public**: (una cadena larga de caracteres).
4. Abre el archivo `public/script.js` en tu editor de código.
5. Reemplaza las líneas 2 y 3 con tus datos reales:

```javascript
/* public/script.js */
const SUPABASE_URL = "https://tu-proyecto.supabase.co"; // <-- Pega tu URL aquí
const SUPABASE_KEY = "tu-anon-key-larga...";          // <-- Pega tu KEY aquí
```

## Paso 4: ¡Probar!
1. Abre el archivo `public/index.html` en tu navegador (doble clic o arrástralo a Chrome).
2. Deberías ver la pantalla de ingreso.
3. Intenta unirte a la fila y verás cómo funciona.

## Nota sobre el Panel de Administración (Veterinario)
Para "avanzar la fila", actualmente el sistema usa un código secreto simple (`DEVON_VET`) definido en el archivo SQL (línea 49).
*   En esta versión MVP, necesitarás crear un botón staff o llamar a la función manualmente, o usar la consola del navegador:
    `await supabase.rpc('fn_advance_queue', { p_secret_code: 'DEVON_VET' })`
*   Recomendamos duplicar `index.html` como `admin.html` y agregarle el botón de "LLAMAR SIGUIENTE" si quieres una interfaz gráfica para el médico.
