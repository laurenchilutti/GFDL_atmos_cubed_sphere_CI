#!/bin/sh -xe

##############################################################################
## User set up variables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2022.1.1
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
git clone --recursive -b PWupgrade https://github.com/laurenchilutti/SHiELD_build.git && cd SHiELD_build && ./CHECKOUT_code |& tee ${logDir}/checkout.log
## Check out the PR
cd ${testDir}/SHiELD_SRC/GFDL_atmos_cubed_sphere && git fetch origin ${branch}:toMerge && git merge toMerge
