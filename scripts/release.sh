#!/bin/bash
set -ev

# create new coverage report
npm run coveralls

### Update docs
# generate new set of json files in docs/json/development
npm run docs
git submodule add -f -b gh-pages https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} ghpages
# copy set of json to tag folder
mkdir ghpages/json/${TRAVIS_TAG}
cp -R docs/json/development/* ghpages/json/${TRAVIS_TAG}
cd ghpages
git add json/${TRAVIS_TAG}
# add new tag to versions
echo "" >> versions.txt
echo "${TRAVIS_TAG}" >> versions.txt
git add versions.txt
# commit to gh-pages branch
git commit -m "Updating docs for ${TRAVIS_TAG}"
git push https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} HEAD:gh-pages
