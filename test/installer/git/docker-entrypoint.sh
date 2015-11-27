#!/bin/bash

if [[ $1 = "reno" ]]; then
  set -e

  PATH="$HOME/bin:$PATH"

  mkdir -p ~/.ssh
  ssh-keyscan -H "$TEST_HOST" >> ~/.ssh/known_hosts
  git clone "$TEST_RENO_REPO" ~/.reno

  ~/.reno/install.sh
  reno init "$TEST_INFILL_REPO"
  reno info
  exit
fi

exec "$@"
