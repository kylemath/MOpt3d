%% plot_bananas.m - Plot a surface of the coverage and the slice map for each subject,
% write out a .nii brik of the banana coverage
global prm maxprm look loc now plot

%% setup figure 
figure;
set(gcf,'Renderer','OpenGL')
fsize = ceil(sqrt(prm.nsubj));
set(gcf,'Color',[1 1 1]);
set(gca,'xdir','reverse')
for i_sub = 1:prm.nsubj
    fprintf(['Drawing Subject ' num2str(i_sub) '. \n']);
    subplot(fsize,fsize,i_sub); 
    hold on;
    
    %% load anatomy
    load_anat2     
    
    %% load bananas
    img_banan = abs(look.coverage_slices(:,:,:,i_sub));
    move_banan
    img_banan = resize_brik(img_banan,prm.istep,plot.brainres);
    
    %% bananas
    if plot.banan    
        ba = patch(isosurface(abs(img_banan),.5));
        alpha(ba,.4);
        set(ba,'FaceColor',[.2 1 .2],'EdgeColor','none'); 
        isonormals(img_banan,ba);
    end
     
    %% scalp
    if plot.scalp
        if prm.space == 2
        sc = patch(isosurface(smooth3(img_scalp),.1));
        elseif prm.space == 1
            sc = patch(isosurface(img_scalp));
        end
        alpha(sc,.2);
%         isonormals(img_scalp,sc);  
        set(sc,'SpecularStrength',.01);   
        set(sc,'FaceColor',[1 .8 .8],'EdgeColor','none');
    end
    
%     %% brain    
%     if plot.brain 
%         br = patch(isosurface(img_brain));
%         alpha(br,.2);
%         set(br,'FaceColor',[.8 .8 1],'EdgeColor','none');
%         set(br,'SpecularStrength',.01);
%     end
%     
    %% intersect
    if plot.brain && plot.isect            
         [X,Y,Z] = meshgrid(1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres),1:round(maxprm.kres/plot.brainres));
        [faces,verts,colors] = isosurface(X,Y,Z,img_brain,.2,img_banan);
        babr = patch('Vertices',verts,'Faces',faces,'FaceVertexCData',colors,'FaceColor','interp','edgecolor','none');    
        alpha(babr,.8);
         temp = colormap;
        temp(1,:) = [1 .8 .8];
        colormap(temp)
        if prm.modeltype == 1%geometric
            set(gca,'CLim',[0 25]);
        elseif prm.modeltype >1 %physical
            set(gca,'CLim',[0 3000]);
        end
        isonormals(img_brain,babr);  
        set(babr,'SpecularStrength',.01);

    end

    %% plot sources and detectors % this is from look_slice.m (maxprm.kres2+7)
    if plot.sourcedet 
        if prm.space == 2
         scatter3(((loc.dloc(2,:,i_sub)*10+maxprm.kres2+7)/prm.istep)+y,((loc.dloc(1,:,i_sub)*10+maxprm.kres2+7)/prm.istep)+x, ((loc.dloc(3,:,i_sub)*10+maxprm.kres2+7)/prm.istep)+z,50,'fill');
         scatter3(((loc.sloc(2,:,i_sub)*10+maxprm.kres2+7)/prm.istep)+y,((loc.sloc(1,:,i_sub)*10+maxprm.kres2+7)/prm.istep)+x, ((loc.sloc(3,:,i_sub)*10+maxprm.kres2+7)/prm.istep)+z,50,'fill');
        elseif prm.space == 1
         scatter3(((loc.dloc(2,:,i_sub)*10+maxprm.kres2)/prm.istep)+y,((loc.dloc(1,:,i_sub)*10+maxprm.kres2)/prm.istep)+x, ((loc.dloc(3,:,i_sub)*10+maxprm.kres2)/prm.istep)+z,50,'fill');
         scatter3(((loc.sloc(2,:,i_sub)*10+maxprm.kres2)/prm.istep)+y,((loc.sloc(1,:,i_sub)*10+maxprm.kres2)/prm.istep)+x, ((loc.sloc(3,:,i_sub)*10+maxprm.kres2)/prm.istep)+z,50,'fill');
        end
    end  

    %% Setup plot
    view(180,0);
     lighting phong;
    daspect([1 1 1])
    set(gca,'xdir','reverse')
    view(90,0); axis image;
    camlight(180,-20,'infinite');
    camlight(180,10,'infinite');
    camlight(0,-80,'infinite');
    camlight(0,-90,'infinite');
    axis off;
    axis(gca,'vis3d');
    title(['S' now.sub{i_sub}]);
    view(90,0);

end
subplot(fsize,fsize,prm.nsubj);  axis off; cb = colorbar;
if prm.modeltype == 1 %geometric            
    set(gca,'CLim',[0 25]);
    if plot.meansum == 1
        set(get(cb,'ylabel'),'string','Mean Bananas Per Voxel')
    elseif plot.meansum == 2
        set(get(cb,'ylabel'),'string','Sum of Bananas Per Voxel')
    end
elseif prm.modeltype > 1 %2 physical or 3 inverse
    set(gca,'CLim',[0 3000]);
    set(get(cb,'ylabel'),'string','Sum of Absolute Voxel Weights')
end
suptitle([ upper(now.exp) ' - Individual Photon Density Maps']);
