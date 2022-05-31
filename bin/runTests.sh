#!/usr/bin/env bash

# Source env settings
. .env

if [ -z "$1" ]
then
  echo "you must provide S3TEST_CONF file"
fi

echo "Run s3tests_boto3.functional tests"

if [ "$2" ]
then
  S3TEST_CONF=$1 ./tests/virtualenv/bin/nosetests -v --nologcapture s3tests_boto3.functional.$2
else
  S3TEST_CONF=$1 ./tests/virtualenv/bin/nosetests -v --nologcapture s3tests_boto3.functional
fi
