# MOpt3d

mopt3d.m - Matlab 3D-reconstruction of OPTical imaging data

Copyright (c) 2014 All Right Reserved
Dr. Kyle Mathewson, Postdoctoral Fellow, Beckman Institute
kylemath@gmail.com
April 24/2014 - University of Illinios

Translated to matlab based on original fortran 90 code opt3d_fast_v2.f90 by Dr. Gabriele Gratton

------------------

mopt3d.m is a wrapper function that sets the paramaters and calls the fucntions to:

Run the code by running mopt3d in the command line. Change settings inside the mopt3d script. You will at least have to change the experiment name and data path.

1) Load in location information from .mtg and .rol/.tol files 
 -readloc_new.m - no longer needs a .loc text file, finds files  based on parameters
2) Create photon density maps (banana paths) for each "channel", for each subject
-slices.m, look_slice.m, setuplook.m, in_lookup.m
3) Plots these maps on individual and common space anatomy
-plot_banans.m, -load_anat.m
4) Saves these photon density maps as .nii briks for plottin in outside programs (freesurfer)
-write_freesurer_nii.m
5) Convert this information to a voxel lookup table
-convert2vox.m
6) Loads in pc##-##/.avm or pc##-##.00# files created by PPOD
-import_avm.m, -import_ppod.m
7) Analyzes the continuous or averaged data
-anal_avm.m, -anal_retinotopy.m
8) Plots the results of the analysis on individual and group anatomy
-plot_anal_avm.m, -plot_anal.m
9) Saves a .nii brik of the data for plotting in outside programs (freesurfer)
-write_freesurer_nii.m


All of the parameters, as well as steps 1 and 2 are direct translations of the algorithm used in opt3d_fast_v2.f90, with some computations converted to vector computations to speed up the code. However, this code differs in that it cycles through EVERY SLICE to make a 3D brik of the data

Please see Documentation/html/opt3dmat_functions_variables.html for more detailed information
