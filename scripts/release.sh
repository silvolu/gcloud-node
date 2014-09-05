#!/bin/bash
set -ev

# deploy to npm
npm run coveralls

# git submodule add -b master https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} master > /dev/null 2>&1
# cd master
# npm install
# npm run docs
# git submodule add -b gh-pages https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} ghpages > /dev/null 2>&1
# cd ghpages
# git rm -r .
# cp -R ../docs/* .
# git add -f .
# git config user.email "sawchuk@gmail.com"
# git config user.name "stephenplusplus"
# git commit -am "building gh-pages [ci skip]"
# git push https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} HEAD:gh-pages > /dev/null 2>&1
