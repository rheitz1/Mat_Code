%===============================================================
% Statistical tests on amplitude of all signals
% window from Woodman et al. = 110 - 170 for monkeys Q and P.  S's was
% later for left VF stimuli (right electrode) in same proportion as delay
% in RT to left VF stimuli.  Here, I will use window = 150 - 250, which
% seems to cover all the time periods where differences emerge. 

Spike_correct_in = allwf.neuron.in_correct(find(keeper.reg.neuron),:);
Spike_correct_out = allwf.neuron.out_correct(find(keeper.reg.neuron),:);
Spike_errors_in = allwf.neuron.in_errors(find(keeper.reg.neuron),:);
Spike_errors_out = allwf.neuron.out_errors(find(keeper.reg.neuron),:);

LFP_correct_in = allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),:);
LFP_correct_out = allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),:);
LFP_errors_in = allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),:);
LFP_errors_out = allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),:);


OR_correct_contra = allwf.OR.in_correct(find(keeper.reg.OR),:);
OR_correct_ipsi = allwf.OR.out_correct(find(keeper.reg.OR),:);
OR_errors_contra = allwf.OR.in_errors(find(keeper.reg.OR),:);
OR_errors_ipsi = allwf.OR.out_errors(find(keeper.reg.OR),:);


%get means in window 150 - 200
SPwindow = 250:350;
ADwindow = 650:750;


%use regular mean because we want the NaNs so we can take those session
%means out.  If we use removeNaN, then truncated analyses will be left with
%no trials.  This should have the effect we're looking for.
mSpike_correct_in = mean(Spike_correct_in(:,SPwindow),2);
mSpike_correct_out = mean(Spike_correct_out(:,SPwindow),2);
mSpike_errors_in = mean(Spike_errors_in(:,SPwindow),2);
mSpike_errors_out = mean(Spike_errors_out(:,SPwindow),2);
 
mLFP_correct_in = mean(LFP_correct_in(:,ADwindow),2);
mLFP_correct_out = mean(LFP_correct_out(:,ADwindow),2);
mLFP_errors_in = mean(LFP_errors_in(:,ADwindow),2);
mLFP_errors_out = mean(LFP_errors_out(:,ADwindow),2);
 
mOR_correct_contra = mean(OR_correct_contra(:,ADwindow),2);
mOR_correct_ipsi = mean(OR_correct_ipsi(:,ADwindow),2);
mOR_errors_contra = mean(OR_errors_contra(:,ADwindow),2);
mOR_errors_ipsi = mean(OR_errors_ipsi(:,ADwindow),2);

% [mSpike_correct_in mSpike_correct_out] = removeNaN(mSpike_correct_in,mSpike_correct_out);
% [mSpike_errors_in mSpike_errors_out] = removeNaN(mSpike_errors_in,mSpike_errors_out);
% [mLFP_correct_in mLFP_correct_out] = removeNaN(mLFP_correct_in,mLFP_correct_out);
% [mLFP_errors_in mLFP_errors_out] = removeNaN(mLFP_errors_in,mLFP_errors_out);
% [mOL_correct_contra mOL_correct_ipsi] = removeNaN(mOL_correct_contra,mOL_correct_ipsi);
% [mOL_errors_contra mOL_errors_ipsi] = removeNaN(mOL_errors_contra,mOL_errors_ipsi);
% [mOR_correct_contra mOR_correct_ipsi] = removeNaN(mOR_correct_contra,mOR_correct_ipsi);
% [mOR_errors_contra mOR_errors_ipsi] = removeNaN(mOR_errors_contra,mOR_errors_ipsi);
% 


%===============================================
% paired t-tests
[stats.spike_correct.h,stats.spike_correct.p,stats.spike_correct.ci,stats.spike_correct.t] = ttest(mSpike_correct_in,mSpike_correct_out);
[stats.spike_errors.h,stats.spike_errors.p,stats.spike_errors.ci,stats.spike_errors.t] = ttest(mSpike_errors_in,mSpike_errors_out);
[stats.LFP_correct.h,stats.LFP_correct.p,stats.LFP_correct.ci,stats.LFP_correct.t] = ttest(mLFP_correct_in,mLFP_correct_out);
[stats.LFP_errors.h,stats.LFP_errors.p,stats.LFP_errors.ci,stats.LFP_errors.t] = ttest(mLFP_errors_in,mLFP_errors_out);
[stats.OR_correct.h,stats.OR_correct.p,stats.OR_correct.ci,stats.OR_correct.t] = ttest(mOR_correct_contra,mOR_correct_ipsi);
[stats.OR_errors.h,stats.OR_errors.p,stats.OR_errors.ci,stats.OR_errors.t] = ttest(mOR_errors_contra,mOR_errors_ipsi);

