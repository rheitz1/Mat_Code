%Scatter Plot Analyses

%================
% Average firing rate difference target in - distractor in for
% correct vs error trials
%
% NEURON
fire_corr_in = nanmean(allwf.neuron.in_correct(find(keeper.reg.neuron),250:350),2);
fire_corr_out = nanmean(allwf.neuron.out_correct(find(keeper.reg.neuron),250:350),2);
fire_err_in = nanmean(allwf.neuron.in_errors(find(keeper.reg.neuron),250:350),2);
fire_err_out = nanmean(allwf.neuron.out_errors(find(keeper.reg.neuron),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;
[r p] = corr(firediff_corr,firediff_err)
scatter(firediff_corr,firediff_err,'fillcolor','r','sizedata',50)
vline(0,'k')
hline(0,'k')


% LFP
fire_corr_in = nanmean(allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),650:750),2);
fire_corr_out = nanmean(allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),650:750),2);
fire_err_in = nanmean(allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),650:750),2);
fire_err_out = nanmean(allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;
[r p] = corr(firediff_corr,firediff_err)
scatter(firediff_corr,firediff_err,'fillcolor','^r','sizedata',75)
vline(0,'k')
hline(0,'k')

%OR
fire_corr_in = nanmean(allwf.OR.in_correct(find(keeper.reg.OR),650:750),2);
fire_corr_out = nanmean(allwf.OR.out_correct(find(keeper.reg.OR),650:750),2);
fire_err_in = nanmean(allwf.OR.in_errors(find(keeper.reg.OR),650:750),2);
fire_err_out = nanmean(allwf.OR.out_errors(find(keeper.reg.OR),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;
[r p] = corr(firediff_corr,firediff_err)
scatter(firediff_corr,firediff_err,'fillcolor','r','sizedata',50)
vline(0,'k')
hline(0,'k')

 
%==============
% Average firing rate difference target in - distractor in for correct
% trials vs RT

%Neuron
fire_corr_in = nanmean(allwf.neuron.in_correct(find(keeper.reg.neuron),250:350),2);
fire_corr_out = nanmean(allwf.neuron.out_correct(find(keeper.reg.neuron),250:350),2);
fire_err_in = nanmean(allwf.neuron.in_errors(find(keeper.reg.neuron),250:350),2);
fire_err_out = nanmean(allwf.neuron.out_errors(find(keeper.reg.neuron),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

RTs_corr = allRTs.neuron.correct(find(keeper.reg.neuron));

[r p] = corr(firediff_corr,RTs_corr)
scatter(firediff_corr,RTs_corr)
clear z

%LFP
fire_corr_in = nanmean(allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),650:750),2);
fire_corr_out = nanmean(allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),650:750),2);
fire_err_in = nanmean(allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),650:750),2);
fire_err_out = nanmean(allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

RTs_corr = allRTs.LFP.Hemi.correct(find(keeper.reg.LFP));

[r p] = corr(firediff_corr,RTs_corr)
scatter(firediff_corr,RTs_corr)
clear z


%OR
fire_corr_in = nanmean(allwf.OR.in_correct(find(keeper.reg.OR),650:750),2);
fire_corr_out = nanmean(allwf.OR.out_correct(find(keeper.reg.OR),650:750),2);
fire_err_in = nanmean(allwf.OR.in_errors(find(keeper.reg.OR),650:750),2);
fire_err_out = nanmean(allwf.OR.out_errors(find(keeper.reg.OR),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

RTs_corr = allRTs.OR.correct(find(keeper.reg.OR));

[r p] = corr(firediff_corr,RTs_corr)
scatter(firediff_corr,RTs_corr)
clear z


%=============
% TDT vs RT scatter plots and correlations (using all data) 
% CORRECT TRIALS

%Neuron
z(:,1) = allTDT.neuron.correct;
z(:,2) = allRTs.neuron.correct;

z = removeNaN(z);
[r p] = corr(z(:,1),z(:,2))

scatter(z(:,1),z(:,2))
clear z




%LFP
z(:,1) = allTDT.LFP.Hemi.correct;
z(:,2) = allRTs.LFP.Hemi.correct;
z = removeNaN(z);

%IF MONKEY S
% z(6:7,2) = NaN;
% z = removeNaN(z);

[r p] = corr(z(:,1),z(:,2))

scatter(z(:,1),z(:,2))
clear z



%OR
z(:,1) = allTDT.OR.correct;
z(:,2) = allRTs.OR.correct;
z = removeNaN(z);

%IF MONKEY S
% z(6:7,2) = NaN;
% z = removeNaN(z);

[r p] = corr(z(:,1),z(:,2))

scatter(z(:,1),z(:,2))
clear z




% ERROR TRIALS
%=============
% TDT vs RT scatter plots and correlations (using all data)
 
%Neuron
z(:,1) = allTDT.neuron.errors;
z(:,2) = allRTs.neuron.errors;
 
z = removeNaN(z);
[r p] = corr(z(:,1),z(:,2))
 
scatter(z(:,1),z(:,2))
clear z
 
 
 
 
%LFP
z(:,1) = allTDT.LFP.Hemi.errors;
z(:,2) = allRTs.LFP.Hemi.errors;
z = removeNaN(z);
 
%IF MONKEY S
z(3:4,2) = NaN;
z = removeNaN(z);
 
[r p] = corr(z(:,1),z(:,2))
 
scatter(z(:,1),z(:,2))
clear z
 
 
 
%OR
z(:,1) = allTDT.OR.errors;
z(:,2) = allRTs.OR.errors;
z = removeNaN(z);
 
%IF MONKEY S
% z(6:7,2) = NaN;
% z = removeNaN(z);
 
[r p] = corr(z(:,1),z(:,2))
 
scatter(z(:,1),z(:,2))
clear z




%===================================
% Firing rate / amplitude difference between target in & distractor in
% correlated with RT

%Neuron
fire_corr_in = nanmean(allwf.neuron.in_correct(find(keeper.reg.neuron),250:350),2);
fire_corr_out = nanmean(allwf.neuron.out_correct(find(keeper.reg.neuron),250:350),2);
fire_err_in = nanmean(allwf.neuron.in_errors(find(keeper.reg.neuron),250:350),2);
fire_err_out = nanmean(allwf.neuron.out_errors(find(keeper.reg.neuron),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;
RT = allRTs.neuron.correct(find(keeper.reg.neuron));
%IF MONKEY = S
% RT(3) = [];
% firediff_corr(3) = [];
% firediff_err(3) = [];

[r p] = corr(firediff_corr,RT)
scatter(firediff_corr,RT,'fillcolor','r')


%LFP
fire_corr_in = nanmean(allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),250:350),2);
fire_corr_out = nanmean(allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),250:350),2);
fire_err_in = nanmean(allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),250:350),2);
fire_err_out = nanmean(allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;
RT = allRTs.LFP.Hemi.correct(find(keeper.reg.LFP));
 
%IF MONKEY = S
% RT(3) = [];
% firediff_corr(3) = [];
% firediff_err(3) = [];

[r p] = corr(firediff_corr,RT)
scatter(firediff_corr,RT,'fillcolor','r')


%OR
fire_corr_in = nanmean(allwf.OR.in_correct(find(keeper.reg.OR),250:350),2);
fire_corr_out = nanmean(allwf.OR.out_correct(find(keeper.reg.OR),250:350),2);
fire_err_in = nanmean(allwf.OR.in_errors(find(keeper.reg.OR),250:350),2);
fire_err_out = nanmean(allwf.OR.out_errors(find(keeper.reg.OR),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;
RT = allRTs.OR.correct(find(keeper.reg.OR));
 
[r p] = corr(firediff_corr,RT)
scatter(firediff_corr,RT,'fillcolor','r')






%==========================================
% Trial history: correlations between delay in RT and delay in TDT

%Neuron
RTdiff_cc_ec = allRTs.neuron.c_c(find(keeper.history.neuron_e_e)) - allRTs.neuron.e_c(find(keeper.history.neuron_e_e));
TDTdiff_cc_ec = allTDT.neuron.correct_c_c(find(keeper.history.neuron_e_e)) - allTDT.neuron.correct_e_c(find(keeper.history.neuron_e_e));
 
z = [TDTdiff_cc_ec RTdiff_cc_ec];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
RTdiff_ec_ce = allRTs.neuron.e_c(find(keeper.history.neuron_e_e)) - allRTs.neuron.c_e(find(keeper.history.neuron_e_e));
TDTdiff_ec_ce = allTDT.neuron.correct_e_c(find(keeper.history.neuron_e_e)) - allTDT.neuron.correct_c_e(find(keeper.history.neuron_e_e));
 
z = [TDTdiff_ec_ce RTdiff_ec_ce];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
 
 
RTdiff_ce_ee = allRTs.neuron.c_e(find(keeper.history.neuron_e_e)) - allRTs.neuron.e_e(find(keeper.history.neuron_e_e));
TDTdiff_ce_ee = allTDT.neuron.correct_c_e(find(keeper.history.neuron_e_e)) - allTDT.neuron.correct_e_e(find(keeper.history.neuron_e_e));
 
z = [TDTdiff_ce_ee RTdiff_ce_ee];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
 
%LFP
RTdiff_cc_ec = allRTs.LFP.Hemi.c_c(find(keeper.history.LFP_e_e)) - allRTs.LFP.Hemi.e_c(find(keeper.history.LFP_e_e));
TDTdiff_cc_ec = allTDT.LFP.Hemi.correct_c_c(find(keeper.history.LFP_e_e)) - allTDT.LFP.Hemi.correct_e_c(find(keeper.history.LFP_e_e));
 
z = [TDTdiff_cc_ec RTdiff_cc_ec];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
RTdiff_ce_ee = allRTs.LFP.Hemi.c_e(find(keeper.history.LFP_e_e)) - allRTs.LFP.Hemi.e_e(find(keeper.history.LFP_e_e));
TDTdiff_ce_ee = allTDT.LFP.Hemi.correct_c_e(find(keeper.history.LFP_e_e)) - allTDT.LFP.Hemi.correct_e_e(find(keeper.history.LFP_e_e));
 
z = [TDTdiff_ce_ee RTdiff_ce_ee];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
 
 
 
 
 
%=============================================
% Trial history: correlations between delay in RT and average firing
% rate/voltage in window 150-250 ms (Target-in only)
 
fire_in_c_c = nanmean(allwf.neuron.in_c_c(find(keeper.history.neuron_e_e),250:350),2);
fire_in_e_c = nanmean(allwf.neuron.in_e_c(find(keeper.history.neuron_e_e),250:350),2);
fire_in_c_e = nanmean(allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),250:350),2);
fire_in_e_e = nanmean(allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),250:350),2);
 
