allowed_name() {
  [[ $1 != *[[:upper:][:space:]./]* ]]
}

is_hide_name() {
  local IFS=:
  for i in $INFILL_HIDE_NAME; do
    [[ $1 = "$i" ]] && return 0
  done
  return 1
}

list_infill() {
  local pwd=$PWD
  cd "$INFILL_DIR"

  for name in *; do
    allowed_name "$name" || continue
    is_hide_name "$name" && continue
    [[ "${1:-}" = "--feature" && -f $name ]] && continue
    [[ "${1:-}" = "--group" && -d $name ]] && continue
    puts "$name"
  done

  cd "$pwd"
}

exists_feature() {
  allowed_name "$1" && [[ -d "$INFILL_DIR/$1" ]]
}

exists_group() {
  allowed_name "$1" && [[ -f "$INFILL_DIR/$1" ]]
}

is_installed() {
  [[ -f "$INFILL_INSTALLED_DIR/$1" ]]
}
