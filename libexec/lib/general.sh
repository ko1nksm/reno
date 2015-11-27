readonly TAB=$'\t'
readonly LF=$'\n'

readonly BLACK="\033[30m"
readonly RED="\033[31m"
readonly GREEN="\033[32m"
readonly YELLOW="\033[33m"
readonly BLUE="\033[34m"
readonly MAGENTA="\033[35m"
readonly CYAN="\033[36m"
readonly WHITE="\033[37m"
readonly RESET="\033[m"

copy_function() {
  local code=$(declare -f store_shim)
  eval "${code/$1 /$2 }"
}

puts() {
  printf "%s\n" "$1"
}

store() {
  printf -v "$1" "%s" "$2"
}

store_shim() {
  # shellcheck disable=SC2086
  eval $1="'${2//\'/"'\''"}'"
}

# printf -v not supported by bash 2.x
if ! printf -v _ "" 2>/dev/null; then
  copy_function "store_shim" "store"
fi

exists() {
  type "$1" >/dev/null 2>&1
}

detect_exists() {
  local cmd
  for cmd in "$@"; do
    exists "$cmd" || continue
    puts "$cmd"
    return 0
  done
  return 1
}

mkfile() {
  local file=$1
  puts "${2:-}" > "$file"
}

defined() {
  [[ ${!1:+x} ]]
}

readline() {
  IFS= read -r "$@"
}

lines() {
  local i=0
  while readline _; do
    i=$((i + 1))
  done
  echo $i
}

tty() {
  cat > /dev/tty
}

trim() {
  local var=${1:-}
  var=${var#${var%%[![:space:]]*}}
  var=${var%${var##*[![:space:]]}}
  puts "$var"
}

# xargs -d not supported in some os
xargsd() {
  local delim=$1
  shift
  tr "$delim" "\0" | xargs -0 "$@"
}

readfile() {
  local i
  for i in "$@"; do
    [[ -f $i ]] || continue
    puts "$(< "$i")"
  done
}

:source() {
  if [[ -f $1 ]]; then
    source "$1"
  fi
}

# Enclose parameters in double quotes
shquote() {
  local text="" str pattern="[[:space:]\*\!\"\#\$\&\'\(\)\~\`\[\]\;\<\>\?]"

  for str in "$@"; do
    str=${str//\\/\\\\}
    str=${str//\!/\\!}
    str=${str//\"/\\\"}
    str=${str//\`/\\\`}
    [[ $str = *$pattern* ]] && str="\"$str\""
    text="$text${text:+ }$str"
  done

  puts "$text"
}

contains() {
  local text=$1 i
  shift
  for i in "$@"; do
    [[ $text = "$i" ]] && return 0
  done
  return 1
}
