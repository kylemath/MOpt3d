%% in_lookup.m - this subroutine encode channel info stored in look.one_vox_chans into look.idw_chan_per_vox and look.n_chan_per_vox
%  Dr. Kyle Mathewson - June 8, 2013 - Translation of Gabriele Gratton's opt3d_fast_v2.f90
%  j = x coordinate
%  i = y coordinate
%  isubj = subject
%  must be called immediately after setuplookup subroutine

%% Setup workspace and define function
function in_lookup(j,i,isubj)
global prm maxprm look

%% Select the channels for this voxel
[chan_names] = find(look.one_vox_chans);
n_near = length(chan_names);
   
%% Rescale the data to double voxels
jj=j.*maxprm.kresrat;
ii=i.*maxprm.kresrat;

%% Geometric model
if prm.modeltype == 1 
    
    %assign chan names
    look.idw_chan_per_vox(1,1:n_near,jj,ii,isubj)=chan_names;  
    
    % give all the channels the same weight
    look.idw_chan_per_vox(2,1:n_near,jj,ii,isubj)=ones(1,n_near);   
    
%% Physical Model
elseif prm.modeltype == 2 
    
    %retreive, scale, and clip weights
    weights = look.one_vox_weights.*1000000;
    weights(weights>256.*128-1) = 256.*128-1;
    weights(weights<-256.*128) = -256.*128;
    
    % select the channels for this voxel
    look.idw_chan_per_vox(1,1:n_near,jj,ii,isubj)=chan_names;
    
    % give the channel its weight
    look.idw_chan_per_vox(2,1:n_near,jj,ii,isubj)=weights(chan_names);   
end

%% count the channels
look.n_chan_per_vox(jj,ii,isubj)=n_near;
