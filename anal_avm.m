
%% subtract two conditions for a subject  %need to build in different contrasts here
fprintf('Computing Contrast. \n');
for i_sub = 1:prm.nsubj
    data(i_sub).allmtg.contrast = squeeze(data(i_sub).allmtg.vox(:,:,anal.eccen));
end

%% Create subject data brik
fprintf('Creating Subject Data Brik. \n');
clear group
temp = zeros(maxprm.kre2,maxprm.kre2,maxprm.kre2,size(data(1).allmtg.vox,1),prm.nsubj);
for i_sub = 1:prm.nsubj
    for i_vox = 1:vox(i_sub).nvox
        temp(vox(i_sub).x(i_vox),vox(i_sub).y(i_vox),vox(i_sub).z(i_vox),:,i_sub) = data(i_sub).allmtg.contrast(:,i_vox);
    end
end
%% Create grand average and compute stats

if prm.nsubj == 1
    temp(temp == 0) = NaN;  %good spot to remove high sd channels
    group.mean = temp - repmat(nanmean(temp(:,:,:,anal.baseline,:),4),[1 1 1 size(data(1).allmtg.vox,1) 1]); %subtract the baseline average
    clear temp

else
    temp(temp == 0) = NaN;  %good spot to remove high sd channels
    temp = temp - repmat(nanmean(temp(:,:,:,anal.baseline,:),4),[1 1 1 size(data(1).allmtg.vox,1) 1]); %subtract the baseline average
    fprintf('Computing Group Average. \n');
    group.mean = nanmean(temp,5); %grand average
    
    if anal.smooth > 0
        fprintf('Applying Spatial Smoothing. \n');
        for i_time = 1:size(group.mean,4)
            group.mean(:,:,:,i_time) = smooth3(group.mean(:,:,:,i_time),'gaussian',round(((20/prm.istep)+1)/2)*2-1,anal.smooth/prm.istep); %20 mm kernel as per opt3d (Gabriele April 2014)- user defined SD  (opt3d spatial filter parameter)
        end
    end
    fprintf('Computing Group Standard Deviation. \n');
    
    group.std = nanstd(temp,[],5); %std over subjects
    
    if anal.pool == 1 %pooled (1) or unpooled (0) standard deviation
        fprintf('Pooling Standard Deviation over time. \n');
        group.std = repmat(mean(group.std,4),[1 1 1 size(group.std,4)]); %pool std over time
    end
    fprintf('Computing Number of Subjects. \n');
    group.nsub = sum(~isnan(temp),5); %nsub for each voxel
    clear temp
    
    group.mean(group.nsub < 4) = 0; %remove voxels with less than 4 subjects    %zero out if assumptions of t-test not met
    group.std(group.nsub < 4) = 0;
    fprintf('Computing T-test. \n');
    group.ttest = group.mean./group.std; %should pool the std over time
    fprintf('Computing Z-transform. \n');
    group.ztransform = sqrt(group.nsub.*   log(  1+ (group.ttest.^2)./group.nsub)  ).*sqrt(1-(1./(2.*group.nsub))); %Kathy's formula that is in opt3d 2013
    group.tsign = sign(group.mean); %since you loose the sign of the effect in the t-stat
    
    group.mean(isnan(group.mean)) = 0;
    group.ttest(isnan(group.ttest)) = 0; %make NaN's zeros for plotting
    group.ztransform(isnan(group.ztransform)) = 0;
    
end