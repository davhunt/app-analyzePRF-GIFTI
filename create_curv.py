#!/usr/bin/env python

import numpy as np
import nibabel as nib
import scipy.io as sio

mat_contents = sio.loadmat('prf_results.mat')

nib.freesurfer.io.write_morph_data('prf/prf_surfaces/lh.polarAngle', mat_contents['lh_polarAngle'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/rh.polarAngle', mat_contents['rh_polarAngle'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/lh.eccentricity', mat_contents['lh_eccentricity'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/rh.eccentricity', mat_contents['rh_eccentricity'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/lh.gain', mat_contents['lh_gain'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/rh.gain', mat_contents['rh_gain'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/lh.meanvol', mat_contents['lh_meanvol'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/rh.meanvol', mat_contents['rh_meanvol'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/lh.r2', mat_contents['lh_r2'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/rh.r2', mat_contents['rh_r2'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/lh.rfWidth', mat_contents['lh_rfWidth'])
nib.freesurfer.io.write_morph_data('prf/prf_surfaces/rh.rfWidth', mat_contents['rh_rfWidth'])
