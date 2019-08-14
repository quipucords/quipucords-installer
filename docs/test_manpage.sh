#!/bin/bash
date=$(date +%s)
tmpfile=$(mktemp /tmp/test-manpage-$date.1)
manpage=$PWD/quipucords-installer.1
cd ../; make manpage manpage_path=$tmpfile

DIFF=$(diff $tmpfile $manpage)
CMP=$(cmp $tmpfile $manpage)

if [ "$DIFF" != "" ]
then
  echo "Make manpage was not run."
  echo "$DIFF"
  rm $tmpfile
  exit 1
fi

if [ "$CMP" != "" ]
then
  echo "`make manpage` was not run."
  echo "$CMP"
  rm $tmpfile
  exit 1
fi
echo "Successful Test"
