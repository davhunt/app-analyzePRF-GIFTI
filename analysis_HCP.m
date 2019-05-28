% This script shows how analyzePRF_HCP7TRET was used to analyze the
% HCP 7T Retinotopy time-series data.
%
% Note that this is a skeleton script, in the sense that we do not
% loop over the 181+3 subjects and 3 model fits in this script.
% (Presumably, you would have to deploy this on a compute cluster.)
% Also, note that we do not explicitly save the outputs. We leave
% this to the user to implement on their local system.
%
% It is assumed that the time-series data have been organized and placed
% into /path/to/HCP7TRET/. Also, it is assumed that group-average subjects
% 999997, 999998, and 999999 have been computed and saved.
%
% We use a modified version of analyzePRF. This is provided as a
% frozen static version called "analyzePRF_HCP7TRET", distinguishing it
% from the version on github (http://github.com/kendrickkay/analyzePRF/).
% Relative to the github version, modifications have been made in the files:
%   analyzePRF.m
%   analyzePRFcomputesupergridseeds.m
% and are marked with the comment text "MODIFICATION FOR HCP 7T RETINOTOPY DATASET".
%
% Code dependencies:
% - analyzePRF_HCP7TRET
% - knkutils (http://github.com/kendrickkay/knkutils/)
% - MatlabCIFTI
% - workbench

function analysis_HCP(gifti_dir)

% define
%runs = {'MNINonLinear/Results/tfMRI_RETCCW_7T_AP/tfMRI_RETCCW_7T_AP_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
%        'MNINonLinear/Results/tfMRI_RETCW_7T_PA/tfMRI_RETCW_7T_PA_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
%        'MNINonLinear/Results/tfMRI_RETEXP_7T_AP/tfMRI_RETEXP_7T_AP_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
%        'MNINonLinear/Results/tfMRI_RETCON_7T_PA/tfMRI_RETCON_7T_PA_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
%        'MNINonLinear/Results/tfMRI_RETBAR1_7T_AP/tfMRI_RETBAR1_7T_AP_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii' ...
%        'MNINonLinear/Results/tfMRI_RETBAR2_7T_PA/tfMRI_RETBAR2_7T_PA_Atlas_1.6mm_MSMAll_hp2000_clean.dtseries.nii'};

runs = {'tfMRI_RETCCW_7T_AP/tfMRI_RETCCW_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
        'tfMRI_RETCW_7T_PA/tfMRI_RETCW_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
        'tfMRI_RETEXP_7T_AP/tfMRI_RETEXP_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
        'tfMRI_RETCON_7T_PA/tfMRI_RETCON_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
        'tfMRI_RETBAR1_7T_AP/tfMRI_RETBAR1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
        'tfMRI_RETBAR2_7T_PA/tfMRI_RETBAR2_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii'};
    %subjs = matchfiles('/path/to/HCP7TRET/??????');  % match 6-digit subject IDs
%subjs = matchfiles('/N/u/davhunt/Carbonate/Downloads/100610');
subjs = matchfiles(gifti_dir);
tr = 1;                % temporal sampling rate in seconds
pxtodeg = 16.0/200;    % conversion from pixels to degrees
wbcmd = 'wb_command';  % path to workbench command

% define which subject to analyze (1 through 184)
wh = 1;

% define which model fit to perform (1 through 3)
typ = 1;  % 1 is all runs, 2 is first half of each run, 3 is second half of each run

% load stimulus apertures
%load('/N/u/davhunt/Carbonate/Downloads/apertures/RETCCWsmall.mat');
%load('/N/u/davhunt/Carbonate/Downloads/apertures/RETCWsmall.mat');
%load('/N/u/davhunt/Carbonate/Downloads/apertures/RETEXPsmall.mat');
%load('/N/u/davhunt/Carbonate/Downloads/apertures/RETCONsmall.mat');
%load('/N/u/davhunt/Carbonate/Downloads/apertures/RETBARsmall.mat');

%aperturefiles = {'RETCCWsmall.mat' ...
%                 'RETCWsmall.mat' ...
%                 'RETEXPsmall.mat' ...
%                 'RETCONsmall.mat' ...
%                 'RETBARsmall.mat'};
cwd = pwd
aperturefiles = {strcat(cwd,'/apertures/RETCCWsmall.mat') ...
                 strcat(cwd,'/apertures/RETCWsmall.mat') ...
                 strcat(cwd,'/apertures/RETEXPsmall.mat') ...
                 strcat(cwd,'/apertures/RETCONsmall.mat') ...
                 strcat(cwd,'/apertures/RETBARsmall.mat')};

a1 = loadmulti(aperturefiles,'stim',4);
stimulus = splitmatrix(a1,4);
stimulus = stimulus([1 2 3 4 5 5]);
clear a1;

% load data
addpath /N/u/davhunt/Carbonate/Downloads/gifti-1.8/
data = {};
for p=1:6
  data{p} = double(getfield(ciftiopen([subjs{wh} '/' runs{p}],wbcmd),'cdata'));
end

% deal with subsetting
switch typ
case 1
case 2
  stimulus = cellfun(@(x) x(:,:,1:150),stimulus,'UniformOutput',0);
  data =     cellfun(@(x) x(:,1:150),  data,    'UniformOutput',0);
case 3
  stimulus = cellfun(@(x) x(:,:,151:300),stimulus,'UniformOutput',0);
  data =     cellfun(@(x) x(:,151:300),  data,    'UniformOutput',0);
end

% fit the models
a1 = analyzePRF(stimulus,data,tr,struct('seedmode',2));

% prepare outputs
quants = {'ang' 'ecc' 'gain' 'meanvol' 'R2' 'rfsize'};
%allresults = zeros(91282,length(quants),length(subjs),3,'single');  % 91282 x 6 x 184 x 3
allresults = zeros(91282,length(quants),length(subjs),1,'single');
allresults(:,1,wh,typ) = a1.ang;
allresults(:,2,wh,typ) = a1.ecc*pxtodeg;     % convert to degrees
allresults(:,3,wh,typ) = a1.gain;
allresults(:,4,wh,typ) = a1.meanvol;
allresults(:,5,wh,typ) = a1.R2;
allresults(:,6,wh,typ) = a1.rfsize*pxtodeg;  % convert to degrees

% one final modification to the outputs:
% whenever eccentricity is exactly 0, we set angle to NaN since it is ill-defined.
%allresults = squish(permute(allresults,[1 3 4 2]),3);  % 91282*184*3 x 6
allresults = squish(permute(allresults,[1 3 4 2]),1);  % 91282*184*3 x 6
allresults(allresults(:,2)==0,1) = NaN;
%allresults = permute(reshape(allresults,[91282 184 3 6]),[1 4 2 3]);
allresults = permute(reshape(allresults,[91282 1 1 6]),[1 4 2 3]);

mkdir('prf');
cd 'prf'

a2.img = make_nii(allresults(:,1,1,1),[2.00 2.00 2.00]);
save_nii(a2.img,'polarAngle.nii.gz');

a2.img = make_nii(allresults(:,2,1,1),[2.00 2.00 2.00]);
save_nii(a2.img,'eccentricity.nii.gz');

a2.img = make_nii(allresults(:,3,1,1),[2.00 2.00 2.00]);
save_nii(a2.img,'gain.nii.gz');

a2.img = make_nii(allresults(:,4,1,1),[2.00 2.00 2.00]);
save_nii(a2.img,'meanvol.nii.gz');

a2.img = make_nii(allresults(:,5,1,1),[2.00 2.00 2.00]);
save_nii(a2.img,'R2.nii.gz');

a2.img = make_nii(allresults(:,6,1,1),[2.00 2.00 2.00]);
save_nii(a2.img,'rfWidth.nii.gz');

cd ..
