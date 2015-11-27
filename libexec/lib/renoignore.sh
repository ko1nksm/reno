import "pattern"

ignore_matching() {
  local text="/$1"
  local ret pattern value
  local LANG=C LC_COLLATE=C LC_CTYPE=C

  [[ $text = */ ]] && ret=0 || ret=1

  while readline pattern; do
    if_comment "$pattern" && continue

    value=0
    if [[ $pattern = !* ]]; then
      pattern=${pattern:1}
      value=1
    fi

    [[ $pattern = \\* ]] && pattern=${pattern:1}
    [[ $pattern =  /* ]] || pattern="*/$pattern"

    if [[ $pattern = */ ]]; then
      case $text in
        $pattern) ret=$((1 - value)) ;;
        $pattern*) ret=$value ;;
      esac
    else
      case $text in
        $pattern | $pattern/*) ret=$value
      esac
    fi
  done

  return $ret
}
