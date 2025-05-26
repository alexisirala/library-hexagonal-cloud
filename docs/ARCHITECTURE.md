# Arquitectura Cloud Native - Library Management

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                      Docker Host                           │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              library-cloud-network                    │  │
│  │                                                       │  │
│  │  ┌─────────────────┐         ┌─────────────────┐      │  │
│  │  │   library-api   │         │   library-db    │      │  │
│  │  │                 │         │                 │      │  │
│  │  │ ┌─────────────┐ │         │ ┌─────────────┐ │      │  │
│  │  │ │   Laravel   │ │◄────────┤ │   MySQL     │ │      │  │
│  │  │ │   Backend   │ │         │ │   8.0       │ │      │  │
│  │  │ │             │ │         │ │             │ │      │  │
│  │  │ │ Port: 8000  │ │         │ │ Port: 3306  │ │      │  │
│  │  │ └─────────────┘ │         │ └─────────────┘ │      │  │
│  │  │                 │         │                 │      │  │
│  │  │ Exposed: 8001   │         │ Exposed: 3307   │      │  │
│  │  └─────────────────┘         └─────────────────┘      │  │
│  │           │                           │                │  │
│  │           │                           │                │  │
│  └───────────┼───────────────────────────┼────────────────┘  │
│              │                           │                   │
└──────────────┼───────────────────────────┼───────────────────┘
               │                           │
        ┌──────▼──────┐             ┌──────▼──────┐
        │   Client    │             │  Database   │
        │ (HTTP API)  │             │   Admin     │
        │             │             │             │
        └─────────────┘             └─────────────┘
```

## Características de la Implementación Cloud Native

### 1. Separación de Servicios
- **API Backend**: Servicio independiente para lógica de negocio
- **Base de Datos**: Servicio dedicado para persistencia de datos

### 2. Containerización
- Cada servicio ejecuta en su propio contenedor
- Aislamiento de dependencias y recursos
- Portabilidad entre diferentes entornos

### 3. Orquestación
- Docker Compose para definir y ejecutar aplicación multi-contenedor
- Configuración declarativa de servicios
- Gestión automática de dependencias

### 4. Networking
- Red privada para comunicación entre servicios
- Exposición selectiva de puertos
- Resolución de nombres automática

### 5. Escalabilidad
- Servicios pueden escalarse independientemente
- Configuración para múltiples instancias
- Load balancing potential

### 6. Configuración
- Variables de entorno para configuración
- Separación de configuración del código
- Diferentes configuraciones por entorno

## Comparación: Monolítico vs Cloud Native

| Aspecto | Monolítico | Cloud Native |
|---------|------------|--------------|
| **Arquitectura** | Un solo proceso | Múltiples servicios |
| **Base de Datos** | SQLite local | MySQL en contenedor |
| **Escalabilidad** | Vertical únicamente | Horizontal y vertical |
| **Aislamiento** | Compartido | Contenedores aislados |
| **Despliegue** | Un solo artefacto | Múltiples contenedores |
| **Configuración** | Archivo .env local | Variables de entorno |
| **Networking** | Localhost | Red de contenedores |
| **Persistencia** | Archivo local | Volúmenes Docker |
| **Dependencias** | Instalación directa | Imagen Docker |
| **Portabilidad** | Dependiente del SO | Multiplataforma |

## Ventajas del Enfoque Cloud Native

### Desarrollo
- Aislamiento de servicios
- Fácil testing de integración
- Entornos consistentes

### Operaciones
- Escalabilidad independiente
- Actualizaciones sin downtime
- Monitoreo granular

### Infraestructura
- Uso eficiente de recursos
- Portabilidad entre clouds
- Facilidad de backup/restore

## Tecnologías Utilizadas

### Contenedores
- **Docker**: Plataforma de contenedores
- **Docker Compose**: Orquestación multi-contenedor

### Backend
- **PHP 8.2**: Runtime del backend
- **Laravel 10**: Framework web
- **Composer**: Gestor de dependencias PHP

### Base de Datos
- **MySQL 8.0**: Sistema de gestión de base de datos
- **Volúmenes Docker**: Persistencia de datos

### Networking
- **Bridge Network**: Red privada entre contenedores
- **Port Mapping**: Exposición selectiva de puertos
