global prm anal group plot

%load scalp and brain

figure;
set(gcf,'Renderer','OpenGL')
set(gcf,'Color',[1 1 1]);  
fsize = ceil(sqrt(prm.nsubj));
for i_sub = 1:prm.nsubj
    
    %%load individual anatomy
    load_anat

    %% load Data  
    if anal.slow_fast == 1 %slow
        img_banan = round(group(anal.analysis_type).slowpower(:,:,:,i_sub)*100); %100 to increase resolution in freesurfer - need to work on this
    elseif anal.slow_fast == 2%fast
        img_banan = round(group(anal.analysis_type).fastpower(:,:,:,i_sub)*100);
    end

    move_banan %move bananas to brain
   
    %% cutout
%     img_brain(:,:,round((loc.AC(3,i_sub)*10)/prm.istep-((1/prm.istep)*20))) = 0;  %I-S
%     img_brain(:,round((loc.AC(2,i_sub)*10)/prm.istep),:) = 0; %P-A
%     img_brain(1:round((loc.AC(1,i_sub)*10)/prm.istep),:,:) = 0; %L-R
%     img_banan(:,:,round((loc.AC(3,i_sub)*10)/prm.istep-((1/prm.istep)*20))) = 300;  %I-S
%     img_banan(:,round((loc.AC(2,i_sub)*10)/prm.istep),:) = 300; %P-A
%     img_banan(round((loc.AC(1,i_sub)*10)/prm.istep),:,:) = 300; %L-R


    %% plot activation overlayed on brain
    subplot(fsize+1,fsize,i_sub);
    set(gca,'xdir','reverse')
 


    [X,Y,Z] = meshgrid(1:round(maxprm.kres/prm.istep),1:round(maxprm.kres/prm.istep),1:round(maxprm.kres/prm.istep));
    [faces,verts,colors] = isosurface(X,Y,Z,img_brain,.1,img_banan);
    covp = patch('Vertices',verts,'Faces',faces,'FaceVertexCData',colors,'FaceColor','interp','edgecolor','none');   
    isonormals(img_brain,verts);
    isonormals(img_brain,covp);
    
    lighting phong;  
    daspect([1 1 1])
    view(0,0);
    axis image;
    axis off;
    axis(gca,'vis3d');
    material dull
     camlight(0,90,'infinite');
    camlight(270,-25,'infinite');
    camlight(180,-40,'infinite');

    view(55,18);

    %for plotting power of activation (very similar to bananas maps but only show good channels)
    temp = colormap;
    temp(1,:) = [1 .8 .8];
    colormap(temp)
    set(gca,'CLim',[0 100]);

    %makes ciruclar colorbar
%     colormap([1 0 0;1 0.0625 0;1 0.125 0;1 0.1875 0;1 0.25 0;1 0.3125 0;1 0.375 0;1 0.4375 0;1 0.5 0;1 0.5625 0;1 0.625 0;1 0.6875 0;1 0.75 0;1 0.8125 0;1 0.875 0;1 0.9375 0;1 1 0;0.9375 1 0;0.875 1 0;0.8125 1 0;0.75 1 0;0.6875 1 0;0.625 1 0;0.5625 1 0;0.5 1 0;0.4375 1 0;0.375 1 0;0.3125 1 0;0.25 1 0;0.1875 1 0;0.125 1 0;0.0625 1 0;        1 .8 .8        ;0 0.9375 0.0625;0 0.875 0.125;0 0.8125 0.1875;0 0.75 0.25;0 0.6875 0.3125;0 0.625 0.375;0 0.5625 0.4375;0 0.5 0.5;0 0.4375 0.5625;0 0.375 0.625;0 0.3125 0.6875;0 0.25 0.75;0 0.1875 0.8125;0 0.125 0.875;0 0.0625 0.9375;0 0 1;0.0666666701436043 0 0.933333337306976;0.133333340287209 0 0.866666674613953;0.200000002980232 0 0.800000011920929;0.266666680574417 0 0.733333349227905;0.333333343267441 0 0.666666686534882;0.400000005960464 0 0.600000023841858;0.466666668653488 0 0.533333361148834;0.533333361148834 0 0.466666668653488;0.600000023841858 0 0.400000005960464;0.666666686534882 0 0.333333343267441;0.733333349227905 0 0.266666680574417;0.800000011920929 0 0.200000002980232;0.866666674613953 0 0.133333340287209;0.933333337306976 0 0.0666666701436043;1 0 0])
%     set(gca,'CLim',[-pi*100 pi*100]);
%     colorbar
    
    %% replace with write_freesurfer_nii
    if anal.saveanal

        % increase data resolution to match freesurfer HD
        x = prm.istep:prm.istep:maxprm.kres;
        y = prm.istep:prm.istep:maxprm.kres;
        z = prm.istep:prm.istep:maxprm.kres;
        xI = plot.outres:plot.outres:maxprm.kres;
        yI = plot.outres:plot.outres:maxprm.kres;
        zI = plot.outres:plot.outres:maxprm.kres;
        [X,Y,Z] = meshgrid(x,y,z);
        [XI,YI,ZI] = meshgrid(xI,yI,zI);
        ba_img_hr = interp3(X,Y,Z,img_banan,XI,YI,ZI);
        ba_img_hr = int16(ba_img_hr);
        clear X Y Z XI YI ZI 

        orig_mri_hdr = spm_vol([now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep 'oS' now.sub{i_sub} '_' now.date{i_sub} '_MPRAGE_R_FSL_HR.nii']);

        % write a structural brik
        nhdr = orig_mri_hdr;
        nhdr.dim = size(ba_img_hr);
        nhdr.descrip = [now.exp now.sub{i_sub} '_EccenFastImagLD'];
        nhdr.fname = [now.path filesep 'mri' filesep tens_dig '00-' tens_dig '99' filesep 'S' now.sub{i_sub} '_' now.date{i_sub} filesep nhdr.descrip '.nii'];
        spm_write_vol(nhdr,ba_img_hr);
    end

   

end %i_sub for plotting

%% plot legend
subplot(fsize+1,fsize,fsize*(fsize+1)); 

if anal.analysis_type == 1 || anal.analysis_type == 2 %polar
    wheel = Colour_Wheel('Polar',0,2,0); label = ['Polar - ' num2str(anal.analysis_type)];
elseif anal.analysis_type == 3 || anal.analysis_type == 4 %eccentric
    wheel = Colour_Wheel('Eccen',0,1,0); label = ['Eccen - ' num2str(anal.analysis_type)];
end
imshow(wheel);

if anal.slow_fast == 1 %slow
    title([label ' - Slow']);
elseif anal.slow_fast ==2 %fast
    title([label ' - Fast']);
end
