#!/usr/bin/env bats

load env

@test "feature" {
  reno-install "foo"

  [[ -L "$HOME/file1" ]]
  [[ -f "$HOME/feature" ]]
  [[ -f "$INFILL_INSTALLED_DIR/foo" ]]

  reno-uninstall "foo"

  [[ ! -e "$HOME/file1" ]]
  [[ ! -e "$HOME/feature" ]]
  [[ ! -e "$INFILL_INSTALLED_DIR/foo" ]]
}

@test "find_feature_files" {
expected=$(cat << DATA
.dot
sub/1.txt
DATA
)

  files=$(call find_feature_files "bar" | sort)

  [[ "$files" = "$expected" ]]
}
