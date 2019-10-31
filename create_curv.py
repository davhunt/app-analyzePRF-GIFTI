#!/usr/bin/env python

import numpy as np
import nibabel as nib
import scipy.io as sio

mat_contents = sio.loadmat('lh_polarAngle.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_polarAngle', mat_contents['lh_polarAngle'])

mat_contents = sio.loadmat('rh_polarAngle.mat')
nib.freesurfer.io.write_morph_data('prf/rh.benson14_polarAngle', mat_contents['rh_polarAngle'])

mat_contents = sio.loadmat('lh_eccentricity.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_eccentricity', mat_contents['lh_eccentricity'])

mat_contents = sio.loadmat('rh_eccentricity.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_eccentricity', mat_contents['rh_eccentricity'])

mat_contents = sio.loadmat('lh_gain.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_gain', mat_contents['lh_gain'])

mat_contents = sio.loadmat('rh_gain.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_gain', mat_contents['rh_gain'])

mat_contents = sio.loadmat('lh_meanvol.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_meanvol', mat_contents['lh_meanvol'])

mat_contents = sio.loadmat('rh_meanvol.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_meanvol', mat_contents['rh_meanvol'])

mat_contents = sio.loadmat('lh_r2.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_r2', mat_contents['lh_r2'])

mat_contents = sio.loadmat('rh_r2.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_r2', mat_contents['rh_r2'])

mat_contents = sio.loadmat('lh_rfWidth.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_rfWidth', mat_contents['lh_rfWidth'])

mat_contents = sio.loadmat('rh_rfWidth.mat')
nib.freesurfer.io.write_morph_data('prf/lh.benson14_rfWidth', mat_contents['rh_rfWidth'])
