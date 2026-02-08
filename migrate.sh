#!/bin/bash

# Script de Migraciones para Devon VET Turnos
# Configurado para Supabase CLI

echo "🇲🇽 MIGRACIONES DEVON VET - SUPABASE CLI"
echo "========================================"

# Verificar si Supabase CLI está instalado
if ! command -v supabase &> /dev/null; then
    echo "❌ Error: Supabase CLI no encontrada. Instálala con:"
    echo "npm install -g supabase"
    exit 1
fi

SUPABASE_VERSION=$(supabase --version)
echo "✅ Supabase CLI detectada: $SUPABASE_VERSION"

# Verificar si estamos en un proyecto de Supabase
if [ ! -f "supabase/config.toml" ]; then
    echo "❌ Error: No se encuentra el archivo supabase/config.toml"
    echo "Ejecuta: supabase init"
    exit 1
fi

# Lista de migraciones en orden correcto
migrations=(
    "config/20250208000006_set_mexico_timezone.sql"
    "config/20250208000001_create_turns_table.sql"
    "config/20250208000002_create_set_turn_day_seq_function.sql"
    "config/20250208000003_create_daily_turn_counters_table.sql"
    "config/20250208000004_enable_row_level_security.sql"
    "config/20250208000005_create_realtime_subscription.sql"
)

echo ""
echo "📋 Ejecutando migraciones en orden:"
for migration in "${migrations[@]}"; do
    echo "  → $migration"
done

echo ""
echo "🚀 Iniciando proceso de migración..."
echo ""

# Ejecutar cada migración
for migration in "${migrations[@]}"; do
    if [ -f "$migration" ]; then
        echo "📄 Ejecutando: $migration"
        
        if supabase db push --file "$migration"; then
            echo "  ✅ Completada: $migration"
        else
            echo "  ❌ Error en: $migration"
            echo "  Código de salida: $?"
            
            # Preguntar si continuar
            read -p "¿Desea continuar con las siguientes migraciones? (s/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Ss]$ ]]; then
                echo "🛑 Proceso detenido por el usuario"
                exit 1
            fi
        fi
        
        echo ""  # Línea en blanco
    else
        echo "❌ Archivo no encontrado: $migration"
        exit 1
    fi
done

echo ""
echo "🎉 Migraciones completadas exitosamente!"
echo ""
echo "🔍 Verificación sugerida:"
echo "  supabase db diff"
echo "  supabase db remote changes"
echo ""
echo "📊 Para verificar las tablas:"
echo "  supabase db shell"
echo "  \d public.turns"
echo "  \d public.daily_turn_counters"
