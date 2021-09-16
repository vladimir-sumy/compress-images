#!/bin/bash
#file containing images
filename="$1"
#apt install imagemagick-6.q16
if [ -z "$filename" ]; then
  echo "Please specify an input filename."
  exit 1
fi
if [ ! -d "images_backup" ]; then
   echo "Directory images_backup does not exists."
  exit 1
fi

counter=0
converted=0
notfound=0

while read line; do
  counter=$((counter+1))
  if test -f "$line"; then
    FILESIZE=$(stat -c%s "$line")
    DIRNAME=$(dirname "$line")
    if [ ! -d "images_backup/${DIRNAME}" ]; then
      mkdir -p "images_backup/${DIRNAME}"
    fi
    cp -r $line "images_backup/${line}"
    convert $line -resize "1024x>" -quality 80 $line
    FILESIZE2=$(stat -c%s "$line")
    chown www-data:www-data "images_backup/${line}"
    echo "${line} $FILESIZE / $FILESIZE2 "
    converted=$((converted+1))
  else
    notfound=$((notfound+1))
  fi
done < $filename
echo "Total: ${counter} Converted: ${converted} NotFound: ${notfound} "
