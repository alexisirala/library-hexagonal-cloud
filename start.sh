#!/bin/bash

echo "🚀 Iniciando Library Hexagonal Cloud Native..."

# Verificar si Docker está corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está ejecutándose. Por favor inicia Docker Desktop."
    exit 1
fi

# Construir y ejecutar
echo "🔨 Construyendo contenedores..."
docker-compose build

echo "🚀 Iniciando servicios..."
docker-compose up -d

echo "⏳ Esperando a que los servicios estén listos..."
sleep 45

echo "🔍 Verificando estado de los servicios..."
docker-compose ps

echo "✅ ¡Proyecto iniciado!"
echo "📱 API disponible en: http://localhost:8001/api/books"
echo "🗄️  Base de datos MySQL en puerto: 3307"
echo ""
echo "Comandos útiles:"
echo "- Ver logs: docker-compose logs -f"
echo "- Parar servicios: docker-compose down"
echo "- Reiniciar: docker-compose restart"
