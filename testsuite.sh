#!/bin/sh -xe
ulimit -s unlimited
##############################################################################
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2022.1.1
##############################################################################
## HPC-ME container
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
mkdir -p ${logDir}
baselineDir=${dirRoot}/baselines/intel/${intelVersion}
## Run the CI Tests
# Define the builddir testscriptdir and rundir BUILDDIR is used by test scripts 
# Set the BUILDDIR for the test script to use
export BUILDDIR="${testDir}/SHiELD_build"
testscriptDir=${BUILDDIR}/RTS/CI
runDir=${BUILDDIR}/CI/BATCH-CI
# Run CI test scripts
cd ${testscriptDir}
set -o pipefail
# Define the test
for test in `ls ${baselineDir}`
do
  if [${test}="C256r20.solo.superC"] || [${test}="C384.sw.BLvortex"]
    then
      nodes=2
    elif [${test}="C512r20.solo.superC"] || [${test}="C768.sw.BTwave"]
    then
      nodes=4 
    else
     nodes=1
  fi
  # Execute the test piping output to log file
  ./${test} " --mpi=pmi2 --nodes= ${nodes}" |& tee ${logDir}/run_${test}.log
  ## Compare Restarts to Baseline
  for resFile in `ls ${baselineDir}/${test}`
  do
    diff ${baselineDir}/${test}/${resFile} ${runDir}/${test}/RESTART/${resFile}
  done
done
