#!/usr/bin/env bash

# Get Working Directory

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

BG=$(find $DIR -type f -name '*.jpg' | shuf -n 1)
echo $BG > $DIR/last.log
feh --bg-fill $BG
