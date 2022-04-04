# Docker - Wine

Imagem Docker para executar aplicações com Wine

## Gerar imagem

A imagem Docker pode ser gerada diretamente do código no GitHub executando:

```sh
docker build -t docker-wine:bullseye https://github.com/eduardoklosowski/docker-wine.git#main
```

## Criar ambiente Wine

O primeiro passo para criar um ambiente do Wine é iniciar um contêiner:

```sh
./run-wine-container
```

A criação do ambiente pode ser feita com o comando:

```sh
winecfg
```

Durante a criação do ambiente será pedido para instalar as dependências do [Mono](https://www.mono-project.com/), é recomdável instar.

Para habilitar o [DXVK](https://github.com/doitsujin/dxvk) (D3D9, D3D10 e D3D11 para Wine através do [Vulkan](https://www.vulkan.org/)) pode-se executar:

```sh
enable-dxvk
```

Para desabilitar o DXVK pode-se executar:

```sh
disable-dxvk
```

## Executar programa

Para executar um programa basta copiá-lo para `~/.wine_env/docker-wine`, iniciar um contêiner (`./run-wine-container`) e executar o programa com Wine (`wine programa.exe`).

## Criar ambiente Wine 64 bits

Para criar um ambiente Wine 64 bits é necessário iniciar um contêiner com algumas variáveis de ambiente, o que pode ser feita com o comando:

```sh
./run-wine-container env64 bash
```

Após isso pode-se seguir o procedimento normal, apenas na hora de executar um programa com Wine, deve-se utilizar `wine64` no lugar de `wine`.
