function [] = main()

if ~isdeployed
	disp('loading paths for IUHPC')
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/mrTools'))
	%addpath(genpath('/N/u/brlife/git/vistasoft'))
	addpath(genpath('/N/u/davhunt/Carbonate/analyzePRF/utilities'))
        addpath(genpath('/N/u/davhunt/Carbonate/Downloads/gifti-1.8/'))
end

% load config.json
config = loadjson('config.json');

PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/bin']);

% compute pRF
analysis_HCP(config.gifti_dir);

createSurfs();

end
