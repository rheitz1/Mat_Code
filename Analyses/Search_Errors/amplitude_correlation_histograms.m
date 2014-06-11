%p value threshold
p_thresh = .05;
use_keepers_only = 0;

trls = 1:length(r.SPK_LFP.in_correct);
do_not_use.SPK_LFP = setdiff(trls,keeper.SPK_LFP);
clear trls

trls = 1:length(r.SPK_EEG.in_correct);
do_not_use.SPK_EEG = setdiff(trls,keeper.SPK_EEG);
clear trls

trls = 1:length(r.LFP_EEG.in_correct);
do_not_use.LFP_EEG = setdiff(trls,keeper.LFP_EEG);
clear trls

if use_keepers_only
    r.SPK_LFP.in_correct(do_not_use.SPK_LFP) = NaN;
    r.SPK_LFP.out_correct(do_not_use.SPK_LFP) = NaN;
    r.SPK_LFP.in_incorrect(do_not_use.SPK_LFP) = NaN;
    r.SPK_LFP.out_incorrect(do_not_use.SPK_LFP) = NaN;
    
    r.SPK_EEG.in_correct(do_not_use.SPK_EEG) = NaN;
    r.SPK_EEG.out_correct(do_not_use.SPK_EEG) = NaN;
    r.SPK_EEG.in_incorrect(do_not_use.SPK_EEG) = NaN;
    r.SPK_EEG.out_incorrect(do_not_use.SPK_EEG) = NaN;
    
    r.LFP_EEG.in_correct(do_not_use.LFP_EEG) = NaN;
    r.LFP_EEG.out_correct(do_not_use.LFP_EEG) = NaN;
    r.LFP_EEG.in_incorrect(do_not_use.LFP_EEG) = NaN;
    r.LFP_EEG.out_incorrect(do_not_use.LFP_EEG) = NaN;
    
end

%SPK-EEG
 
% in correct
[n.in_cor x.in_cor] = hist(r.SPK_EEG.in_correct,30);
[n.in_corsig x.in_corsig] = hist(r.SPK_EEG.in_correct(find(p_val.SPK_EEG.in_correct < p_thresh)),30);
 
figure
subplot(2,2,1)
bar(x.in_cor,n.in_cor)
hold on
bar(x.in_corsig,n.in_corsig,'r')
title('SPK-EEG in correct')
xlim([-1 1])

% out correct
[n.out_cor x.out_cor] = hist(r.SPK_EEG.out_correct,30);
[n.out_corsig x.out_corsig] = hist(r.SPK_EEG.out_correct(find(p_val.SPK_EEG.out_correct < p_thresh)),30);
 
subplot(2,2,2)
bar(x.out_cor,n.out_cor)
hold on
bar(x.out_corsig,n.out_corsig,'r')
title('SPK-EEG out correct')
xlim([-1 1])

%in incorrect
[n.in_incor x.in_incor] = hist(r.SPK_EEG.in_incorrect,30);
[n.in_incorsig x.in_incorsig] = hist(r.SPK_EEG.in_incorrect(find(p_val.SPK_EEG.in_incorrect < p_thresh)),30);
 
subplot(2,2,3)
bar(x.in_incor,n.in_incor)
hold on
bar(x.in_incorsig,n.in_incorsig,'r')
title('SPK-EEG in incorrect')
xlim([-1 1])

%out incorrect
[n.out_incor x.out_incor] = hist(r.SPK_EEG.out_incorrect,30);
[n.out_incorsig x.out_incorsig] = hist(r.SPK_EEG.out_incorrect(find(p_val.SPK_EEG.out_incorrect < p_thresh)),30);
 
subplot(2,2,4)
bar(x.out_incor,n.out_incor)
hold on
bar(x.out_incorsig,n.out_incorsig,'r')
title('SPK-EEG out incorrect')
xlim([-1 1])



 
%LFP-EEG
 
