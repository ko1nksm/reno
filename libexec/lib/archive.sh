extract() {
  local format=$1
  local filename=$2
  local dir=$3

  [[ -e "$filename" ]] || abort "File '$filename' not found."

  local command=""
  case $format in
    zip) command="unzip" ;;
    tar.gz) command="tar" ;;
    *) abort "Unsupported format '$format'"
  esac
  exists "$command" || abort "$command is required."

  local tmpdir
  tmpdir=$(mktemp -d)
  case $format in
    zip) run unzip "$filename" -d "$tmpdir" ;;
    tar.gz) run tar zxf "$filename" -C "$tmpdir" ;;
  esac

  # if extract directory has one directory on root, strip it.
  local root_dir_count=0
  local root_dir=""
  while readline path; do
    path=${path:2}
    [[ $path = "" ]] && continue
    root_dir_count=$((root_dir_count + 1))
    [[ -d "$tmpdir/$path" ]] && root_dir="$tmpdir/$path"
  done < <(cd "$tmpdir"; find ./ -maxdepth 1)

  (( root_dir_count != 1)) && root_dir=$tmpdir

  if [[ $root_dir || $RENO_DRY_RUN ]]; then
    run cp -a "$root_dir" "$dir"
    run rm "$tmpdir"
  fi

  [[ $RENO_DRY_RUN ]] && rmdir "$tmpdir"

  return 0
}
