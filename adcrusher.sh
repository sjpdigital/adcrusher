#!/usr/bin/env bash

command -v pngquant >/dev/null 2>&1 || { printf >&2 "I require pngquant but it's not installed. Aborting."; exit 1; }
command -v jpegoptim >/dev/null 2>&1 || { printf >&2 "I require jpegoptim but it's not installed. Aborting."; exit 1; }
command -v svgo >/dev/null 2>&1 || { printf >&2 "I require svgo but it's not installed. Aborting."; exit 1; }
command -v uglifyjs >/dev/null 2>&1 || { printf >&2 "I require uglifyjs but it's not installed. Aborting."; exit 1; }
command -v html-minifier >/dev/null 2>&1 || { printf >&2 "I require html-minifier but it's not installed. Aborting."; exit 1; }

pushd () {
  command pushd "$@" > /dev/null
}

popd () {
  command popd "$@" > /dev/null
}

if (( $# < 1 ))
then
  printf "Usage: adcrusher folder [ folder ]"
  exit 1
fi

for var in "$@"
do
  if [ ! -d "$var" ]; then
    printf "$var is not a directory, skipping..."
    continue
  else
    dest="crushed-$var"
    rm -rf "$dest"
    cp -rf "$var" "$dest"

    printf "entering $var"
    pushd "$dest"

    printf "minify .png\n"
    find . -name "*.png" -exec pngquant --skip-if-larger --force --ext .png --speed 1 {} \;

    printf "minify .jpg\n"
    find . -name "*.jpg" -exec jpegoptim -m 70 -t -s {} \;

    printf "minify .svg\n"
    find . -name "*.svg" -exec svgo {} \;

    printf "minify .js\n"
    find . -name "*.js" ! -name "manifest.js" -exec uglifyjs --compress --mangle --screw-ie8 --output {} -- {} \;

    printf "minify .html\n"
    find . -name "*.html" \
      -exec html-minifier \
      --case-sensitive \
      --collapse-boolean-attributes \
      --collapse-inline-tag-whitespace \
      --collapse-inline-tag-whitespace \
      --collapse-whitespace \
      --html5 \
      --minify-cs \
      --minify-js \
      --remove-comments \
      --remove-empty-attributes \
      --output "{}.min" {} \; \
      -exec mv "{}.min" {} \;

    printf "zipping...\n"
    zip -r "../$var.zip" *

    printf "leaving $var\n"
    popd

    printf "cleanup...\n"
    rm -rf "$dest"

    printf "\ndone!\n"
  fi
done
