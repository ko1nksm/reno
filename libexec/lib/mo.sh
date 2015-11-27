if [[ ${BASH_SOURCE:-} = "" ]]; then
  # hack for bash < 3.0
  BASH_SOURCE="mo" source "$RENO_DIR/vendor/mo"
else
  source "$RENO_DIR/vendor/mo"
fi
