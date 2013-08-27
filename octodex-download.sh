#!/bin/bash

# bash script for downloading all octodex.github.com images

# log arguments to console for debugging
echo "${0##*/} $1 $2 $3"

if [ $# -ne 3 ]
then
    echo $#
	echo "Usage: ${0##*/} URL -d DIRECTORY"
	echo "for example:"
	echo "${0##*/} octodex.github.com -d /Users/Kich/GitHubImages"
	exit 1;
fi

for i in {1..4}
do
case $1 in
-d) shift; directory=$1; shift ;;
*) url=${url:-$1}; shift;;
esac
done

mkdir -p $directory;

cd $directory;

NAMES=`curl $url | egrep -i "<a name=" | awk "{print $2}"| cut -f2 -d "=" | cut -f1 -d ">" | sed "s/\"//g"`
for name in $NAMES;
do
	FINAL_URL="http://octodex.github.com/images/$name.png"
	wget --spider -r -l 1 $FINAL_URL
	EXIT_CODE=$?
	if [ $EXIT_CODE -gt 0 ];
	then
	    FINAL_URL="http://octodex.github.com/images/$name.jpg"
	    wget --spider -r -l 1 $FINAL_URL
		EXIT_CODE=$?
		if [ $EXIT_CODE -gt 0 ];
		then
	    FINAL_URL="http://octodex.github.com/images/$name.gif"
		fi
	fi
echo "\n Downloading $FINAL_URL \n"
wget $FINAL_URL
done

echo "\n\n*******************************\n"
echo "Download Finished!"