#!/bin/bash

# assuming we're in the directory containing 7T RET_?mm_fix folder

rm -rf compiled_upload && mkdir compiled_upload

log=compiled_upload/commit_ids.txt
true > $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "/N/u/brlife/git/mrTools" >> $log
(cd /N/u/brlife/git/mrTools && git log -1) >> $log
echo "/N/u/davhunt/Carbonate/analyzePRF/utilities" >> $log
(cd /N/u/davhunt/Carbonate/analyzePRF/utilities && git log -1) >> $log
echo "/N/u/davhunt/Carbonate/Downloads/gifti-1.8" >> $log
(cd /N/u/davhunt/Carbonate/Downloads/gifti-1.8 && git log -1) >> $log
echo "/N/u/davhunt/Carbonate/NIfTI_cifti_matlab_tools" >> $log
(cd /N/u/davhunt/Carbonate/NIfTI_cifti_matlab_tools && git log -1) >> $log

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/mrTools'))
addpath(genpath('/N/u/davhunt/Carbonate/analyzePRF/utilities'))
addpath(genpath('/N/u/davhunt/Carbonate/Downloads/gifti-1.8'))
addpath(genpath('/N/u/davhunt/Carbonate/NIfTI_cifti_matlab_tools'))
mcc -m -R -nodisplay -d compiled_upload convertDtseries
exit
END
matlab -nodisplay -nosplash -r build && rm build.m