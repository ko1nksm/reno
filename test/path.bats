#!/usr/bin/env bats

load env

normpath() {
  call normpath "$1"
}

relpath() {
  call relpath "$@"
}

@test "normpath" {
  run normpath "/a/b/c"
  [[ $output = "/a/b/c" ]]

  run normpath "/a/../b//.//c//"
  [[ $output = "/b/c" ]]

  run normpath "a"
  [[ $output = "$PWD/a" ]]
}

@test "relpath" {
  run relpath "/a/b/c" "/a/b/c/"
  [[ $output = "./" ]]

  run relpath "/a/b/c/d" "/a/b/c/"
  [[ $output = "d" ]]

  run relpath "/a/b/c/d/e" "/a/b/c/"
  [[ $output = "d/e" ]]

  run relpath "/a/b/d/e" "/a/b/c/"
  [[ $output = "../d/e" ]]

  run relpath "/a/b/c/d" "/b/c/"
  [[ $output = "../../a/b/c/d" ]]
}
