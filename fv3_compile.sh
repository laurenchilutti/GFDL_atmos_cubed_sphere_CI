#!/bin/sh -xe

##############################################################################
## User set up variables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2023.2.0
##############################################################################
## container
container=/contrib/containers/noaa-intel-prototype_2023.08.02.sif
container_env_script=/contrib/containers/load_spack_noaa-intel.sh
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
cd ${testDir}/SHiELD_SRC
## Check out the PR
cd GFDL_atmos_cubed_sphere && git fetch origin ${1}:toMerge && git merge toMerge |& tee ${logDir}/fetch.log
# Set up build
cd ${testDir}/SHiELD_build/Build
# Build SHiELD
set -o pipefail
singularity exec -B /contrib ${container} ${container_env_script} ${dirRoot}/tests_to_compile.sh |& tee ${logDir}/compile.log # PIPE OUTPUT TO ${logDir}/compile.log

ls ${logDir}
