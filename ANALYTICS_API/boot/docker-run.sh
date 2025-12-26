#!/bin/bash

# Docker run script for Random App Number API
# Usage: ./boot/docker-run.sh [build|run|stop|logs|shell]

set -e

CONTAINER_NAME="random-number-api"
IMAGE_NAME="random-number-api"
PORT=${PORT:-8000}
DATABASE_URL=${DATABASE_URL:-"sqlite:///./test.db"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Build Docker image
build() {
    log_info "Building Docker image: $IMAGE_NAME"
    docker build -t $IMAGE_NAME:latest .
    log_info "Image built successfully!"
}

# Run container
run() {
    log_info "Starting container: $CONTAINER_NAME"
    
    # Check if container is already running
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_warning "Container is already running. Stopping it first..."
        docker stop $CONTAINER_NAME
    fi
    
    # Remove old container if exists
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_warning "Removing old container..."
        docker rm $CONTAINER_NAME
    fi
    
    docker run -d \
        --name $CONTAINER_NAME \
        -p $PORT:8000 \
        -e DATABASE_URL="$DATABASE_URL" \
        -e PYTHONDONTWRITEBYTECODE=1 \
        -e PYTHONUNBUFFERED=1 \
        -v $(pwd):/app \
        $IMAGE_NAME:latest
    
    log_info "Container started successfully!"
    log_info "API available at: http://localhost:$PORT"
    log_info "Swagger UI: http://localhost:$PORT/docs"
}

# Stop container
stop() {
    log_info "Stopping container: $CONTAINER_NAME"
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        docker stop $CONTAINER_NAME
        log_info "Container stopped successfully!"
    else
        log_warning "Container is not running"
    fi
}

# View logs
logs() {
    log_info "Showing logs for: $CONTAINER_NAME"
    docker logs -f $CONTAINER_NAME
}

# Interactive shell in container
shell() {
    log_info "Opening interactive shell in container: $CONTAINER_NAME"
    docker exec -it $CONTAINER_NAME /bin/bash
}

# Status
status() {
    log_info "Checking container status..."
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_info "Container is RUNNING"
        docker ps --filter "name=$CONTAINER_NAME"
    elif docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_warning "Container is STOPPED"
        docker ps -a --filter "name=$CONTAINER_NAME"
    else
        log_warning "Container does not exist"
    fi
}

# Main script logic
case "${1:-run}" in
    build)
        build
        ;;
    run)
        build
        run
        ;;
    stop)
        stop
        ;;
    logs)
        logs
        ;;
    shell)
        shell
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {build|run|stop|logs|shell|status}"
        echo ""
        echo "Commands:"
        echo "  build    - Build Docker image"
        echo "  run      - Build and run container (default)"
        echo "  stop     - Stop running container"
        echo "  logs     - View container logs (follow mode)"
        echo "  shell    - Open interactive shell in container"
        echo "  status   - Show container status"
        echo ""
        echo "Environment variables:"
        echo "  PORT          - Container port (default: 8000)"
        echo "  DATABASE_URL  - Database connection string"
        echo ""
        echo "Examples:"
        echo "  ./boot/docker-run.sh run"
        echo "  ./boot/docker-run.sh logs"
        echo "  PORT=9000 ./boot/docker-run.sh run"
        echo "  DATABASE_URL=postgresql://user:pass@host:5432/db ./boot/docker-run.sh run"
        exit 1
        ;;
esac
