#!/bin/bash
set -ev

# if on master and not a pull request, execute regression tests
if [ "${TRAVIS_BRANCH}" == "master" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  npm run regression-test
fi
