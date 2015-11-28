if [[ ! ${RENO_SUPPORT_READLINKF:-} ]]; then
  if readlink -f /dev/null >/dev/null 2>&1; then
    RENO_SUPPORT_READLINKF="readlink"
  else
    RENO_SUPPORT_READLINKF="bash"
  fi
fi

case $RENO_SUPPORT_READLINKF in
  readlink)
    readlinkf() {
      readlink -f "$1"
    }
    ;;
  bash)
    readlinkf() {
      # fallback for if -f option missing
      local file=$1
      local pwd=$PWD
      while [[ $file ]]; do
        cd "${file%/*}"
        name=${file##*/}
        file=$(readlink "$name") &&:
      done
      echo "$(pwd -P)/$name"
      cd "$pwd"
    }
    ;;
  *) abort "Unknown RENO_SUPPORT_READLINKF type '$RENO_SUPPORT_READLINKF'"
esac

symlink() {
  run ln -s "$(relpath "$1" "${2%/*}")" "$2"
}

mklink() {
  local srcw destw

  srcw=$(cygpath -a -w "$1")
  destw=$(cygpath -a -w "$2")

  run cmd /c "mklink /j \"$destw\" \"$srcw\"" >/dev/null
}
