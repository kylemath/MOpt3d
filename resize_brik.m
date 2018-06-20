function [out_brik] = resize_brik(in_brik,inres,outres)

global maxprm

[sx,sy,sz] = size(in_brik);

% Resize brain back to large
x = inres:inres:maxprm.kres;
y = inres:inres:maxprm.kres;
z = inres:inres:maxprm.kres;
xI = outres:outres:maxprm.kres;
yI = outres:outres:maxprm.kres;
zI = outres:outres:maxprm.kres;
[X,Y,Z] = meshgrid(x,y,z);
[XI,YI,ZI] = meshgrid(xI,yI,zI);
out_brik = interp3(X,Y,Z,in_brik,XI,YI,ZI);
