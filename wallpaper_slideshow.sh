#!/bin/bash
#Author: Kyle Agronick
#Email: agronick@gmail.com
 
#Usage: wallpaper_slideshow.sh [FOLDER] [MINUTES]...
#display a new one every [MINUTES] minutes. This script is 
#best used when invoked from an autostart folder. Run with
# --help to display help information.



if [[  $@ == **help** ]] || [[  $@ == **-h** ]]; then  
cat << EOF
Usage: $0  [FOLDER] [MINUTES]

Loads a random background image every [MINUTES]
from FOLDER].  Defaults to 2 minutes. Default 
images are the Elementary OS stock background 
images.
 
OPTIONS:
   --bootonly      To load one image and exit
   --makecmd      Make the command to paste into 
   --help	  Show this help and exit
EOF
exit
fi
 
IS_NUM='^[0-9]+$'  
FOLDER=$1
MINS=2

if [[  $@ == **makecmd** ]]; then  
	CMD="Copy and paste this command: 
$(readlink -f $0) $1"
	if [[  $2 != **makecmd** ]]; then
	CMD+=" $2 "
	fi
	if [[  $3 != **makecmd** ]]; then
	CMD+=" $3 "
	fi 
	echo -e "\n"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo $CMD
 	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo -e "\n"
	exit;
fi

FOLDER='/usr/share/backgrounds';
if [[ -d $1 ]];
    then FOLDER=$1
fi

if [[ $1 =~ $IS_NUM ]];
    then MINS=$1 
elif [[ $2 =~ $IS_NUM ]];
    then MINS=$2 
fi

 
IFS=$'\n'
MINS+="m" 
cd "$FOLDER"
while true; do
	FILES=`find ./ -iregex '.*\.\(tga\|jpg\|gif\|png\|jpeg\)$' | shuf` 
	 
	if [ -z "$FILES" ]; then
	    echo "There does not appear to be any image files in $FOLDER"
	    exit
	fi

	for item in $FILES
	do  

	   item=$(readlink -f $item)   
	   gsettings set org.gnome.desktop.background picture-uri "$item" 
	   if [[  $@ == **bootonly** ]]; then  
		exit;
	   fi

	   sleep $MINS

	done
done
