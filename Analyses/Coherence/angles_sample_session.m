%Plot angles for S sample session
cd /Volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL_inverted/overlap/SameElectrode/

load S091208001-RH_SEARCH_AD13DSP13a


figure
imagesc(tout,f,angle(Pcoh.in.all).')
axis xy
xlim([-200 500])
colorbar




allang.in.high.tneg200 = angle(Pcoh.in.all(find(tout == -200),find(f >= 35)));
allang.in.high.tneg100 = angle(Pcoh.in.all(find(tout == -100),find(f >= 35)));
allang.in.high.t0 = angle(Pcoh.in.all(find(tout == 0),find(f >= 35)));
allang.in.high.t100 = angle(Pcoh.in.all(find(tout == 100),find(f >= 35)));
allang.in.high.t200 = angle(Pcoh.in.all(find(tout == 200),find(f >= 35)));
allang.in.high.t300 = angle(Pcoh.in.all(find(tout == 300),find(f >= 35)));
allang.in.high.t400 = angle(Pcoh.in.all(find(tout == 400),find(f >= 35)));
allang.in.high.t500 = angle(Pcoh.in.all(find(tout == 500),find(f >= 35)));


allang.in.low.tneg200 = angle(Pcoh.in.all(find(tout == -200),find(f <= 25)));
allang.in.low.tneg100 = angle(Pcoh.in.all(find(tout == -100),find(f <= 25)));
allang.in.low.t0 = angle(Pcoh.in.all(find(tout == 0),find(f <= 25)));
allang.in.low.t100 = angle(Pcoh.in.all(find(tout == 100),find(f <= 25)));
allang.in.low.t200 = angle(Pcoh.in.all(find(tout == 200),find(f <= 25)));
allang.in.low.t300 = angle(Pcoh.in.all(find(tout == 300),find(f <= 25)));
allang.in.low.t400 = angle(Pcoh.in.all(find(tout == 400),find(f <= 25)));
allang.in.low.t500 = angle(Pcoh.in.all(find(tout == 500),find(f <= 25)));



%keep track of mean angles from -100:400 ms
startt = find(tout == -200);
endt = find(tout == 500);
timevec = startt:endt;

for t = 1:length(timevec)
    
    tempang.in.high_all = angle(Pcoh.in.all(timevec(t),find(f >= 35)));
    tempang.in.low_all = angle(Pcoh.in.all(timevec(t),find (f <= 25)));
    
    circstats.in.mean.high_all(1,t) = circ_mean(tempang.in.high_all);
    circstats.in.mean.low_all(1,t) = circ_mean(tempang.in.low_all);
    
    circstats.in.var.high_all(1,t) = circ_var(tempang.in.high_all);
    circstats.in.var.low_all(1,t) = circ_var(tempang.in.low_all);
    
    circstats.in.r.high_all(1,t) = circ_r(tempang.in.high_all);
    circstats.in.r.low_all(1,t) = circ_r(tempang.in.low_all);
    
    
    
    tempang.out.high_all = angle(Pcoh.out.all(timevec(t),find(f >= 35)));
    tempang.out.low_all = angle(Pcoh.out.all(timevec(t),find (f <= 25)));
    
    circstats.out.mean.high_all(1,t) = circ_mean(tempang.out.high_all);
    circstats.out.mean.low_all(1,t) = circ_mean(tempang.out.low_all);
    
    circstats.out.var.high_all(1,t) = circ_var(tempang.out.high_all);
    circstats.out.var.low_all(1,t) = circ_var(tempang.out.low_all);
    
    circstats.out.r.high_all(1,t) = circ_r(tempang.out.high_all);
    circstats.out.r.low_all(1,t) = circ_r(tempang.out.low_all);

%     
%     tempang.high_err = angle(Pcoh.in.err(timevec(t),find(f >= 35)));
%     tempang.low_err = angle(Pcoh.in.err(timevec(t),find (f <= 25)));
%     
%     
%     circstats.mean.high_err(1,t) = circ_mean(tempang.high_err);
%     circstats.mean.low_err(1,t) = circ_mean(tempang.low_err);
%     
%     circstats.var.high_err(1,t) = circ_var(tempang.high_err);
%     circstats.var.low_err(1,t) = circ_var(tempang.low_err);
%     
%     circstats.r.high_err(1,t) = circ_r(tempang.high_err);
%     circstats.r.low_err(1,t) = circ_r(tempang.low_err);
    
end


%plot variability over time
highvar.in_all = squeeze(circstats.in.var.high_all);
highvar.in_all = rad2deg(highvar.in_all);
highvar.in_all = sqrt(highvar.in_all);

lowvar.in_all = squeeze(circstats.in.var.low_all);
lowvar.in_all = rad2deg(lowvar.in_all);
lowvar.in_all = sqrt(lowvar.in_all);

highvar.out_all = squeeze(circstats.out.var.high_all);
highvar.out_all = rad2deg(highvar.out_all);
highvar.out_all = sqrt(highvar.out_all);
 
lowvar.out_all = squeeze(circstats.out.var.low_all);
lowvar.out_all = rad2deg(lowvar.out_all);
lowvar.out_all = sqrt(lowvar.out_all);

% 
% highvar_err = squeeze(circstats.var.high_err);
% highvar_err = rad2deg(highvar_err);
% highvar_err = sqrt(highvar_err);
% 
% lowvar_err = squeeze(circstats.var.low_err);
% lowvar_err = rad2deg(lowvar_err);
% lowvar_err = sqrt(lowvar_err);


figure

subplot(1,2,1)
plot(tout(timevec),highvar.in_all,'k',tout(timevec),highvar.out_all,'--k')
title('Gamma')
xlim([-200 500])

subplot(1,2,2)
plot(tout(timevec),lowvar.in_all,'k',tout(timevec),lowvar.out_all,'--k')
title('Low Freq')
xlim([-200 500])
%==========================================================


