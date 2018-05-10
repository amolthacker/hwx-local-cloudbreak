#!/bin/bash

BASE_DIR="$(dirname $0)"
source $BASE_DIR/env.sh
source $BASE_DIR/utils.sh "cloudbreak-install"

logInfo "Spinning up the Cloudbreak VM ..."
cd vagrant
vagrant up
cd ..
exitOnErr "Cloudbreak VM setup failed"

sleep 120

logInfo "Installing and configuring the Cloudbreak CLI ..."
./scripts/setup-cloudbreak.sh
exitOnErr "Cloudbreak CLI setup failed"




