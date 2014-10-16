#!/bin/bash
set -o errexit

usage()
{
	echo
	echo "Usage:"
	echo "  start-hotfix.sh name version"
	echo "  - Creates a new branch off from 'master' named"
	echo "    'hotfix/name_of_hotfix'."
	echo ""
}

usage

if [ $# = 2 ]; then
	version=$2
	name=$1
else
	echo -e "\e[33mEnter hotfix branch name: \e[0m"
	read name
	echo -e "\e[33mEnter version number (major.minor.hotfix): \e[0m"
	read version
fi

if [[ $version == "v*" ]]; then
	echo -e "\e[33m$version\e[0m"
else
	version="v$version"
fi

echo -e "\e[33mVersion number will be $version\e[0m"
read -p "Do you want to continue? [Yy]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];
	then
	echo  -e "\e[33mCheckout new branch from master : hotfix-$version\e[0m"
	git checkout -b hotfix-$version master
	./scripts/bump.sh "readme.md" $version
	git commit -a -m "Hotfix $version : $name"
	echo $version > ./scripts/.history/hotfix.last
else
	echo  -e "\e[33mAbort\e[0m"
	exit 1
fi