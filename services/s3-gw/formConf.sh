#!/usr/bin/env bash

. .env

readonly CONF_FILE="services/s3-gw/s3tests.conf"
readonly GATE_PUBLIC_KEY="0313b1ac3a8076e155a7e797b24f0b650cccad5941ea59d7cfd51a024a8b2a06bf"

if [ -f "$CONF_FILE" ]; then
  echo "$CONF_FILE already exists"
  exit 0
fi


if [ ! -f "./bin/authmate" ]; then
  echo "Downloading authmate"
  curl -L https://github.com/nspcc-dev/neofs-s3-gw/releases/download/"${S3_GW_VERSION}"/neofs-authmate-linux-amd64 --output ./bin/authmate
  if [ $? -eq 0 ]; then
    chmod +x ./bin/authmate
  else
    echo "Couldn't download authmate"
    exit 1
  fi
fi

issue_secret () {
  local -n wallet=$1
  local -n err
  result=$(AUTHMATE_WALLET_PASSPHRASE=${wallet[password]} ./bin/authmate issue-secret --wallet ${wallet[path]} \
  --peer s01.neofs.devenv:8080 --gate-public-key ${GATE_PUBLIC_KEY} \
  --bearer-rules ./services/s3-gw/bearer_rules.json) 
  echo ${result}
}

declare -A wallet_main
wallet_main[path]="./services/s3-gw/wallets/wallet_main.json"
wallet_main[password]=""

declare -A wallet_alt
wallet_alt[path]="./services/s3-gw/wallets/wallet_alt.json"
wallet_alt=""

echo "Issuing a secret for main wallet"
result_main=$(issue_secret wallet_main)
if [ -z "$result_main" ]; then
    exit 1
fi
access_key_main=$(echo ${result_main} | jq -r '.access_key_id')
secret_key_main=$(echo ${result_main} | jq -r '.secret_access_key')
user_id_main=$(echo ${result_main} | jq -r '.wallet_public_key') 
echo "access_key = ${access_key_main}, secret_key = ${secret_key_main}"

echo "Issuing a secret for alt wallet"
result_alt=$(issue_secret wallet_alt)
if [ -z "$result_alt" ]; then
    exit 1
fi
access_key_alt=$(echo ${result_alt} | jq -r '.access_key_id')
secret_key_alt=$(echo ${result_alt} | jq -r '.secret_access_key')
user_id_alt=$(echo ${result_alt} | jq -r '.wallet_public_key') 
echo "access_key = ${access_key_alt}, secret_key = ${secret_key_alt}"

cp -f services/s3tests.conf.template ${CONF_FILE}

sed -i "s/S3_HOST/${S3_GW_HOST}/g" ${CONF_FILE}
sed -i "s/S3_TLS/${S3_GW_TLS}/g" ${CONF_FILE}
sed -i "s/S3_PORT/${S3_GW_PORT}/g" ${CONF_FILE}
sed -i "s/S3_MAIN_ACCESS_KEY/${access_key_main}/g" ${CONF_FILE}
sed -i "s/S3_MAIN_SECRET_KEY/${secret_key_main}/g" ${CONF_FILE}
sed -i "s/S3_MAIN_USER_ID/${user_id_main}/g" ${CONF_FILE}
sed -i "s/S3_ALT_ACCESS_KEY/${access_key_alt}/g" ${CONF_FILE}
sed -i "s/S3_ALT_SECRET_KEY/${secret_key_alt}/g" ${CONF_FILE}
sed -i "s/S3_ALT_USER_ID/${user_id_alt}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_ACCESS_KEY/${access_key_alt}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_SECRET_KEY/${secret_key_alt}/g" ${CONF_FILE}
sed -i "s/S3_TENANT_USER_ID/${user_id_alt}/g" ${CONF_FILE}
sed -i "s/S3_IAM_ACCESS_KEY/${access_key_alt}/g" ${CONF_FILE}
sed -i "s/S3_IAM_SECRET_KEY/${secret_key_alt}/g" ${CONF_FILE}
sed -i "s/S3_IAM_USER_ID/${user_id_alt}/g" ${CONF_FILE}
