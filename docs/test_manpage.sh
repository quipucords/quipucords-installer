set -x
default_location=../install/quipucords-installer.1
tmpfile=$(mktemp /tmp/test-manpage.1)
cd ../; make manpage manpage_path=$tmpfile
if [ $tmpfile = $default_location ]
then
  echo "File is identical"
else
  echo "File is not identical"
fi
rm "$tmpfile"
set +x

