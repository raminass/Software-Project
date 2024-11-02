# Base image with Ubuntu LTS
FROM ubuntu:22.04

# Prevent timezone prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install essential packages and development tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
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

# Install Python packages
RUN pip3 install --no-cache-dir \
    numpy \
    pytest \
    ipython

# Setup SSH server
RUN mkdir /var/run/sshd
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Create a user for SSH access
RUN useradd -rm -d /home/developer -s /bin/bash -g root -G sudo -u 1000 developer
RUN echo 'developer:developer' | chpasswd

# Create workspace directory
RUN mkdir -p /workspace
RUN chown developer:root /workspace

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]
