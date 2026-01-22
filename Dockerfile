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
