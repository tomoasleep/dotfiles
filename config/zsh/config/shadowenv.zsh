# Ref: https://shopify.github.io/shadowenv/getting-started/
if which shadowenv > /dev/null; then
  eval "$(shadowenv init bash)"
fi
