# Base

FROM debian:bookworm-slim AS base

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        bash-completion \
        ca-certificates \
    ; \
    rm -rf /var/lib/apt/lists/*


# AUX

FROM base AS aux

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    echo "deb http://deb.debian.org/debian $(sed -rn 's/^VERSION_CODENAME=//p' /etc/os-release)-backports main" > /backports.list; \
    echo "Package: src:mesa:any src:libdrm:any" >> /backports-mesa; \
    echo "Pin: release n=$(sed -rn 's/^VERSION_CODENAME=//p' /etc/os-release)-backports" >> /backports-mesa; \
    echo "Pin-Priority: 500" >> /backports-mesa

RUN set -eux; \
    wget -nv -O/winehq.asc https://dl.winehq.org/wine-builds/winehq.key; \
    echo "deb [signed-by=/etc/apt/keyrings/winehq.asc] https://dl.winehq.org/wine-builds/debian/ $(sed -rn 's/^VERSION_CODENAME=//p' /etc/os-release) main" > /winehq.list

RUN wget -nv -O/dxvk.tar.gz https://github.com/doitsujin/dxvk/releases/download/v2.5.3/dxvk-2.5.3.tar.gz


# Image

FROM base

COPY --from=aux /backports.list /etc/apt/sources.list.d/backports.list
COPY --from=aux /backports-mesa /etc/apt/preferences.d/50-mesa

COPY --from=aux /winehq.asc /etc/apt/keyrings/winehq.asc
COPY --from=aux /winehq.list /etc/apt/sources.list.d/winehq.list

RUN set -eux; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        winehq-stable="10.0.0.0~$(sed -rn 's/^VERSION_CODENAME=//p' /etc/os-release)-1" \
        mesa-vulkan-drivers:amd64 \
        mesa-vulkan-drivers:i386 \
        libgl1:amd64 \
        libgl1:i386 \
        libegl1:amd64 \
        libegl1:i386 \
        libgles2:amd64 \
        libgles2:i386 \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-x \
        joystick \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY --from=aux /dxvk.tar.gz /usr/lib/dxvk/dxvk.tar.gz
COPY bin/setup-dxvk /usr/local/bin/setup-dxvk
