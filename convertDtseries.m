function [] = convertDtseries(subj, res)

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/mrTools'))
	addpath(genpath('/N/u/davhunt/Carbonate/analyzePRF/utilities'))
        addpath(genpath('/N/u/davhunt/Carbonate/Downloads/gifti-1.8/'))
        addpath(genpath('/N/u/davhunt/Carbonate/NIfTI_cifti_matlab_tools'))
end

wbcmd = '/usr/local/workbench/bin_linux64/wb_command';  % path to workbench command

if str2num(res) == 2.0
  runs = {'tfMRI_RETCCW_7T_AP/tfMRI_RETCCW_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETCW_7T_PA/tfMRI_RETCW_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETEXP_7T_AP/tfMRI_RETEXP_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETCON_7T_PA/tfMRI_RETCON_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETBAR1_7T_AP/tfMRI_RETBAR1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETBAR2_7T_PA/tfMRI_RETBAR2_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii'};
  for p=1:6
    data{p} = double(getfield(ciftiopen(['./' subj '_7T_RET_2mm_fix/MNINonLinear/Results/' runs{p}],wbcmd),'cdata'));
  end

elseif str2num(res) == 1.6
  runs = {'tfMRI_RETCCW_7T_AP/tfMRI_RETCCW_7T_AP_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETCW_7T_PA/tfMRI_RETCW_7T_PA_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETEXP_7T_AP/tfMRI_RETEXP_7T_AP_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETCON_7T_PA/tfMRI_RETCON_7T_PA_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETBAR1_7T_AP/tfMRI_RETBAR1_7T_AP_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
          'tfMRI_RETBAR2_7T_PA/tfMRI_RETBAR2_7T_PA_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii'};
  for p=1:6
    data{p} = double(getfield(ciftiopen(['./' subj '_7T_RET_1.6mm_fix/MNINonLinear/Results/' runs{p}],wbcmd),'cdata'));
  end

else
  disp('HCP retinotopic data must be 1.6 or 2 mm');
  exit;
end

p=1;
for task = {'RETCCW' 'RETCW' 'RETEXP' 'RETCON' 'RETBAR1' 'RETBAR2'}
  gii = gifti;
  if str2num(res) == 2
    gii.cdata = data{p}(1:29696,:); % LH has 29696 grayordinates
  elseif str2num(res) == 1.6
    gii.cdata = data{p}(1:54216,:); % LH has 54216 grayordinates
  end
  save_gifti(gii,strcat('left_data_',char(task),'.gii'));

  gii = gifti;
  if str2num(res) == 2
    gii.cdata = data{p}(29697:59412,:); % RH has 29716 grayordinates
  elseif str2num(res) == 1.6
    gii.cdata = data{p}(54217:108441,:); % RH has 54225 grayordinates
  end
  save_gifti(gii,strcat('right_data_',char(task),'.gii'));

  p = p+1;
end

end
