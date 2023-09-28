#!/bin/sh -xe

##############################################################################
## User set up variables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2023.2.0
##############################################################################
## container
container=/contrib/containers/noaa-intel-prototype_2023.09.25.sif
container_env_script=container_env_script=/contrib/containers/load_spack_noaa-intel.sh
##############################################################################
## Set up the directories
if [ -z "$1" ]
  then
    echo "Error: No FMS tag supplied, please rerun and provide a tag to use for FMS"
    exit 1
  else
    echo FMS tag is ${1}
    FMStag=${1}
fi
if [ -z "$2" ]
  then
    echo "no FMScoupler tag specified, using what is in SHiELD_build/CHECKOUT_code"
  else
    echo FMSCoupler tag is ${2}
    FMSCtag=${2}
fi
if [ -z "$3" ]
  then
    echo "no atmos_drivers tag specified, using what is in SHiELD_build/CHECKOUT_code"
  else
    echo atmos_drivers tag is ${3}
    ADtag=${3}
fi

testDir=${dirRoot}/${intelVersion}/${FMStag}
## create directories
rm -rf ${testDir}
mkdir -p ${testDir}

## clone code
cd ${testDir}
git clone --recursive https://github.com/NOAA-GFDL/SHiELD_build.git && cd SHiELD_build && ./CHECKOUT_code


## Check out the FMS tag
mkdir -p ${testDir}/SHiELD_SRC
cd ${testDir}/SHiELD_SRC/FMS && git checkout origin/${FMStag}
cd ${testDir}/SHiELD_SRC/FMSCoupler && git checkout origin/${FMSCtag}
cd ${testDir}/SHiELD_SRC/atmos_drivers && git checkout origin/${ADtag}
