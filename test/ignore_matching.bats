#!/usr/bin/env bats

load env

ignore() {
  call ignore_matching "$1" <<< "$ignore_list"
}

@test "match (simple)" {
ignore_list=$(cat << DATA
foo/1
foo/3
/foo/4
DATA
)

  ignore "foo/1"
  ignore "foo/1/2"
  ! ignore "foo/2"
  ignore "foo/3"
  ignore "foo/" # Normal directory does not create symlink.
  ! ignore "foo/11"
  ignore "pre/foo/1"
  ignore "foo/4"
  ! ignore "pre/foo/4"
}

@test "match (directory)" {
ignore_list=$(cat << DATA
foo/
bar/1/
/baz/2/
DATA
)

  ! ignore "foo/"
  ignore "foo/1"
  ignore "foo/1/2"
  ignore "foo/1/2/"
  ! ignore "pre/foo/"
  ignore "bar"
  ignore "bar/"
  ! ignore "baz/2"
  ignore "pre/baz/2"
}

@test "match (glob)" {
ignore_list=$(cat << DATA
foo/1/*
foo/2/?*
foo/3/[a-c]*
foo/*/foo
DATA
)

  ! ignore "foo/1"
  ignore "foo/1/"
  ignore "foo/1/a"
  ! ignore "foo/2"
  ignore "foo/2/" # Normal directory does not create symlink.
  ignore "foo/3/a"
  ! ignore "foo/3/d"
  ignore "foo/bar/bar/bar/foo"
}


@test "match (comment)" {
ignore_list=$(cat << 'DATA'
#comment

foo
#bar
\#baz
DATA
)

  ignore "foo"
  ! ignore "#bar"
  ignore "#baz"
}

@test "match (inverse)" {
ignore_list=$(cat << 'DATA'
foo/*
!foo/2
DATA
)

  ignore "foo/1"
  ! ignore "foo/2"
}

@test "match (directory)" {
ignore_list=$(cat << 'DATA'
foo
bar/
DATA
)

  ignore "foo"
  ignore "foo/1"
  ! ignore "bar"
  ignore "bar/1"
  ! ignore "baz"
}