RT_c_c = allRTs.neuron.c_c(find(keeper.history.neuron_e_e));
RT_e_c = allRTs.neuron.e_c(find(keeper.history.neuron_e_e));
RT_c_e = allRTs.neuron.c_e(find(keeper.history.neuron_e_e));
RT_e_e = allRTs.neuron.e_e(find(keeper.history.neuron_e_e));
 
z = [fire_in_c_c RT_c_c];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
 
 
 
%=============================================
% Trial history: correlations between delay in RT and average firing
% rate/voltage in window 150-250 ms (DIFFERENCE BETWEEN TIN AND DIN)
 
%Neuron
firediff_c_c = nanmean(allwf.neuron.in_c_c(find(keeper.history.neuron_e_e),250:350),2) - nanmean(allwf.neuron.out_c_c(find(keeper.history.neuron_e_e),250:350),2);
firediff_e_c = nanmean(allwf.neuron.in_e_c(find(keeper.history.neuron_e_e),250:350),2) - nanmean(allwf.neuron.out_e_c(find(keeper.history.neuron_e_e),250:350),2);
firediff_c_e = nanmean(allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),250:350),2) - nanmean(allwf.neuron.out_c_e(find(keeper.history.neuron_e_e),250:350),2);
firediff_e_e = nanmean(allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),250:350),2) - nanmean(allwf.neuron.out_e_e(find(keeper.history.neuron_e_e),250:350),2);
 
