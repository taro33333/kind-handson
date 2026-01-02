#!/bin/bash

# ボリュームの権限を修正
sudo chown -R handson:handson /home/handson/.minikube 2>/dev/null || true
sudo chown -R handson:handson /home/handson/.kube 2>/dev/null || true
sudo chown -R handson:handson /home/handson/workspace/my-work 2>/dev/null || true

echo "======================================"
echo " Kubernetes Container Security Handson"
echo "======================================"
echo ""

# Dockerソケットの権限を修正
if [ -S /var/run/docker.sock ]; then
    echo "✅ Docker socket detected"
    sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
else
    echo "⚠️  Docker socket not found"
fi

echo ""
echo "📚 Book repository: /home/handson/workspace/book"
echo ""
echo "🚀 Quick Start (kind - recommended):"
echo "   kind create cluster --name handson"
echo "   kubectl get nodes"
echo ""
echo "🚀 Alternative (minikube):"
echo "   minikube start --driver=docker"
echo ""
echo "======================================"
echo ""

exec "$@"
