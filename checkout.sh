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
## create directories
rm -rf ${testDir}
mkdir -p ${logDir}
## clone code
cd ${testDir}
#git clone --recursive https://github.com/NOAA-GFDL/SHiELD_build.git && cd SHiELD_build && ./CHECKOUT_code
#git clone --recursive -b parallelworks https://github.com/laurenchilutti/SHiELD_build.git && cd SHiELD_build && ./CHECKOUT_code
git clone --recursive -b pwsbatch https://github.com/laurenchilutti/SHiELD_build.git && cd SHiELD_build && ./CHECKOUT_code
## Check out the PR
cd ${testDir}/SHiELD_SRC/GFDL_atmos_cubed_sphere && git fetch origin ${branch}:toMerge && git merge toMerge
