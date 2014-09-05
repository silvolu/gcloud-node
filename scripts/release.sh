#!/bin/bash

# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
echo "${TRAVIS_TAG}" >> versions.txt
git add versions.txt
# commit to gh-pages branch
git config user.email "silvano.luciani@gmail.com"
git config user.name "silvolu"
git commit -m "Update docs for ${TRAVIS_TAG}"
git push https://${GH_OAUTH_TOKEN}@github.com/${GH_OWNER}/${GH_PROJECT_NAME} HEAD:gh-pages
