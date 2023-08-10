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
export MODULESHOME=/usr/share/lmod/lmod
## create directories
rm -rf ${testDir}
mkdir -p ${logDir}
# salloc commands to start up 
#salloc --exclusive -N 4 -J ${branch}C512r20.solo.superC sleep 30m &
#salloc --exclusive -N 4 -J ${branch}C768.sw.BTwave sleep 30m &
#salloc --exclusive -N 2 -J ${branch}C256r20.solo.superC sleep 30m &
#salloc --exclusive -N 2 -J ${branch}C384.sw.BLvortex sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C128r20.solo.superC sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C128r3.solo.TC sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C128r3.solo.TC.d1 sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C128r3.solo.TC.h6 sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C128r3.solo.TC.tr8 sleep 30m &3salloc --exclusive -N 1 -J ${branch}C96.solo.BCdry sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.BCdry sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.BCmoist sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.BCmoist.nhK sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.mtn_rest sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.mtn_rest.nonmono.nccmp -df2 sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_1k.solo.mtn_rest_shear sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_1k.solo.mtn_rest_shear.olddamp sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_1k.solo.mtn_schar sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_1k.solo.mtn_schar.mono sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_2k.solo.bubble sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_2k.solo.bubble.n0 sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_2k.solo.bubble.nhK sleep 30m &
#salloc --exclusive -N 1 -J ${branch}d96_500m.solo.mtn_schar sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C192.sw.BLvortex sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C192.sw.BTwave sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C192.sw.modon sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C384.sw.BTwave sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.sw.BLvortex sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.sw.BTwave sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.sw.RHwave sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.sw.modon sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.BCdry.hyd sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.BCmoist.hyd sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.BCmoist.hyd.d3 sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.mtn_rest.hyd sleep 30m &
#salloc --exclusive -N 1 -J ${branch}C96.solo.mtn_rest.hyd.nccmp -df2 sleep 30m &

## clone code
cd ${testDir}
git clone --recursive https://github.com/NOAA-GFDL/SHiELD_build.git && cd SHiELD_build && ./CHECKOUT_code
## Check out the PR
cd ${testDir}/SHiELD_SRC/GFDL_atmos_cubed_sphere && git fetch origin ${branch}:toMerge && git merge toMerge
