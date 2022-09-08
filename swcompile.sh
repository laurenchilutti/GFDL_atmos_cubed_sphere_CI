#!/bin/sh -xe

##############################################################################
## User set up variables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2022.1.1
##############################################################################
## HPC-ME container
container=/contrib/containers/HPC-ME_base-ubuntu20.04-intel${intelVersion}.sif 
container_env_script=/contrib/containers/load_spack_HPC-ME.sh
##############################################################################
## Set up the directories
if [ -z "$1" ]
  then
    echo "No branch supplied; using main"
    branch=main
  else
    echo Branch is ${1}
    branch=${1}
fi
testDir=${dirRoot}/${intelVersion}/${branch}
logDir=${testDir}/log
# Set up build
cd ${testDir}/SHiELD_build/Build
#Define External Libs path
export EXTERNAL_LIBS=${dirRoot}/externallibs
# Build SHiELD
set -o pipefail
singularity exec -B /contrib ${container} ${container_env_script} "./COMPILE solo sw 64bit repro intel clean"

