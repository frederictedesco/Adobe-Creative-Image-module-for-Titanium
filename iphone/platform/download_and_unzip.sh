#!/bin/sh

function downloadAndUnzip {	
	if [ -f $1 ]; then
		echo "already downloaded $FILE"
	else
		echo "Downloading... $1"
		curl -sS $1 > $2
		echo "Unzipping... $2"
		unzip -o -q $2 -x __MACOSX/*
	fi
}

FILE1="AdobeCreativeSDKFoundation.framework.zip"
FILE2="AdobeCreativeSDKImage.framework.zip"
DOWNLOAD1="http://public.lio.lu/creativesdkimage/AdobeCreativeSDKFoundation.framework.zip"
DOWNLOAD2="http://public.lio.lu/creativesdkimage/AdobeCreativeSDKImage.framework.zip"

downloadAndUnzip $DOWNLOAD1 $FILE1
downloadAndUnzip $DOWNLOAD2 $FILE2