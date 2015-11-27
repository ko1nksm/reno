export TEST_HOME="$BATS_TMPDIR/reno"
rm -rf "$TEST_HOME"
cp -a "$BATS_TEST_DIRNAME/fixture/home" "$TEST_HOME"

export HOME=$TEST_HOME
export RENO_DIR="$BATS_TEST_DIRNAME/../"
export PATH="$BATS_TEST_DIRNAME/../libexec:$BATS_TEST_DIRNAME/helper:$PATH"

export INFILL_DIR=$(reno env INFILL_DIR)
export INFILL_VAR_DIR=$(reno env INFILL_VAR_DIR)
export INFILL_INSTALLED_DIR=$(reno env INFILL_INSTALLED_DIR)

tty() {
  printf "\n\033[36m%s\033[m\n" "$(cat)" > /dev/tty
}
