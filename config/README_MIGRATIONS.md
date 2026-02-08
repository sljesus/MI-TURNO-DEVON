# Migraciones de Base de Datos - Devon VET Turnos

## 🇲🇽 Configurado para México

**Zona Horaria:** `America/Mexico_City` (CDT/CST)
**Horario Estándar:** UTC-6 (CST)
**Horario de Verano:** UTC-5 (CDT)

## 📋 Estructura de Migraciones

Las migraciones están organizadas por fecha y número secuencial:
- Formato: `YYYYMMDDHHMMSS_descripcion.sql`
- Ejemplo: `20250208000001_create_turns_table.sql`

**Importante:** Todas las migraciones están configuradas específicamente para la zona horaria de México.

## 🗃️ Migraciones Disponibles

### 1. `20250208000001_create_turns_table.sql`
**Propósito:** Crear la tabla principal de turnos
**Características:**
- UUID como identificador único
- Seguimiento de usuario (user_id)
- Timestamp de creación en zona horaria de México
- Payload JSON para datos flexibles
- Fecha del turno y secuencia diaria (México)
- Índice optimizado para consultas por fecha

### 2. `20250208000002_create_set_turn_day_seq_function.sql`
**Propósito:** Función y trigger para numeración automática de turnos
**Características:**
- Asigna automáticamente `day_seq` (número de turno del día)
- Reinicia secuencia cada día a las 00:00 (hora de México)
- Manejo concurrente seguro
- Todas las fechas usan zona horaria de México

### 3. `20250208000003_create_daily_turn_counters_table.sql`
**Propósito:** Tabla de contadores diarios
**Características:**
- Registra el último número de turno por día (México)
- Optimiza consultas de secuencia
- Inicializa contador para el día actual (México)

### 4. `20250208000004_enable_row_level_security.sql`
**Propósito:** Configurar seguridad a nivel de fila (RLS)
**Características:**
- Lectura pública de la cola de turnos
- Usuarios solo pueden modificar sus propios turnos
- Políticas granulares de acceso

### 5. `20250208000005_create_realtime_subscription.sql`
**Propósito:** Habilitar suscripciones en tiempo real
**Características:**
- Publicación de cambios en tiempo real
- Soporte para múltiples clientes simultáneos
- Actualizaciones automáticas de la UI

### 6. `20250208000006_set_mexico_timezone.sql`
**Propósito:** Configurar zona horaria de México a nivel de base de datos
**Características:**
- Establece `America/Mexico_City` como timezone por defecto
- Funciones helper para fechas/horas de México
- Configuración persistente a nivel de base de datos

## 🚀 Ejecución de Migraciones

### En Supabase Dashboard:
1. Ir a **SQL Editor**
2. Copiar y pegar el contenido de cada archivo SQL
3. Ejecutar en orden secuencial

### Vía API:
```sql
-- Ejecutar todas las migraciones en orden (importante: primero la de timezone)
\i 20250208000006_set_mexico_timezone.sql
\i 20250208000001_create_turns_table.sql
\i 20250208000002_create_set_turn_day_seq_function.sql
\i 20250208000003_create_daily_turn_counters_table.sql
\i 20250208000004_enable_row_level_security.sql
\i 20250208000005_create_realtime_subscription.sql
```

**⚠️ Importante:** Ejecutar primero `20250208000006_set_mexico_timezone.sql` para establecer la zona horaria de México antes de crear las tablas.

## 🔍 Verificación Post-Migración

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
```

## 📊 Estructura de Datos

### Tabla `turns`
| Columna | Tipo | Descripción |
|---------|------|-------------|
| id | uuid | Identificador único del turno |
| user_id | uuid | ID del usuario que solicita el turno |
| created_at | timestamptz | Timestamp de creación |
| payload | jsonb | Datos adicionales (nombre mascota, etc.) |
| turn_date | date | Fecha del turno |
| day_seq | bigint | Número secuencial del día |

### Tabla `daily_turn_counters`
| Columna | Tipo | Descripción |
|---------|------|-------------|
| turn_date | date | Fecha del contador |
| last_counter | bigint | Último número asignado |

## 🔧 Notas Técnicas

- **UUIDs:** Usan `gen_random_uuid()` para mayor seguridad
- **Timezone:** Todos los timestamps usan `with time zone`
- **Índices:** Optimizados para consultas frecuentes
- **RLS:** Configurado para acceso granular
- **Realtime:** Publicación automática de cambios

## 🚨 Consideraciones de Seguridad

1. **RLS activado** por defecto
2. **Políticas explícitas** para cada operación
3. **Validación de usuario** en operaciones de escritura
4. **Acceso público** solo para lectura de cola

---

**Última actualización:** 08/02/2026
**Versión:** 1.0.0