% in correct
[n.in_cor x.in_cor] = hist(r.LFP_EEG.in_correct,30);
[n.in_corsig x.in_corsig] = hist(r.LFP_EEG.in_correct(find(p_val.LFP_EEG.in_correct < p_thresh)),30);
 
figure
subplot(2,2,1)
bar(x.in_cor,n.in_cor)
hold on
bar(x.in_corsig,n.in_corsig,'r')
title('LFP-EEG in correct')
xlim([-1 1]) 
 
% out correct
[n.out_cor x.out_cor] = hist(r.LFP_EEG.out_correct,30);
[n.out_corsig x.out_corsig] = hist(r.LFP_EEG.out_correct(find(p_val.LFP_EEG.out_correct < p_thresh)),30);
 
subplot(2,2,2)
bar(x.out_cor,n.out_cor)
hold on
bar(x.out_corsig,n.out_corsig,'r')
title('LFP-EEG out correct')
xlim([-1 1]) 
 
%in incorrect
[n.in_incor x.in_incor] = hist(r.LFP_EEG.in_incorrect,30);
[n.in_incorsig x.in_incorsig] = hist(r.LFP_EEG.in_incorrect(find(p_val.LFP_EEG.in_incorrect < p_thresh)),30);
 
subplot(2,2,3)
bar(x.in_incor,n.in_incor)
hold on
bar(x.in_incorsig,n.in_incorsig,'r')
title('LFP-EEG in incorrect')
xlim([-1 1]) 
 
%out incorrect
[n.out_incor x.out_incor] = hist(r.LFP_EEG.out_incorrect,30);
[n.out_incorsig x.out_incorsig] = hist(r.LFP_EEG.out_incorrect(find(p_val.LFP_EEG.out_incorrect < p_thresh)),30);
 
subplot(2,2,4)
bar(x.out_incor,n.out_incor)
hold on
bar(x.out_incorsig,n.out_incorsig,'r')
title('LFP-EEG out incorrect')
xlim([-1 1])



%SPK-LFP
 
% in correct
[n.in_cor x.in_cor] = hist(r.SPK_LFP.in_correct,30);
[n.in_corsig x.in_corsig] = hist(r.SPK_LFP.in_correct(find(p_val.SPK_LFP.in_correct < p_thresh)),30);
 
figure
subplot(2,2,1)
bar(x.in_cor,n.in_cor)
hold on
bar(x.in_corsig,n.in_corsig,'r')
title('SPK-LFP in correct')
xlim([-1 1]) 
 
% out correct
[n.out_cor x.out_cor] = hist(r.SPK_LFP.out_correct,30);
[n.out_corsig x.out_corsig] = hist(r.SPK_LFP.out_correct(find(p_val.SPK_LFP.out_correct < p_thresh)),30);
 
subplot(2,2,2)
bar(x.out_cor,n.out_cor)
hold on
bar(x.out_corsig,n.out_corsig,'r')
title('SPK-LFP out correct')
xlim([-1 1]) 
 
%in incorrect
[n.in_incor x.in_incor] = hist(r.SPK_LFP.in_incorrect,30);
[n.in_incorsig x.in_incorsig] = hist(r.SPK_LFP.in_incorrect(find(p_val.SPK_LFP.in_incorrect < p_thresh)),30);
 
subplot(2,2,3)
bar(x.in_incor,n.in_incor)
hold on
bar(x.in_incorsig,n.in_incorsig,'r')
title('SPK-LFP in incorrect')
xlim([-1 1]) 
 
%out incorrect
[n.out_incor x.out_incor] = hist(r.SPK_LFP.out_incorrect,30);
[n.out_incorsig x.out_incorsig] = hist(r.SPK_LFP.out_incorrect(find(p_val.SPK_LFP.out_incorrect < p_thresh)),30);
 
subplot(2,2,4)
bar(x.out_incor,n.out_incor)
hold on
bar(x.out_incorsig,n.out_incorsig,'r')
title('SPK-LFP out incorrect')
xlim([-1 1])
