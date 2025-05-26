# Informe Técnico: Trabajo Práctico Monolithic vs Cloud Native Apps

**Estudiante:** Alexis Irala  
**Materia:** Electiva I / III - Arquitectura WEB – FP-UNA  
**Profesor:** Rodrigo Benítez  
**Fecha:** 26 de Mayo de 2025

## 1. Descripción de la Funcionalidad

### Sistema de Gestión de Biblioteca

La funcionalidad implementada consiste en un **Sistema de Gestión de Biblioteca** que permite:

#### Operaciones CRUD de Libros
- **Crear libros** con título, autor, ISBN y cantidad
- **Listar todos los libros** disponibles
- **Obtener detalles** de un libro específico
- **Actualizar información** de libros existentes
- **Eliminar libros** del sistema

#### Sistema de Préstamos
- **Prestar libros** (reduce cantidad disponible)
- **Devolver libros** (incrementa cantidad disponible)
- **Validación de disponibilidad** antes de préstamos

#### API RESTful
- Endpoints consistentes en ambas versiones
- Respuestas JSON estructuradas
- Códigos de estado HTTP apropiados
- Manejo de errores robusto

### Arquitectura Base
Ambas implementaciones utilizan **Arquitectura Hexagonal** con:
- **Capa de Dominio**: Entidades y reglas de negocio
- **Capa de Aplicación**: Casos de uso y servicios
- **Capa de Infraestructura**: Persistencia y controladores

## 2. Implementaciones Desarrolladas

### 2.1 Aplicación Monolítica

**Tecnologías:**
- Laravel 10 (PHP 8.2)
- SQLite (base de datos)
- Servidor de desarrollo integrado

**Estructura:**
```
Library-hexagonal/
├── app/
│   ├── Application/Book/     # Servicios de aplicación
│   ├── Domain/Book/          # Entidades de dominio
│   ├── Infrastructure/       # Persistencia
│   └── Http/Controllers/     # Controladores API
├── database/
│   ├── migrations/           # Esquemas de BD
│   └── seeders/             # Datos de prueba
└── routes/api.php           # Definición de rutas
```

**Características:**
- Deploy simple con `php artisan serve`
- Base de datos SQLite embebida
- Desarrollo rápido e iterativo
- Debugging directo

### 2.2 Aplicación Cloud Native

**Tecnologías:**
- Laravel 10 (contenedor Docker)
- MySQL 8.0 (contenedor separado)
- Docker Compose (orquestación)

**Estructura:**
```
library-hexagonal-cloud/
├── backend/                 # Código Laravel
│   ├── Dockerfile          # Imagen personalizada
│   └── [mismo código]      # Misma lógica de negocio
├── database/
│   └── init.sql            # Inicialización MySQL
├── docker-compose.yml      # Orquestación
├── docs/                   # Documentación técnica
└── scripts/                # Herramientas de gestión
```

**Servicios:**
- **library-api**: Backend en puerto 8001
- **library-db**: MySQL en puerto 3307
- **Red privada**: Comunicación inter-contenedores

## 3. Comparación Técnica

### 3.1 Arquitectura

| Aspecto | Monolítico | Cloud Native |
|---------|------------|--------------|
| **Procesos** | 1 proceso único | 2 contenedores |
| **Base de Datos** | SQLite local | MySQL containerizado |
| **Networking** | Localhost | Red Docker |
| **Configuración** | .env local | Variables de entorno |
| **Persistencia** | Archivo DB | Volúmenes Docker |

### 3.2 Desarrollo

| Criterio | Monolítico | Cloud Native |
|----------|------------|--------------|
| **Setup Time** | ~30 segundos | ~2 minutos |
| **Hot Reload** | Inmediato | Rebuild necesario |
| **Debugging** | IDE directo | Docker logs |
| **Testing** | PHPUnit directo | En contenedor |

### 3.3 Operaciones

| Operación | Monolítico | Cloud Native |
|-----------|------------|--------------|
| **Deploy** | `php artisan serve` | `docker-compose up` |
| **Escalabilidad** | Vertical | Horizontal |
| **Monitoring** | 1 proceso | Por servicio |
| **Backup** | Archivo SQLite | Volumen MySQL |

## 4. Decisiones Arquitectónicas

### 4.1 Selección de Tecnologías

#### Monolítico
- **Laravel**: Framework robusto y rápido desarrollo
- **SQLite**: Simplicidad, cero configuración
- **PHP Built-in Server**: Deploy inmediato

#### Cloud Native
- **Docker**: Estándar de containerización
- **MySQL**: Base de datos empresarial
- **Docker Compose**: Orquestación simple y efectiva

### 4.2 Patrones Implementados

#### Arquitectura Hexagonal
- **Ports & Adapters**: Interfaces claras entre capas
- **Dependency Inversion**: Inyección de dependencias
- **Repository Pattern**: Abstracción de persistencia

