% convert2vox.m - Convert the lookup tables to a list of good voxels
clear vox
%% Convert to good voxel list to save space
for i_sub = 1:prm.nsubj
    


%     %load brain
%     smooth_suffix = '';
%     if plot.smooth == 1
%         smooth_suffix = '_S';
%     end
%     hdr2 = spm_vol([now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep 'c1oS' now.sub{i_sub} '_' now.date{i_sub} '_MPRAGE_R' smooth_suffix '.nii']);
%     img_br = spm_read_vols(hdr2);
%     
%     %% make same size as bananas
%     img_br(end:maxprm.kres,:,:) = 0;
%     img_br(:,end:maxprm.kres,:) = 0;
%     img_br(:,:,end:maxprm.kres) = 0;
%     
%     %resize brain
%     [sx,sy,sz] = size(img_br);
%     xO = 1:sx;
%     yO = 1:sy;
%     zO = 1:sz;
%     xI = prm.istep:prm.istep:sx;
%     yI = prm.istep:prm.istep:sy;
%     zI = prm.istep:prm.istep:sz;
%     [X,Y,Z] = meshgrid(xO,yO,zO);
%     [XI,YI,ZI] = meshgrid(xI,yI,zI);
%     img_br = interp3(X,Y,Z,img_br,XI,YI,ZI);
%     
%     
%     %% move bananas if needed 
%     moves = round(((10*loc.AC(:,i_sub)) - maxprm.kres2 - 7)/prm.istep); %thanks to Jacky Scavuzzo for help with this line
%     x = -1*moves(1); %left+/right- 
%     y = -1*moves(2);  %foward+/backward-
%     z = -1*moves(3);   %up+/down1
%     
%     if x>0
%         xl = size(img_br,1);
%         img_br(x:xl+x-1,:,:) = img_br(1:end,:,:);
%         img_br(1:x-1,:,:) = 0;
%         img_br(xl+1:end,:,:) = [];
%     elseif x<0
%         img_br(1:abs(x),:,:) = [];
%     end
%     if y>0
%         yl = size(img_br,2);
%         img_br(:,y:yl+y-1,:) = img_br(:,1:end,:);
%         img_br(:,1:y-1,:) = 0;
%         img_br(:,yl+1:end,:) = [];
%     elseif y<0
%         img_br(:,1:abs(y),:) = [];
%     end
%     if z>0
%         zl = size(img_br,3);
%         img_br(:,:,z:zl+z-1) = img_br(:,:,1:end);
%         img_br(:,:,1:z-1) = 0;
%         img_br(:,:,zl+1:end) = [];
%     elseif z<0
%         img_br(:,:,1:abs(z)) = [];
%     end   
%     
%     img_br(end:round(maxprm.kres/prm.istep),:,:) = 0;
%     img_br(:,end:round(maxprm.kres/prm.istep),:) = 0;
%     img_br(:,:,end:round(maxprm.kres/prm.istep))  = 0;
%     
%     
%     %threshold the brain
%    br_img_t = (img_br > 0); 

    %find intersection areas
    vox(i_sub).idvox = find(look.coverage_slices(:,:,:,i_sub)>0  ); %& br_img_t
    vox(i_sub).nvox = length(vox(i_sub).idvox);
    [vox(i_sub).x,vox(i_sub).y,vox(i_sub).z] = ind2sub(size(look.coverage_slices(:,:,:,(i_sub))),find(look.coverage_slices(:,:,:,(i_sub))>0  )  ); %& br_img_t
    for i_vox = 1:vox(i_sub).nvox
        vox(i_sub).chans{i_vox} = look.log_chan_per_vox{vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),i_sub};
        vox(i_sub).weights{i_vox} = look.log_weight_per_vox{vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),i_sub};
    end
    fprintf(['There are ' num2str(vox(i_sub).nvox) ' voxels for Subject ' num2str(i_sub) '. \n']);
end
