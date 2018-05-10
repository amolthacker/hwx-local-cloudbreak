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

function usage {
    echo  -e "${GRAY} $0 <tool> [eg: utils.sh provisioner] ${NC}"
    exit 1
}

[[ $# -ne 1 ]] && usage
PROG=$1

function datetime {
    echo `date +%m-%d-%yT%H:%M:%S`
}

function datetimefmtd {
    echo $(datetime) | sed 's/[-:]/_/g'
}

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
