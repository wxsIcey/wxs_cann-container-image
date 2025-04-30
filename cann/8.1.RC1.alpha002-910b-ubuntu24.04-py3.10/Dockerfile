# Stage 1: Install Python
FROM ubuntu:24.04 AS python-installer

# Python Environment variables
ENV PATH=/usr/local/python3.10.17/bin:${PATH}

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        apt-transport-https