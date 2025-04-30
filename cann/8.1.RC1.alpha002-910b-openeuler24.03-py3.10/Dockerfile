# Stage 1: Install Python
FROM openeuler/openeuler:24.03 AS python-installer

# Python Environment variables
ENV PATH=/usr/local/python3.10.17/bin:${PATH}

RUN yum update -y && \
    yum install -y \
        gcc \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*