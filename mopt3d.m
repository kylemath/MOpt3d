% mopt3d.m - Matlab 3D-reconstruction of OPTical imaging data
global prm maxprm loc look vox now plot anal group data
load(['files' filesep 'prm.mat']) %some basic settings

%% Pull the settings from the GUI
load_gui_prm(app)

%% Load parameter maxima
prm_max

%% Load locations %new style with no loc file
readloc_new 

%% Compute the bananas for each slice
slices

%% Plot coverage bananas 
plot_bananas
mean_bananas

 %% Convert lookup tables to voxel lists
convert2vox

 %% Load and analyse and plot data
if prm.data_type == 1 %continuous .001 data
    import_ppod
    anal_retinotopy 
    % Plot analysis
    for i1 = anal.compute_blocks %1-2 Polar; 3-4 Eccen %blocks go 1234 PolarNPolarPEccenNEccenP
        for i2 = anal.slow_or_fast % 1-Slow; 2-Fast; 1:2 slow and fast
            anal.analysis_type = i1; 
            anal.slow_fast = i2;
            plot_anal
        end
    end
    
elseif prm.data_type == 2 %averaged .avm data
    import_avm
    for ianal = 1:4
        anal.eccen = ianal;
        anal_avm
        plot_anal_avm
    end
end