%===============================================




%================================================
% wilcoxon signed-rank tests (~paired t-test)


% [stats.spike_correct.p,stats.spike_correct.h,stats.spike_correct.ci,stats.spike_correct.t] = signrank(mSpike_correct_in,mSpike_correct_out);
% [stats.spike_errors.p,stats.spike_errors.h,stats.spike_errors.ci,stats.spike_errors.t] = signrank(mSpike_errors_in,mSpike_errors_out);
% [stats.LFP_correct.p,stats.LFP_correct.h,stats.LFP_correct.ci,stats.LFP_correct.t] = signrank(mLFP_correct_in,mLFP_correct_out);
% [stats.LFP_errors.p,stats.LFP_errors.h,stats.LFP_errors.ci,stats.LFP_errors.t] = signrank(mLFP_errors_in,mLFP_errors_out);
% [stats.OL_correct.p,stats.OL_correct.h,stats.OL_correct.ci,stats.OL_correct.t] = signrank(mOL_correct_contra,mOL_correct_ipsi);
% [stats.OL_errors.p,stats.OL_errors.h,stats.OL_errors.ci,stats.OL_errors.t] = signrank(mOL_errors_contra,mOL_errors_ipsi);
% [stats.OR_correct.p,stats.OR_correct.h,stats.OR_correct.ci,stats.OR_correct.t] = signrank(mOR_correct_contra,mOR_correct_ipsi);
% [stats.OR_errors.p,stats.OR_errors.h,stats.OR_errors.ci,stats.OR_errors.t] = signrank(mOR_errors_contra,mOR_errors_ipsi);
% 