RT_c_c = allRTs.neuron.c_c(find(keeper.history.neuron_e_e));
RT_e_c = allRTs.neuron.e_c(find(keeper.history.neuron_e_e));
RT_c_e = allRTs.neuron.c_e(find(keeper.history.neuron_e_e));
RT_e_e = allRTs.neuron.e_e(find(keeper.history.neuron_e_e));
 
z = [firediff_c_c RT_c_c];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
z = [firediff_e_c RT_e_c];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
z = [firediff_c_e RT_c_e];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
z = [firediff_e_e RT_e_e];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
 
%LFP
firediff_c_c = nanmean(allwf.LFP.Hemi.in_c_c(find(keeper.history.LFP_e_e),650:750),2) - nanmean(allwf.LFP.Hemi.out_c_c(find(keeper.history.LFP_e_e),650:750),2);
firediff_e_c = nanmean(allwf.LFP.Hemi.in_e_c(find(keeper.history.LFP_e_e),650:750),2) - nanmean(allwf.LFP.Hemi.out_e_c(find(keeper.history.LFP_e_e),650:750),2);
firediff_c_e = nanmean(allwf.LFP.Hemi.in_c_e(find(keeper.history.LFP_e_e),650:750),2) - nanmean(allwf.LFP.Hemi.out_c_e(find(keeper.history.LFP_e_e),650:750),2);
firediff_e_e = nanmean(allwf.LFP.Hemi.in_e_e(find(keeper.history.LFP_e_e),650:750),2) - nanmean(allwf.LFP.Hemi.out_e_e(find(keeper.history.LFP_e_e),650:750),2);
 
