.PHONY: help build up down logs shell db-shell test clean dev prod subtree-help subtree-add subtree-push subtree-pull

help: ## Mostrar esta ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Construir las imágenes Docker
	docker-compose build

up: ## Iniciar los servicios en modo producción
	docker-compose up -d

down: ## Parar todos los servicios
	docker-compose down

logs: ## Ver logs de todos los servicios
	docker-compose logs -f

shell: ## Acceder al shell del contenedor backend
	docker-compose exec library-api bash

db-shell: ## Acceder al shell de MySQL
	docker-compose exec library-db mysql -u library_user -plibrary_password123 library_cloud_db

test: ## Ejecutar tests
	docker-compose exec library-api php artisan test

clean: ## Limpiar contenedores y volúmenes
	docker-compose down -v
	docker system prune -f

dev: ## Iniciar en modo desarrollo
	docker-compose -f docker-compose.dev.yml up --build

dev-down: ## Parar modo desarrollo
	docker-compose -f docker-compose.dev.yml down

prod: ## Iniciar en modo producción
	docker-compose up --build -d

status: ## Ver estado de los servicios
	docker-compose ps

restart: ## Reiniciar todos los servicios
	docker-compose restart

backup: ## Crear backup de la base de datos
	docker-compose exec library-db mysqldump -u root -prootpassword123 library_cloud_db > backup_$(shell date +%Y%m%d_%H%M%S).sql

migrate: ## Ejecutar migraciones
	docker-compose exec library-api php artisan migrate

seed: ## Ejecutar seeders
	docker-compose exec library-api php artisan db:seed

fresh: ## Reiniciar BD con datos frescos
	docker-compose exec library-api php artisan migrate:fresh --seed

# Comandos de Subtrees
subtree-help: ## Mostrar ayuda para gestión de subtrees
	./manage-subtrees.sh help

subtree-add: ## Agregar un subtree (uso: make subtree-add COMPONENT=backend REPO=url)
	@if [ -z "$(COMPONENT)" ] || [ -z "$(REPO)" ]; then \
		echo "Error: Se requiere COMPONENT y REPO"; \
		echo "Uso: make subtree-add COMPONENT=backend REPO=https://github.com/user/repo.git"; \
		exit 1; \
	fi
	./manage-subtrees.sh add $(COMPONENT) $(REPO)

subtree-push: ## Enviar cambios a un subtree (uso: make subtree-push COMPONENT=backend)
	@if [ -z "$(COMPONENT)" ]; then \
		echo "Error: Se requiere COMPONENT"; \
		echo "Uso: make subtree-push COMPONENT=backend"; \
		exit 1; \
	fi
	./manage-subtrees.sh push $(COMPONENT)

subtree-pull: ## Obtener cambios de un subtree (uso: make subtree-pull COMPONENT=backend)
	@if [ -z "$(COMPONENT)" ]; then \
		echo "Error: Se requiere COMPONENT"; \
		echo "Uso: make subtree-pull COMPONENT=backend"; \
		exit 1; \
	fi
	./manage-subtrees.sh pull $(COMPONENT)
