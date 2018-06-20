%mean over subjects
global look maxprm prm plot

i_sub = 1;
load_anat2
%% sum and mean over all subjects
for i_sub = 1:prm.nsubj 
    img_banan = abs(look.coverage_slices(:,:,:,i_sub)); %mean over subjects
    move_banan %move to brain
    
    if i_sub == 1
        img_banan_sum = zeros(size(img_banan));
    end   
    img_banan_sum = img_banan_sum + img_banan; %add to banana sum
end
if plot.meansum == 1 %if mean
    img_banan_sum = img_banan_sum./prm.nsubj;
end
img_banan_sum = resize_brik(img_banan_sum,prm.istep,plot.brainres);

% save mean
if plot.savemean
    write_freesurfer_nii
end
% img_banan_sum(img_banan_sum == 0) = NaN;

%% draw image
figure;
hold on;
set(gcf,'Color',[1 1 1]);
set(gcf,'Renderer','OpenGL') 
set(gca,'xdir','reverse')

%brain
br = patch(isosurface(img_brain));
alpha(br,.2);
set(br,'FaceColor',[.8 .8 1],'EdgeColor','none');
set(br,'SpecularStrength',.01);

%% cutout
%     img_brain(:,:,24) = 0;  %I-S
%     img_brain(:,24,:) = 0; %P-A
%     img_brain(24,:,:) = 0; %L-R

%intersect
[X,Y,Z] = meshgrid(1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres));
[faces,verts,colors] = isosurface(X,Y,Z,img_brain,.1,img_banan_sum);
covp = patch('Vertices',verts,'Faces',faces,'FaceVertexCData',colors,'FaceColor','interp','edgecolor','none');
% p2 = patch(isocaps(img_mri,.1),'FaceColor','inter','EdgeColor','none');
alpha(covp,.9);
% isonormals(img_brain,verts);
% isonormals(img_brain,covp);

%settings
temp = colormap;
temp(1,:) = [1 .8 .8];
colormap(temp)
set(gca,'CLim',[0 max(img_banan_sum(:))]);
cb = colorbar;

if prm.modeltype == 1 %geometric
    if plot.meansum == 1
        set(get(cb,'ylabel'),'string','Mean Bananas Per Voxel')
    elseif plot.meansum == 2
        set(get(cb,'ylabel'),'string','Sum of Bananas Per Voxel')
    end
elseif prm.modeltype > 1 %2 physical or 3 inverse
    set(get(cb,'ylabel'),'string','Average Sum of Absolute Voxel Weights')
end

lighting phong;
daspect([1 1 1])
view(0,0);
axis image;
axis off;
axis(gca,'vis3d');
material dull
camlight(0,90,'infinite');
camlight(270,-25,'infinite');
camlight(180,-65,'infinite');
view(55,12)