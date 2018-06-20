global anal prm



% Plot some results
i_sub = 1;
step = 1;
slices = step:step:maxprm.kre2;
% slices = 20:step:38
% anal.analysis_type = 1

%% single slice
figure;
CLim = [-300 300];
for i_slice = slices
    subplot(ceil(sqrt(length(slices))),ceil(sqrt(length(slices))),((i_slice-slices(1))/step)+1);  
    
    gry = gray(64);
    gry = gry(end:-1:1,:);
%     gry(end,:) = [1 0 0];
    colormap([gry]);
 
    h = imagesc(squeeze(img_brain(:,:,i_slice)),CLim);     
    hold on;  
    b = imagesc(squeeze(img_banan(:,:,i_slice)),CLim);
   
    set(h,'AlphaData',squeeze(1-img_brain(:,:,i_slice)));
    set(b,'AlphaData',squeeze(img_banan(:,:,i_slice)));

    text(1,1,num2str(i_slice));  
    axis image
    axis off
end










% figure; 
% hold on;
% CLim = [0 10];
% for i_slice = slices
%     subplot(ceil(sqrt(length(slices))),ceil(sqrt(length(slices))),(i_slice-(slices(1)-step))/step);
% 
%     imagesc(img_brain(:,:,i_slice));
%     imagesc(img_banan(:,:,i_slice));
%     axis off;
%     text(2,2,num2str(i_slice));
% end

% 
% figure;
% hold on;
% colormap('HSV')
% CLim = [-pi pi];
% for i_slice = slices
%     subplot(ceil(sqrt(length(slices))),ceil(sqrt(length(slices))),(i_slice-(slices(1)-step))/step);
%     imagesc(group_avg(anal.analysis_type).fastphase(:,1:end/2,i_slice),CLim);
%     axis off;
% end
% figure;
% hold on;
% CLim = [0 10];
% for i_slice = slices
%     subplot(ceil(sqrt(length(slices))),ceil(sqrt(length(slices))),(i_slice-(slices(1)-step))/step);
%     imagesc(group_avg(anal.analysis_type).slowpower(:,1:end/2,i_slice,plot_sub)); 
%     axis off;
% end
% figure; 
% hold on;
% colormap('HSV')
% CLim = [-pi pi];
% for i_slice = slices
%     subplot(ceil(sqrt(length(slices))),ceil(sqrt(length(slices))),(i_slice-(slices(1)-step))/step);
%     imagesc(group_avg(anal.analysis_type).slowphase(:,1:end/2,i_slice,plot_sub),CLim);
%     axis off;
% end