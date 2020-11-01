function [] = main()

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/mrTools'))
        addpath(genpath('/N/u/brlife/git/NIfTI'))
	addpath(genpath('utilities'))
        addpath(genpath('gifti-1.8'))
end


% load config.json
config = loadjson('config.json');

PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/bin']);

seedmodes = []; % deal with PRF seedmodes
if config.wantquick
  seedmodes = [-2];
else
  if config.seedmode0
    seedmodes = [seedmodes 0];
  end
  if config.seedmode1
    seedmodes = [seedmodes 1];
  end
  if config.seedmode2
    seedmodes = [seedmodes 2];
  end
end
if isempty(seedmodes)
  disp('No seeds specified, using [0 1 2] seedmode')
end

% compute pRF
getPRF(config.func_L, config.func_R, config.stim, seedmodes, config.hcp, config.TR, config.pxtodeg, config.gsr);

createSurfs(config.pial_L, config.pial_R, config.wm_L, config.wm_R, config.inflated_L, config.inflated_R, config.hcp);

end
