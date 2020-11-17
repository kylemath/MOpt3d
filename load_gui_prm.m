%% load_gui_prm.m load the input settings from the gui into rest of code
% Dr. Kyle Mathewson - Nov 16, 2020

function load_gui_prm(app)

global prm now anal plot
prm.nsubj = app.nsubj; 
now.exp = app.exp;
now.sub = app.sub;
now.date = app.date;
now.path = app.path;
prm.istep = app.istep;
prm.space = app.space;
prm.data_type = app.data_type;
now.data_fol = app.data_fol;
now.mtg_suf = app.mtg_suf;
now.tol_suf = app.tol_suf;
anal.compute_blocks = app.compute_blocks;
anal.freq_spin = str2num(app.freq_spin); %since it is a fraction
anal.freq_flash = app.freq_flash;
anal.wave_num = app.wave_num;
anal.slow_or_fast = app.slow_or_fast;
anal.baseline = app.baseline;
anal.times = app.times;
anal.stat = app.stat;
anal.pool = app.pool;
anal.smooth = app.smooth;
anal.n_cond = app.n_cond;
anal.eccen = app.eccen;
anal.saveanal = app.saveanal;
prm.nses = app.nses;
prm.modeltype = app.modeltype;
prm.idata = app.idata;
prm.kwave = app.kwave;
prm.dstcrit = app.dstcrit;
prm.dstcrit2 = app.dstcrit2;
prm.abscoef = app.abscoef;
prm.scatcoef = app.scatcoef;
prm.resol = app.resol;
prm.errcrit = app.errcrit;
prm.epsihbo2= app.epsihbo2;
prm.epsihbo1= app.epsihbo1;
prm.epsihb2= app.epsihb2;
prm.epsihb1= app.epsihb1;
prm.dpf = [app.dpf1 app.dpf2]; %had to enter separately
plot.smooth = app.plot_smooth;
plot.banan = app.banan;
plot.scalp = app.scalp;
plot.brain = app.brain;
plot.isect = app.isect;
plot.sourcedet = app.sourcedet;
plot.savemean = app.savemean;
plot.meansum = app.meansum;
plot.brainres = app.brainres;
plot.outres = app.outres;

