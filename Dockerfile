FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=appuser
ARG USER_ID=1000
ARG GROUP_ID=1000

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
        locales \
        nano && \
    rm -rf /var/lib/apt/lists/*

# Set the locale (Buildroot sometimes grumbles if UTF-8 isn't set)
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Dynamically create a user that matches host UID
RUN groupadd -g ${GROUP_ID} ${USER} && \
    useradd -u ${USER_ID} -g ${USER} -m ${USER}

USER ${USER}
WORKDIR /app
