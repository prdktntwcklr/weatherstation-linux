FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Mandatory Buildroot Pakackages
        # See: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
        build-essential \
        bash \
        bc \
        binutils \
        bzip2 \
        cpio \
        diffutils \
        file \
        g++ \
        gcc \
        git \
        gzip \
        libncurses5-dev \
        make \
        patch \
        perl \
        python3 \
        rsync \
        sed \
        tar \
        unzip \
        wget \
        # Other Packages
        ca-certificates \
        nano

# Create a non-root user and set up the environment
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir -p /app \
    && chown -R $USERNAME:$USERNAME /app

USER $USERNAME
WORKDIR /app
