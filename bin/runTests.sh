#!/usr/bin/env bash

# Source env settings
. .env

if [ -z "$1" ]
then
  echo "you must provide S3TEST_CONF file"
fi

echo "Run s3tests_boto3.functional tests"

S3TEST_CONF=$1 ./tests/virtualenv/bin/nosetests -v --nologcapture --debug-log=debug.log \
 s3tests_boto3.functional.test_s3:test_object_copy_same_bucket
