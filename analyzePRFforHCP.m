function analyzePRFforHCP(func_L, func_R)

%runs = {'tfMRI_RETCCW_7T_AP/tfMRI_RETCCW_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
%        'tfMRI_RETCW_7T_PA/tfMRI_RETCW_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
%        'tfMRI_RETEXP_7T_AP/tfMRI_RETEXP_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
%        'tfMRI_RETCON_7T_PA/tfMRI_RETCON_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
%        'tfMRI_RETBAR1_7T_AP/tfMRI_RETBAR1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii' ...
%        'tfMRI_RETBAR2_7T_PA/tfMRI_RETBAR2_7T_PA_Atlas_MSMAll_hp2000_clean.dtseries.nii'};

func_L_gii = gifti(func_L);
func_R_gii = gifti(func_R);

%subjs = matchfiles(gifti_dir);

tr = 1;                % temporal sampling rate in seconds
pxtodeg = 16.0/200;    % conversion from pixels to degrees
%wbcmd = '/usr/bin/wb_command';  % path to workbench command

% define which subject to analyze (1 through 184)
wh = 1;

% define which model fit to perform (1 through 3)
typ = 1;  % 1 is all runs, 2 is first half of each run, 3 is second half of each run

% load stimulus apertures
aperturefiles = {strcat(pwd,'/apertures/RETCCWsmall.mat') ...
                 strcat(pwd,'/apertures/RETCWsmall.mat') ...
                 strcat(pwd,'/apertures/RETEXPsmall.mat') ...
                 strcat(pwd,'/apertures/RETCONsmall.mat') ...
                 strcat(pwd,'/apertures/RETBARsmall.mat')};

a1 = loadmulti(aperturefiles,'stim',4);
stimulus = splitmatrix(a1,4);
stimulus = stimulus([1 2 3 4 5 5]);
clear a1;

data = {};
LD_LIBRARY_PATH = getenv('LD_LIBRARY_PATH');

sumTR = 1;
for p=1:size(stimulus,2)
%  data{p} = double(getfield(ciftiopen([subjs{wh}(1:end-2) '/' runs{p}],wbcmd),'cdata'));
%  data{p} = data{p}(1:59412,:);
%  data{p} = double(cat(1, func_L_gii.cdata(:,p*300-299:p*300), func_R_gii.cdata(:,p*300-299:p*300)));

  data{p} = double(cat(1, func_L_gii.cdata(:,sumTR:sumTR+size(stimulus{p},3)-1), func_R_gii.cdata(:,sumTR:sumTR+size(stimulus{p},3)-1)));
  sumTR = sumTR + size(stimulus{p},3);
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
a1 = analyzePRF(stimulus,data,tr,struct('seedmode',[-2]));



% convert pAngle results to standard pRF convention (0-180 deg = UVM -> L/R HM -> LVM)
for i = 1:size(a1.ang)
  if a1.ang(i) >= 90.0 && a1.ang(i) <= 270.0
    a1.ang(i) = a1.ang(i) - 90;
  elseif a1.ang(i) >= 0.0 && a1.ang(i) < 90.0
    a1.ang(i) = -a1.ang(i) + 90;
  elseif a1.ang(i) > 270.0 && a1.ang(i) <= 360.0
    a1.ang(i) = -a1.ang(i) + 450;
  end
end

% prepare outputs
quants = {'ang' 'ecc' 'gain' 'meanvol' 'R2' 'rfsize'};

totalVerticesLH = size(func_L_gii.cdata,1); totalVerticesRH = size(func_R_gii.cdata,1);
totalVertices = totalVerticesLH + totalVerticesRH;
allresults = zeros(totalVertices,length(quants),1,1,'single');


%allresults = zeros(91282,length(quants),length(subjs),3,'single');
% 91282 grayordinates x 6 quants x 184 subjects x 3 model fits
allresults = zeros(59412,length(quants),1,1,'single');
allresults(:,1,wh,typ) = a1.ang;
allresults(:,2,wh,typ) = a1.ecc*pxtodeg;     % convert to degrees
allresults(:,3,wh,typ) = a1.gain;
allresults(:,4,wh,typ) = a1.meanvol;
allresults(:,5,wh,typ) = a1.R2;
allresults(:,6,wh,typ) = a1.rfsize*pxtodeg; % convert to degrees

% one final modification to the outputs:
% whenever eccentricity is exactly 0, we set angle to NaN since it is ill-defined.
%allresults = squish(permute(allresults,[1 3 4 2]),3);  % 91282*184*3 x 6
allresults = squish(permute(allresults,[1 3 4 2]),1);
allresults(allresults(:,2)==0,1) = NaN;
%allresults = permute(reshape(allresults,[91282 184 3 6]),[1 4 2 3]);
%allresults = permute(reshape(allresults,[59412 1 1 6]),[1 4 2 3]);
allresults = permute(reshape(allresults,[totalVertices 1 1 6]),[1 4 2 3]);

% first 29696 grayordinates in CIFTI are lh, next 29716 are rh
lh_polarAngle = allresults(1:totalVerticesLH,1,1,1);
rh_polarAngle = allresults(totalVerticesLH+1:totalVertices,1,1,1);

lh_eccentricity = allresults(1:totalVerticesLH,2,1,1);
rh_eccentricity = allresults(totalVerticesLH+1:totalVertices,2,1,1);

lh_gain = allresults(1:totalVerticesLH,3,1,1);
rh_gain = allresults(totalVerticesLH+1:totalVertices,3,1,1);

lh_meanvol = allresults(1:totalVerticesLH,4,1,1);
rh_meanvol = allresults(totalVerticesLH+1:totalVertices,4,1,1);

lh_r2 = allresults(1:totalVerticesLH,5,1,1);
rh_r2 = allresults(totalVerticesLH+1:totalVertices,5,1,1);

lh_rfWidth = allresults(1:totalVerticesLH,6,1,1);
rh_rfWidth = allresults(totalVerticesLH+1:totalVertices,6,1,1);

save('prf_results.mat', 'lh_polarAngle', 'rh_polarAngle', 'lh_eccentricity', 'rh_eccentricity', ...
  'lh_gain', 'rh_gain', 'lh_meanvol', 'rh_meanvol', 'lh_r2', 'rh_r2', 'lh_rfWidth', 'rh_rfWidth');

for hemi = {'lh', 'rh'}
  for prf = {'polarAngle','eccentricity','gain','meanvol','r2','rfWidth'}
    gii = gifti;
    gii.cdata = eval([char(hemi),'_',char(prf)]);
    save_gifti(gii,strcat('prf/prf_surfaces/',char(hemi),'.',char(prf),'.gii'));
  end
end

end
