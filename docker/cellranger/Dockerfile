FROM centos:centos8

ENV CELLRANGER_VERSION 6.0.2
ENV BCL2FASTQ2_VERSION v2.20.0.422

COPY cellranger-${CELLRANGER_VERSION}.tar.gz /tmp/cellranger-${CELLRANGER_VERSION}.tar.gz
COPY bcl2fastq2-${BCL2FASTQ2_VERSION}-Source.tar.gz /tmp/bcl2fastq2-${BCL2FASTQ2_VERSION}-Source.tar.gz

RUN yum group install -y "Development Tools" && \
    tar -xzvf /tmp/cellranger-${CELLRANGER_VERSION}.tar.gz -C /opt && \
    tar -xzvf /tmp/bcl2fastq2-${BCL2FASTQ2_VERSION}-Source.tar.gz -C /tmp && \
    cd /tmp/bcl2fastq && \
    src/configure --prefix=/opt/bcl2fastq2 && \
    make && \
    make install && \
    rm -rf /tmp/* && \
    yum remove -y @"Development Tools"

ENV PATH "/opt/cellranger-${CELLRANGER_VERSION}:$PATH"
ENV PATH "/opt/bcl2fastq2/bin:$PATH"