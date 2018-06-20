%% look_slice.m - This subroutine produces a lookup table for a slice
%  Dr. Kyle Mathewson - June 8, 2013 - Translation of Gabriele Gratton's opt3d_fast_v2.f90
% The lookup table indicate if the data point is within the trajectory for a particular channel.
% If yes, the logical variable LOOKUPT of index (ichan) is set to truemlv.  Otherwise, is set to falsemlv.
% The trajectory is described as a series of 9 spheres of variable radius whose centers are equally spaced
% along a semicircle between the source and the detector (the source and detector points are excluded).

function look_slice
global maxprm prm loc look %voxf maxprm.voxs x ;

%% for each subject and point
for isubj=1:prm.nsubj
    fprintf(['Subject ' num2str(isubj) '. \n']);
    look.idw_chan_per_vox(1:2,1:maxprm.kncx,maxprm.kre2,maxprm.kre2,isubj) = 0;
    look.n_chan_per_vox(maxprm.kre2,maxprm.kre2,isubj) = 0;
    for j=prm.istep:prm.istep:maxprm.kres
        %         fprintf(['Step ' num2str(j) '. \n']);
        for k=prm.istep:prm.istep:maxprm.kres
            %% determine x, y, and z coordinates
            switch prm.mapdir
                case 1 % coronal
                    x = [prm.islice k j];
                case 2 % sagittal
                    x = [k prm.islice j];
                case 3 % axial
                    x = [k j prm.islice];
            end
            
            %  Recent the data so coordinates are positive
            % this is the confusing part of the code, this is for the .rol data (ROP< OPA) 
            if prm.space == 2 %rol
                x = .1.*maxprm.voxs.*(x-maxprm.kres2-7); %7 
            elseif prm.space ==1 %tol
                x = .1.*maxprm.voxs.*(x-maxprm.kres2);  
            end
           
            %% set up look-up table
            setuplookup(isubj,x);
            %% encode it in lookup tables
            in_lookup(j,k,isubj);
        end
        %% update progress bar
        frac2 = (j/prm.istep) / (maxprm.kres/prm.istep);
        frac1 = ((isubj-1) + frac2) / prm.nsubj;
        progressbar([],frac1,frac2,[]);
    end
end
fprintf('Completed setting up look up table. \n')
