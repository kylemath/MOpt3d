clear data
mtg_letters = char(97:97+maxprm.kses); %abcdefgh
for i_sub = 1:prm.nsubj
    fprintf(['Subject Number: ' num2str(i_sub) '. \n'])

    for i_mtg = 1:prm.nses
        fprintf(['Montage: ' num2str(i_mtg) '. \n'])
        
        %need to change this to be more predicatable
        data(i_sub).mtg(i_mtg) = load([now.path filesep now.exp filesep 'pc01-12' filesep now.exp now.sub{i_sub} mtg_letters(i_mtg) '.avm'],'-mat');
    end
    
%     data(i_sub).allmtg.aph = [squeeze(data(i_sub).avg(1).aph), ...
%                                 squeeze(data(i_sub).avg(2).aph), ...
%                                 squeeze(data(i_sub).avg(3).aph), ...
%                                 squeeze(data(i_sub).avg(4).aph)  ];

    data(i_sub).allmtg.aph = data(i_sub).mtg(1).aph;
%     
    %% high sd phase channel removal needs to be added here

%     %%  Remove distant channels (and too close)
%     data(i_sub).allmtg.aph = data(i_sub).allmtg.aph(:,data(i_sub).allmtg.aph(1,:,1) ~= 0,:);
%     
    
    %% Create data brik,from .avm files
    data(i_sub).allmtg.vox = zeros(size(data(i_sub).allmtg.aph,1),vox(i_sub).nvox,anal.n_cond);
    for i_vox = 1:vox(i_sub).nvox
%         fprintf(['Voxel Number: ' num2str(i_vox) '. \n'])
        if prm.modeltype == 1
            data(i_sub).allmtg.vox(:,i_vox,:) = mean(   data(i_sub).allmtg.aph(:,vox(i_sub).chans{i_vox},:),2);
        elseif prm.modeltype == 2
            data(i_sub).allmtg.vox(:,i_vox,:) = mean(   data(i_sub).allmtg.aph(:,vox(i_sub).chans{i_vox},:).*repmat(vox(i_sub).weights{i_vox},[size(data(i_sub).allmtg.aph,1),1,anal.n_cond]),2);
        end
    end
end





