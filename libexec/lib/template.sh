template() {
  local src=$1
  local dest=${2:-}

  import "mo"

  set +u
  if [[ $dest ]]; then
    run mkfile "$dest" "$(mo "$src")"
  else
    mo "$src"
  fi
  set -u
}
