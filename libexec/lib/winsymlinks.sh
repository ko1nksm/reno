winsymlinks() {
  local options="winsymlinks:lnk" option
  for option in $1; do
    case $option in
      winsymlinks | winsymlinks:* ) ;;
      *) options="$options $option"
    esac
  done
  echo "$options"
}

case $(uname -a) in
  *[[:space:]]Msys*)
    export MSYS
    MSYS=$(winsymlinks "${MSYS:-}")
    ;;
  *[[:space:]]Cygwin*)
    export CYGWIN
    CYGWIN=$(winsymlinks "${CYGWIN:-}")
    ;;
esac
