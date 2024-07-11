FROM debian:bookworm-slim

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
    ; \
    rm -rf /var/lib/apt/lists/*

ADD --chmod=644 https://dl.winehq.org/wine-builds/winehq.key /etc/apt/trusted.gpg.d/winehq.asc
RUN set -eux; \
    echo "deb https://dl.winehq.org/wine-builds/debian/ $(sed -rn 's/^VERSION_CODENAME=//p' /etc/os-release) main" > /etc/apt/sources.list.d/winehq.list; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        winehq-stable \
        mesa-vulkan-drivers:amd64 \
        mesa-vulkan-drivers:i386 \
        libgl1:amd64 \
        libgl1:i386 \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-x \
        joystick \
    ; \
    rm -rf /var/lib/apt/lists/*

ADD --chmod=644 https://github.com/doitsujin/dxvk/releases/download/v2.4/dxvk-2.4.tar.gz /dxvk.tar.gz
COPY bin/setup-dxvk /usr/local/bin/setup-dxvk
