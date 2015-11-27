if [[ ! ${RENO_SUPPORT_STAT:-} ]]; then
  if [[ $(stat -f '/') = "/" ]]; then
    RENO_SUPPORT_STAT="bsd"
  else
    RENO_SUPPORT_STAT="gnu"
  fi
fi

case $RENO_SUPPORT_STAT in
  gnu)
    get_perm() {
      printf "%04d\n" $(( 10#$(stat -L -c "%a" "$1") ))
    }

    get_inode() {
      stat -L -c "%i" "$1"
    }

    get_filesize() {
      stat -L -c "%s" "$1"
    }

    statNY() {
      local line q s1 s2 e1 e2
      # GNU stat's %N format is hard to use.
      #
      # $ stat -c "%N" "that's"
      # `that\'s' -> `which'
      #
      # And quotation mark is dependent on locale
      xargsd "\n" stat -c "%N" | while readline line; do
        q="${line:${#line}-1:1}" # end of quotation mark

        s1=1 # after the character of the first quote
        e1=s1
        while :; do
          case ${line:$e1:1} in
            $q) break ;;
            \\) e1=$((e1 + 2)) ;;
             *) e1=$((e1 + 1)) ;;
          esac
        done

        s2=$((e1 + 6)) # after the character of the next quote
        e2=s2
        if (( s2 < ${#line} )); then
          while :; do
            case ${line:$e2:1} in
              $q) break ;;
              \\) e2=$((e2 + 2)) ;;
               *) e2=$((e2 + 1)) ;;
            esac
          done
        fi

        printf "%s\t%s\n" "${line:$s1:$((e1 - s1))}" "${line:$s2:$((e2 - s2))}"
      done
    }

    ;;
  bsd)
    get_perm() {
      printf "%04d\n" $(( 10#$(stat -L -f "%Mp%Lp" "$1") ))
    }

    get_inode() {
      stat -L -f "%i" "$1"
    }

    get_filesize() {
      stat -L -f "%z" "$1"
    }

    statNY() {
      xargsd "\n" stat -f "%N$TAB%Y"
    }

    ;;
  *) abort "Unknown RENO_SUPPORT_STAT type '$RENO_SUPPORT_STAT'"
esac
