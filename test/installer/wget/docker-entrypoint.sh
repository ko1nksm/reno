#!/bin/bash

if [[ $1 = "reno" ]]; then
  set -e

  PATH="$HOME/bin:$PATH"

  export RENO_ARCHIVE=$TEST_RENO_ARCHIVE
  export RENO_WGET_OPTS=$TEST_WGET_OPTS

  bash -c "$(wget $RENO_WGET_OPTS -qO - $TEST_RENO_INSTALLER)"

  reno init --type archive --format tar.gz "$TEST_INFILL_ARCHIVE"
  reno info
  exit
fi

exec "$@"
