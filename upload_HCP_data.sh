#!/bin/bash

# assuming we're in the directory containing 7T RET_?mm_fix folder and 3T Structural_preproc folder

project=${1}
subj=${2}
res=${3}

if (( $(echo "$res == 1.6" | bc -l) )); then
  unzip ${subj}_3T_Structural_1.6mm_preproc.zip && mv ${subj} ${subj}_3T_Structural_1.6mm_preproc
  unzip ${subj}_7T_RET_1.6mm_fix.zip && mv ${subj} ${subj}_7T_RET_1.6mm_fix
elif (( $(echo "$res == 2" | bc -l) )); then
  unzip ${subj}_3T_Structural_preproc.zip && mv ${subj} ${subj}_3T_Structural_preproc
  unzip ${subj}_7T_RET_2mm_fix.zip && mv ${subj} ${subj}_7T_RET_2mm_fix
fi

time singularity exec -e docker://davhunt/wb_freesurfer:3.0 ./compiled_upload/convertDtseries $subj $res

if (( $(echo "$res == 1.6" | bc -l) )); then
  cp $(echo ${subj}_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/${subj}.R.pial_1.6mm_MSMAll.59k_fs_LR.surf.gii) right_pial.surf.gii #MNI?????
  cp $(echo ${subj}_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/${subj}.L.pial_1.6mm_MSMAll.59k_fs_LR.surf.gii) left_pial.surf.gii
  cp $(echo ${subj}_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/${subj}.R.white_1.6mm_MSMAll.59k_fs_LR.surf.gii) right_white.surf.gii
  cp $(echo ${subj}_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/${subj}.L.white_1.6mm_MSMAll.59k_fs_LR.surf.gii) left_white.surf.gii
  cp $(echo ${subj}_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/${subj}.R.very_inflated_1.6mm_MSMAll.59k_fs_LR.surf.gii) right_inflated.surf.gii
  cp $(echo ${subj}_3T_Structural_1.6mm_preproc/MNINonLinear/fsaverage_LR59k/${subj}.L.very_inflated_1.6mm_MSMAll.59k_fs_LR.surf.gii) left_inflated.surf.gii
elif (( $(echo "$res == 2" | bc -l) )); then
  cp $(echo ${subj}_3T_Structural_preproc/MNINonLinear/fsaverage_LR32k/${subj}.R.pial_MSMAll.32k_fs_LR.surf.gii) right_pial.surf.gii #MNI?????
  cp $(echo ${subj}_3T_Structural_preproc/MNINonLinear/fsaverage_LR32k/${subj}.L.pial_MSMAll.32k_fs_LR.surf.gii) left_pial.surf.gii
  cp $(echo ${subj}_3T_Structural_preproc/MNINonLinear/fsaverage_LR32k/${subj}.R.white_MSMAll.32k_fs_LR.surf.gii) right_white.surf.gii
  cp $(echo ${subj}_3T_Structural_preproc/MNINonLinear/fsaverage_LR32k/${subj}.L.white_MSMAll.32k_fs_LR.surf.gii) left_white.surf.gii
  cp $(echo ${subj}_3T_Structural_preproc/MNINonLinear/fsaverage_LR32k/${subj}.R.very_inflated_MSMAll.32k_fs_LR.surf.gii) right_inflated.surf.gii
  cp $(echo ${subj}_3T_Structural_preproc/MNINonLinear/fsaverage_LR32k/${subj}.L.very_inflated_MSMAll.32k_fs_LR.surf.gii) left_inflated.surf.gii
else
  echo "HCP data resolution must be 1.6mm or 2mm"
fi

bl dataset upload \
    --project $project   \
    --datatype neuro/surface \
    --desc 'HCP dtseries data from retinotopy task at '$res'mm resolution' \
    --subject $subj \
    --left_data left_data.gii \
    --right_data right_data.gii \
    --left_pial left_pial.surf.gii \
    --right_pial right_pial.surf.gii \
    --left_wm left_white.surf.gii \
    --right_wm right_white.surf.gii \
    --left_inflated left_inflated.surf.gii \
    --right_inflated right_inflated.surf.gii \
    --tag "MNI" \
    --tag "HCP 7T RET dtseries" \
    --tag $res'mm isotropic res'


rm right_*surf.gii left_*surf.gii right_data.gii left_data.gii
if [ -d ${subj}_7T_RET_1.6mm_fix ]; then rm -r ${subj}_7T_RET_1.6mm_fix ${subj}_3T_Structural_1.6mm_preproc; fi
if [ -d ${subj}_7T_RET_2mm_fix ]; then rm -r ${subj}_7T_RET_2mm_fix ${subj}_3T_Structural_preproc; fi
