# Guía de Despliegue - Library Hexagonal Cloud Native

## Prerrequisitos

### Software Requerido
- Docker Desktop (versión 4.0 o superior)
- Docker Compose (incluido en Docker Desktop)
- Git (para clonar el repositorio)

### Verificación de Prerrequisitos
```bash
# Verificar Docker
docker --version
docker-compose --version

# Verificar que Docker esté ejecutándose
docker info
```

## Despliegue Local

### Opción 1: Script Automático
```bash
cd /Users/alexisirala/library-hexagonal-cloud
./start.sh
```

### Opción 2: Manual
```bash
# 1. Navegar al directorio del proyecto
cd /Users/alexisirala/library-hexagonal-cloud

# 2. Construir las imágenes
docker-compose build

# 3. Iniciar los servicios
docker-compose up -d

# 4. Verificar el estado
docker-compose ps

# 5. Ver logs (opcional)
docker-compose logs -f
```

## Verificación del Despliegue

### 1. Estado de los Servicios
```bash
docker-compose ps
```
Deberías ver algo como:
```
NAME                     COMMAND                  SERVICE       STATUS          PORTS
library-backend-cloud    "sh -c 'echo 'Esper…"   library-api   Up 2 minutes    0.0.0.0:8001->8000/tcp
library-mysql-cloud     "docker-entrypoint.s…"   library-db    Up 2 minutes    0.0.0.0:3307->3306/tcp, 33060/tcp
```

### 2. Health Check de la Base de Datos
```bash
docker-compose exec library-db mysqladmin ping -h localhost -u root -prootpassword123
```

### 3. Prueba de la API
```bash
# Listar libros
curl -X GET http://localhost:8001/api/books

# Crear un libro (ejemplo)
curl -X POST http://localhost:8001/api/books \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Book",
    "author": "Test Author", 
    "isbn": "9781234567890",
    "quantity": 5
  }'
```

## Comandos de Gestión

### Parar los Servicios
```bash
# Parar pero mantener los datos
docker-compose stop

# Parar y eliminar contenedores (mantiene volúmenes)
docker-compose down

# Parar y eliminar todo (incluyendo volúmenes)
docker-compose down -v
```

### Ver Logs
```bash
# Logs de todos los servicios
docker-compose logs -f

# Logs de un servicio específico
docker-compose logs -f library-api
docker-compose logs -f library-db
```

### Acceso a los Contenedores
```bash
# Acceder al contenedor del backend
docker-compose exec library-api bash

# Acceder al contenedor de la base de datos
docker-compose exec library-db mysql -u library_user -plibrary_password123 library_cloud_db
```

### Reiniciar Servicios
```bash
# Reiniciar todos los servicios
docker-compose restart

# Reiniciar un servicio específico
docker-compose restart library-api
```

## Solución de Problemas

### Problema: Puerto ya en uso
```bash
# Verificar qué proceso usa el puerto
lsof -i :8001
lsof -i :3307

# Cambiar puertos en docker-compose.yml si es necesario
```

### Problema: Base de datos no se conecta
```bash
# Verificar logs de la base de datos
docker-compose logs library-db

# Verificar health check
docker-compose ps

# Reiniciar servicio de BD
docker-compose restart library-db
```

### Problema: API no responde
```bash
# Verificar logs del backend
docker-compose logs library-api

# Verificar que las migraciones se ejecutaron
docker-compose exec library-api php artisan migrate:status

# Ejecutar migraciones manualmente si es necesario
docker-compose exec library-api php artisan migrate --force
```

### Problema: Permisos de archivos
```bash
# Arreglar permisos dentro del contenedor
docker-compose exec library-api chown -R www-data:www-data /var/www/storage
docker-compose exec library-api chmod -R 755 /var/www/storage
```

## Actualización del Código

```bash
# 1. Parar los servicios
docker-compose down

# 2. Actualizar el código en ./backend

# 3. Reconstruir las imágenes
docker-compose build --no-cache

# 4. Iniciar nuevamente
docker-compose up -d
```

## Backup y Restore

### Backup de la Base de Datos
```bash
# Crear backup
docker-compose exec library-db mysqldump -u root -prootpassword123 library_cloud_db > backup.sql

# Backup con docker run
docker run --rm --volumes-from library-mysql-cloud \
  -v $(pwd):/backup mysql:8.0 \
  mysqldump -h library-mysql-cloud -u root -prootpassword123 library_cloud_db > /backup/backup.sql
```

### Restore de la Base de Datos
```bash
# Restore desde backup
docker-compose exec -T library-db mysql -u root -prootpassword123 library_cloud_db < backup.sql
```

## Monitoreo

### Uso de Recursos
```bash
# Ver uso de recursos de los contenedores
docker stats

# Información detallada de un contenedor
docker inspect library-backend-cloud
```

### Logs en Tiempo Real
```bash
# Seguir logs de todos los servicios
docker-compose logs -f --tail=100

# Logs con timestamps
docker-compose logs -f -t
```

## Configuración de Producción

Para un entorno de producción, considera:

1. **Variables de Entorno Seguras**: Usar Docker Secrets
2. **Reverse Proxy**: Nginx o Traefik
3. **SSL/TLS**: Certificados HTTPS
4. **Monitoring**: Prometheus + Grafana
5. **Logging**: Centralizado con ELK Stack
6. **Backup Automático**: Scripts programados
7. **Health Checks**: Configurar health checks personalizados
