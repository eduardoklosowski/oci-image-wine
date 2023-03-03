# Aux

FROM debian:bullseye-slim AS aux

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gpg \
        jq \
        wget \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    wget -nv -O - "https://dl.winehq.org/wine-builds/winehq.key" \
        | gpg --dearmor -o /winehq.gpg; \
    wget -nv -O /dxvk.tar.gz \
        "$(wget -qO - https://api.github.com/repos/doitsujin/dxvk/releases \
               | jq -r '.[]|select(.tag_name == "v1.10.3").assets[0].browser_download_url')"


# Image

FROM debian:bullseye-slim

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gosu \
        sudo \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY --from=aux /winehq.gpg /etc/apt/trusted.gpg.d/winehq.gpg
RUN set -eux; \
    dpkg --add-architecture i386; \
    echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" \
        > /etc/apt/sources.list.d/winehq.list; \
    apt-get update; \
    apt-get install -y --install-recommends winehq-stable; \
    rm -rf /var/lib/apt/lists/*

COPY --from=aux /dxvk.tar.gz /
COPY bin/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint"]
