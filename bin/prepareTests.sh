#!/usr/bin/env bash

# Source env settings
. .env

echo "Preparing s3-tests"

if [ -d "./tests" ]; then
  echo "Tests are already downloaded. Nothing to do"
else
  mkdir -p ./tests
  git clone "git@github.com:nspcc-dev/s3-tests.git" tests
  cd ./tests && ./bootstrap && cd ..
fi