#### Cloud Native Patterns
- **Container per Service**: Aislamiento de responsabilidades
- **External Configuration**: Variables de entorno
- **Health Checks**: Monitoreo de servicios

## 5. Herramientas Utilizadas

### Desarrollo
- **IDE**: Visual Studio Code
- **Version Control**: Git
- **Dependency Management**: Composer (PHP)

### Containerización
- **Docker Desktop**: Plataforma de contenedores
- **Docker Compose**: Orquestación multi-contenedor
- **Docker Hub**: Registry de imágenes base

### Testing
- **cURL**: Pruebas de API
- **Scripts**: Automatización de tests
- **Docker Logs**: Debugging de contenedores

## 6. Guías de Despliegue

### 6.1 Monolítico
```bash
# 1. Clonar repositorio
git clone <repository>
cd Library-hexagonal

# 2. Instalar dependencias
composer install

# 3. Configurar entorno
cp .env.example .env
php artisan key:generate

# 4. Ejecutar migraciones
php artisan migrate --seed

# 5. Iniciar servidor
php artisan serve
```

### 6.2 Cloud Native
```bash
# 1. Prerrequisitos
# - Docker Desktop instalado y ejecutándose

# 2. Clonar repositorio
git clone <repository>
cd library-hexagonal-cloud

# 3. Iniciar servicios
docker-compose up --build

# 4. Verificar estado
docker-compose ps

# 5. Probar API
curl http://localhost:8001/api/books
```

## 7. Resultados y Capturas

### 7.1 Monolítico
- ✅ API funcional en `http://localhost:8000`
- ✅ Tiempo de inicio: ~2 segundos
- ✅ Base de datos SQLite con datos de prueba
- ✅ Todos los endpoints operativos

### 7.2 Cloud Native
- ✅ API funcional en `http://localhost:8001`
- ✅ MySQL en contenedor separado
- ✅ Servicios comunicándose via red Docker
- ✅ Misma funcionalidad que versión monolítica

### 7.3 Pruebas de Funcionalidad
```bash
# Ambas versiones pasan todas las pruebas:
GET    /api/books           ✅
GET    /api/books/{id}      ✅
POST   /api/books           ✅
PUT    /api/books/{id}      ✅
DELETE /api/books/{id}      ✅
PATCH  /api/books/{id}/borrow  ✅
PATCH  /api/books/{id}/return  ✅
```

## 8. Ventajas y Desventajas

### 8.1 Monolítico

#### Ventajas ✅
- Desarrollo rápido e iterativo
- Debugging simple y directo
- Deploy inmediato
- Menor overhead de recursos
- Ideal para MVPs y prototipos

#### Desventajas ❌
- Escalabilidad limitada
- Acoplamiento tecnológico
- Single point of failure
- Actualizaciones con downtime

### 8.2 Cloud Native

#### Ventajas ✅
- Escalabilidad horizontal
- Aislamiento de servicios
- Portabilidad completa
- DevOps friendly
- Preparado para microservicios

#### Desventajas ❌
- Complejidad operacional
- Mayor uso de recursos
- Curva de aprendizaje
- Network latency

## 9. Casos de Uso Recomendados

### Cuándo usar Monolítico
- **Equipos pequeños** (1-3 desarrolladores)
- **Proyectos con deadline ajustado**
- **MVPs y validación de concepto**
- **Aplicaciones simples a medianas**
- **Recursos de infraestructura limitados**

### Cuándo usar Cloud Native
- **Equipos grandes** (4+ desarrolladores)
- **Aplicaciones enterprise**
- **Escalabilidad crítica**
- **Múltiples entornos** (dev/staging/prod)
- **Futuro en microservicios**

## 10. Conclusiones

### 10.1 Aprendizajes Clave

1. **Misma funcionalidad, diferente deployment**: Ambas versiones implementan idéntica lógica de negocio
2. **Trade-offs claros**: Simplicidad vs Escalabilidad
3. **Arquitectura Hexagonal**: Facilita migración entre paradigmas
4. **Containerización**: Añade consistencia pero también complejidad

### 10.2 Recomendaciones

Para este proyecto específico:
- **Fase inicial**: Monolítico para desarrollo rápido
- **Crecimiento**: Migrar a Cloud Native containerizado
- **Escala**: Evolucionar a microservicios si es necesario

### 10.3 Impacto en la Industria

- **Monolíticos** siguen siendo válidos para muchos casos
- **Cloud Native** es el futuro para aplicaciones escalables
- **Híbrido** (monolito containerizado) ofrece mejor balance inicial

## 11. URLs del Repositorio

- **Monolítico**: `/Users/alexisirala/Library-hexagonal`
- **Cloud Native**: `/Users/alexisirala/library-hexagonal-cloud`
- **Documentación**: Incluida en ambos proyectos

---

**Nota**: Este trabajo demuestra la implementación práctica de dos paradigmas arquitectónicos modernos, evidenciando las decisiones técnicas y trade-offs involucrados en cada enfoque.
