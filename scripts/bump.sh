#!/bin/bash
# Version bumper
set -o errexit
usage()
{
	echo
	echo "Usage:"
	echo "  bump.sh file version"
}

if [ $# = 2 ]; then
	file=$1
	version=$2
	
	if [ ! -f $file ]; then
		echo -e "\e[33mFile not found!\e[0m"
		usage
		exit 2
	fi

	# find version number assignment ("=|: v1.5.5" for example)
	# and replace it with newly specified version number
	sed -i.backup -E "s/[\=\:]\s?v?[0-9.]+/\: $version/" $file $file

	# remove backup file created by sed command
	rm $file.backup

	echo -e "\e[33mVersion bumped to $version\e[0m"
else
	echo -e "\e[33mError: You didn't provide the needed arguments.\e[0m"
	usage
	exit 1
fi