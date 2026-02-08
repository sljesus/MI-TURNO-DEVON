# Devon VET - Sistema de Turnos

Aplicación web para gestión de turnos veterinarios con actualización en tiempo real.

## 🚀 Características

- **Sistema de turnos en tiempo real** con Supabase
- **Interfaz moderna y responsiva** para móviles y escritorio
- **Panel de administración** para veterinarios
- **Notificaciones automáticas** cuando es tu turno
- **Botón de ayuda** para registrar turnos de terceros
- **Persistencia de turno** en localStorage

## 📁 Estructura del Proyecto

```
MI-TURNO-DEVON/
├── public/                 # Archivos públicos del servidor
│   ├── index.html         # Página principal de turnos
│   ├── admin.html         # Panel de administración
│   └── assets/            # Recursos estáticos
├── src/                   # Código fuente
│   ├── js/
│   │   └── script.js      # Lógica principal de la aplicación
│   ├── css/
│   │   └── styles.css     # Estilos principales
│   └── components/        # Componentes reutilizables (futuro)
├── config/                # Configuración
│   └── *.sql             # Migraciones de base de datos
├── docs/                  # Documentación
│   └── INSTRUCCIONES_SUPABASE.md
└── README.md
```

## 🛠️ Tecnologías

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Backend**: Supabase (Base de datos + Realtime)
- **Servidor**: http-server (Node.js)

## 🚀 Instalación y Ejecución

### Prerrequisitos
- Node.js instalado
- Acceso a una base de datos Supabase

### Pasos

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd MI-TURNO-DEVON
   ```

2. **Configurar Supabase**
   - Crear un proyecto en [Supabase](https://supabase.com)
   - Ejecutar las migraciones desde `config/`
   - Actualizar las credenciales en `src/js/script.js`

3. **Iniciar servidor de desarrollo**
   ```bash
   npx http-server public -p 8000 -a 0.0.0.0
   ```

4. **Acceder a la aplicación**
   - **Página principal**: http://localhost:8000/index.html
   - **Panel admin**: http://localhost:8000/admin.html

## 📱 Acceso desde Dispositivos Móviles

Para acceder desde tu celular en la misma red WiFi:

1. Obtén tu IP local: `ipconfig` (Windows) o `ifconfig` (macOS/Linux)
2. Reemplaza `localhost` con tu IP (ej: `http://192.168.1.10:8000`)

## 🔧 Configuración

### Variables de Entorno

Las credenciales de Supabase se configuran directamente en `src/js/script.js`:

```javascript
const SUPABASE_URL = "https://your-project.supabase.co";
const SUPABASE_KEY = "your-anon-key";
```

### Base de Datos

Ejecuta las migraciones SQL desde la carpeta `config/` para configurar las tablas necesarias.

## 🎯 Funcionalidades

### Para Clientes
- Sacar turno para mascotas
- Ver estado actual de la cola
- Recibir notificaciones cuando es su turno
- Persistencia del turno al recargar la página

### Para Administradores
- Ver paciente actual siendo atendido
- Llamar al siguiente paciente
- Ver cola de espera completa
- Gestionar el flujo de turnos

## 🤝 Contribuir

1. Fork del proyecto
2. Crear una rama de características
3. Commit de los cambios
4. Push a la rama
5. Crear Pull Request

## 📄 Licencia

MIT License - ver archivo LICENSE para detalles

## 🆘 Soporte

Para configuración de Supabase, revisa `docs/INSTRUCCIONES_SUPABASE.md`

---

**Desarrollado con ❤️ para Devon VET**