%==========================================
% Catch trials (NOTE: plots used all correct trials; for test, limit
% correct target_in and distractor_in to keeper catch trials
Spike_correct_in = allwf.neuron.in_correct(find(keeper.catch.neuron),:);
Spike_correct_out = allwf.neuron.out_correct(find(keeper.catch.neuron),:);
Spike_catch_correct_in = allwf.neuron.catch.correct_in(find(keeper.catch.neuron),:);
Spike_catch_errors_in = allwf.neuron.catch.errors_in(find(keeper.catch.neuron),:);
Spike_catch_nosacc = allwf.neuron.catch.correct_nosacc(find(keeper.catch.neuron),:);


LFP_correct_in = allwf.LFP.Hemi.in_correct(find(keeper.catch.LFP),:);
LFP_correct_out = allwf.LFP.Hemi.out_correct(find(keeper.catch.LFP),:);
LFP_catch_correct_in = allwf.LFP.Hemi.catch.correct_in(find(keeper.catch.LFP),:);
LFP_catch_errors_in = allwf.LFP.Hemi.catch.errors_in(find(keeper.catch.LFP),:);
LFP_catch_nosacc = allwf.LFP.Hemi.catch.correct_nosacc(find(keeper.catch.LFP),:);


OR_correct_in = allwf.OR.in_correct(find(keeper.catch.OR),:);
OR_correct_out = allwf.OR.out_correct(find(keeper.catch.OR),:);
OR_catch_correct_in = allwf.OR.catch.correct_in(find(keeper.catch.OR),:);
OR_catch_errors_in = allwf.OR.catch.errors_in(find(keeper.catch.OR),:);
OR_catch_nosacc = allwf.OR.catch.correct_nosacc(find(keeper.catch.OR),:);


mSpike_correct_in = mean(Spike_correct_in(:,SPwindow),2);
mSpike_correct_out = mean(Spike_correct_out(:,SPwindow),2);
mSpike_catch_correct_in = mean(Spike_catch_correct_in(:,SPwindow),2);
mSpike_catch_errors_in = mean(Spike_catch_errors_in(:,SPwindow),2);
mSpike_catch_nosacc = mean(Spike_catch_nosacc(:,SPwindow),2);

mLFP_correct_in = mean(LFP_correct_in(:,ADwindow),2);
mLFP_correct_out = mean(LFP_correct_out(:,ADwindow),2);
mLFP_catch_correct_in = mean(LFP_catch_correct_in(:,ADwindow),2);
mLFP_catch_errors_in = mean(LFP_catch_errors_in(:,ADwindow),2);
mLFP_catch_nosacc = mean(LFP_catch_nosacc(:,ADwindow),2); 

mOR_correct_in = nanmean(OR_correct_in(:,ADwindow),2);
mOR_correct_out = nanmean(OR_correct_out(:,ADwindow),2);
mOR_catch_correct_in = nanmean(OR_catch_correct_in(:,ADwindow),2);
mOR_catch_errors_in = nanmean(OR_catch_errors_in(:,ADwindow),2);
mOR_catch_nosacc = nanmean(OR_catch_nosacc(:,ADwindow),2);

%===============================
% paired t-tests
[stats.spike_correct_in_v_catch_errors.h,stats.spike_correct_in_v_catch_errors.p,stats.spike_correct_in_v_catch_errors.ci,stats.spike_correct_in_v_catch_errors.t] = ttest(mSpike_correct_in,mSpike_catch_errors_in);
[stats.spike_correct_out_v_catch_correct.h,stats.spike_correct_out_v_catch_correct.p,stats.spike_correct_out_v_catch_correct.ci,stats.spike_correct_out_v_catch_correct.t] = ttest(mSpike_correct_out,mSpike_catch_correct_in);
[stats.spike_correct_out_v_catch_nosacc.h,stats.spike_correct_out_v_catch_nosacc.p,stats.spike_correct_out_v_catch_nosacc.ci,stats.spike_correct_out_v_catch_nosacc.t] = ttest(mSpike_correct_out,mSpike_catch_nosacc);
[stats.spike_catch_correct_v_catch_nosacc.h,stats.spike_catch_correct_v_catch_nosacc.p,stats.spike_catch_correct_v_catch_nosacc.ci,stats.spike_catch_correct_v_catch_nosacc.t] = ttest(mSpike_catch_correct_in,mSpike_catch_nosacc);
[stats.spike_catch_correct_v_catch_errors.h,stats.spike_catch_correct_v_catch_errors.p,stats.spike_catch_correct_v_catch_errors.ci,stats.spike_catch_correct_v_catch_errors.t] = ttest(mSpike_catch_correct_in,mSpike_catch_errors_in);

[stats.LFP_correct_in_v_catch_errors.h,stats.LFP_correct_in_v_catch_errors.p,stats.LFP_correct_in_v_catch_errors.ci,stats.LFP_correct_in_v_catch_errors.t] = ttest(mLFP_correct_in,mLFP_catch_errors_in);
[stats.LFP_correct_out_v_catch_correct.h,stats.LFP_correct_out_v_catch_correct.p,stats.LFP_correct_out_v_catch_correct.ci,stats.LFP_correct_out_v_catch_correct.t] = ttest(mLFP_correct_out,mLFP_catch_correct_in);
[stats.LFP_correct_out_v_catch_nosacc.h,stats.LFP_correct_out_v_catch_nosacc.p,stats.LFP_correct_out_v_catch_nosacc.ci,stats.LFP_correct_out_v_catch_nosacc.t] = ttest(mLFP_correct_out,mLFP_catch_nosacc);
[stats.LFP_catch_correct_v_catch_nosacc.h,stats.LFP_catch_correct_v_catch_nosacc.p,stats.LFP_catch_correct_v_catch_nosacc.ci,stats.LFP_catch_correct_v_catch_nosacc.t] = ttest(mLFP_catch_correct_in,mLFP_catch_nosacc);
[stats.LFP_catch_correct_v_catch_errors.h,stats.LFP_catch_correct_v_catch_errors.p,stats.LFP_catch_correct_v_catch_errors.ci,stats.LFP_catch_correct_v_catch_errors.t] = ttest(mLFP_catch_correct_in,mLFP_catch_errors_in);


[stats.OR_correct_in_v_catch_errors.h,stats.OR_correct_in_v_catch_errors.p,stats.OR_correct_in_v_catch_errors.ci,stats.OR_correct_in_v_catch_errors.t] = ttest(mOR_correct_in,mOR_catch_errors_in);
[stats.OR_correct_out_v_catch_correct.h,stats.OR_correct_out_v_catch_correct.p,stats.OR_correct_out_v_catch_correct.ci,stats.OR_correct_out_v_catch_correct.t] = ttest(mOR_correct_out,mOR_catch_correct_in);
[stats.OR_correct_out_v_catch_nosacc.h,stats.OR_correct_out_v_catch_nosacc.p,stats.OR_correct_out_v_catch_nosacc.ci,stats.OR_correct_out_v_catch_nosacc.t] = ttest(mOR_correct_out,mOR_catch_nosacc);
[stats.OR_catch_correct_v_catch_nosacc.h,stats.OR_catch_correct_v_catch_nosacc.p,stats.OR_catch_correct_v_catch_nosacc.ci,stats.OR_catch_correct_v_catch_nosacc.t] = ttest(mOR_catch_correct_in,mOR_catch_nosacc);
[stats.OR_catch_correct_v_catch_errors.h,stats.OR_catch_correct_v_catch_errors.p,stats.OR_catch_correct_v_catch_errors.ci,stats.OR_catch_correct_v_catch_errors.t] = ttest(mOR_catch_correct_in,mOR_catch_errors_in);

