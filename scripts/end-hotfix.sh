#!/bin/bash
set -o errexit

usage()
{
	echo
	echo "Usage:"
	echo "  end-hotfix.sh"
	echo -e "\e[31mWaring:\e[0m"
	echo -e "\e[31m  PLEASE COMMIT AND PUSH ALL YOUR CHANGES BEFORE RUN THIS SCRIPT\e[0m"
	echo
}
clear
usage

if [ -f ./scripts/.history/hotfix.last ]; then 
	version=`cat ./scripts/.history/hotfix.last`
	echo -e "\e[33mVersion number readed from ./scripts/.history/hotfix.last\e[0m"
else
	echo -e "\e[33mEnter version number (major.minor.hotfix): \e[0m"
	read version
fi

if [[ $version == v* ]]; then
	echo 
else
	version="v$version"
fi

echo -e "\e[33mhotfix-$version will be merged with master and develop\e[0m"
read -p "Do you want to continue? [Yy] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];
	then
	echo -e "\e[33mCheckout master\e[0m"
	git checkout master
	echo -e "\e[33mMerge branch 'hotfix-$version' into master\e[0m"
	git merge --no-ff hotfix-$version -m "hotfix-$version merged with master"
	echo -e "\e[33mCreates tag $version\e[0m"
	git tag -a $version -m 'version updated to $version'
	git push --tags origin master
	echo -e "\e[33mCheckout develop\e[0m"
	git checkout develop
	echo -e "\e[33mMerge branch 'hotfix-$version' into develop\e[0m"
	git merge --no-ff hotfix-$version -m "hotfix-$version merged with develop"
	# see http://stackoverflow.com/questions/23918062/simple-vs-current-push-default-in-git-for-decentralized-workflow
	# if  git config push.default current
	git push
	#else if  git config push.default simple
	git push --set-upstream origin develop

	read -p "Do you want to delete hotfix-$version? [Yy]" -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]];
	then
		#git push origin --delete hotfix-$version
		git branch -d hotfix-$version
	fi

else
	echo  -e "\e[33mAbort\e[0m"
	exit 1
fi
