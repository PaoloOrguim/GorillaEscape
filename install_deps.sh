#!/usr/bin/env bash
#
# install_deps.sh — instala dependências de build e runtime
# para o projeto OpenGL/GLEW/GLFW desenvolvido pelo Érico.
#
# Compatível com Debian 12/Ubuntu 22.04+ e WSL2.
# -------------------------------------------------------------------

set -euo pipefail

#––– 1. Verifica se está rodando como root –––#
if [[ "$EUID" -ne 0 ]]; then
    echo "Por favor, execute como root: sudo $0"
    exit 1
fi

echo "==> Atualizando índices do apt…"
apt update -y

echo "==> Instalando toolchain C/C++ e utilitários básicos…"
apt install -y build-essential pkg-config git cmake wget curl

echo "==> Instalando cabeçalhos e libs X11/OpenGL necessários pelo GLFW…"
apt install -y \
    libx11-dev libxrandr-dev libxinerama-dev \
    libxcursor-dev libxxf86vm-dev libgl1-mesa-dev

echo "==> Instalando bibliotecas opcionais mas recomendadas…"
apt install -y libasound2-dev libpulse-dev libglm-dev

echo "==> Instalando GLFW via apt (dinâmico) *ou* compilando estático."
read -p "Compilar GLFW estático (libglfw3.a) localmente? [s/N] " BUILD_STATIC

if [[ "${BUILD_STATIC,,}" == "s" ]]; then
    TMP_DIR="$(mktemp -d)"
    echo "-> Clonando GLFW dentro de $TMP_DIR…"
    git clone --depth 1 https://github.com/glfw/glfw.git "$TMP_DIR/glfw"
    pushd "$TMP_DIR/glfw" > /dev/null
    cmake -S . -B build -D BUILD_SHARED_LIBS=OFF -D GLFW_BUILD_DOCS=OFF \
        -D GLFW_BUILD_TESTS=OFF -D GLFW_BUILD_EXAMPLES=OFF
    cmake --build build -j"$(nproc)"
    echo "-> Copiando libglfw3.a para lib-linux/…"
    install -D build/src/libglfw3.a "$(pwd -P | sed 's#glfw.*##')lib-linux/libglfw3.a"
    popd > /dev/null
    rm -rf "$TMP_DIR"
else
    echo "-> Instalando pacote oficial libglfw3-dev (link dinâmico)…"
    apt install -y libglfw3-dev
    echo "   Lembre-se de trocar './lib-linux/libglfw3.a' por '-lglfw' no Makefile."
fi

echo "==> Dependências concluídas!"
echo "Agora é só rodar 'make' na raiz do projeto. ;)"

