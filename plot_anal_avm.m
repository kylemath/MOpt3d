%% Plot the results of the analysis
i_sub = 1;
load_anat2

%load correct data depending on analysis type
switch anal.stat %1-Means; 2-Std; 3-Nsub; 4-ttest; 5-z(tanal)
    case 1
        img_banan = squeeze(group.mean(:,:,:,anal.times));
        CLim = [-25 25];
        label = 'Means';
    case 2
        img_banan = squeeze(group.std(:,:,:,anal.times));
        CLim = [0 100];
        label = 'Standard Deviation';
    case 3 
        img_banan = squeeze(group.nsub(:,:,:,anal.times));
        CLim = [0 prm.nsubj];
        label = 'Number of Subjects';
    case 4 
        img_banan = squeeze(group.ttest(:,:,:,anal.times).*group.tsign(:,:,:,anal.times));
        CLim = [-1 1];
        label = 'T-Statistic';
    case 5
        img_banan = squeeze(group.ztransform(:,:,:,anal.times).*group.tsign(:,:,:,anal.times));
        CLim = [-1 1];
        label = 'Z-transformed T-stat';
end

move_banan
%     img_brain(:,:,(9*end)/32:end) = 0;  %I-S
%     img_brain(:,24,:) = 0; %P-A
%     img_brain(24,:,:) = 0; %L-R

img_banan = resize_brik(img_banan,prm.istep,plot.brainres);

%% plot the data
figure;
title([upper(now.exp) ' - ' num2str(prm.nsubj) ' Subjects - Eccentricity #' num2str(anal.eccen)])
set(gcf,'Renderer','OpenGL')
set(gcf,'Color',[1 1 1]);
set(gca,'xdir','reverse')
br = patch(isosurface(img_brain));
alpha(br,.2);
set(br,'FaceColor',[.9 .9 .9],'EdgeColor','none');
set(br,'SpecularStrength',.01);
[X,Y,Z] = meshgrid(1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres));
[faces,verts,colors] = isosurface(X,Y,Z,img_brain,.1,img_banan);
bs = patch('Vertices',verts,'Faces',faces,'FaceVertexCData',colors,'FaceColor','interp','edgecolor','none');
set(bs,'SpecularStrength',.01);
lighting phong
view(90,0);
axis image;
axis off;
axis(gca,'vis3d');
material dull
camlight(0,90,'infinite');
camlight(180,-25,'infinite');
camlight(0,-25,'infinite');

temp = colormap;
if anal.stat == 2 || anal.stat == 3 %subjects or std
    temp(1,:) = [1 .8 .8];
else
    temp(33,:) = [1 .8 .8];
end
colormap(temp)
set(gca,'CLim',CLim);
cb = colorbar;
set(get(cb,'ylabel'),'string',[label])
       














%% individual subjects 
%     figure;
% set(gcf,'Renderer','OpenGL')
% set(gcf,'Color',[1 1 1]);
% fsize = ceil(sqrt(prm.nsubj));
% 
% for i_sub = 1:prm.nsubj
%    
%     %% current data to plot (can make a function from here on)
%     img_banan = squeeze(group.combined(:,:,:,anal.times,i_sub));
% 
%     move_banan
%     img_banan = resize_brik(img_banan,prm.istep,plot.brainres);
%     load_anat2
% 
%     %% plot the data
%     subplot(fsize,fsize,i_sub);
%     set(gca,'xdir','reverse')
%       br = patch(isosurface(img_brain));
%         alpha(br,1);
%         set(br,'FaceColor',[.8 .8 .8],'EdgeColor','none');
%         set(br,'SpecularStrength',.01);
%         
%         [X,Y,Z] = meshgrid(1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres));
%         [faces,verts,colors] = isosurface(X,Y,Z,img_brain,.1,img_banan);
%         br = patch('Vertices',verts,'Faces',faces,'FaceVertexCData',colors,'FaceColor','interp','edgecolor','none');
%             alpha(br,1);
%             set(br,'SpecularStrength',.01);
%             lighting phong
%             view(90,0);
%             axis image;
%             axis off;
%             axis(gca,'vis3d');
%             material dull
%             camlight(0,90,'infinite');
%             camlight(180,-25,'infinite');
%             camlight(0,-25,'infinite');
%             temp = colormap;
%             temp(33,:) = [1 .8 .8];
%             colormap(temp)
%             set(gca,'CLim',[-50 50]);
%             view(90,0);
%     
% end



 %% plot some stats
% 
% figure;
% subplot(2,3,1);
%     hist(group.mean(group.mean~=0),1000);
%     xlabel('Mean (Picoseconds)')
%     ylabel('Number of Voxels')
% subplot(2,3,2);
%     hist(group.std(group.std~=0),1000);
%     xlabel('SD');
% subplot(2,3,3);
%     hist(group.nsub(group.nsub~=0),1000);
%     xlabel('Number of subjects');
% subplot(2,3,4);
%     hist(group.ttest(:),1000);
%     xlabel('T-stat');
%     ylabel('Number of Voxels')
% subplot(2,3,5);
%     hist(group.ztransform(:).*group.tsign(:),1000);
%     xlabel('Z-stat');
% 
% 


%% make a movie
% figure; 
% axis(gca,'vis3d');
% axis off;
% daspect([1 1 1])
% set(gcf,'Color',[0 0 0]);
% 
% 
% writerObj = VideoWriter('EMM_data_example2.avi');
% open(writerObj);
% frames = 0;
% for i_view = 360:-2:0 
% frames = frames +1;
% if frames > 64
%     frames = 1;
% end
% act = patch(isosurface(group.ztransform(:,:,:,frames),.4));
% set(act,'FaceColor',[1 0 0],'EdgeColor','none');
% set(act,'SpecularStrength',.1);
% camlight
% br = patch(isosurface(img_br,50));
% alpha(br,.4);
% set(br,'FaceColor',[1 1 1],'EdgeColor','none');
% set(br,'SpecularStrength',.01);
% 
%     view(i_view,10);
%     frame = getframe(gcf);
%     writeVideo(writerObj,frame);
% cla(gcf)
%  
% end
% close(writerObj);

      
