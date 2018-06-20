%% Slices.m - Cycle through each slice and compute lookup table
% Calls look_slice - which calls setuplookup and in_lookup

%% setup the progress bar
slice_plural = 's';
sub_plural = 's';
if prm.nslice == 1;
    slice_plural = '';
end
if prm.nsubj == 1;
    sub_plural = '';
end

%% compute the bananas for the whole brain
progressbar(['Computing ' num2str(prm.nslice) ' Light Path Slice' slice_plural], ...
            [num2str(prm.nsubj) ' Subject' sub_plural], ... 
            [num2str(maxprm.kre2) ' Slice Columns'], ...
            'Writing Lookup Tables');


look.coverage_slices(maxprm.kre2,maxprm.kre2,maxprm.kre2,prm.nsubj) = 0;
look.log_chan_per_vox{maxprm.kre2,maxprm.kre2,maxprm.kre2,prm.nsubj} = [];
look.log_weight_per_vox{maxprm.kre2,maxprm.kre2,maxprm.kre2,prm.nsubj} = [];

for curr_slice = prm.slices
    fprintf(['Slice ' num2str(curr_slice) '. \n']);
    prm.islice = curr_slice;
    
    look_slice   
    
    if prm.modeltype == 1
        look.coverage_slices(curr_slice.*maxprm.kresrat,:,:,:) = look.n_chan_per_vox; %indicate which voxels are covered
    end 
    for y=1:maxprm.kre2
        for z=1:maxprm.kre2
            for s=1:prm.nsubj
                if prm.modeltype == 2
                    look.coverage_slices(curr_slice.*maxprm.kresrat,y,z,s) = sum(abs(look.idw_chan_per_vox(2,1:look.n_chan_per_vox(y,z,s),y,z,s))); %changed to abs 4/7/14
                end
                look.log_chan_per_vox{curr_slice.*maxprm.kresrat,y,z,s} = look.idw_chan_per_vox(1,1:look.n_chan_per_vox(y,z,s),y,z,s); %indicate for each voxel which chans are covered
                look.log_weight_per_vox{curr_slice.*maxprm.kresrat,y,z,s} = look.idw_chan_per_vox(2,1:look.n_chan_per_vox(y,z,s),y,z,s); %indicate weights of those chans
            end
        end
        
        %update progress bar
        frac_y = y/maxprm.kre2;
        frac = ((curr_slice - prm.slices(1)+2).*maxprm.kresrat)/prm.nslice;
        progressbar(frac,[],[],frac_y);
    end
    progressbar([],[],[],0); %reset lookup

end 
%% Transform
look.coverage_slices = permute(look.coverage_slices,[1 3 2 4]); %3124 for old .tol files %is this condition still the case KEM 3/2014
look.log_chan_per_vox = permute(look.log_chan_per_vox,[1 3 2 4]);
look.log_weight_per_vox = permute(look.log_weight_per_vox,[1 3 2 4]);

progressbar(1); %close
clear curr_slice y z