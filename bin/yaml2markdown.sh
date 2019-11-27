#!/bin/bash
#
# yaml2markdown
#
# Usage: ./bin/yaml2markdown.sh
#
# Required packages:
# * https://github.com/kislyuk/yq
#

# === dir paths
rootDir="$(cd `dirname $0` && dirname "$(pwd)")"
binDir="$rootDir/bin"
srcDir="$rootDir/src"
distDir="$rootDir/dist"

# === Generate json dist
bash $binDir/yaml2json.sh

# === Generate README
readme=$rootDir/README.md
rm $readme

# == Add disclaimer
echo -e "<!--This file is automatically generated from yaml2markdown.sh -->\n\n" > $readme
cat $rootDir/README_TEMPLATE.md >> $readme

# == Add projects
projectsReadme="$(python $binDir/generateReadme.py)"
tmpReadme="${readme}.tmp"

awk -v PROJECTS="$projectsReadme" '{
  sub(/<AWESOME_LIST>/, PROJECTS);
  print;
}' $readme > $tmpReadme
mv $tmpReadme $readme

# == Update ToC
$binDir/gh-md-toc --insert $readme > /dev/null
rm "$rootDir"/README.md.orig*  "$rootDir"/README.md.toc*
