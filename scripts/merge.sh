#!/bin/bash
set -ev

# if on master and not a pull request, execute regression tests and update docs
if [ "${TRAVIS_BRANCH}" == "travis-reg" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
# if [ "${TRAVIS_BRANCH}" == "master" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  npm run regression-test

  # generate new set of json files in docs/json/development
  npm run docs
  git submodule add -b gh-pages https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} ghpages
  # copy set of json to tag folder
  cp -R docs/json/development ghpages/json/
  cd ghpages
  git add json/development
  # commit to gh-pages branch
  git config user.email "silvano.luciani@gmail.com"
  git config user.name "silvolu"
  git commit -m "Updating docs for development branch"
  git push https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} HEAD:gh-pages
fi
