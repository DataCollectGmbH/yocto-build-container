FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y -f install locales vim ssh python3 python3-cryptography btrfs-progs cryptsetup  cmake libengine-pkcs11-openssl pesign libp11-kit-dev libnss3-tools libjson-c-dev libnss3-dev libssl-dev libcurl4-openssl-dev bash-completion sudo curl screen diffstat gawk chrpath wget cpio texinfo less mc perl libtext-unidecode-perl libxml-libxml-perl pigz \
    && apt-get install -f \
    && apt-get --no-install-recommends -y install build-essential git-core diffstat texinfo chrpath libsdl1.2-dev xterm texi2html coreutils diffstat docbook-utils fakeroot g++ gawk gcc help2man libgmp3-dev libmpfr-dev libreadline6-dev libtool libxml2-dev make quilt ant automake liblzo2-2 chrpath doxygen libncurses5-dev xsltproc libcups2-dev libfreetype6-dev libxext-dev libxrender-dev libxtst-dev libcrypt-openssl-bignum-perl libperl4-corelibs-perl docbook2x subversion screen tmux htop unrar zip bc socat parted kpartx device-tree-compiler virtualbox pigz gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales \
    && pip3 install pycryptodome \
    && apt-get install -f \
    && apt-get clean && rm -rf /var/lib/apt/lists/*



RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8


RUN cd /
RUN git clone https://github.com/JackOfMostTrades/aws-kms-pkcs11.git \
    && git clone --recurse-submodules https://github.com/aws/aws-sdk-cpp \
    && cd aws-sdk-cpp && mkdir build && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_ONLY="core;s3;kms;acm-pca" -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make && make install


    

RUN sed -i '1i AWS_SDK_PATH=/usr/local/' /aws-kms-pkcs11/Makefile \
    && cd /aws-kms-pkcs11 && make \
    && make install


RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install 

RUN rm awscliv2.zip && rm -rf /aws-kms-pkcs11 /aws-sdk-cpp /aws


ENV LC_ALL en_US.UTF-8

#RUN useradd -s /bin/bash --create-home devel \
#        && addgroup devel staff \
#        && addgroup devel sudo \
#        && true



RUN useradd -s /bin/bash --create-home devel \
    && addgroup devel staff \
    && addgroup devel sudo \
    && echo "devel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    
# Create loop devices with appropriate permissions
#RUN for i in $(seq 0 7); do \
#        mknod /dev/loop$i b 7 $i && \
#        chown root:staff /dev/loop$i && \
#        chmod 660 /dev/loop$i; \
#    done
