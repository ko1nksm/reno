import "pattern"

attributes_matching() {
  local text="/$1"
  local line pattern attribute=""
  local LANG=C LC_COLLATE=C LC_CTYPE=C

  while readline line; do
    if_comment "$line" && continue

    pattern=$(trim "${line% *}")

    [[ $pattern = \\* ]] && pattern=${pattern:1}
    [[ $pattern =  /* ]] || pattern="*/$pattern"

    case $text in
      $pattern | $pattern/*) attribute=${line##* }; break
    esac
  done

  puts "$attribute"
}

get_attr() {
  local __value IFS=","

  for __value in $1; do
    case $__value in
      soft | hard | copy | tmpl) store "$2" "$__value" ;;
      "" | *[!0-9]*) ;;
      *) store "$3" "$(printf "%04d" $((10#$__value)))" ;;
    esac
  done
}
