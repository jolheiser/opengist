BINARY_NAME := "opengist"

all: install build

install:
	@echo "Installing NPM dependencies..."
	@npm ci
	@echo "Installing Go dependencies..."
	@go mod download

build_frontend:
	@echo "Building frontend assets..."
	npx vite build

build_backend:
	@echo "Building Opengist binary..."
	go build -tags fs_embed -o {{BINARY_NAME}} .

build: build_frontend build_backend

build_docker:
	@echo "Building Docker image..."
	docker build -t {{BINARY_NAME}}:latest .

watch_frontend:
	@echo "Building frontend assets..."
	npx vite dev --port 16157

watch_backend:
	@echo "Building Opengist binary..."
	OG_DEV=1 npx nodemon --watch '**/*' -e html,yml,go,js --signal SIGTERM --exec 'go run . --config config.yml'

watch:
	@bash ./watch.sh

clean:
	@echo "Cleaning up build artifacts..."
	@rm -f {{BINARY_NAME}} public/manifest.json
	@rm -rf public/assets

clean_docker:
	@echo "Cleaning up Docker image..."
	@docker rmi {{BINARY_NAME}}