#!/usr/bin/env bash

. ./services/minio/.minio.env

CONF_FILE="services/minio/s3tests.conf"

cp services/s3tests.conf.template ${CONF_FILE}

sed -i "s/S3_HOST/localhost/g" ${CONF_FILE}
sed -i "s/S3_PORT/9000/g" ${CONF_FILE}
sed -i "s/S3_MAIN_ACCESS_KEY/${MINIO_USER_ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_MAIN_SECRET_KEY/${MINIO_USER_SECRET_KEY}/g" ${CONF_FILE}
sed -i "s/S3_ALT_ACCESS_KEY/${MINIO_USER_ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_ALT_SECRET_KEY/${MINIO_USER_SECRET_KEY}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_ACCESS_KEY/${MINIO_USER_ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_SECRET_KEY/${MINIO_USER_SECRET_KEY}/g" ${CONF_FILE}
sed -i "s/S3_IAM_ACCESS_KEY/${MINIO_USER_ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_IAM_SECRET_KEY/${MINIO_USER_SECRET_KEY}/g" ${CONF_FILE}
