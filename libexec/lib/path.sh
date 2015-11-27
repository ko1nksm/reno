# Do not depend on other modules because install.sh imports this file only.

normpath() {
  local path=$1
  local normpath="" fragment IFS="/"

  [[ $path = /* ]] || path="$PWD/$path"

  for fragment in ${path:1}; do
    case $fragment in
      "" | .) ;;
      ..) normpath=${normpath%/*} ;;
      *) normpath="$normpath/$fragment" ;;
    esac
  done
  printf "%s\n" "$normpath"
}

relpath() {
  local target=$(normpath "$1")
  local dir=$(normpath "${2:-$PWD}")

  if [[ $target = "$dir" ]]; then
    printf "./\n"
    return
  fi

  local back=""
  while [[ $dir && $target = "${target#$dir}" ]]; do
    dir=${dir%/*}
    back="../$back"
  done

  printf "%s\n" "${back}${target#$dir/}"
}
