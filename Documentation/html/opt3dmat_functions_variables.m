%% Opt3dmat Documentation
% Opt3dmat Documentation 
% Dr. Kyle Mathewson, Beckman Institute, University of Illinois
% After opt3d_fast_v2.f90 - by Dr. Gabriele Gratton


%%  <opt3dmat.html -opt3dmat.m>

%%  <prm_max.html -prm_max.m>
%         maxprm.(...)
%%  <readprm.html -readprm.m>
%         prm.(...)
 
%%  <readloc.html -readloc.m>
%         loc.(...)
%         loc.iwave (maxchan,maxsub)
%         loc.xmf (maxchan)
%         loc.dst (nchan,nsubj)
%         loc.recd (5,9+1,nchan,nsubj)
%                  (5: x,y,z,radius,flag)
%         loc.sloc (3,nchan)
%         loc.dloc (3,nchan)
%         loc.sdst (nchan)
%         loc.ddst (nchan)
%         loc.adst (nchan)
%%     <slices.html -slices.m> <look_slice.html -look_slice.m> <setuplookup.html -setuplook.m> <in_lookup.html -in_lookup.m>
%         look.(...) (217 976 128 Bytes per subject)
%         -look_slice.m
%             -setuplook.m 
%                 look.one_vox_chans (nchan) (lookupt)
%                 look.one_vox_weights (nchan) (xlookupt)
%                 look.rsd (nchan) (rsd) (recd(1:3,0)-recd(1:3,9)  vs. loc.dst)
%              -in_lookup.m
%                 look.idw_chan_per_vox (2,maxchan,96,96,nsubj) (lookupt3)
%                                        (2: chan, weight)
%                 look.n_chan_per_vox (96,96,nsubj) (lookupt4)
%         look.log_chan_per_vox {~chans,96,96,96,nsubj}
%         look.log_weight_per_vox {~chans,96,96,96,nsubj}
%         look.coverage_slices (96,96,96,nsubj)
%%     <plot_bananas.html -plot_bananas.m>
%%     <convert2vox.html -convert2vox.m>
%         vox.(...) (39 685 448 Bytes per subject)
%         vox.idvox (ngoodvox,nsubj) (look.coverage_slices > 0)
%         vox.nvox (nsubj)
%         vox.x (nvox,nsubj)
%         vox.y (nvox,nsubj)
%         vox.z (nvox,nsubj)
%         vox.chans {~chan,nvox,nsubj} (look.log_chan_per_vox(x,y,z))
%         vox.weights {~chan,nvox,nsubj} (look.log_weight_per_vox(x,y,z))
%%     -importppod.m
%         Data.(...) (375 901 392 Bytes per subject)
%         Data(nsubj).nblocks (1)
%         Data(nsubj,nblocks).PC.ac (bpoints, nchans)
%         Data(nsubj,nblocks).PC.aux.time (bpoints)
%         Data(nsubj,nblocks).PC.aux.dig (bpoints)
%%     -importavm.m
%         Data.(...) (19 281 840 Bytes per subject)
%         Data(nsubj).avg.mtg(nmtg).aac (tpoints, nchans, bins)
%         Data(nsubj).avg.mtg(nmtg).adc (tpoints, nchans, bins)
%         Data(nsubj).avg.all.aac (timepoints, nchans, bins)
%                 