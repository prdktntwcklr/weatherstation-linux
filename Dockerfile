FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

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
RUN useradd -m builderuser && \
    mkdir -p /home/builderuser/app && \
    chown -R builderuser:builderuser /home/builderuser

# Copy files into image
# TODO: We'd prefer mounting them, but this currently doesn't work due to
# conflicting owners between the Windows host and the Linux Docker container
COPY . /home/builderuser/app/

RUN chown -R builderuser:builderuser /home/builderuser/app

USER builderuser

WORKDIR /home/builderuser/app
