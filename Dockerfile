FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    gcc \
    g++ \
    gdb \
    valgrind \
    make \
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*

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
