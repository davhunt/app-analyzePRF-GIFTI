[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.203-blue.svg)](https://doi.org/10.25663/bl.app.203)

# app-analyzePRF-GIFTI (Surface)

This service runs the [analyzePRF toolbox](https://github.com/kendrickkay/analyzePRF) to derive pRF (population receptive field) measurements on the cortical surface, from retinotopy task fMRI data. Measurements include r^2, polar angle, eccentricity, and rf width.

[![pRF parameters](https://raw.githubusercontent.com/davhunt/pictures/master/Screenshot%20from%202019-04-17%2014-41-11.png)

The fMRI data should be in the form of [GIFTI](https://surfer.nmr.mgh.harvard.edu/fswiki/GIfTI)-format files, in the Brainlife ["surfaces"](https://brainlife.io/datatype/5dec20ff6c0bd9f84485779f) datatype, which consists of the time-series information for each vertex in the left and right hemispheres (left_data.gii and right_data.gii) as well as the geometrical information (x,y,z coordinates) of each vertex on the pial, white, and inflated surfaces (left_white.gii, left_pial.gii, left_inflated.gii, etc.)

### Authors
- David Hunt (davhunt@iu.edu)
- Kendrick Kay (kendrick@post.harvard.edu)

### Project director
- Franco Pestilli (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-AOC-1916518](https://img.shields.io/badge/NSF_AOC-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)

## Running 

This app analyzes vertex-wise time-series data stored in GIFTIs.

### With HCP data

To download and use fMRI data from the Human Connectome Project with this app, go to db.humanconnectome.org and login or create an account, and download Aspera. In the "WU-Minn HCP Data" under "Explore Subjects" find "Subjects with 7T MR Session Data," and download
for 2mm^3 res data:		1) Structural Preprocessed
				2) Retinotopy Task fMRI 2mm/32k FIX-Denoised (Compact)

or for 1.6mm^3 res data:	1) Structural Preprocessed for 7T (1.6mm/59k mesh)
				2) Retinotopy Task fMRI 1.6mm/59k FIX-Denoised (Compact)

Move the .zip files to your current working directory and gunzip them.

To convert the HCP "CIFTI" files to GIFTI you will need to use "convertDtseries.m" in this repository, which converts a given subject at 2mm or 1.6mm resolution to GIFTI.

If you've downloaded data for subject 102311 at 2mm, for example:

```bash
matlab -nodisplay -r 'convertDtseries 102311 2mm; exit;'
```

Or, with Singularity/Docker:

```bash
subj=102311; res=2mm;
time singularity exec -e docker://davhunt/wb_freesurfer:3.0 ./compiled_upload/convertDtseries $subj $res
```

And the data can be uploaded to Brainlife.

Or, converting and uploading all in one script:

```bash
subj=102311; res=2mm; project=*bl_project_id*; #see https://brainlife.io/docs/cli/upload/
./upload_HC_data $project $subj $res
```

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.203](https://doi.org/10.25663/brainlife.app.203) via the "Execute" tab.

### Running Locally

### On Command Line

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
        "func_L": "/input/left_data.gii",
        "func_R": "/input/right_data.gii",
        "pial_L": "/input/surfaces/left_pial.surf.gii",
        "pial_R": "/input/surfaces/right_pial.surf.gii",
        "wm_L": "/input/surfaces/left_wm.surf.gii",
        "wm_R": "/input/surfaces/right_wm.surf.gii",
        "inflated_L": "/input/surfaces/left_inflated.surf.gii",
        "inflated_R": "/input/surfaces/right_inflated.surf.gii"
}
```
3. Launch the App by executing `main`
```bash
./main
```

## Output

The main output will be the "prf" directory, which will store the geometric surfaces inputted (in "surfaces") as well as the population receptive field measurements r squared, polar angle, eccentricity, and receptive field width (std of the Gaussian), in "prf_surfaces," for each vertex analyzed on each hemisphere.

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run.

### References

[2013 Kay et al. Compressive spatial summation in human visual cortex.](https://doi.org/10.1152/jn.00105.2013)

[2018 Benson et al. The HCP 7T Retinotopy Dataset: Description and pRF Analysis](https://www.biorxiv.org/content/10.1101/308247v2.full)


### License

Terms of use: This content is licensed under a Creative Commons Attribution 3.0 
Unported License (http://creativecommons.org/licenses/by/3.0/us/). You are free 
to share and adapt the content as you please, under the condition that you cite 
the appropriate manuscript (see below).

If you use analyzePRF in your research, please cite the following paper:
  Kay KN, Winawer J, Mezer A and Wandell BA (2013) 
    Compressive spatial summation in human visual cortex.
    J. Neurophys. doi: 10.1152/jn.00105.2013

History of major code changes:
- 2014/06/17 - Version 1.1.

## CONTENTS

Contents:
- analyzeHCP.m - Matlab script calling analyzePRF.m for HCP data
- analyzePRF.m - Top-level function that you want to call
- analyzePRFcomputeGLMdenoiseregressors.m - Helper function
- analyzePRFcomputesupergridseeds.m - Helper function
- example*.m - Example scripts
- exampledataset.mat - Example dataset
- README - The file you are reading
- setup.m - A simple script that downloads the example dataset
            and adds analyzePRF to the MATLAB path
- utilities - A directory containing various utility functions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Copyright (c) 2014, Kendrick Kay
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this
list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

The names of its contributors may not be used to endorse or promote products 
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
