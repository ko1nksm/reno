if_comment() {
  case $1 in
    "" | "#"*) return 0
  esac
  return 1
}
