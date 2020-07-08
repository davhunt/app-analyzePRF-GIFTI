#!/bin/bash

fsdir=${1}

echo "creating vtks"
mris_convert prf/surfaces/lh.white.gii prf/surfaces/lh.white.vtk
mris_convert prf/surfaces/rh.white.gii prf/surfaces/rh.white.vtk
mris_convert prf/surfaces/lh.pial.gii prf/surfaces/lh.pial.vtk
mris_convert prf/surfaces/rh.pial.gii prf/surfaces/rh.pial.vtk
mris_convert prf/surfaces/lh.sphere.gii prf/surfaces/lh.sphere.vtk
mris_convert prf/surfaces/rh.sphere.gii prf/surfaces/rh.sphere.vtk
mris_convert prf/surfaces/lh.inflated.gii prf/surfaces/lh.inflated.vtk
mris_convert prf/surfaces/rh.inflated.gii prf/surfaces/rh.inflated.vtk

rm -f prf/surfaces/*.gii # don't nned GIFTIs anymore
