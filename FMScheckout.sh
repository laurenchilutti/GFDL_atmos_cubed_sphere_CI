#!/bin/sh -xe

##############################################################################
## User set up variables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2022.1.1
##############################################################################
## container
container=/contrib/containers/HPC-ME_base-ubuntu20.04-intel${intelVersion}.sif
container_env_script=container_env_script=/contrib/containers/load_spack_HPC-ME.sh
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

testDir=${dirRoot}/${intelVersion}/${FMStag}
logDir=${testDir}/log
export MODULESHOME=/usr/share/lmod/lmod
## create directories
rm -rf ${testDir}
mkdir -p ${logDir}

## clone code
cd ${testDir}
git clone --recursive https://github.com/NOAA-GFDL/SHiELD_build.git

## Check out the FMS tag
mkdir -p ${testDir}/SHiELD_SRC
cd ${testDir}/SHiELD_SRC/ && git clone -b ${FMStag} https://github.com/NOAA-GFDL/FMS.git
