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
  lhDataCat = [data{1}(1:29696,:),data{2}(1:29696,:),data{3}(1:29696,:),data{4}(1:29696,:),data{5}(1:29696,:),data{6}(1:29696,:)];
  rhDataCat = [data{1}(29697:59412,:),data{2}(29697:59412,:),data{3}(29697:59412,:),data{4}(29697:59412,:),data{5}(29697:59412,:),data{6}(29697:59412,:)];

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
  lhDataCat = [data{1}(1:54216,:),data{2}(1:54216,:),data{3}(1:54216,:),data{4}(1:54216,:),data{5}(1:54216,:),data{6}(1:54216,:)];
  rhDataCat = [data{1}(54217:108441,:),data{2}(54217:108441,:),data{3}(54217:108441,:),data{4}(54217:108441,:),data{5}(54217:108441,:),data{6}(54217:108441,:)];

else
  disp('HCP retinotopic data must be 1.6 or 2 mm');
  exit;
end

gii = gifti;
gii.cdata = lhDataCat;
save_gifti(gii,'left_data.gii');

gii = gifti;
gii.cdata = rhDataCat;
save_gifti(gii,'right_data.gii');

end

