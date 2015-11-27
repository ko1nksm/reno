#!/usr/bin/env bats

load env

@test "yesno" {
  reno-yesno "msg" <<< 'y'
  ! reno-yesno "msg" <<< 'n'
}
