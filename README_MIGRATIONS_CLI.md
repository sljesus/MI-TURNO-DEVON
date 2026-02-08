# 🚀 Ejecutar Migraciones vía CLI (Supabase)

## 📋 Scripts Disponibles

### PowerShell (Windows)
```powershell
.\migrate.ps1
```

### Bash (Linux/Mac)
```bash
chmod +x migrate.sh
./migrate.sh
```

### npm scripts
```bash
npm run migrate          # PowerShell (Windows)
npm run migrate:bash      # Bash (Linux/Mac)
npm run migrate:check     # Verificar diferencias
npm run migrate:status   # Ver cambios remotos
npm run migrate:shell     # Abrir shell de base de datos
```

## 🎯 Proceso de Ejecución

### 1️⃣ Requisitos Previos
- ✅ Supabase CLI instalada: `npm install -g supabase`
- ✅ Proyecto de Supabase inicializado: `supabase init`
- ✅ Conectado a tu proyecto de Supabase

### 2️⃣ Ejecutar Migraciones
Las migraciones se ejecutan en este orden específico:

1. **Configuración Timezone México** 🇲🇽
2. **Creación de Tablas** 📊
3. **Funciones y Triggers** ⚙️
4. **Seguridad (RLS)** 🔒
5. **Realtime Subscriptions** 📡

### 3️⃣ Verificación Post-Migración
```bash
# Verificar diferencias
supabase db diff

# Verificar estado remoto
supabase db remote changes

# Conectar a la base de datos
supabase db shell
```

## 🔍 Comandos de Verificación

Dentro del shell de Supabase:
```sql
-- Verificar estructura de tablas
\d public.turns
\d public.daily_turn_counters

-- Verificar políticas RLS
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';

-- Verificar publicaciones
SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';

-- Verificar zona horaria
SHOW timezone;

-- Probar funciones de México
SELECT get_mexico_now();
SELECT get_mexico_date();
```

## 🚨 Solución de Problemas

### Error: "Supabase CLI no encontrada"
```bash
npm install -g supabase
```

### Error: "No se encuentra supabase/config.toml"
```bash
supabase init
# O conectar a proyecto existente:
supabase link --project-ref YOUR_PROJECT_REF
```

### Error: "Permiso denegado" (PowerShell)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "Permiso denegado" (Bash)
```bash
chmod +x migrate.sh
```

## 📊 Estructura Esperada Post-Migración

Después de ejecutar las migraciones, deberías tener:

### Tablas
- `public.turns` - Tabla principal de turnos
- `public.daily_turn_counters` - Contadores diarios

### Funciones
- `set_turn_day_seq()` - Asigna secuencia diaria
- `get_mexico_now()` - Timestamp actual México
- `get_mexico_date()` - Fecha actual México

### Configuración
- Timezone: `America/Mexico_City`
- RLS: Habilitado
- Realtime: Publicado

## 🎉 Confirmación Exitosa

Si todo está correcto, verás:
- ✅ Todas las migraciones completadas
- ✅ Sin errores en la ejecución
- ✅ Tablas creadas con zona horaria de México
- ✅ Funciones listas para usar

---

**Listo para usar Devon VET Turnos en México!** 🇲🇽🐾