RT_c_c = allRTs.LFP.Hemi.c_c(find(keeper.history.LFP_e_e));
RT_e_c = allRTs.LFP.Hemi.e_c(find(keeper.history.LFP_e_e));
RT_c_e = allRTs.LFP.Hemi.c_e(find(keeper.history.LFP_e_e));
RT_e_e = allRTs.LFP.Hemi.e_e(find(keeper.history.LFP_e_e));
 
z = [firediff_c_c RT_c_c];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
z = [firediff_e_c RT_e_c];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
z = [firediff_c_e RT_c_e];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))
 
 
z = [firediff_e_e RT_e_e];
z = removeNaN(z);
[a b] = corr(z(:,1),z(:,2))





%==================================
% correct vs errors RT difference correlated with TDT difference

%Neuron
RTdiff = allRTs.neuron.correct(find(keeper.reg.neuron)) - allRTs.neuron.errors(find(keeper.reg.neuron));
TDTdiff = allTDT.neuron.correct(find(keeper.reg.neuron)) - allTDT.neuron.errors(find(keeper.reg.neuron));

z = [TDTdiff RTdiff];
z = removeNaN(z);

%IF MONKEY == Q
z(18:19,1) = NaN;
z(6,1) = NaN;
z = removeNaN(z);

[a b] = corr(z(:,1),z(:,2))



%=======================================
%ttests for TDT timing (using only keepers)
%correct trials

%neuron vs LFP
[p h s] = ranksum(removeNaN(allTDT.neuron.correct(find(keeper.reg.neuron))),removeNaN(allTDT.LFP.Hemi.correct(find(keeper.reg.LFP))))

%LFP vs OR
[p h s] = ranksum(removeNaN(allTDT.LFP.Hemi.correct(find(keeper.reg.LFP))),removeNaN(allTDT.OR.correct(find(keeper.reg.OR))))





%=============================
%ttests for correct RT & TDT vs error RT & TDT (using keepers)

%neuron
RTcor = allRTs.neuron.correct(find(keeper.reg.neuron));
TDTcor = allTDT.neuron.correct(find(keeper.reg.neuron));

RTerr = allRTs.neuron.errors(find(keeper.reg.neuron));
TDTerr = allTDT.neuron.errors(find(keeper.reg.neuron));

z = [RTcor RTerr];
z = removeNaN(z);
[a b c d] = ttest(z(:,1),z(:,2))
clear z

z = [TDTcor TDTerr];
z = removeNaN(z);
[a b c d] = ttest(z(:,1),z(:,2))
clear z




%LFP
RTcor = allRTs.LFP.Hemi.correct(find(keeper.reg.LFP));
TDTcor = allTDT.LFP.Hemi.correct(find(keeper.reg.LFP));
 
RTerr = allRTs.LFP.Hemi.errors(find(keeper.reg.LFP));
TDTerr = allTDT.LFP.Hemi.errors(find(keeper.reg.LFP));
 
z = [RTcor RTerr];
z = removeNaN(z);
[a b c d] = ttest(z(:,1),z(:,2))
clear z
 
z = [TDTcor TDTerr];
z = removeNaN(z);
[a b c d] = ttest(z(:,1),z(:,2))
clear z

%OR
RTcor = allRTs.OR.correct(find(keeper.reg.OR));
TDTcor = allTDT.OR.correct(find(keeper.reg.OR));
 
RTerr = allRTs.OR.errors(find(keeper.reg.OR));
TDTerr = allTDT.OR.errors(find(keeper.reg.OR));
 
z = [RTcor RTerr];
z = removeNaN(z);
[a b c d] = ttest(z(:,1),z(:,2))
clear z
 
z = [TDTcor TDTerr];
z = removeNaN(z);
[a b c d] = ttest(z(:,1),z(:,2))
clear z







%=================================
% Trial History: comparison of target-in vs distractor-in activity and
% condition

%Neuron 

fire_in_c_c = nanmean(allwf.neuron.in_c_c(find(keeper.history.neuron_e_e),250:350),2);
fire_in_e_c = nanmean(allwf.neuron.in_e_c(find(keeper.history.neuron_e_e),250:350),2);
fire_in_c_e = nanmean(allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),250:350),2);
fire_in_e_e = nanmean(allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),250:300),2);
 
fire_out_c_c = nanmean(allwf.neuron.out_c_c(find(keeper.history.neuron_e_e),250:350),2);
fire_out_e_c = nanmean(allwf.neuron.out_e_c(find(keeper.history.neuron_e_e),250:350),2);
fire_out_c_e = nanmean(allwf.neuron.out_c_e(find(keeper.history.neuron_e_e),250:350),2);
fire_out_e_e = nanmean(allwf.neuron.out_e_e(find(keeper.history.neuron_e_e),250:350),2);
 
