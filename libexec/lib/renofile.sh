is_section() {
  [[ ${1:0:2} = "["[[:alpha:]] && ${1:${#1}-1:1} = "]" ]] || return 1
  [[ ${1:1:${#1}-2} != *[![:alnum:]:_-]* ]]
}

read_renofile() {
  local name=$1
  local section=$2
  local match="" line

  while readline line; do
    is_section "$line" && match=""

    if [[ $line = "[$section]" ]]; then
      match=1
      echo
      continue
    fi

    [[ $match ]] && puts "$line" || echo
  done < <(readfile "$INFILL_DIR/$name/Renofile")
}

load_renofile_env() {
  local name=$1
  shift

  local script=$(read_renofile "$name" "env") line

  if [[ $script ]]; then
    run cd "$INFILL_DIR/$name"

    verbose "> [Load env section]"
    while readline line; do
      verbose "| $line"
    done < <(trim "$script")

    trap 'abort "load_renofile_env error env section at $PWD/Renofile"' EXIT
    set +u
    eval "$script" "$@"
    set -u
    trap - EXIT
  fi
}

run_renofile() {
  local name=$1
  local section=$2
  shift 2

  local script=$(read_renofile "$name" "$section")

  if [[ $script ]]; then
    run cd "$INFILL_DIR/$name"

    verbose "> [Run section '$section']"
    trap 'abort "run_renofile error $section section at $PWD/Renofile"' EXIT
    set +u
    run eval "$script" "$@"
    set -u

    trap - EXIT
  fi
}
