#!/bin/sh -xe
ulimit -s unlimited
##############################################################################
## User set up veriables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2022.1.1
##############################################################################
## Set up the directories
branch=main
testDir=${dirRoot}/${intelVersion}/${branch}
## Run the CI Test
# Define the builddir testscriptdir and rundir BUILDDIR is used by test scripts 
# Set the BUILDDIR for the test script to use
export BUILDDIR="${testDir}/SHiELD_build"
runDir=${BUILDDIR}/CI/BATCH-CI
## Compare Restarts to Baseline
. ${MODULESHOME}/init/sh
for test in `ls ${runDir}`
do
  if [ -n "$(ls -A ${runDir}/${test}/RESTART/)" ]
  then
    echo "there are restarts in : " ${runDir}/${test}"/RESTART/"
    ls ${runDir}/${test}/RESTART/
  else
    echo "no files in " ${runDir}/${test}"/RESTART/"
  fi
done
