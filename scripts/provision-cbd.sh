#!/bin/bash

###################
# ANSI COLORS
###################
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
NC='\033[0m'
###################

###################
# Functions
###################

function datetime {
    echo `date +%m-%d-%yT%H:%M:%S`
}

function datetimefmtd {
    echo $(datetime) | sed 's/[-:]/_/g'
}

PROG="cbd-provisioner"

function logInfo {
    echo -e "$(datetime) ${YELLOW}${PROG}${NC} [${GREEN}INFO${NC}] $@"
}

function logErr {
    echo -e "$(datetime) ${YELLOW}${PROG}${NC} [${RED}ERROR${NC}] $@"
}

function exitWithErr {
    if [ $# -gt 0 ]
    then
        logErr $@
    fi
    exit 1
}

function exitOnErr {
    if [ $? -ne 0 ]
    then
        exitWithErr $@
    fi
}

###################

DOCKER_ENGINE_VERSION='1.9.1'
DOCKER_REPO_BASE_URL='https://yum.dockerproject.org/repo/main/centos/7'
DOCKER_REPO_GPG_URL='https://yum.dockerproject.org/gpg'

CLOUDBREAK_VERSION=$1
CLOUDBREAK_REPO_BASE_PATH='s3.amazonaws.com/public-repo-1.hortonworks.com/HDP/cloudbreak'
CLOUDBREAK_DEPLOYER_INSTALL_DIR=$2
CLOUDBREAK_DEPLOYER_PROFILE_SECRET=$3
CLOUDBREAK_DEPLOYER_PROFILE_USER_EMAIL=$4
CLOUDBREAK_DEPLOYER_PROFILE_USER_PASSWORD=$5
CLOUDBREAK_DEPLOYER_IP=$6

###################

sudo -i

logInfo "Updating requisite system packages ..."
logInfo "-------------------------------------------------"
yum update -y

logInfo "Installing and Configuring iptables-services and net-tools ..."
logInfo "-------------------------------------------------"
yum install -y iptables-services net-tools
iptables --flush INPUT && iptables --flush FORWARD && service iptables save

logInfo "Configuring Docker Repo ..."
logInfo "-------------------------------------------------"
cat > /etc/yum.repos.d/docker.repo <<EOF
[dockerrepo]
name=Docker Repository
baseurl=$DOCKER_REPO_BASE_URL
enabled=1
gpgcheck=1
gpgkey=$DOCKER_REPO_GPG_URL
EOF

logInfo "Installing & Starting Docker ..."
logInfo "-------------------------------------------------"
yum install -y "docker-engine-${DOCKER_ENGINE_VERSION}" "docker-engine-selinux-${DOCKER_ENGINE_VERSION}"
systemctl start docker
systemctl enable docker

logInfo "Fetching & Configuring Cloudbreak Deployer ..."
logInfo "-------------------------------------------------"
curl -Ls ${CLOUDBREAK_REPO_BASE_PATH}/cloudbreak-deployer_${CLOUDBREAK_VERSION}_$(uname)_x86_64.tgz | sudo tar -xz -C /bin cbd
mkdir -p ${CLOUDBREAK_DEPLOYER_INSTALL_DIR} && cd ${CLOUDBREAK_DEPLOYER_INSTALL_DIR}
cat > Profile <<EOF
export UAA_DEFAULT_SECRET=$CLOUDBREAK_DEPLOYER_PROFILE_SECRET
export UAA_DEFAULT_USER_EMAIL=$CLOUDBREAK_DEPLOYER_PROFILE_USER_EMAIL
export UAA_DEFAULT_USER_PW=$CLOUDBREAK_DEPLOYER_PROFILE_USER_PASSWORD
export PUBLIC_IP=$CLOUDBREAK_DEPLOYER_IP
EOF

logInfo "Installing & Starting Cloudbreak ..."
logInfo "-------------------------------------------------"
logInfo ""
logInfo "Generating docker-compose and uaa configs ..."
rm *.yml && cbd generate
logInfo "Pulling and verifying images for Cloudbreak services ..."
cbd pull parallel
logInfo "Starting Cloudbreak ..."
cbd start
logInfo "-------------------------------------------------"

###################