FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install essential packages and development tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    postgresql-client \
    gcc \
    g++ \
    gdb \
    valgrind \
    make \
    cmake \
    git \
    openssh-server \
    sudo \
    vim \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Official Docker CLI + Compose v2 plugin (multi-arch: amd64 / arm64).
RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "$ARCH" in \
      x86_64) DOCKER_ARCH=x86_64; COMPOSE_ARCH=x86_64 ;; \
      aarch64|arm64) DOCKER_ARCH=aarch64; COMPOSE_ARCH=aarch64 ;; \
      *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;; \
    esac; \
    curl -fsSL \
      "https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-27.3.1.tgz" \
      | tar -xz --strip-components=1 -C /usr/local/bin docker/docker; \
    mkdir -p /usr/local/lib/docker/cli-plugins /usr/libexec/docker/cli-plugins; \
    curl -fsSL \
      "https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-${COMPOSE_ARCH}" \
      -o /usr/local/lib/docker/cli-plugins/docker-compose; \
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose; \
    ln -sf /usr/local/lib/docker/cli-plugins/docker-compose \
      /usr/libexec/docker/cli-plugins/docker-compose

WORKDIR /workspace

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y openssh-server && \
    useradd -m -s /bin/bash student && \
    echo 'student:course' | chpasswd && \
    mkdir -p /run/sshd && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]
