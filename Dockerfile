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

# Install Python packages, including Jupyter Notebook and scientific libraries
RUN pip3 install --no-cache-dir \
    numpy \
    pytest \
    ipython \
    jupyter \
    matplotlib \
    pandas \
    scipy

# Setup SSH server
RUN mkdir /var/run/sshd
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Create a user for SSH access
RUN useradd -rm -d /home/developer -s /bin/bash -g root -G sudo -u 1000 developer
RUN echo 'developer:developer' | chpasswd


# Setup Jupyter Notebook to run on container startup
RUN mkdir -p /home/developer/.jupyter
RUN echo "c.NotebookApp.allow_origin = '*'" > /home/developer/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /home/developer/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /home/developer/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> /home/developer/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.notebook_dir = '/home/developer'" >> /home/developer/.jupyter/jupyter_notebook_config.py

# Expose SSH and Jupyter Notebook ports
EXPOSE 22
EXPOSE 8888

# Start both SSH and Jupyter Notebook servers on container startup
CMD service ssh start && sudo -u developer jupyter-notebook --no-browser --ip=0.0.0.0 --port=8888 --notebook-dir=/home/developer
