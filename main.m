function [] = main()

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/mrTools'))
	addpath(genpath('/N/u/davhunt/Carbonate/analyzePRF/utilities'))
        addpath(genpath('/N/u/davhunt/Carbonate/Downloads/gifti-1.8/'))
        addpath(genpath('/N/u/davhunt/Carbonate/NIfTI_cifti_matlab_tools'))
end


% load config.json
config = loadjson('config.json');

PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/bin']);

% compute pRF
getPRF(config.func_L, config.func_R, config.stim, config.hcp);

createSurfs(config.pial_L, config.pial_R, config.wm_L, config.wm_R, config.inflated_L, config.inflated_R, config.hcp);

end