firediff_c_c = fire_in_c_c - fire_out_c_c;
firediff_e_c = fire_in_e_c - fire_out_e_c;
firediff_c_e = fire_in_c_e - fire_out_c_e;
firediff_e_e = fire_in_e_e - fire_out_e_e;
 
firerat_c_c = fire_in_c_c ./ fire_out_c_c;
firerat_e_c = fire_in_e_c ./ fire_out_e_c;
firerat_c_e = fire_in_c_e ./ fire_out_c_e;
firerat_e_e = fire_in_e_e ./ fire_out_e_e;

[a b c d] = ttest(firediff_c_c,firediff_e_c)
[a b c d] = ttest(firediff_e_c,firediff_c_e)
[a b c d] = ttest(firediff_c_e,firediff_e_e)
 
[a b c d] = ttest(firediff_c_c,firediff_c_e)
[a b c d] = ttest(firediff_c_c,firediff_e_e)
 
 
 
%========================================
% Trial History: comparison of target-in ONLY and condition
fire_in_c_c = nanmean(allwf.neuron.in_c_c(find(keeper.history.neuron_e_e),250:350),2);
fire_in_e_c = nanmean(allwf.neuron.in_e_c(find(keeper.history.neuron_e_e),250:350),2);
fire_in_c_e = nanmean(allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),250:350),2);
fire_in_e_e = nanmean(allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),250:350),2);
 
[a b c d] = ttest(fire_in_c_c,fire_in_e_c)
[a b c d] = ttest(fire_in_e_c,fire_in_c_e)
[a b c d] = ttest(fire_in_c_e,fire_in_e_e)
 
[a b c d] = ttest(fire_in_c_c,fire_in_e_c)
[a b c d] = ttest(fire_in_c_c,fire_in_c_e)
[a b c d] = ttest(fire_in_c_c,fire_in_e_e)
 
 
 
 
 
 
 
 
%========================================
% Trial History: comparison of target-in ONLY and condition
fire_in_c_c = nanmean(allwf.LFP.Hemi.in_c_c(find(keeper.history.LFP_e_e),250:300),2);
fire_in_e_c = nanmean(allwf.LFP.Hemi.in_e_c(find(keeper.history.LFP_e_e),250:300),2);
fire_in_c_e = nanmean(allwf.LFP.Hemi.in_c_e(find(keeper.history.LFP_e_e),250:300),2);
fire_in_e_e = nanmean(allwf.LFP.Hemi.in_e_e(find(keeper.history.LFP_e_e),250:300),2);
 
[a b c d] = ttest(fire_in_c_c,fire_in_e_c)
[a b c d] = ttest(fire_in_e_c,fire_in_c_e)
[a b c d] = ttest(fire_in_c_e,fire_in_e_e)
 
[a b c d] = ttest(fire_in_c_c,fire_in_e_c)
[a b c d] = ttest(fire_in_c_c,fire_in_c_e)
[a b c d] = ttest(fire_in_c_c,fire_in_e_e)














%============================
% ROC areas correlated to RTs
RT_cc = allRTs.neuron.c_c(find(keeper.history.neuron_e_e));
RT_ec = allRTs.neuron.e_c(find(keeper.history.neuron_e_e));
RT_ce = allRTs.neuron.c_e(find(keeper.history.neuron_e_e));
RT_ee = allRTs.neuron.e_e(find(keeper.history.neuron_e_e));

ROC_cc = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),250:400),2);
ROC_ec = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),250:400),2);
ROC_ce = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),250:400),2);
ROC_ee = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),250:400),2);


% IF MONKEY == S
RT_cc(3) = [];
RT_ce(3) = [];
RT_ee(3) = [];
ROC_cc(3) = [];
ROC_ce(3) = [];
ROC_ee(3) = [];

ROC_ee(18) = [];
RT_ee(18) = [];


% IF MONKEY == Q
% % % % % % % % % % % RT_cc(4) = [];
% % % % % % % % % % % ROC_cc(4) = [];

corr(RT_cc,ROC_cc)
corr(RT_ce,ROC_ce)
corr(RT_ee,ROC_ee)


RTdiff_cc_ce = RT_cc - RT_ce;
RTdiff_cc_ee = RT_ce - RT_ee;

ROCdiff_cc_ce = ROC_cc - ROC_ce;
ROCdiff_cc_ee = ROC_cc - ROC_ee;

scatter(RTdiff_cc_ce,ROCdiff_cc_ce)

