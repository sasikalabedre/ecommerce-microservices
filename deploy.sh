#!/bin/bash

REGION="ap-southeast-2"
REGISTRY="939169264693.dkr.ecr.ap-southeast-2.amazonaws.com"

AUTH_IMAGE="$REGISTRY/ecommerce/auth-service:latest"
PRODUCT_IMAGE="$REGISTRY/ecommerce/product-service:latest"
ORDER_IMAGE="$REGISTRY/order-service:latest"

echo "Logging in to ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REGISTRY

echo "Pulling latest images..."
docker pull $AUTH_IMAGE
docker pull $PRODUCT_IMAGE
docker pull $ORDER_IMAGE

echo "Stopping old containers..."
docker stop auth-service product-service order-service 2>/dev/null || true

echo "Removing old containers..."
docker rm auth-service product-service order-service 2>/dev/null || true

echo "Starting auth-service..."
docker run -d --name auth-service -p 3001:3001 $AUTH_IMAGE

echo "Starting product-service..."
docker run -d --name product-service -p 3003:3003 $PRODUCT_IMAGE

echo "Starting order-service..."
docker run -d --name order-service -p 3002:3002 $ORDER_IMAGE

echo "Checking containers..."
docker ps

echo "Deployment completed."
