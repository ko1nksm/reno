import "pattern"

read_group_file() {
  if [[ $1 = "--oneline" ]]; then
    local list=""

    while IFS=" " read -r item _; do
      list="$list${list:+, }$item"
    done < <(read_group_file "$2")

    puts "$list"
    return 0
  fi

  local name=$1
  local line

  while readline line; do
    if_comment "$line" && continue
    puts "$line"
  done < <(readfile "$INFILL_DIR/$name")
}
