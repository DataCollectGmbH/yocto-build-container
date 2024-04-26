FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y -f install locales vim ssh python3 bash-completion sudo curl screen diffstat gawk chrpath wget cpio texinfo less mc perl libtext-unidecode-perl libxml-libxml-perl pigz \
    && apt-get install -f \
    && apt-get --no-install-recommends -y install build-essential git-core diffstat texinfo chrpath libsdl1.2-dev xterm texi2html coreutils diffstat docbook-utils fakeroot g++ gawk gcc help2man libgmp3-dev libmpfr-dev libreadline6-dev libtool libxml2-dev make quilt ant automake liblzo2-2 chrpath doxygen libncurses5-dev xsltproc libcups2-dev libfreetype6-dev libxext-dev libxrender-dev libxtst-dev libcrypt-openssl-bignum-perl libperl4-corelibs-perl docbook2x subversion screen tmux htop unrar zip bc socat parted kpartx device-tree-compiler virtualbox pigz gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales \
    && apt-get install -f \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8

RUN useradd -s /bin/bash --create-home devel \
        && addgroup devel staff \
        && addgroup devel sudo \
        && true

RUN mkdir -p /yocto && chown devel:staff /yocto
WORKDIR /yocto
USER devel:staff
