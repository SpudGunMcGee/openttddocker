FROM ubuntu:latest

ARG OPENTTD_VERSION
ARG GFX_VERSION
ENV args='-D -c /config/openttd.cfg'

RUN apt-get update && apt-get install -y \
    wget \
    git \
    unzip \
    xz-utils \
    libgomp1 \
    libglib2.0-0

RUN mkdir /app /config /extract
WORKDIR /extract

RUN wget https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-generic-amd64.tar.xz \
    && tar -xvf openttd-${OPENTTD_VERSION}-linux-generic-amd64.tar.xz \
    && mv openttd-${OPENTTD_VERSION}-linux-generic-amd64/* /app

RUN wget -q https://cdn.openttd.org/opengfx-releases/${GFX_VERSION}/opengfx-${GFX_VERSION}-all.zip \
    && unzip opengfx-${GFX_VERSION}-all.zip \
    && tar -xf opengfx-${GFX_VERSION}.tar \
    && mv opengfx-${GFX_VERSION}/* /app/baseset

RUN adduser --home /config --system --group openttd

RUN chmod u+x /app/openttd
RUN chown -R openttd:openttd /config /app

WORKDIR /app
VOLUME /config

USER openttd

EXPOSE 3977/tcp
EXPOSE 3979/tcp
EXPOSE 3979/udp

ENTRYPOINT /app/openttd ${args}
#ENTRYPOINT [ "bash" ]