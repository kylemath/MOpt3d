
% %% ROP
% prm.nsubj = 1; %currently this is from the first how many to count in the .loc file, etc.
% now.exp = 'rop';
% now.sub = {'0503';'0533';'0757';'0789';'0790';'0803';'0808';'1501';'1502';'1503';'1504';'1505';'1506';'1507';'1508';'1509';'1510';'1511';'1512';'1513';'1515';'1516';'1519';'1520';'1521';'1522';'1523';'1524';'1525';'1526';'1527';'1528';'1529';'1530';'1531';'1532';'1534';'1536';'1537';}; %
% %missing mri - '1517';'1535';
% now.date = {'060813';'052013';'121013';'111413';'022514';'101413';'083013';'061013';'072413';'062713';'093013';'072213';'062713';'083013';'062613';'061713';'082613';'072913';'083013';'090913';'091413';'072913';'100713';'060813';'060813';'083013';'102113';'091413';'091413';'070213';'090913';'102113';'091413';'092313';'093013';'101413';'112613';'102513';'102113'}; %
% % now.date = {'123456'}; %tol

% %% EOP
% % prm.nsubj = 37; %currently this is from the first how many to count in the .loc file, etc.
% % now.exp = 'eop';
% % now.sub = {'0503';'0533';'0757';'0789';'0790';'0808';'1501';'1502';'1503';'1504';'1505';'1506';'1507';'1508';'1509';'1510';'1511';'1513';'1515';'1516';'1519';'1520';'1521';'1522';'1523';'1524';'1525';'1526';'1527';'1528';'1529';'1530';'1531';'1532';'1534';'1536';'1537';}; %
% % %missing mri - '1517';'1535'; 1512(EOP)'0803';
% % now.date = {'060813';'052013';'121013';'111413';'022514';'083013';'061013';'072413';'062713';'093013';'072213';'062713';'083013';'062613';'061713';'082613';'072913';'090913';'091413';'072913';'100713';'060813';'060813';'083013';'102113';'091413';'091413';'070213';'090913';'102113';'091413';'092313';'093013';'101413';'112613';'102513';'102113'}; %
% % % now.date = {'123456'}; %tol

% %% OPA
% % prm.nsubj = 38; %currently this is from the first how many to count in the .loc file, etc.
% % now.exp = 'opa';
% % now.sub = {'0503';'0533';'0757';'0789';'0790';'0803';'0808';'1501';'1502';'1503';'1504';'1505';'1506';'1507';'1508';'1509';'1510';'1511';'1512';'1513';'1515';'1516';'1519';'1520';'1521';'1522';'1523';'1524';'1525';'1526';'1527';'1528';'1529';'1530';'1531';'1532';'1534';'1536';}; %
% % % %missing mri - '1517';'1535'; '1537'; (OPA)
% % now.date = {'060813';'052013';'121013';'111413';'022514';'101413';'083013';'061013';'072413';'062713';'093013';'072213';'062713';'083013';'062613';'061713';'082613';'072913';'083013';'090913';'091413';'072913';'100713';'060813';'060813';'083013';'102113';'091413';'091413';'070213';'090913';'102113';'091413';'092313';'093013';'101413';'112613';'102513'}; %
% % % % now.date = {'123456'}; %tol

% %% Analysis Settings
% % now.path = ['E:' filesep 'data']; %  %data folder
% % now.path = ['\\128.174.211.151\data'];
% now.path = ['/Volumes/Lab_Files/Data/Backup_Illinois']
% prm.istep = 2.5; %resolution of voxels
% prm.space = 2; %talaraich (tol) = 1; real (rol) = 2; 
% prm.data_type = 1; %1 - ppod .001 unepoched; 2 - avm average files
% now.data_fol = 'pc00-00'; %folder that the .001 or .avm files are in
% now.mtg_suf = '_6col'; % abc1234xxxxx.mtg
% now.tol_suf = '_scalp_dig_fid'; % abc1234xxxxx.rol/tol

% %% Retinotopy analysis
% anal.compute_blocks = 3; %for loading data and analysis  %since blocks go 1234 PolarNPolarPEccenNEccenP
% anal.freq_spin = 1/48; % (wedge spin frequency Hz)
% anal.freq_flash = 5; % (Wedge alternation freq Hz)
% anal.wave_num = 12; %wavelength length of flash frequency for wavelets 
% anal.slow_or_fast = 2; %1 slow, 2 fast, 1:2 slow and fast %this is just for the plotting retiontopy now (combine with prm.idata)

% %% Traditional Analysis
% anal.baseline = 1:6; %inclusive (.avm file says 0 is point 7)
% anal.times = 10; %times to plot the result
% anal.stat = 1; %1-Means; 2-Std; 3-Nsub; 4-ttest; 5-z(tanal)
% anal.pool = 1; %pooled (1) or unpooled (0) standard deviation
% anal.smooth = 8; %0 - no smoothing, > 0 is smoothing gaussian SD in mm
% anal.n_cond = 4; %number of bins in .avm files %can get from the header
% anal.eccen = 2; %eccentricity
% anal.saveanal = 0; %1 save analysis, 0 don't save

% %% Load prm file
% prm.nses = 1; %opa = 8, %rop = 1, %emm = 4?, %milk = 1  %can I automate this?

% %% Additional settings
% prm.modeltype = 1; %1 - Geometric; 2 - Physical; 3 - Inverse
% prm.idata = 2; %type of data, 1 if dc, 2 if phase, 3 if ac 
% prm.kwave = 1; %Wavelength to use (1 = All; 2 = short; 3 = long; 4 = oxy; 5 = deoxy);
% prm.dstcrit = 2.00; %shortest distance channel to consider in cm
% prm.dstcrit2 = 6.0; %longest distance 
% prm.abscoef = .01;
% prm.scatcoef = 1; 
% prm.resol = .8; %path width (in cm);
% prm.errcrit = 160; %SD of phase - 160-200 normal %make option for short and long 
% prm.epsihbo2=0.956;%g Hbo830% absorption coeficients for Hb and HbO (from ISS 'extinc.txt')
% prm.epsihbo1=2.3153;%f Hbo690
% prm.epsihb2=4.9307;%e  Hb830
% prm.epsihb1=1.7914;%d Hb690
% prm.dpf = [6.51 5.86]; %Differential path length factor [690 830] per Duncan et al., 95
        
% %% plot settings for coverage/montage viewing
% plot.smooth = 0; %1 if want smoothing; 0 if full resolution brain for plotting %take this out now that we downsample brain to do this part
% plot.banan = 1; %bananas for subjects
% plot.scalp = 1; %plot scalp for subjects
% plot.brain = 1;  %plot brain for subjects
% plot.isect = 1;  %plot banana+brain intersection for each subject
% plot.sourcedet = 1; %plot sources and detectors for subjects
% plot.savemean = 0;  %save a mean bananas over subjects brik, 1 yes 0 no
% plot.meansum = 1; %1 = plot mean bananas over subjects; 2 = plot sum of bananas over subjects
% plot.brainres = 2.5; %resolution of plotting brain %need to add functionality
% plot.outres = .5; %for freesurfer .nii file
