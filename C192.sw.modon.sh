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
container=/contrib/containers/HPC-ME_base-ubuntu20.04-intel${intelVersion}.sif 
container_env_script=/contrib/containers/load_spack_HPC-ME.sh
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
## Run the CI Test
# Define the builddir testscriptdir and rundir BUILDDIR is used by test scripts 
# Set the BUILDDIR for the test script to use
export BUILDDIR="${testDir}/SHiELD_build"
testscriptDir=${BUILDDIR}/RTS/CI
runDir=${BUILDDIR}/CI/BATCH-CI

#Add path to yaml tools
export PATH="/contrib/fv3/yamltools/bin:$PATH"

# Run CI test scripts
cd ${testscriptDir}
set -o pipefail
# Define the test
test=C192.sw.modon
scancel -n ${branch}${test}
# Execute the test piping output to log file
./${test} " --mpi=pmi2 --exclusive singularity exec -B /contrib ${container} ${container_env_script}" |& tee ${logDir}/run_${test}.log
