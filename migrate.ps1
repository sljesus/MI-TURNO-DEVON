# Script de Migraciones para Devon VET Turnos
# Configurado para Supabase CLI

param(
    [string]$ProjectRef = "",
    [string]$DbPassword = ""
)

# Colores para output
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Cyan = "Cyan"

Write-Host "🇲🇽 MIGRACIONES DEVON VET - SUPABASE CLI" -ForegroundColor $Cyan
Write-Host "========================================" -ForegroundColor $Cyan

# Verificar si Supabase CLI está instalado
try {
    $supabaseVersion = supabase --version 2>$null
    Write-Host "✅ Supabase CLI detectada: $supabaseVersion" -ForegroundColor $Green
} catch {
    Write-Host "❌ Error: Supabase CLI no encontrada. Instálala con:" -ForegroundColor $Red
    Write-Host "npm install -g supabase" -ForegroundColor $Yellow
    exit 1
}

# Verificar si estamos en un proyecto de Supabase
if (-not (Test-Path "supabase\config.toml")) {
    Write-Host "❌ Error: No se encuentra el archivo supabase\config.toml" -ForegroundColor $Red
    Write-Host "Ejecuta: supabase init" -ForegroundColor $Yellow
    exit 1
}

# Lista de migraciones en orden correcto
$migrations = @(
    "config\20250208000006_set_mexico_timezone.sql",
    "config\20250208000001_create_turns_table.sql", 
    "config\20250208000002_create_set_turn_day_seq_function.sql",
    "config\20250208000003_create_daily_turn_counters_table.sql",
    "config\20250208000004_enable_row_level_security.sql",
    "config\20250208000005_create_realtime_subscription.sql"
)

Write-Host "`n📋 Ejecutando migraciones en orden:" -ForegroundColor $Yellow
foreach ($migration in $migrations) {
    Write-Host "  → $migration" -ForegroundColor $White
}

Write-Host "`n🚀 Iniciando proceso de migración...`n" -ForegroundColor $Green

# Ejecutar cada migración
foreach ($migration in $migrations) {
    if (Test-Path $migration) {
        Write-Host "📄 Ejecutando: $migration" -ForegroundColor $Cyan
        
        try {
            # Ejecutar migración con Supabase CLI
            $result = supabase db push --file $migration
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✅ Completada: $migration" -ForegroundColor $Green
            } else {
                Write-Host "  ❌ Error en: $migration" -ForegroundColor $Red
                Write-Host "  Código de salida: $LASTEXITCODE" -ForegroundColor $Red
                
                # Preguntar si continuar
                $continue = Read-Host "¿Desea continuar con las siguientes migraciones? (s/N)"
                if ($continue -ne "s" -and $continue -ne "S") {
                    Write-Host "🛑 Proceso detenido por el usuario" -ForegroundColor $Yellow
                    exit 1
                }
            }
        } catch {
            Write-Host "  ❌ Excepción en: $migration" -ForegroundColor $Red
            Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor $Red
            
            $continue = Read-Host "¿Desea continuar con las siguientes migraciones? (s/N)"
            if ($continue -ne "s" -and $continue -ne "S") {
                Write-Host "🛑 Proceso detenido por el usuario" -ForegroundColor $Yellow
                exit 1
            }
        }
        
        Write-Host ""  # Línea en blanco
    } else {
        Write-Host "❌ Archivo no encontrado: $migration" -ForegroundColor $Red
        exit 1
    }
}

Write-Host "`n🎉 Migraciones completadas exitosamente!" -ForegroundColor $Green
Write-Host "`n🔍 Verificación sugerida:" -ForegroundColor $Yellow
Write-Host "  supabase db diff" -ForegroundColor $White
Write-Host "  supabase db remote changes" -ForegroundColor $White
Write-Host "`n📊 Para verificar las tablas:" -ForegroundColor $Yellow
Write-Host "  supabase db shell" -ForegroundColor $White
Write-Host "  \d public.turns" -ForegroundColor $Cyan
Write-Host "  \d public.daily_turn_counters" -ForegroundColor $Cyan
