include .env
export

DOCKER_COMPOSE := docker-compose -f docker-compose.yml

DSN := "postgresql://$(DB_USERNAME):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(DB_SSLMODE)"

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
.PHONY: help

run: db-up migrate-up app-up ### Run app and migrate up
.PHONY: run

stop: migrate-down ### Stop all containers and migrate down
	$(DOCKER_COMPOSE) down
.PHONY: stop

app-up: ### Start app
	$(DOCKER_COMPOSE) up --build -d app
.PHONY: app-up

app-down: ### Stop app
	$(DOCKER_COMPOSE) down app
.PHONY: app-down

wait-db: ### Wait until db is ready
	@until docker exec -t $(shell docker compose ps -q db) pg_isready -U $(DB_USERNAME); do sleep 1; done
.PHONY: wait-postgres

migrate-up: wait-db ### Migrate up
	docker run --rm --network $(shell docker inspect --format='{{.HostConfig.NetworkMode}}' $(shell docker compose ps -q db)) -v $(shell pwd)/migrations:/migrations migrate/migrate -path /migrations/ -database $(DSN) -verbose up
.PHONY: migrate-up

migrate-down: wait-db ### Migrate down
	echo "y" | docker run --rm --network $(shell docker inspect --format='{{.HostConfig.NetworkMode}}' $(shell docker compose ps -q db)) -v $(shell pwd)/migrations:/migrations migrate/migrate -path /migrations/ -database $(DSN) -verbose down -all
.PHONY: migrate-down

db-up: ### Start db
	$(DOCKER_COMPOSE) up -d db
.PHONY: db-up

db-down: ### Stop db
	$(DOCKER_COMPOSE) down db
.PHONY: db-down

logs: ### Show logs
	@echo "Showing logs..."
	$(DOCKER_COMPOSE) logs -f
.PHONY: logs

restart: stop run ### Restart containers
.PHONY: restart
