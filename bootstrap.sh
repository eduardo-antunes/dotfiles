#!/bin/sh
#------------------------------------------------------------------------------#
# bootstrap.sh: cria links simbólicos para cada um dos itens de configuração   #
# no diretório de dotfiles, ou então apenas para um desses itens, conforme     #
# solicitado.                                                                  #
#                                                                              #
# Data de criação: 2025-11-15                                                  #
# Autor: Eduardo Antunes dos Santos Vieira                                     #
# Modo de uso: ./bootstrap.sh [item-configuração]                              #
#------------------------------------------------------------------------------#

DOTFILES_DIR="$PWD"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Cria link para item de configuração genérico (~/.config)
cfg_item() {
  if [ ! -d "$DOTFILES_DIR/$1" ]; then
    echo "Item de configuração $1 não existe"
    return 1
  fi

  local dest="$CONFIG_DIR/$1"
  [ -h "$dest" ] && return 0 # já está carregado
  [ -d "$dest" ] && mv "$dest" "$dest.bak"
  # Cria link simbólico para o diretório, tornando a inclusão de novos
  # arquivos a configurações existentes mais fácil
  ln -s "$DOTFILES_DIR/$1" "$CONFIG_DIR"
}

# Cria link para configuração do bash (~)
cfg_item_bash() {
  if [ ! -d "$DOTFILES_DIR/bash" ]; then
    echo 'Item de configuração bash não existe'
    return 1
  fi

  local dest="$HOME/.bashrc"
  [ -h "$dest" ] && return 0 # já está carregado
  [ -f "$dest" ] && mv "$dest" "$dest.bak"
  ln -s "$DOTFILES_DIR/bash/bashrc" "$dest"
}

# Cria link para scripts locais (~/.local/bin)
cfg_item_bin() {
  if [ ! -d "$DOTFILES_DIR/local-bin" ]; then
    echo 'Item de configuração local-bin não existe'
    return 1
  fi

  # Aqui, criam-se links para arquivos individuais em vez do diretório como
  # um todo, pois eu posso ter programas externos instalados em ~/.local/bin
  # e eu não quero que eles apareçam no repositório
  for script in $DOTFILES_DIR/local-bin/*; do
    local filename="$(basename "$script")"
    local dest="$HOME/.local/bin/$filename"
    [ -h "$dest" ] && return 0 # já está carregado
    [ -f "$dest" ] && mv "$dest" "$dest.bak"
    ln -s "$script" "$HOME/.local/bin"
  done
}

case $# in
  0)
    echo 'Carregando todas as configurações...'
    cfg_item_bash
    cfg_item emacs
    cfg_item foot
    cfg_item gdb
    cfg_item nvim
    cfg_item wezterm
    echo 'Ok!'
    ;;
  1)
    echo "carregando configuração de $1"
    case $1 in
      bash) cfg_item_bash ;;
      local-bin) cfg_item_bin ;;
      *) cfg_item "$1"
    esac
    ;;
  *) echo "Modo de uso: $0 [item-configuração]" ;;
esac
