#!/bin/sh -xe
ulimit -s unlimited
##############################################################################
## User set up veriables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2022.1.1
##############################################################################
## HPC-ME container
branch="refs/pull/261/merge"
testDir=${dirRoot}/${intelVersion}/${branch}
baselineDir=${dirRoot}/baselines/intel/${intelVersion}
BUILDDIR="${testDir}/SHiELD_build"
runDir=${BUILDDIR}/CI/BATCH-CI
test=C128r20.solo.superC

module load intel/2022.1.2
module load netcdf
module load nccmp
for resFile in `ls ${baselineDir}/${test}`
do
  nccmp -d ${baselineDir}/${test}/${resFile} ${runDir}/${test}/RESTART/${resFile}
done
