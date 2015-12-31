#!/usr/bin/env bash

readonly VERSION="0.1.2"
readonly PROJECT="https://github.com/ko1nksm/reno"
readonly REPOSITORY="https://github.com/ko1nksm/reno.git"
readonly ARCHIVE="https://github.com/ko1nksm/reno/archive/master.tar.gz"
readonly INSTALLER="https://raw.githubusercontent.com/ko1nksm/reno/master/install.sh"

if [ "${0##*/}" != "reno-properties" ]; then
  set -eu

  abort() { echo "$@"; exit 1; }
  exists() { type "$1" > /dev/null 2>&1; }

  confirm() {
    local input
    echo -n "$1 [y/N] "
    if [[ $RENO_YES ]]; then
      echo "y"
      return 0
    fi
    read input
    [[ $input = "y" || $input = "Y" ]]
  }

  info() {
    echo
    echo "  Reno directory: ${RENO_DIR:-}"
    echo "  Reno command  : ${RENO_BIN:-}"
    echo
  }

  extract() {
    mkdir -p  "$1"
    tar xz --strip-components=1 -C "$1"
  }

  [ "${BASH_VERSION:-}" ] || abort "Do run with bash."

  [[ -d ${0%/*} ]] && current=$(cd "${0%/*}"; pwd) || current=""

  : "${RENO_REPOSITORY:=$REPOSITORY}"
  : "${RENO_ARCHIVE:=$ARCHIVE}"
  : "${RENO_BIN:=$HOME/bin/reno}"
  : "${RENO_DIR:=$HOME/.reno}"
  : "${RENO_CURL_OPTS:=}"
  : "${RENO_WGET_OPTS:=}"
  : "${RENO_YES:=}"

  echo "Reno installer"
  [[ -e $RENO_BIN || -L $RENO_BIN ]] && abort "Already exists $RENO_BIN."

  if [[ $current && -e "$current/.RENO_DIR" ]]; then
    RENO_DIR=$current
    info
    confirm "Are you sure to install reno?" || exit 1
  else
    [[ -e $RENO_DIR || -L $RENO_DIR ]] && abort "Already exists $RENO_DIR."

    if exists git; then
        info
        confirm "Are you sure to install reno via git?" || exit 1
      git clone "$RENO_REPOSITORY" "$RENO_DIR"
    else
      fallback=""
      if exists curl;then
        fallback="curl"
      elif exists wget; then
        fallback="wget"
      fi

      if [[ $fallback ]]; then
        echo "Git not found. Uses $fallback instead."
        info
        confirm "Are you sure to install reno via $fallback?" || exit 1

        case $fallback in
          curl)
            # shellcheck disable=SC2086
            curl $RENO_CURL_OPTS -L "$RENO_ARCHIVE" | extract "$RENO_DIR" ;;
          wget)
            # shellcheck disable=SC2086
            wget $RENO_WGET_OPTS -O - "$RENO_ARCHIVE" | extract "$RENO_DIR" ;;
        esac
      else
        abort "Requires git or curl or wget to install via online."
      fi
    fi
  fi

  . "$RENO_DIR/libexec/lib/winsymlinks.sh"
  . "$RENO_DIR/libexec/lib/path.sh"

  mkdir -p "${RENO_BIN%/*}"
  ln -s "$(relpath "$RENO_DIR/bin/reno" "${RENO_BIN%/*}")" "$RENO_BIN"

  echo "'$RENO_BIN' has been created."
  exists reno || echo "Add '\$HOME/bin' to your \$PATH."
fi
