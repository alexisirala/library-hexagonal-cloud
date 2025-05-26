#!/bin/bash

# Script de pruebas para la API Cloud Native
echo "🧪 Iniciando pruebas de la API Library Cloud Native..."

API_BASE="http://localhost:8001/api"

# Función para mostrar resultados
show_result() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2"
    else
        echo "❌ $2"
    fi
}

# Verificar que la API esté disponible
echo "📡 Verificando disponibilidad de la API..."
curl -s $API_BASE/books > /dev/null
show_result $? "API accesible en $API_BASE"

# Test 1: Listar todos los libros
echo "📚 Test 1: Listar todos los libros"
RESPONSE=$(curl -s $API_BASE/books)
if [[ $RESPONSE == *"id"* ]] && [[ $RESPONSE == *"title"* ]]; then
    echo "✅ Lista de libros obtenida correctamente"
    echo "📊 Número de libros: $(echo $RESPONSE | grep -o '"id"' | wc -l)"
else
    echo "❌ Error al obtener lista de libros"
fi

# Test 2: Crear un nuevo libro
echo "📖 Test 2: Crear un nuevo libro"
CREATE_RESPONSE=$(curl -s -X POST $API_BASE/books \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Test Book Cloud Native",
        "author": "Test Author API",
        "isbn": "9781234567890",
        "quantity": 10
    }')

if [[ $CREATE_RESPONSE == *"id"* ]]; then
    BOOK_ID=$(echo $CREATE_RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    echo "✅ Libro creado con ID: $BOOK_ID"
    
    # Test 3: Obtener el libro creado
    echo "🔍 Test 3: Obtener libro específico"
    GET_RESPONSE=$(curl -s $API_BASE/books/$BOOK_ID)
    if [[ $GET_RESPONSE == *"Test Book Cloud Native"* ]]; then
        echo "✅ Libro obtenido correctamente"
    else
        echo "❌ Error al obtener libro específico"
    fi
    
    # Test 4: Actualizar el libro
    echo "✏️ Test 4: Actualizar libro"
    UPDATE_RESPONSE=$(curl -s -X PUT $API_BASE/books/$BOOK_ID \
        -H "Content-Type: application/json" \
        -d '{
            "title": "Test Book Updated",
            "author": "Test Author Updated",
            "isbn": "9781234567890",
            "quantity": 15
        }')
    
    if [[ $UPDATE_RESPONSE == *"Test Book Updated"* ]]; then
        echo "✅ Libro actualizado correctamente"
    else
        echo "❌ Error al actualizar libro"
    fi
    
    # Test 5: Prestar libro
    echo "📤 Test 5: Prestar libro"
    BORROW_RESPONSE=$(curl -s -X PATCH $API_BASE/books/$BOOK_ID/borrow)
    if [[ $BORROW_RESPONSE == *"successfully"* ]] || [[ $BORROW_RESPONSE == *"quantity"* ]]; then
        echo "✅ Libro prestado correctamente"
    else
        echo "❌ Error al prestar libro"
    fi
    
    # Test 6: Devolver libro
    echo "📥 Test 6: Devolver libro"
    RETURN_RESPONSE=$(curl -s -X PATCH $API_BASE/books/$BOOK_ID/return)
    if [[ $RETURN_RESPONSE == *"successfully"* ]] || [[ $RETURN_RESPONSE == *"quantity"* ]]; then
        echo "✅ Libro devuelto correctamente"
    else
        echo "❌ Error al devolver libro"
    fi
    
    # Test 7: Eliminar libro
    echo "🗑️ Test 7: Eliminar libro"
    DELETE_RESPONSE=$(curl -s -X DELETE $API_BASE/books/$BOOK_ID)
    if [ $(curl -s -o /dev/null -w "%{http_code}" $API_BASE/books/$BOOK_ID) -eq 404 ]; then
        echo "✅ Libro eliminado correctamente"
    else
        echo "❌ Error al eliminar libro"
    fi
    
else
    echo "❌ Error al crear libro de prueba"
fi

echo ""
echo "🏁 Pruebas completadas!"
echo "💡 Para ejecutar manualmente:"
echo "   curl $API_BASE/books"
