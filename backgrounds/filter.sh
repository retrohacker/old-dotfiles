#!/usr/bin/env bash
# filter.sh
#
# Usage:  filter.sh is used to remove corrupt and/or low resolution images from
#         the backgrounds directory.

# Get Working Directory

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

min_width=1920
min_height=1080
files=$(find $DIR -type f -name '*.jpg')

deleted=0

for file in $files; do
  metadata=$(identify -ping -regard-warnings $file 2>/dev/null)
  if [ $? -ne 0 ]; then
    rm $file
    deleted=$((deleted+1))
    continue
  fi
  width=$(echo $metadata | cut -f 3 -d " " | sed s/x.*//)
  if [ $width -lt 1920 ]; then
    deleted=$((deleted+1))
    rm $file
    continue
  fi
  height=$(echo $metadata | cut -f 3 -d " " | sed s/.*x//)
  if [ $height -lt 1080 ]; then
    deleted=$((deleted+1))
    rm $file
    continue
  fi
done

echo "Deleted $deleted files"
