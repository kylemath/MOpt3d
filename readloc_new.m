%% readloc.m - Read the .loc file that is read by opt3d, and create the bananas
%  Dr. Kyle Mathewson - Translation of Gabriele Gratton's opt3d_fast_v2.f90
%  This subroutine gets the information about the locations of the sources and detectors for each subject, and determine the 3-D
%  locations associated with each channel.  The 3-D locations are determined as a series of equidistant points along a semicircular
%  arch between the source and the detector.
%  In the present implementation, the locations can be expressed in Talairach coordinates.
%  Each source or detector location is identified by a label.
%  This routine uses a file (suggested extension: .loc) in which the following info needs to be provided:
%        first row:                   name of a VMI file where an anatomical image is stored
%        second row:                  name of a TAI file where eight reference points are stored (see Talairach routine)
%        third row:           number of sources and number of detectors
%  EDIT THIS
%        a row for each subject with: (a) a value (+1 or -1) that will inidcate whether the left to right dimension needs to be inverted
%                                     (b) the extended name (including path) of the file where the montage is described
%                                     (c) the extended name (including path) of the .ELP file where the digitized location of each source
%                                         and detector are stored (this also includes the appropriate labels)
%                                     (d) the extended name (including path) of a file where the EMSE coordinates of the eight points
%                                         used for the Talairach transformation are stored
%  The montage file is a file made up of one row for each channel.
%  This row contains the labels for the source and detector locations, the wavelength, and the modulation frequency.

%% setup workspace and define function
function readloc_new
global prm maxprm loc coordinates now
% old cosines sines fname_mtg mrifile taifile mtglabel labels montage   detector dummy  fname1 fnametai infomsg curr_labels  prop sourcex surfcoord voxf voxs;

%% setup progress bar
plural = 's';
if prm.nsubj == 1
    plural = '';
end
progressbar(['Reading ' num2str(prm.nsubj) ' Subject''s Locations'], ...
            'Channel Locations');
        
%% setup head/banana shape models???
for i=0:9
    sines(i+1)=sin((i).*3.14159./10.);
    cosines(i+1)=0.5.*(1.-cos((i).*3.14159./10.));
end

%% set channel wavelength to its default value = 0
loc.iwave = zeros(maxprm.knc,maxprm.kns); %1 - short; 2 - long

%% load montage information for .loc file
% fid_loc = fopen(fname_loc,'r');
% [mrifile]=fgetl(fid_loc);
% [taifile]=fgetl(fid_loc);
nsources=prm.nsrcs;
ndets=prm.ndets;
% dum = fgetl(fid_loc);

%% load MRI data
%      loadmri(mrifile,taifile);

%% Read coordinates of each location for each subject
for i_sub=1:prm.nsubj %for each subject
    fprintf(['Sub ' num2str(i_sub) '. ']);

    % set default modulation frequency
    for j=1:maxprm.knc
        loc.xmf(j,i_sub)=1.;
    end
    
%     i_direct=fgetl(fid_loc);
%     fname_mtg=fgetl(fid_loc);  %edited 3/2014 to get rid of loc file
    fname_mtg = [now.path filesep now.exp filesep 'reg' filesep now.exp now.sub{i_sub} now.mtg_suf '.mtg'];
    fprintf(fname_mtg)
    % read montage file
    fid_mtg = fopen(fname_mtg,'r');
    mtglabel=fgetl(fid_mtg);

    %setup the number of channels???
    if prm.nchans<=96
        prm.nch(i_sub)=prm.nchans.*prm.nses;
    else
        for j=1:prm.nses
            prm.nchses(j,i_sub)=fscanf(fid_mtg,'%g',1);
        end
        prm.nch(i_sub)=0;
        for j=1:prm.nses;
            prm.nch(i_sub)=prm.nch(i_sub)+prm.nchses(j,i_sub);
        end
    end
    
    %actually read the file
    for j=1:prm.nch(i_sub)
        inch(1,j,i_sub)=fscanf(fid_mtg,'%g',1);
        inch(2,j,i_sub)=fscanf(fid_mtg,'%g',1);
        montage{1,j}=fscanf(fid_mtg,'%s',1);
        montage{2,j}=fscanf(fid_mtg,'%s',1);
        iwavexx=fscanf(fid_mtg,'%g',1);
        xmfxx=fscanf(fid_mtg,'%g',1);
        % fix these values for the rest of program
        if iwavexx==690
            loc.iwave(j,i_sub)=1;
        end
        if iwavexx==830
            loc.iwave(j,i_sub)=2;
        end
        loc.xmf(j,i_sub)=xmfxx./110.;
    end
    fclose(fid_mtg);
    
    %open .tol or .rol file for that subject
