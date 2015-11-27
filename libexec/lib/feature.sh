import "renoignore" "symlink" "cmp"

find_feature_files() {
  local name dir ignore="" file

  if [[ $1 = "--full" ]]; then
    name=$2
    dir="$INFILL_DIR/$2/"
  else
    name=$1
    dir=""
  fi

  ignore=$(readfile "$INFILL_DIR/.renoignore" "$INFILL_DIR/$name/.renoignore")

  while readline file; do
    file=${file:2}
    case $file in
      "" | Renofile | .renoignore | .renoattributes) ;;
      *)
        [[ -d "$INFILL_DIR/$name/$file" ]] && text="$file/" || text=$file
        ignore_matching "$text" <<< "$ignore" && continue
        puts "$dir$file"
    esac
  done < <(cd "$INFILL_DIR/$name"; find . -follow)
}

compare_feature_file() {
  local file1=${1%/}
  local file2=${2%/}

  if [[ -L $file1 || -L $file2 ]]; then
    if [[ "$file1" = "$file2" ]]; then
      echo "same"
      return 0
    fi

    local real1=$(readlinkf "$file1")
    local real2=$(readlinkf "$file2")

    if [[ "$real1" = "$real2" ]]; then
      echo "soft"
      return 0
    fi
  fi

  if [[ -d $file1 || -d $file2 ]]; then
    if cmpdir "$file1" "$file2"; then
      echo "copy"
      return 0
    fi

    return 1
  fi

  local inode1=$(get_inode "$file1")
  local inode2=$(get_inode "$file2")

  if [[ $inode1 = "$inode2" ]]; then
    local real1=$(readlinkf "$file1")
    local real2=$(readlinkf "$file2")

    if [[ "$real1" = "$real2" ]]; then
      echo "same"
      return 0
    fi

    echo "hard"
    return 0
  fi

  if cmpfile "$file1" "$file2"; then
    echo "copy"
    return 0
  fi

  return 1
}
