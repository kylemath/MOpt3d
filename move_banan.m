global prm

%% move bananas if needed  %need to add talairach move here
if prm.space == 2 %rol real space
    moves = round(((10*loc.AC(:,i_sub)) - maxprm.kres2 - 7)/prm.istep); %thanks to Jacky Scavuzzo for help with this line
elseif prm.space == 1 %tol talairach
    moves = round([-25, 5, -36]/prm.istep);
end
x = moves(1); %left+/right-
y = moves(2);  %foward+/backward-
z = moves(3);   %up+/down1
if x>0
    xl = size(img_banan,1);
    img_banan(x:xl+x-1,:,:) = img_banan(1:end,:,:);
    img_banan(1:x-1,:,:) = 0;
    img_banan(xl+1:end,:,:) = [];
elseif x<0
    img_banan(1:abs(x),:,:) = [];
end
if y>0
    yl = size(img_banan,2);
    img_banan(:,y:yl+y-1,:) = img_banan(:,1:end,:);
    img_banan(:,1:y-1,:) = 0;
    img_banan(:,yl+1:end,:) = [];
elseif y<0
    img_banan(:,1:abs(y),:) = [];
end
if z>0
    zl = size(img_banan,3);
    img_banan(:,:,z:zl+z-1) = img_banan(:,:,1:end);
    img_banan(:,:,1:z-1) = 0;
    img_banan(:,:,zl+1:end) = [];
elseif z<0
    img_banan(:,:,1:abs(z)) = [];
end


%% make same size as bananas
img_banan(end:round(maxprm.kres/prm.istep),:,:) = 0;
img_banan(:,end:round(maxprm.kres/prm.istep),:) = 0;
img_banan(:,:,end:round(maxprm.kres/prm.istep))  = 0;
img_scalp(end:round(maxprm.kres/prm.istep),:,:) = 0;
img_scalp(:,end:round(maxprm.kres/prm.istep),:) = 0;
img_scalp(:,:,end:round(maxprm.kres/prm.istep)) = 0;
img_brain(end:round(maxprm.kres/prm.istep),:,:) = 0;
img_brain(:,end:round(maxprm.kres/prm.istep),:) = 0;
img_brain(:,:,end:round(maxprm.kres/prm.istep)) = 0;