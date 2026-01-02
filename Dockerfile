# Kubernetes Container Security Handson Environment
# Apple Silicon (arm64) / Intel (amd64) 両対応

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    jq \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    conntrack \
    iptables \
    sudo \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Docker CLIをインストール（アーキテクチャ自動検出）
RUN ARCH_NAME=$(dpkg --print-architecture) \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=${ARCH_NAME} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# kubectlをインストール（アーキテクチャ自動検出）
RUN ARCH_NAME=$(dpkg --print-architecture) \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH_NAME}/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# kindをインストール（アーキテクチャ自動検出）
RUN ARCH_NAME=$(dpkg --print-architecture) \
    && curl -Lo /tmp/kind "https://kind.sigs.k8s.io/dl/latest/kind-linux-${ARCH_NAME}" \
    && chmod +x /tmp/kind \
    && mv /tmp/kind /usr/local/bin/kind

# minikubeをインストール（アーキテクチャ自動検出）※予備として残す
RUN ARCH_NAME=$(dpkg --print-architecture) \
    && curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${ARCH_NAME}" \
    && install "minikube-linux-${ARCH_NAME}" /usr/local/bin/minikube \
    && rm "minikube-linux-${ARCH_NAME}"

# Helmをインストール
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 非rootユーザーを作成
RUN useradd -m -s /bin/bash -G sudo handson \
    && echo "handson ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# kubectl補完とエイリアスを設定
RUN echo 'source <(kubectl completion bash)' >> /home/handson/.bashrc \
    && echo 'alias k=kubectl' >> /home/handson/.bashrc \
    && echo 'complete -o default -F __start_kubectl k' >> /home/handson/.bashrc

# 作業ディレクトリを設定
WORKDIR /home/handson/workspace

# kind設定ファイルをコピー
COPY --chown=handson:handson kind-config.yaml /home/handson/workspace/kind-config.yaml

# リポジトリをクローン
RUN git clone https://github.com/mochizuki875/kubernetes-container-security-book.git /home/handson/workspace/book \
    && chown -R handson:handson /home/handson

USER handson

# エントリーポイントスクリプト
COPY --chown=handson:handson entrypoint.sh /home/handson/entrypoint.sh
RUN chmod +x /home/handson/entrypoint.sh

ENTRYPOINT ["/home/handson/entrypoint.sh"]
CMD ["bash"]
