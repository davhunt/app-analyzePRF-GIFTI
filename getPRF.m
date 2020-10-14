function getPRF(func_L, func_R, stim, HCPstimuli, TR, pxtodeg)

if length(func_L) ~= length(stim) || length(func_R) ~= length(stim)
  error('must input one stimulus for each fmri run')
end

if ~isempty(TR) tr = TR;  % temporal sampling rate in seconds 
else
  error('No repetition time (TR) found for inputted fMRI')
end

if isempty(pxtodeg) error('conversion factor from pixels (of visual stimulus) to degrees not specified'); end    % conversion from pixels to degrees

% define which subject to analyze (1 through 184)
wh = 1;
% define which model fit to perform (1 through 3)
typ = 1;  % 1 is all runs, 2 is first half of each run, 3 is second half of each run

stimulus = {};
if HCPstimuli == 1
  aperturefiles = {strcat(pwd,'/apertures/RETCCWsmall.mat') ...
                   strcat(pwd,'/apertures/RETCWsmall.mat') ...
                   strcat(pwd,'/apertures/RETEXPsmall.mat') ...
                   strcat(pwd,'/apertures/RETCONsmall.mat') ...
                   strcat(pwd,'/apertures/RETBARsmall.mat') ...
                   strcat(pwd,'/apertures/RETBARsmall.mat')};
  for p=1:length(aperturefiles)
    a1 = load(aperturefiles{p},'stim');
    stimulus{p} = a1.stim;
  end
else
  if isempty(stim)
    error('either user-uploaded or HCP stimuli must be specified');
  end
  for p=1:length(stim)
    a1 = load_untouch_nii(char(stim{p}));
    stimulus{p} = a1.img;
  end
end

LD_LIBRARY_PATH = getenv('LD_LIBRARY_PATH');

func_L_gii = {};
func_R_gii = {};
data = {};
for p=1:length(func_L)
  func_L_gii = gifti(char(func_L{p}));
  func_R_gii = gifti(char(func_R{p}));
  data{p} = double(cat(1, func_L_gii.cdata, func_R_gii.cdata));
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
a1 = analyzePRF(stimulus,data,tr,struct('seedmode',[0 1 2]));

% prepare outputs
quants = {'ang' 'ecc' 'gain' 'meanvol' 'R2' 'rfsize' 'expt'};

totalVerticesLH = size(func_L_gii.cdata,1); totalVerticesRH = size(func_R_gii.cdata,1);
totalVertices = totalVerticesLH + totalVerticesRH;

% 91282 grayordinates x 6 quants x 184 subjects x 3 model fits
allresults = zeros(totalVertices,length(quants),1,1,'single');
allresults(:,1,wh,typ) = a1.ang;
allresults(:,2,wh,typ) = a1.ecc*pxtodeg;     % convert to degrees
allresults(:,3,wh,typ) = a1.gain;
allresults(:,4,wh,typ) = a1.meanvol;
allresults(:,5,wh,typ) = a1.R2;
allresults(:,6,wh,typ) = a1.rfsize*pxtodeg; % convert to degrees
allresults(:,7,wh,typ) = a1.expt;

% one final modification to the outputs:
% whenever eccentricity is exactly 0, we set polar angle to NaN since it is ill-defined.
% remove eccentricity and rfsizes > 90 degrees since they don't make sense
allresults = squish(permute(allresults,[1 3 4 2]),1);
allresults(allresults(:,2)==0,1) = NaN;
allresults(allresults(:,2)>90,2) = NaN;
allresults(allresults(:,6)>90,6) = NaN;
allresults(:,5) = allresults(:,5)/100.0;
allresults = permute(reshape(allresults,[totalVertices 1 1 7]),[1 4 2 3]);

% first 29696 grayordinates in CIFTI are lh, next 29716 are rh
% (for 1.6mm res, first 54216 are lh, next 54225 are rh)
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

lh_expt = allresults(1:totalVerticesLH,7,1,1);
rh_expt = allresults(totalVerticesLH+1:totalVertices,7,1,1);

save('prf_results.mat', 'lh_polarAngle', 'rh_polarAngle', 'lh_eccentricity', 'rh_eccentricity', ...
  'lh_gain', 'rh_gain', 'lh_meanvol', 'rh_meanvol', 'lh_r2', 'rh_r2', 'lh_rfWidth', 'rh_rfWidth', 'lh_expt', 'rh_expt');

for hemi = {'lh', 'rh'}
  for prf = {'polarAngle','eccentricity','gain','meanvol','r2','rfWidth' 'expt'}
    gii = gifti;
    gii.cdata = eval([char(hemi),'_',char(prf)]);
    save_gifti(gii,strcat('prf/prf_surfaces/',char(hemi),'.',char(prf),'.gii'));
  end
end

end
