#!/usr/bin/env bash

. .env

CONF_FILE="services/s3-gw/s3tests.conf"

if [ -f "$CONF_FILE" ]; then
  echo "$CONF_FILE already exists"
  exit 0
fi

if [ ! -f "./bin/authmate" ]; then
  curl -L https://github.com/nspcc-dev/neofs-s3-gw/releases/download/"${S3_GW_VERSION}"/neofs-authmate-linux-amd64 --output ./bin/authmate
  if [ $? -eq 0 ]; then
    chmod +x ./bin/authmate
  else
    echo "couldn't download authmate"
    exit 1
  fi
fi

echo "Authmate issue-secret"
RESULT=$(AUTHMATE_WALLET_PASSPHRASE="" ./bin/authmate issue-secret --wallet ./services/s3-gw/wallet.json \
  --peer s01.neofs.devenv:8080 --gate-public-key 0313b1ac3a8076e155a7e797b24f0b650cccad5941ea59d7cfd51a024a8b2a06bf \
  --create-session-token --bearer-rules ./services/s3-gw/rules.json)

ACCESS_KEY=$(echo $RESULT | jq -r '.access_key_id')
SECRET_KEY=$(echo $RESULT | jq -r '.secret_access_key')

cp services/s3tests.conf.template ${CONF_FILE}

sed -i "s/S3_HOST/s3.neofs.devenv/g" ${CONF_FILE}
sed -i "s/S3_TLS/True/g" ${CONF_FILE}
sed -i "s/S3_PORT/8080/g" ${CONF_FILE}
sed -i "s/S3_MAIN_ACCESS_KEY/${ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_MAIN_SECRET_KEY/${SECRET_KEY}/g" ${CONF_FILE}
sed -i "s/S3_ALT_ACCESS_KEY/${ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_ALT_SECRET_KEY/${SECRET_KEY}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_ACCESS_KEY/${ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_SECRET_KEY/${SECRET_KEY}/g" ${CONF_FILE}
sed -i "s/S3_IAM_ACCESS_KEY/${ACCESS_KEY}/g" ${CONF_FILE}
sed -i "s/S3_IAM_SECRET_KEY/${SECRET_KEY}/g" ${CONF_FILE}
