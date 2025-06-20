#!/usr/bin/env bash

# We need only binary wkhtmltox files in lambda layer, so we delete all the others
rm -rf /tgt/wkhtmltox/{include,share,lib}

mkdir -p /tgt/wkhtmltox/lib
# We need to copy dependencies which are not presented in amazonlinux2023 image
curl https://raw.githubusercontent.com/ncopa/lddtree/refs/tags/v1.27/lddtree.sh -o /tgt/lddtree.sh
chmod +x /tgt/lddtree.sh
cp $(/tgt/lddtree.sh -l /tgt/wkhtmltox/bin/wkhtmltopdf | grep '^\/lib' | sed -r -e'/wkhtmltopdf$/d') /tgt/wkhtmltox/lib/

# To be able to create pdf files we need a font. 
# There is one (dejavu) in the docker image used for compilation.
cp -r /usr/share/fonts /tgt/wkhtmltox/
cat >/tgt/wkhtmltox/fonts/fonts.conf <<EOL
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <dir>/var/task/fonts</dir>
  <dir>/opt/fonts</dir>
  <cachedir>/tmp/fonts-cache</cachedir>
  <config></config>
</fontconfig>
EOL
