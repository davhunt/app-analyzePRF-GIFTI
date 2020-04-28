[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.203-blue.svg)](https://doi.org/10.25663/bl.app.203)

# app-analyzePRF-GIFTI (Surface)

This service runs the [analyzePRF toolbox](https://github.com/kendrickkay/analyzePRF) to derive pRF (population receptive field) measurements on the cortical surface, from retinotopy task fMRI data. Measurements include r^2, polar angle, eccentricity, and rf width.

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
        "func_R": "/input/right_data.gii',
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
