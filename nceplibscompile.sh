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
container_env_script=/contrib/containers/load_spack_noaa-intel.sh
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
# Set up build
cd ${testDir}/SHiELD_build/Build
#Define External Libs path
export EXTERNAL_LIBS=${dirRoot}/FMSexternallibs
#remove nceplibs if it exists
if [ -d $EXTERNAL_LIBS/nceplibs ]
  then
    rm -rf $EXTERNAL_LIBS/nceplibs
fi
echo $container > $EXTERNAL_LIBS/NCEPLIBScontainerversion
echo $container_env_script >> $EXTERNAL_LIBS/NCEPLIBScontainerversion
# Build nceplibs
set -o pipefail
singularity exec -B /contrib ${container} ${container_env_script} "./BUILDnceplibs intel"
