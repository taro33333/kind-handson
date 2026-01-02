# Kubernetes Container Security Handson Environment

「リスクから学ぶ Kubernetesコンテナセキュリティ」のハンズオン用Docker環境

## 動作確認済み環境

- macOS (Apple Silicon M1/M2)
- macOS (Intel)
- Docker Desktop

## クイックスタート

```bash
# 1. ビルドと起動
docker compose up -d --build

# 2. コンテナに入る
docker compose exec handson bash

# 3. kindでクラスタ作成（推奨）
kind create cluster --name handson --config kind-config.yaml

# 4. 確認
kubectl get nodes

# 5. ハンズオン開始
cd /home/handson/workspace/book
```

## kindクラスタの操作

```bash
# クラスタ一覧
kind get clusters

# クラスタ削除
kind delete cluster --name handson

# 再作成
kind create cluster --name handson
```

## 環境の停止・削除

```bash
# 停止（データは保持）
docker compose stop

# 再開
docker compose start
docker compose exec handson bash

# 完全削除（データも消える）
docker compose down -v
```

## ディレクトリ構成

```
/home/handson/
├── workspace/
│   ├── book/      # 書籍サンプルコード
│   └── my-work/   # 作業用（永続化）
└── .kube/         # kubectl設定（永続化）
```

## 含まれるツール

- kubectl
- kind（推奨）
- minikube（予備）
- helm
- docker CLI
