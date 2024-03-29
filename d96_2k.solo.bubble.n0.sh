#!/bin/bash -xe
ulimit -s unlimited
##############################################################################
## User set up veriables
## Root directory for CI
dirRoot=/contrib/fv3
## Intel version to be used
intelVersion=2023.2.0
##############################################################################
## HPC-ME container
container=/contrib/containers/noaa-intel-prototype_2023.09.25.sif
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
if [ -z "$2" ]
  then
    echo "No second argument"
    commit=none
  else
    echo Commit is ${2}
    commit=${2}
fi
MODULESHOME=/usr/share/lmod/lmod
testDir=${dirRoot}/${intelVersion}/GFDL_atmos_cubed_sphere/${branch}/${commit}
logDir=${testDir}/log
baselineDir=${dirRoot}/baselines/intel/${intelVersion}
## Run the CI Test
# Define the builddir testscriptdir and rundir BUILDDIR is used by test scripts 
# Set the BUILDDIR for the test script to use
export BUILDDIR="${testDir}/SHiELD_build"
testscriptDir=${BUILDDIR}/RTS/CI
runDir=${BUILDDIR}/CI/BATCH-CI

# Run CI test scripts
cd ${testscriptDir}
set -o pipefail
# Define the test
test=d96_2k.solo.bubble.n0
# Execute the test piping output to log file
./${test} " --partition=p2 --mpi=pmi2 --job-name=${commit}_${test} singularity exec -B /contrib ${container} ${container_env_script}" |& tee ${logDir}/run_${test}.log

#test not expected to reproduce
