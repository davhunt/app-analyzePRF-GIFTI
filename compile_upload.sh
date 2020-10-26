#!/bin/bash

# assuming we're in the directory containing 7T RET_?mm_fix folder

module unload matlab && module load matlab/2019a

rm -rf compiled_upload && mkdir compiled_upload

log=compiled_upload/commit_ids.txt
true > $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "utilities" >> $log
(cd utilities && git log -1) >> $log
echo "gifti-1.8" >> $log
(cd gifti-1.8 && git log -1) >> $log
echo "NIfTI_cifti_matlab_tools" >> $log
(cd NIfTI_cifti_matlab_tools && git log -1) >> $log

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('utilities'))
addpath(genpath('gifti-1.8'))
addpath(genpath('NIfTI_cifti_matlab_tools'))
mcc -m -R -nodisplay -d compiled_upload convertDtseries
exit
END
matlab -nodisplay -nosplash -r build && rm build.m
