#!/bin/bash
set -o errexit

usage()
{
	echo
	echo "Usage:"
	echo "  start-release.sh name version"
	echo "  - Creates a new branch off from 'develop' named"
	echo "    'release/name_of_release'."
	echo ""
}

usage

if [ $# = 2 ]; then
	version=$2
	name=$1
else
	echo -e "\e[33mEnter release branch name: \e[0m"
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
	echo  -e "\e[33mCheckout new branch from develop : release-$version\e[0m"
	git checkout -b release-$version develop
	./scripts/bump.sh "readme.md" $version
	git commit -a -m "Release $version : $name"
	git push origin release-$version
	echo $version > ./scripts/.history/release.last
else
	echo  -e "\e[33mAbort\e[0m"
	exit 1
fi