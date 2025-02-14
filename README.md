# OCI Image - Wine

Imagem [OCI](https://opencontainers.org/) para rodar programas com [Wine](https://www.winehq.org/).

## Build da Imagem

A imagem pode ser gerada diretamente do código no GitHub executando:

```sh
docker build -t wine 'https://github.com/eduardoklosowski/oci-image-wine.git#main'
```

## Criar Ambiente Wine

O primeiro passo para criar um ambiente do Wine é iniciar um contêiner:

```sh
./run-wine-container
```

Para habilitar o [DXVK](https://github.com/doitsujin/dxvk) (D3D9, D3D10 e D3D11 para Wine através do [Vulkan](https://www.vulkan.org/)) pode-se executar:

```sh
setup-dxvk install
```

Para desabilitar o DXVK pode-se executar:

```sh
setup-dxvk uninstall
```
