#!/bin/bash

# Script para gestionar Git Subtrees en el monorepo
# Usage: ./manage-subtrees.sh [add|push|pull] [component] [repo_url]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}Gestor de Git Subtrees para Library Monorepo${NC}"
    echo ""
    echo "Uso: $0 [COMANDO] [COMPONENTE] [REPO_URL]"
    echo ""
    echo "Comandos:"
    echo "  add     - Agregar un subtree"
    echo "  push    - Enviar cambios al subtree"
    echo "  pull    - Obtener cambios del subtree"
    echo "  list    - Listar subtrees configurados"
    echo ""
    echo "Componentes disponibles:"
    echo "  backend   - Aplicación Laravel"
    echo "  docs      - Documentación"
    echo "  database  - Scripts de base de datos"
    echo ""
    echo "Ejemplos:"
    echo "  $0 add backend https://github.com/usuario/library-backend.git"
    echo "  $0 push backend"
    echo "  $0 pull docs"
}

# Función para agregar subtree
add_subtree() {
    local component=$1
    local repo_url=$2
    
    if [[ -z "$component" || -z "$repo_url" ]]; then
        echo -e "${RED}Error: Se requiere componente y URL del repositorio${NC}"
        show_help
        exit 1
    fi
    
    echo -e "${YELLOW}Agregando subtree para $component desde $repo_url${NC}"
    
    # Verificar si el directorio ya existe
    if [[ -d "$component" ]]; then
        echo -e "${YELLOW}Advertencia: El directorio $component ya existe${NC}"
        read -p "¿Deseas continuar? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    git subtree add --prefix="$component" "$repo_url" main --squash
    echo -e "${GREEN}Subtree $component agregado exitosamente${NC}"
}

# Función para hacer push a subtree
push_subtree() {
    local component=$1
    
    if [[ -z "$component" ]]; then
        echo -e "${RED}Error: Se requiere especificar el componente${NC}"
        show_help
        exit 1
    fi
    
    # Buscar la URL del remote en el historial de git
    local repo_url=$(git log --grep="git-subtree-dir: $component" --pretty=format:"%B" -1 | grep -oP 'git-subtree-split: \K.*' || echo "")
    
    if [[ -z "$repo_url" ]]; then
        echo -e "${RED}Error: No se pudo encontrar la URL del repositorio para $component${NC}"
        echo "Usa: git subtree push --prefix=$component [REPO_URL] main"
        exit 1
    fi
    
    echo -e "${YELLOW}Enviando cambios de $component${NC}"
    git subtree push --prefix="$component" "$repo_url" main
    echo -e "${GREEN}Cambios enviados exitosamente${NC}"
}

# Función para hacer pull de subtree
pull_subtree() {
    local component=$1
    
    if [[ -z "$component" ]]; then
        echo -e "${RED}Error: Se requiere especificar el componente${NC}"
        show_help
        exit 1
    fi
    
    echo -e "${YELLOW}Obteniendo cambios para $component${NC}"
    
    # Esta función requiere que especifiques manualmente la URL
    echo -e "${BLUE}Para hacer pull, ejecuta:${NC}"
    echo "git subtree pull --prefix=$component [REPO_URL] main --squash"
}

# Función para listar subtrees
list_subtrees() {
    echo -e "${BLUE}Subtrees configurados:${NC}"
    git log --grep="git-subtree-dir:" --pretty=format:"%s" | grep "Add" | sort | uniq
}

# Procesar argumentos
case "$1" in
    "add")
        add_subtree "$2" "$3"
        ;;
    "push")
        push_subtree "$2"
        ;;
    "pull")
        pull_subtree "$2"
        ;;
    "list")
        list_subtrees
        ;;
    "help"|"-h"|"--help"|"")
        show_help
        ;;
    *)
        echo -e "${RED}Comando no reconocido: $1${NC}"
        show_help
        exit 1
        ;;
esac
