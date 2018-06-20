global prm now plot

%create folder name
if length(now.sub{i_sub}) == 3
    tens_dig = now.sub{i_sub}(1);
else
    tens_dig = now.sub{i_sub}(1:2);
end
    
ba_img_hr = resize_brik(img_banan_sum,prm.istep,plot.outres);

%% get an old .nii 4D file
% Resize brain back to large
% x = prm.istep:prm.istep:maxprm.kres;
% y = prm.istep:prm.istep:maxprm.kres;
% z = prm.istep:prm.istep:maxprm.kres;
% xI = plot.outres:plot.outres:maxprm.kres;
% yI = plot.outres:plot.outres:maxprm.kres;
% zI = plot.outres:plot.outres:maxprm.kres;
% [X,Y,Z] = meshgrid(x,y,z);
% [XI,YI,ZI] = meshgrid(xI,yI,zI);
% ba_img_hr = interp3(X,Y,Z,img_banan_sum,XI,YI,ZI);
% clear X Y Z XI YI ZI

orig_mri_hdr = spm_vol([now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep 'oS' now.sub{i_sub} '_' now.date{i_sub} '_mprage_R_FSL_HR.nii']);

% write a structural brik
nhdr = orig_mri_hdr;
ba_img_hr(nhdr.dim(1)+1:end,:,:) = [];
ba_img_hr(:,nhdr.dim(2)+1:end,:) = [];
ba_img_hr(:,:,nhdr.dim(3)+1:end) = [];

nhdr.descrip = [now.exp now.sub{i_sub} '_LightPath_Density_UHD_test'];
nhdr.fname = [now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep nhdr.descrip '.nii'];
spm_write_vol(nhdr,ba_img_hr);
