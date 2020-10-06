function [] = main()

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/mrTools'))
        addpath(genpath('/N/u/brlife/git/NIfTI'))
	addpath(genpath('utilities'))
        addpath(genpath('gifti-1.8/'))
end


% load config.json
config = loadjson('config.json');

PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/bin']);

% compute pRF
getPRF(config.func_L, config.func_R, config.stim, config.hcp, config.TR, config.pxtodeg);

createSurfs(config.pial_L, config.pial_R, config.wm_L, config.wm_R, config.inflated_L, config.inflated_R, config.hcp);

end
