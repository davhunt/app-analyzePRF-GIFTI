#!/bin/bash

module unload matlab && module load matlab/2019a

log=compiled/commit_ids.txt
true > $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "/N/u/brlife/git/mrTools" >> $log
(cd /N/u/brlife/git/mrTools && git log -1) >> $log
echo "/N/u/brlife/git/NIfTI" >> $log
(cd /N/u/brlife/git/NIfTI && git log -1) >> $log
echo "utilities" >> $log
(cd utilities && git log -1) >> $log
echo "gifti-1.8" >> $log
(cd /N/u/davhunt/Carbonate/Downloads/gifti-1.8 && git log -1) >> $log

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/mrTools'))
addpath(genpath('/N/u/brlife/git/NIfTI'))
addpath(genpath('utilities'))
addpath(genpath('gifti-1.8'))

mcc -m -R -nodisplay -a /N/u/brlife/git/vistasoft/mrDiffusion/templates -d compiled main
exit
END
matlab -nodisplay -nosplash -r build && rm build.m
