FROM kurron/docker-jetbrains-base:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

LABEL org.kurron.ide.name="CLion" org.kurron.ide.version=1.2.2

# Install make and compilers
RUN apt-get update && \
    apt-get install -y build-essential autoconf automake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ENV PATH /opt/llvm/bin:$PATH

RUN apt-get update && apt-get -y install cmake git build-essential vim python

ADD install-clang /opt/install-clang

RUN /opt/install-clang -j 4 -C /opt/llvm

ADD https://download.jetbrains.com/cpp/CLion-2017.1.3.tar.gz /tmp/ide.tar.gz

RUN mkdir -p /opt/ide && \
    tar zxvf /tmp/ide.tar.gz --strip-components=1 -C /opt/ide && \
    rm /tmp/ide.tar.gz

ENV CL_JDK=/usr/lib/jvm/oracle-jdk-8
USER developer:developer
WORKDIR /home/developer
ENTRYPOINT ["/opt/ide/bin/clion.sh"]
