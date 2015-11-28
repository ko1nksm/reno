import "stat"

if [[ ! ${RENO_SUPPORT_CMP:-} ]]; then
  RENO_SUPPORT_CMP=$(detect_exists cmp diff md5sum)
fi

case $RENO_SUPPORT_CMP in
  cmp)
    cmpfile() {
      cmp -s "$1" "$2" >/dev/null 2>&1
    }
    ;;
  diff)
    cmpfile() {
      diff -q "$1" "$2" >/dev/null 2>&1
    }
    ;;
  md5sum)
    cmpfile() {
      local size1 size2 sum1 sum2

      size1=$(get_filesize "$1")
      size2=$(get_filesize "$2")

      if (( size1 = size2 )); then
        sum1=$(md5sum "$1")
        sum2=$(md5sum "$2")
        [[ "${sum1%% *}" = "${sum2%% *}" ]] && return 0
      fi

      return 1
    }
    ;;
  *) abort "Unknown RENO_SUPPORT_CMP type '$RENO_SUPPORT_CMP'"
esac

if [[ ! ${RENO_SUPPORT_DIFF:-} ]]; then
  RENO_SUPPORT_DIFF=$(detect_exists diff bash)
fi

case $RENO_SUPPORT_DIFF in
  diff)
    cmpdir() {
      diff -r "$1" "$2" >/dev/null 2>&1
    }
    ;;
  bash)
    cmpdir() {
      local list1 list2 line

      [[ -d $1 && -d $2 ]] || return 1

      list1=$(cd "$1"; find . -type f | sort)
      list2=$(cd "$2"; find . -type f | sort)

      [[ "$list1" = "$list2" ]] || return 1

      while readline line; do
        line=${line:2}
        cmpfile "$1/$line" "$2/$line" || return 1
      done <<< "$list1"
      return 0
    }
    ;;
  *) abort "Unknown RENO_SUPPORT_DIFF type '$RENO_SUPPORT_DIFF'"
esac
