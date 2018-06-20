global prm now maxprm plot

%create folder name
if length(num2str(str2num(now.sub{i_sub}))) == 3
    if length(now.sub{i_sub}) == 4
        tens_dig = now.sub{i_sub}(2);
    else
        tens_dig = now.sub{i_sub}(1);
    end
else
    tens_dig = now.sub{i_sub}(1:2);
end
    
%% Load Scalp
 if prm.space == 2 %if real space (rol)
     load([now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep 'oS' now.sub{i_sub} '_' now.date{i_sub} '_MPRAGE_R_scalp.mat']);
 elseif prm.space == 1 %if talairach (1; tol) or anything else
     load(['files' filesep 'T1_LPI_R_scalp.mat']);
 end
 scalp_points_n = ceil(scalp_points/prm.istep);
 scalp_n = zeros(maxprm.kres/plot.brainres,maxprm.kres/plot.brainres,maxprm.kres/plot.brainres);
 for i_point = 1:length(scalp_points_n);
     scalp_n(scalp_points_n(i_point,1),scalp_points_n(i_point,2),scalp_points_n(i_point,3)) = 1;
 end
 img_scalp = scalp_n;

%% load brain
smooth_suffix = '';
if plot.smooth == 1
    smooth_suffix = '_S';
end

if prm.space == 2 %real space .rol
    hdr2 = spm_vol([now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep 'c1oS' now.sub{i_sub} '_' now.date{i_sub} '_MPRAGE_R' smooth_suffix '.nii']);
elseif prm.space == 1 %talairach space
    hdr2 = spm_vol(['files' filesep 'c1colin_1mm.nii']);  
end
img_brain = spm_read_vols(hdr2);

% %% make same size as bananas
img_brain(end:maxprm.kres,:,:) = 0;
img_brain(:,end:maxprm.kres,:) = 0;
img_brain(:,:,end:maxprm.kres) = 0;

img_brain = resize_brik(img_brain,1,plot.brainres);

