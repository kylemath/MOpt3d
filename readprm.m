%% readprm.m -  this subroutine reads the basic parameters
% Dr. Kyle Mathewson - June 8, 2013 - Translation of Gabriele Gratton's opt3d_fast_v2.f90

function readprm(fname_prm)  
    global prm;

    
    fid_prm = fopen(fname_prm);
    
    prm.fname_prm = fname_prm;
    prm.nsubj2=fscanf(fid_prm,'%g',1);
    prm.nses=fscanf(fid_prm,'%g',1);
    prm.ncond=fscanf(fid_prm,'%g',1);
    prm.nchans=fscanf(fid_prm,'%g',1);
    prm.npts=fscanf(fid_prm,'%g',1);
    prm.dt=fscanf(fid_prm,'%g',1);
    prm.datatype=fscanf(fid_prm,'%g',1);
    prm.icond= fscanf(fid_prm,'%g',1);
    prm.ncont= fscanf(fid_prm,'%g',1);
    prm.mapdir= fscanf(fid_prm,'%g',1);
    prm.islice= fscanf(fid_prm,'%g',1);
    prm.nch(1)= fscanf(fid_prm,'%g',1);
    
    prm.irange=fscanf(fid_prm,'%g',1);
    prm.jroi=fscanf(fid_prm,'%g',1);
    prm.ilp1=fscanf(fid_prm,'%g',1);
    prm.ilp0=fscanf(fid_prm,'%g',1);
    prm.iflen=fscanf(fid_prm,'%g',1);
    prm.idetr=fscanf(fid_prm,'%g',1);
    prm.idbeg=fscanf(fid_prm,'%g',1);
    prm.idend=fscanf(fid_prm,'%g',1);
    prm.ibeg=fscanf(fid_prm,'%g',1);
    prm.iend=fscanf(fid_prm,'%g',1);
    prm.intvalbeg=fscanf(fid_prm,'%g',1);
    prm.intvalend=fscanf(fid_prm,'%g',1);
    prm.idirect=fscanf(fid_prm,'%g',1);
    prm.idata=fscanf(fid_prm,'%g',1);
    
    prm.srate2=fscanf(fid_prm,'%g',1);
    prm.stimon=fscanf(fid_prm,'%g',1);
    prm.begbase=fscanf(fid_prm,'%g',1);
    prm.endbase=fscanf(fid_prm,'%g',1);
    prm.errcrit=fscanf(fid_prm,'%g',1);
    prm.abscoef=fscanf(fid_prm,'%g',1);
    prm.scatcoef=fscanf(fid_prm,'%g',1);
    prm.optscale=sqrt(300.* prm.abscoef.*prm.scatcoef);

    prm.resol=fscanf(fid_prm,'%g',1);
    
    prm.ierrterm=fscanf(fid_prm,'%g',1);
    prm.kwave=fscanf(fid_prm,'%g',1);
    prm.dstcrit=fscanf(fid_prm,'%g',1);
    prm.ipol=fscanf(fid_prm,'%g',1);
    prm.errcrit0=fscanf(fid_prm,'%g',1);
    prm.normalize=fscanf(fid_prm,'%g',1);
    prm.iavgsub=fscanf(fid_prm,'%g',1);
    prm.dstcrit2=fscanf(fid_prm,'%g',1);
    prm.spatfilt=fscanf(fid_prm,'%g',1);
    prm.izrange=fscanf(fid_prm,'%g',1);
    prm.modeltype=fscanf(fid_prm,'%g',1);
    prm.idcoord=fscanf(fid_prm,'%g',1);
    prm.nptsdf=fscanf(fid_prm,'%g',1);
    prm.firstpoint=fscanf(fid_prm,'%g',1);
    prm.decfactor=fscanf(fid_prm,'%g',1);
    
    dum = fclose(fid_prm);
    
    
    %defaults
    
    %defaults
    prm.ialignflag=0;
    prm.look_flag=2;
    prm.mapdir2=0;
    
end
