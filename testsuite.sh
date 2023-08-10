#!/bin/sh -xe
ulimit -s unlimited
##############################################################################
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2023.2.0
##############################################################################
## container
container=/contrib/containers/noaa-intel-prototype_2023.08.02.sif
container_env_script=/contrib/containers/load_spack_noaa-intel.sh
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
  scancel -n ${branch}${test}
# Execute the test piping output to log file
  ./${test} " --mpi=pmi2 --exclusive singularity exec -B /contrib ${container} ${container_env_script}" |& tee ${logDir}/run_${test}.log
  ## Compare Restarts to Baseline
. ${MODULESHOME}/init/sh
  module load intel/2022.1.2
module load nccmp
for resFile in `ls ${baselineDir}/${test}`
  do
    nccmp -df ${baselineDir}/${test}/${resFile} ${runDir}/${test}/RESTART/${resFile}
  done
done
