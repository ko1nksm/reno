_eval() { local s=$1; shift; eval "$s"; } # to correct error line number.

info() {
  [[ ${RENO_QUIET:-} ]] || echo -e "reno: $*"
}

warn() {
  echo -e "${YELLOW}reno: [warn] ${*}${RESET}" >&2
}

verbose() {
  if [[ ${RENO_DRY_RUN:-} ]]; then
    echo -e "${CYAN}${*}${RESET}"
  fi
}

quit() {
  [[ ${RENO_QUIET:-} ]] || echo -e "reno: $*"
  exit 0
}

abort() {
  echo -e "${RED}reno: [error] ${*}${RESET}" >&2
  exit 1
}

run() {
  local file line params
  cmd=$1
  shift

  params=()
  case $cmd in
    cd)
      verbose "> cd $*"
      cd "$@"
      ;;
    eval)
      local script=$1
      while readline line; do
        verbose "| $line"
      done < <(trim "$script")
      [[ ${RENO_DRY_RUN:-} ]] || _eval "$@"
      ;;
    mkdir)
      [[ -d $1 ]] || params=(mkdir -p "$@")
      ;;
    mkfile)
      file=$1
      shift
      verbose "> mkfile $file";
      while readline line; do
        verbose "| $line"
      done <<< "$@"
      [[ ${RENO_DRY_RUN:-} ]] || mkfile "$file" "$@"
      ;;
    rm)
      [[ -f $1 ]] && params=(rm "$@")
      [[ -d $1 ]] && params=(rm -r "$@")
      ;;
    *) params=($cmd "$@") ;;
  esac

  if ((${#params[@]})); then
    verbose "> ${params[*]}";
    [[ ${RENO_DRY_RUN:-} ]] || "${params[@]}"
  fi
}
