#!/bin/sh -xe
ulimit -s unlimited
##############################################################################
## User set up veriables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2023.2.0
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
baselineDir=${dirRoot}/baselines/intel/${intelVersion}
BUILDDIR="${testDir}/SHiELD_build"
runDir=${BUILDDIR}/CI/BATCH-CI

## Compare Restarts to Baseline
module load intel/2022.1.2
module load nccmp
for test in `ls ${baselineDir}`
do
  for resFile in `ls ${baselineDir}/${test}`
  do
    nccmp -df ${baselineDir}/${test}/${resFile} ${runDir}/${test}/RESTART/${resFile}
  done
done
