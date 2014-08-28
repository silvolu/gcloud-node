#!/bin/bash
set -ev

# if on master and not a pull request, execute regression tests
if [ "${TRAVIS_BRANCH}" eq "master" && "${TRAVIS_PULL_REQUEST}" -ne "false" ]; then
  npm run regression-test
else
  echo "Branch: ${TRAVIS_BRANCH}"
fi
