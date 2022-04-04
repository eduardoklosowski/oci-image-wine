# Aux

FROM debian:bullseye-slim AS aux

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        gpg \
        jq \
        wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget -nv -O - "https://dl.winehq.org/wine-builds/winehq.key" \
        | gpg --dearmor -o /winehq.gpg \
 && wget -nv -O /dxvk.tar.gz \
        "$(wget -O - https://api.github.com/repos/doitsujin/dxvk/releases/latest \
               | jq -r .assets[0].browser_download_url)"


# Image

FROM debian:bullseye-slim

RUN apt-get update \
 && apt-get install -y --install-recommends \
        ca-certificates \
        gosu \
        sudo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=aux /winehq.gpg /etc/apt/trusted.gpg.d/winehq.gpg
RUN dpkg --add-architecture i386 \
 && echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" \
        > /etc/apt/sources.list.d/winehq.list

RUN apt-get update \
 && apt-get install -y --install-recommends \
        winehq-stable \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=aux /dxvk.tar.gz /
COPY bin/* /usr/bin/

ENTRYPOINT ["/usr/bin/entrypoint"]
