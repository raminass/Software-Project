FROM ubuntu:latest

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
    pandas \
    matplotlib \
    pylint \
    autopep8 \
    flake8 \
    pytest \
    ipython \
    jupyter \
    ipykernel \
    notebook

# Set up Jupyter Notebook
RUN python -m ipykernel install --user --name=python3

# Set up SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create a non-root user
RUN useradd -m -s /bin/bash student
RUN echo 'student:password' | chpasswd
RUN usermod -aG sudo student

# Set up shared folder
RUN mkdir /shared
RUN chown student:student /shared

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

