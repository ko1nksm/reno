#!/usr/bin/env bats

load env

check_store() {
  run call --output store OUTPUT "$1"
  [[ $output = "$1" ]]

  run call --output store_shim OUTPUT "$1"
  [[ $output = "$1" ]]
}


@test "store" {
data=$(cat << 'DATA'
!"#$%&'()-=^~\|@`[{;+:*]},<.>/?_
DATA
)
  CR=$'\r'
  LF=$'\n'
  TAB=$'\t'

  check_store "$data"
  check_store " "
  check_store "=$CR=$LF=$TAB="
  check_store "日本語"
  check_store '\100'
  check_store '\x100'
  check_store '%100'
}
