#!/bin/bash

if [[ $1 = "reno" ]]; then
  set -e

  PATH="$HOME/bin:$PATH"

  export RENO_ARCHIVE=$TEST_RENO_ARCHIVE
  export RENO_CURL_OPTS=$TEST_CURL_OPTS

  bash -c "$(curl -L $RENO_CURL_OPTS $TEST_RENO_INSTALLER)"

  reno init --type archive --format tar.gz "$TEST_INFILL_ARCHIVE"
  reno info
  exit
fi

exec "$@"
