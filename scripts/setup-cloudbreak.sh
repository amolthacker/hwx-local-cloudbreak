#!/bin/bash

BASE_DIR="$(dirname $0)"
source $BASE_DIR/env.sh
source $BASE_DIR/utils.sh "cloudbreak-setup"


logInfo "Installing Cloudbreak CLI ..."
# MacOS
curl -Ls https://s3-us-west-2.amazonaws.com/cb-cli/cb-cli_${CB_VERSION}_Darwin_x86_64.tgz | sudo tar -xz -C /usr/local/bin cb
cb configure --server ${CBD_SERVER_IP} --username ${CB_USER_EMAIL} --password ${CB_USER_PASSWORD}
exitOnErr "Cloudbreak CLI install failed"

logInfo "Adding Credentials ..."
for cred_file in `ls credentials`; do
    cred_name=$(echo credentials/${cred_file} | cut -d '.' -f1 | cut -d '/' -f2)
    logInfo $cred_name
    cb credential create from-file --cli-input-json credentials/${cred_file} --name ${cred_name}
done

exitOnErr "Credential creation failed"
