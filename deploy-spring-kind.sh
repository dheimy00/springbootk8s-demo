#!/usr/bin/env bash
set -e

echo "🔹 Verificando diretório atual..."
PROJECT_DIR=$(pwd)
echo "📂 Diretório do projeto: $PROJECT_DIR"

# Nome da imagem
IMAGE_NAME="demoapp-spring"
NAMESPACE="demo-namespace"

# Build Docker
echo "🔹 Buildando a imagem Docker..."
docker build -t $IMAGE_NAME .

# Carregar imagem no Kind
echo "🔹 Carregando a imagem no Kind..."
kind load docker-image $IMAGE_NAME

# Criar namespace
echo "🔹 Criando namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Gerar TLS (Git Bash no Windows)
echo "🔹 Gerando certificados TLS..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -out "$PROJECT_DIR/tls.crt" \
  -keyout "$PROJECT_DIR/tls.key" \
  -subj "/CN=demoapp.local/O=demoapp"

# Criar secret TLS
echo "🔹 Criando secret TLS..."
kubectl create secret tls demoapp-tls \
  --cert="$PROJECT_DIR/tls.crt" \
  --key="$PROJECT_DIR/tls.key" \
  -n $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Aplicar Deployment, Service e Ingress
echo "🔹 Aplicando Deployment, Service e Ingress..."
kubectl apply -f deployment.yaml -n $NAMESPACE
kubectl apply -f service.yaml -n $NAMESPACE
kubectl apply -f ingress.yaml -n $NAMESPACE

echo "✅ Deploy completo!"
echo "➡ NodePort: http://172.19.0.2:30080"
echo "➡ Ingress HTTP: http://demoapp.local"
echo "➡ Ingress HTTPS: https://demoapp.local"
echo "⚠️ Adicione no seu hosts (Windows):"
echo "172.19.0.2 demoapp.local"
