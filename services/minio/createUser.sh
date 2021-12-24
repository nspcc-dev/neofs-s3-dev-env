#!/usr/bin/env bash

mc alias set minio http://minio."${LOCAL_DOMAIN}":9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"

mc admin user add minio/ "${MINIO_USER_ACCESS_KEY}" "${MINIO_USER_SECRET_KEY}"

mc admin policy set minio readwrite user="${MINIO_USER_ACCESS_KEY}"