%     fname_tol=fgetl(fid_loc); %edited 3/2014 to get rid of loc file
    
    fname_tol = [now.path filesep now.exp filesep 'reg' filesep now.exp now.sub{i_sub} now.tol_suf '.' prm.space_ext];
    fid_tol = fopen(fname_tol,'r');
    ilocations=nsources+ndets;
    
    %fix if there are more than one source or detector accross montages
    %in a single locations
    temp_line ='xx';
    line_count = 0;
    while temp_line ~= -1
        temp_line = fgetl(fid_tol);
        line_count = line_count+1;
    end
    
    if line_count-1 < ilocations
        ilocations = line_count-1;
    end
    %fix if there are extra position besides the optodes
    if line_count-1 > ilocations
        ilocations = line_count-1;
    end
    
  
    fclose(fid_tol);
    
    fid_tol = fopen(fname_tol,'r');
    coordinates = zeros(3,ilocations);
    
    
    % if ELP data
%     if(intparm_30<=1)
%         for k=1:7
%             []=readf(fid_113,[repmat(' ',1,2)],0);
%         end; k=7+1;
%         idummy1=fscanf(fid_113,'%g',size(idummy1));
%         idummy2=fscanf(fid_113,'%g',size(idummy2));
%         for k=1:4;
%             []=readf(fid_113,[repmat(' ',1,2)],0);
%         end; k=4+1;
%         open(119,'location.txt',err=234);
%         %    do j=1,nsources+ndets
%         for j=1:idummy2;
%             for k=1:3;
%                 []=readf(fid_113,[repmat(' ',1,2)],0);
%             end; k=3+1;
%             [dummy,labels(j)]=readf(fid_113,['%s','%s'],2);
%             for k=(1):(3), for k=(1):(3), coordinates(k,j)=fscanf(fid_113,'%g',size(coordinates(k,j))); end; end;
%             writef(fid_119,['%s','%s' ' \n'],dummy,labels(j));
%             for k=(1):(3), writef(fid_119,['%0.15g \n'],coordinates(k,j)); end;
%             % transform coordinates in cm
%             for k=1:3;
%                 coordinates(k,j)=coordinates(k,j).*100.;
%                 if(k==2)
%                     coordinates(k,j)=-coordinates(k,j);
%                 end;
%             end; k=3+1;
%         end; j=idummy2+1;
%         fclose(fid_119);
        
        
%     else if prm.idirect >=2

            % if TOL data
            iline=0;
            for j=1:ilocations
                labels{j}=fscanf(fid_tol,'%s',1);
                coordinates(1,j)=str2double(fscanf(fid_tol,'%s',1));
                coordinates(2,j)=str2double(fscanf(fid_tol,'%s',1));
                coordinates(3,j)=str2double(fscanf(fid_tol,'%s',1));
                iline=iline+1;
                for k=1:3
                    % transform coordinates in cm
                    coordinates(k,j)=(coordinates(k,j).*0.1); %
                end
            end
            fclose(fid_tol);
            ilocations=iline;
%         end
    
    
    

%%  Subtract estimated ac if real space %KM 2013
    loc.AC(:,i_sub) = coordinates(:,end);
%         coordinates = coordinates - repmat(loc.AC,1,size(coordinates,2)); %took out for the new .rol files that already have ac removed (3/2014)
    
    %% determine source and detector locations
    for ichan=1:prm.nch(i_sub) %for each channel
        
        sourcex=0;
        detector=0;
        for k=1:ilocations %for each helmet location
            curr_labels=labels(k);
            if strcmp(deblank(montage(1,ichan)),deblank(curr_labels))
                sourcex=k;
            end
            if strcmp(deblank(montage(2,ichan)),deblank(curr_labels))
                detector=k;
            end
        end
          
        
