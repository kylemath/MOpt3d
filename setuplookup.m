%% setuplookup.m -  this subroutine sets up a lookup table for an invididual subject and a particular point
%  Dr. Kyle Mathewson - June 8, 2013 - Translation of Gabriele Gratton's opt3d_fast_v2.f90
%  The lookup table indicate if the data point is within the trajectory for a particular channel.
%  If yes, the logical variable LOOKUPT of index (ichan) is set to TRUE.  Otherwise, is set to FALSE.
%  isubj=subject
%  x=coordinates of point in cm
%  the set of channels used are stored in the variable look.one_vox_chans


%% Setup workspace and reset lookups
function setuplookup(isubj,x)
global prm loc look
look.one_vox_chans(1:prm.nch(isubj))=false;
look.one_vox_weights(1:prm.nch(isubj)) = 0;

%% Make it faste by exiting if any of a series of boundary conditions realizes
% if  x(1)<-10.95 || (x(1)>7.95  && x(1)<=12.0)
%     return
% end
% if  x(2)<-10 || (x(2)>10 && x(2)<=12.0)
%     return
% end
% if x(3)<-10 || (x(3)>10 && x(3)<=12.0)
%     return
% end

%% Determine distance from origin of axes -- if it exceeds 11 cm, return (do not plot point)
radius = sqrt(sum(x.^2));
radius(~isreal(radius)) = 0; %remove negative
% % if radius>11; return; end

%% Compute channels within distance limits
good_chan = loc.dst(:,isubj) >= prm.dstcrit & loc.dst(:,isubj) < prm.dstcrit2; 

%% Geometric model
% This sections implements a simple elliptical model of the light path
% The trajectory is described as a series of 9 spheres of variable radius whose centers are equally spaced
% along a semicircle between the source and the detector (the source and detector points are excluded).
if prm.modeltype == 1   
    
    % Compute distance of each sphere centere to this voxel, for each channel in one big shot
    dist= sqrt((x(1)-loc.recd(1,:,:,isubj)).^2+(x(2)-loc.recd(2,:,:,isubj)).^2+(x(3)-loc.recd(3,:,:,isubj)).^2);
    dist(~isreal(dist)) = 0; %if any negative distances
    
    % Check if channel is closer to the sphere center than that spheres size All at once for at least one of the spheres
    max_dist_diff = squeeze(max(loc.recd(4,:,:,isubj)-dist));
   
    % Then set the first level lookuptable logical indicating which channels contribute to this voxel
    look.one_vox_chans = max_dist_diff>0 & good_chan; 

%% Physical Model
% This section of the program implements a more complex model of the effect of tissue transparency on the propagation of light through tissue.   
% simplified to work only for slices

elseif prm.modeltype == 2 
    
    % Compute average eccentricity for source and detectors
    %estimate depth from surface (using the average source-detector eccen.)
    z = loc.adst(:,isubj)'-radius;
    
    % Compute distance of point from source and detector
    d1 = sqrt(  (x(1)-loc.sloc(1,:,isubj)).^2 + (x(2)-loc.sloc(2,:,isubj)).^2 + (x(3)-loc.sloc(3,:,isubj)).^2  );
    d2 = sqrt(  (x(1)-loc.dloc(1,:,isubj)).^2 + (x(2)-loc.dloc(2,:,isubj)).^2 + (x(3)-loc.dloc(3,:,isubj)).^2  ); 
    dc = d1+d2;
    
    % Compute intensity fluency for this point
    a = (z.^2).*exp(-prm.optscale.*dc);
    b = d1.*d1.*d1.*d2.*d2.*d2;
    c = (prm.optscale.^2).*(d1+.01).*(d2+.01);
    p = c.*a./b;
    
%     % Ignore if depth outside range
    p(z<0.1 | z>5 ) = 0;
%     
%     % Ignore if distance outside range
    p(d1>8 | d2>8 | dc>12) = 0;    
    
    % If Phase data
    if prm.idata == 2 
        i = p>.000001;
        
        %compute scaling factor due to optical properties of head
        depth = 0.1+0.5.*sqrt(loc.dst(i,isubj)./prm.optscale);
        
        %compute semiperimenter of ellipse to determine average path length (unadjusted)
        semiper = sqrt(pi.^2.*0.5.*loc.dst(i,isubj).*abs(depth) + 4.*(0.5.*loc.dst(i,isubj)-depth).^2  );  
        
        %compute phase fluency
        if ~isempty(depth)
            p(i) = p(i).*(d1(i)+d2(i)-semiper');
        end
    end   
    
    %Save the channels names and weights if exceeding threshold
    i = abs(p)>.000001 & good_chan';
    look.one_vox_chans = i;
    look.one_vox_weights(i)=p(i); 
    
end
