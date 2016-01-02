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

  (
    cd "$INFILL_DIR/$name"
    while readline file; do
      file=${file:2}
      case $file in
        "" | Renofile | .renoignore | .renoattributes) ;;
        *)
        _find_feature_files "$file" "$ignore"
      esac
    done < <(find . -maxdepth 1 -follow)
  )
}

_find_feature_files() {
  local file=$1
  local ignore=$2
  local dir

  if [[ -d $file ]]; then
    dir=$file
    if  ! ignore_matching "$dir/" <<< "$ignore"; then
      puts "$dir"
    fi
    ignore_matching "$dir" <<< "$ignore" && return 0
    while readline file; do
      [[ $file = "$dir" ]] && continue
      _find_feature_files "$file" "$ignore"
    done < <(find "$dir" -maxdepth 1 -follow)
  else
    ignore_matching "$file" <<< "$ignore" && return 0
    puts "$file"
  fi
}

compare_feature_file() {
  local file1=${1%/}
  local file2=${2%/}

  local real1 real2 inode1 inode2 real1 real2

  if [[ -L $file1 || -L $file2 ]]; then
    if [[ "$file1" = "$file2" ]]; then
      echo "same"
      return 0
    fi

    real1=$(readlinkf "$file1")
    real2=$(readlinkf "$file2")

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

  inode1=$(get_inode "$file1")
  inode2=$(get_inode "$file2")

  if [[ $inode1 = "$inode2" ]]; then
    real1=$(readlinkf "$file1")
    real2=$(readlinkf "$file2")

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