%         if i_sub==1
            if sourcex==0||detector==0
                infomsg=sprintf(['%s','%3i'],' Source or detector not found for channel ',ichan);
                fprintf([infomsg '\n']);
                infomsg=sprintf(['%s','%s','%s'],' Source & Detector: ',montage{1,ichan},' ',montage{2,ichan});
                fprintf([infomsg '\n']);
                for k=1:ilocations
                    infomsg=sprintf(['%s','%s'],' Labels available: ',labels{k});
                    fprintf([infomsg '\n']);
                end
                return %need to make this stop the program from continueing %km - 10/20/2013
            end
%         end
        
        
        
        for k=1:3
            curr_coords(k,1,ichan)=coordinates(k,sourcex);
            curr_coords(k,2,ichan)=coordinates(k,detector);
        end
        
        % for each channel, determine the nine locations that are examined
        % first, determine center on surface
        for kk=1:10
            for k=1:3
                surfcoord(k,kk)=cosines(kk).*curr_coords(k,1,ichan)+(1.-cosines(kk)).*curr_coords(k,2,ichan);
                if prm.idirect<0 %i don't think we use this anymore KEM 3/2014
                    surfcoord(2,kk)=-surfcoord(2,kk);
                end
            end
        end
        
        % second, determine distance and maximum depth
        loc.dst(ichan,i_sub) = sqrt( sum( (curr_coords(:,1,ichan)-curr_coords(:,2,ichan)) .^2) );
        loc.sloc(1:3,ichan,i_sub) = curr_coords(:,1,ichan);
        loc.dloc(1:3,ichan,i_sub) = curr_coords(:,2,ichan);
        loc.sdst(ichan,i_sub) = sqrt( sum( curr_coords(:,1,ichan).^2));
        loc.ddst(ichan,i_sub) = sqrt( sum( curr_coords(:,2,ichan).^2));
        loc.adst(ichan,i_sub) = .5*(loc.sdst(ichan,i_sub)+loc.ddst(ichan,i_sub));

        % compute depth (as half of source detector distance)
        % or using a more accurate formula for homogenous media if depth less than approximately 2.5 cm
        scat2=prm.scatcoef;
        abs2=prm.abscoef;
        
        % the following lines changes the scat and abs coefficient depending on the the wavelength -- commented on 8/15/06
        scat2=prm.scatcoef.*2.;
        abs2=prm.abscoef.*2.;
        if loc.iwave(ichan,i_sub)==2
            scat2=scat2.*0.3;
            abs2=abs2.*0.2;
        end
        depth=0.5+0.5.*sqrt(loc.dst(ichan,i_sub)./sqrt(300.*scat2.*abs2));
        
        % the following lines makes the depth deeper for phase -- commented on 8/15/06
        if prm.idata==2||prm.idata==4||prm.idata==5
            depth=depth.*1.5;
        end
        
        % determine radius of head at central location
        radius=0.0;
        for k=1:3
            radius=radius+surfcoord(k,5+1).^2;
        end
        if radius<0.0001
            radius=0.0001;
        end
        radius=sqrt(radius);
        
        for kk=1:10 %for each sphere
            % rescale coordinates as a function of radius
            for k=1:3
                prop(k)=surfcoord(k,kk)./radius;
            end
            %rescale values as a function of the eccentricity
            for k=1:3
                loc.recd(k,kk,ichan,i_sub)=((radius-depth.*sines(kk))./radius).*prop(k);
            end
            %reproduce original coordinates
            for k=1:3
                loc.recd(k,kk,ichan,i_sub)=loc.recd(k,kk,ichan,i_sub).*radius;
            end
            rsltn=prm.resol;
            if loc.iwave(ichan,i_sub)==2
                rsltn=1.25.*prm.resol;  % makes the size of the spheres (rsltn) bigger for the long wavelength -- commented on 8/15/06

            end
            loc.recd(4,kk,ichan,i_sub)=rsltn.*(0.5+0.5.*sines(kk));
        end
        frac2 = ichan/prm.nch(i_sub);
        frac1 = ((i_sub-1)+frac2) / prm.nsubj;  
        progressbar(frac1,frac2);
        
    end %channel
end % subject
loc.recd(5,:,:,:) = zeros;
fprintf('Done.     \n');
