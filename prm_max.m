%% prm_max.m include file for the opt-3d program
% Dr. Kyle Mathewson - June 8, 2013 - Translation of Gabriele Gratton's opt3d_fast_v2.f90

function prm_max

global maxprm prm plot
% max number of points
 maxprm.knp=62 ; 
% max number of channels
 maxprm.knc=960 ; 
% max number of channels used for a particular voxel
 maxprm.kncx=80 ;
% max number of bins
 maxprm.knb=16 ; 
% max number of subjects
 maxprm.kns=32 ; 
% number of montages
 maxprm.kses=8 ; 
% max number of contrasts
 maxprm.knt=16 ; 
% max number of contrasts
 maxprm.knt2=16 ; 
% max number of ROI
 maxprm.knr=16 ; 
% max number of areas for each ROI
 maxprm.kna=16 ; 

% % half field of view in mm
%  maxprm.kfield=120 ; 
% size of each voxel in mm
 maxprm.voxs=1; %was .25
% inverse of vox size
 maxprm.voxf=1../maxprm.voxs ; 
 
 %% Don't change
maxprm.kres=240; % size of map in point
prm.mapdir = 1; %1 is coronol - this isn't changed anymore
prm.idirect = 2; %for line 232 of readloc and readloc_new
prm.nsrcs = 9999; % sources accross all montages %can I automate this
prm.ndets = 0; % detectors accross all montages %can I automate this

%% Set up some more stuff automatically (don't change)
% size of lookup table
maxprm.kre2=maxprm.kres/prm.istep; 
%ratio between lookup and map
maxprm.kresrat=maxprm.kre2/maxprm.kres;
maxprm.kres2=fix(maxprm.kres./2)+0.5 ; 
prm.slices = prm.istep:prm.istep:maxprm.kres;  %go by 2 (e.g. 2:2:192)
prm.nslice = length(prm.slices);
smooth_suffix = '';
if plot.smooth == 1
    smooth_suffix = '_S';
end
if prm.space == 1
    prm.space_ext = 'tol';
elseif prm.space == 2
    prm.space_ext = 'rol';
end
prm.optscale=sqrt(300.* prm.abscoef.*prm.scatcoef);
prm.denom = prm.epsihbo1.*prm.epsihb2-prm.epsihbo2.*prm.epsihb1;



