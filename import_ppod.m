%import_ppod - UI to import a ppod file
    % Dr. Kyle Mathewson - June 8, 2013
   
    
global prm anal
clear data 

for i_sub = 1:prm.nsubj
    %% get user to select pulse corrected data file
    PCPathName = [now.path filesep now.exp filesep 'pc00-00' filesep]; %change this so pc00-00 is an option in opt3d.m
    PCFileName = [now.exp now.sub{i_sub} 'a.001'];
    vox(i_sub).empty = zeros(1,vox(i_sub).nvox);
    
    for i_block = anal.compute_blocks
        fprintf('Importing data. '); 
        tic
        %% import the pulse corrected data from p_pod
        data(i_sub).PC(i_block) = load([PCPathName PCFileName(1:end-3)  sprintf('%03d',i_block)],'-mat');
        %find high std phase channels
        reject_chans = std(data(i_sub).PC(i_block).ph)> prm.errcrit;
        good_chans = ~reject_chans;       
        %subtract the mean from the ac %probably don't need anymore if Ed fixed KEM 3/2014
        data(i_sub).PC(i_block).ac = data(i_sub).PC(i_block).ac - repmat(mean(data(i_sub).PC(i_block).ac,1),length(data(i_sub).PC(i_block).aux.time),1);
        toc
        
 
    end
    
    for i_block = anal.compute_blocks
        
        fprintf('Converting to Hb and Hbo. '); tic
        for i_chan = 1:prm.nch
            %get data for one channel
            tempdata = data(i_sub).PC(i_block).ac(:,i_chan);
            % compute change in optical density
            tempdata = -1*abs(log(tempdata))./(.01 * loc.dst(i_chan)); %not sure what -1 is for, .01 is for units
            if loc.iwave(i_chan,i_sub) == 1 %if 690 nm
                %690 Differential path length factor 
                tempdata = tempdata/prm.dpf(1); 
                %690 final computation for conversion
                data(i_sub).PC(i_block).Hb(:,i_chan) = 1000.*(-tempdata.*prm.epsihbo1./prm.denom); %compute 690 Hb - Deoxyhemoglobin   %the negative is so you can just add them together after to combine
                data(i_sub).PC(i_block).HbO(:,i_chan) = 1000.*(tempdata.*prm.epsihb1./prm.denom); %compute 690 Hbo - Oxyhemoglobin  %yes this looks funny but it is supposed by be Hb = hbo KEM13        
            elseif loc.iwave(i_chan,i_sub) == 2 %if 830 nm
                % 830 Differential path length factor
                tempdata = tempdata/prm.dpf(2); 
                % 830 final computation for conversion
                data(i_sub).PC(i_block).Hb(:,i_chan) = 1000.*(tempdata.*prm.epsihbo2./prm.denom); %compute 830 Hb
                data(i_sub).PC(i_block).HbO(:,i_chan) = 1000.*(-tempdata.*prm.epsihb2./prm.denom); %compute 830 Hbo % %the negative is so you can just add them together after to combine mathcing 690 and 830 channels
            end  
            %return transformed ac data
            data(i_sub).PC(i_block).ac(:,i_chan) = tempdata*1000;  
        end
        toc
        
        
        %% Create data brik from .001 files, for each voxel average the channels data going in, for single data point
        data(i_sub).PC(i_block).HbOvox = zeros(length(data(i_sub).PC(i_block).aux.time),vox(i_sub).nvox);
        data(i_sub).PC(i_block).Hbvox = zeros(length(data(i_sub).PC(i_block).aux.time),vox(i_sub).nvox);
        data(i_sub).PC(i_block).phvox = zeros(length(data(i_sub).PC(i_block).aux.time),vox(i_sub).nvox);
        for i_vox = 1:vox(i_sub).nvox
            if mod(i_vox,1000) == 0
                fprintf(['Reconstructing voxel number ' num2str(i_vox) ' of ' num2str(vox(i_sub).nvox) ' total. \n'])
            end
            temp_chans = vox(i_sub).chans{i_vox};
            temp_chans = temp_chans(good_chans(temp_chans)); %!!!only take those that are good chans          
            if ~isempty(temp_chans) %if there are some channels left            
                if prm.modeltype == 1 %geometric model
                    data(i_sub).PC(i_block).HbOvox(:,i_vox) = mean(   data(i_sub).PC(i_block).HbO(:,temp_chans),2);
                    data(i_sub).PC(i_block).Hbvox(:,i_vox) = mean(   data(i_sub).PC(i_block).Hb(:,temp_chans),2);
                    data(i_sub).PC(i_block).phvox(:,i_vox) = mean(   data(i_sub).PC(i_block).ph(:,temp_chans),2);
                    
                elseif prm.modeltype == 2 %physical model %%%Fix to pick good chans only - already done for chans, need to do for weights
                    data(i_sub).PC(i_block).HbOvox(:,i_vox) = mean( data(i_sub).PC(i_block).HbO(:,temp_chans).*repmat(vox(i_sub).weights{i_vox},[length(data(i_sub).PC(i_block).aux.time),1]),2);
                    data(i_sub).PC(i_block).Hbvox(:,i_vox) = mean( data(i_sub).PC(i_block).Hb(:,temp_chans).*repmat(vox(i_sub).weights{i_vox},[length(data(i_sub).PC(i_block).aux.time),1]),2);
                    data(i_sub).PC(i_block).phvox(:,i_vox) = mean( data(i_sub).PC(i_block).ph(:,temp_chans).*repmat(vox(i_sub).weights{i_vox},[length(data(i_sub).PC(i_block).aux.time),1]),2);
                end
            else %no channels so leave blank
                vox(i_sub).empty(i_vox) = 1;
                data(i_sub).PC(i_block).phvox(:,i_vox) = zeros(1,length(data(i_sub).PC(i_block).aux.time));
            end        
        end          
    end

end





