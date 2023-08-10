#!/bin/sh -xe
ulimit -s unlimited

cd /contrib/fv3/FV3CIScripts
for i in `ls /contrib/fv3/baselines/intel/2022.1.1`
do
  if [ ${i} != C128r20.solo.superC ]
  then
    cp C128r20.solo.superC.sh ${i}.sh
    sed -i "s|C128r20.solo.superC|${i}|g" ${i}.sh
  fi
done


