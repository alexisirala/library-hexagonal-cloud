# Library Management System - Monorepo

Este es un monorepo que contiene todos los componentes del sistema de gestión de biblioteca implementado con arquitectura hexagonal y cloud-native.

## 📁 Estructura del Monorepo

```
library-hexagonal-cloud/
├── backend/           # Aplicación Laravel con arquitectura hexagonal
├── database/          # Scripts SQL y configuración de base de datos
├── docs/             # Documentación del proyecto
├── docker-compose.yml # Configuración de contenedores
└── Makefile          # Scripts de automatización
```

## 🚀 Componentes

### Backend (Laravel + Hexagonal Architecture)
- **Ubicación**: `./backend/`
- **Tecnología**: Laravel 11, PHP 8.3
- **Arquitectura**: Hexagonal (Puertos y Adaptadores)
- **Dominios**: Book Management

### Database
- **Ubicación**: `./database/`
- **Tecnología**: MySQL 8.0
- **Migraciones**: Incluidas en el backend

### Documentación
- **Ubicación**: `./docs/`

## 🛠️ Configuración como Subtrees (Opcional)

Este monorepo puede configurarse con Git Subtrees para permitir el desarrollo independiente de componentes:

```bash
# Agregar backend como subtree
git subtree add --prefix=backend [BACKEND_REPO_URL] main --squash

# Agregar docs como subtree  
git subtree add --prefix=docs [DOCS_REPO_URL] main --squash
```

## Requisitos

- Docker Desktop
- Docker Compose

## Instalación y Ejecución

### 1. Clonar o copiar el proyecto
```bash
cd /Users/alexisirala/library-hexagonal-cloud
```

### 2. Construir y ejecutar los servicios
```bash
docker-compose up --build
```

### 3. Verificar que los servicios estén funcionando
```bash
docker-compose ps
```

### 4. Probar la API
```bash
# Listar todos los libros
curl http://localhost:8001/api/books

# Obtener un libro específico
curl http://localhost:8001/api/books/{id}
```

## Endpoints Disponibles

- `GET /api/books` - Listar todos los libros
- `GET /api/books/{id}` - Obtener un libro específico
- `POST /api/books` - Crear un nuevo libro
- `PUT /api/books/{id}` - Actualizar un libro
- `DELETE /api/books/{id}` - Eliminar un libro
- `PATCH /api/books/{id}/borrow` - Prestar un libro
- `PATCH /api/books/{id}/return` - Devolver un libro

## Servicios

### Backend API (library-api)
- **Puerto**: 8001
- **Imagen**: Custom (Dockerfile)
- **Dependencias**: library-db

### Base de Datos (library-db)
- **Puerto**: 3307
- **Imagen**: mysql:8.0
- **Base de datos**: library_cloud_db
- **Usuario**: library_user

## Comandos Útiles

```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f library-api

# Parar los servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v

# Reconstruir sin caché
docker-compose build --no-cache
```

### Cloud Native:
- Servicios separados en contenedores
- Base de datos MySQL en contenedor dedicado
- Orquestación con Docker Compose
- Escalabilidad horizontal
- Aislamiento de servicios

## Arquitectura de Contenedores

```
┌─────────────────────────────────────────┐
│              Docker Host                │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │        library-cloud-network      │  │
│  │                                   │  │
│  │  ┌─────────────┐ ┌─────────────┐  │  │
│  │  │ library-api │ │ library-db  │  │  │
│  │  │             │ │             │  │  │
│  │  │ Laravel     │ │ MySQL 8.0   │  │  │
│  │  │ Port: 8001  │ │ Port: 3307  │  │  │
│  │  └─────────────┘ └─────────────┘  │  │
│  │         │                │        │  │
│  │         └────────────────┘        │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```
