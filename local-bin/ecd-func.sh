#!/usr/bin/env bash
#------------------------------------------------------------------------------#
# ecd.sh: uma alternativa um pouco mais completa ao cd no bash, feita sobre os #
# comandos pushd e popd. O nome é uma sigla para Eduardo's CD. Inspirado pelo  #
# script acd_func (https://linuxgazette.net//109/marinov.html), mas nenhum     #
# código foi copiado dele.                                                     #
#                                                                              #
# Data de criação: 2025-12-20                                                  #
# Autor: Eduardo Antunes dos Santos Vieira                                     #
# Modo de uso: ecd [diretório|-n|--]                                           #
#------------------------------------------------------------------------------#

function usage {
  echo "Eduardo's cd command"
  echo 'usage: ecd [dir | -n | --]'
  echo '  if no argument is given, cd to home directory'
  echo '  n is expected to be a positive integer'
}

function is_positive_integer {
  [[ "$#" -lt 1 ]] && return 1
  [[ "$1" =~ ^[0-9]+$ ]]
}

function ecd {
  local arg="$HOME"
  [[ "$#" -ge 1 ]] && arg="$1"

  if [[ "$arg" == -* ]]; then
    local flag="${arg:1}"
    case "$flag" in
      h | help | -help) usage; return 0;;
      -) dirs -v; return 0;;
      "") flag=1;;
    esac
    if ! is_positive_integer "$flag"; then
      echo "expected n to be a positive integer"
      usage
      return 1
    fi
    arg=$(dirs +$flag)
    popd -n "+$flag" > /dev/null
  fi
  [[ "${arg:0:1}" == '~' ]] && arg="$HOME${arg:1}"
  pushd $arg > /dev/null

  # Garante que o histórico mantenha-se com no máximo 10 entradas
  popd -n +11 &> /dev/null
}
