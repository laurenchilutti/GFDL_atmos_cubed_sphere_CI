#!/bin/sh -xe
dirRoot=/contrib/fv3
intelVersion=2023.2.0
baselineDir=${dirRoot}/baselines/intel/${intelVersion}
# Run CI test scripts
cd ${dirRoot}/FV3CIScripts
## Compare Restarts to Baseline
. ${MODULESHOME}/init/sh
for test in `ls ${baselineDir}`
do
  ./${test}.sh &
done
