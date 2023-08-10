#!/bin/sh -xe
ulimit -s unlimited
##############################################################################
## User set up veriables
## Root directory for CI
dirRoot=/contrib/fv3
baselineDir=${dirRoot}/baselines/intel/2023.2.0
runDir=${dirRoot}/2023.2.0/refs/pull/261/merge/SHiELD_build/CI/BATCH-CI
# Run CI test scripts
for test in `ls ${runDir}`
do
  cp ${runDir}/${test}/RESTART/* ${baselineDir}/${test}/.
done
