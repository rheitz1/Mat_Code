%these plot ROC areas computed for each individual session rather than on
%the averages of the sessions (for that, see 'trial_history_ROC.m')
 
win = 100;
 
 
%==========
%SPIKES
figure
plot(-100:500,nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),:)), 'k', ...
    -100:500,nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),:)),'b', ...
    -100:500,nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),:)),'r', ...
    -100:500,nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),:)),'g')
xlim([-50 300])
 
ccav.neuron = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),250:400),2);
ceav.neuron = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),250:400),2);
ecav.neuron = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),250:400),2);
eeav.neuron = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),250:400),2);
 
 
%get averages and find time point of peak of average
 
 
[max i] = nanmax(nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),:)));
ccav_maxpos.neuron = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),:)));
ceav_maxpos.neuron = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),:)));
ecav_maxpos.neuron = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),:)));
eeav_maxpos.neuron = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
 
 
% ccmax = nanmax(allROC.neuron.c_c(find(keeper.history.neuron_e_e),250:400),[],2);
% cemax = nanmax(allROC.neuron.c_e(find(keeper.history.neuron_e_e),250:400),[],2);
% ecmax = nanmax(allROC.neuron.e_c(find(keeper.history.neuron_e_e),250:400),[],2);
% eemax = nanmax(allROC.neuron.e_e(find(keeper.history.neuron_e_e),250:400),[],2);
 
% ccavmax_err = std(nanmax(allROC.neuron.c_c(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% ecavmax_err = std(nanmax(allROC.neuron.e_c(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% ceavmax_err = std(nanmax(allROC.neuron.c_e(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% eeavmax_err = std(nanmax(allROC.neuron.e_e(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
 
figure
fw
plot(1:4,[nanmean(ccav.neuron) nanmean(ecav.neuron) nanmean(ceav.neuron) nanmean(eeav.neuron)],'b')
% hold
% plot(1:4,[nanmean(ccmax) nanmean(ecmax) nanmean(cemax) nanmean(eemax)],'k')
 
hold
plot(1:4,[nanmean(ccav_maxpos.neuron) nanmean(ecav_maxpos.neuron) nanmean(ceav_maxpos.neuron) nanmean(eeav_maxpos.neuron)],'r')
 
xlim([.5 4.5])
 
 
 
 
 
 
 
 
 
%============
% LFP
figure
plot(-100:500,nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)), 'k', ...
    -100:500,nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)),'b', ...
    -100:500,nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)),'r', ...
    -100:500,nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)),'g')
 
xlim([-50 300])
 
ccav.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),250:400),2);
ceav.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),250:400),2);
ecav.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),250:400),2);
eeav.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),250:400),2);
 
%get averages and find time point of peak of average
 
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)));
ccav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)));
ceav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)));
ecav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)));
eeav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
% ccmax = nanmax(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),250:400),[],2);
% cemax = nanmax(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),250:400),[],2);
% ecmax = nanmax(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),250:400),[],2);
% eemax = nanmax(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),250:400),[],2);
 
figure
fw
plot(1:4,[nanmean(ccav.LFP) nanmean(ecav.LFP) nanmean(ceav.LFP) nanmean(eeav.LFP)],'b')
% hold
% plot(1:4,[nanmean(ccmax) nanmean(ecmax) nanmean(cemax) nanmean(eemax)],'k')
hold
plot(1:4,[nanmean(ccav_maxpos.LFP) nanmean(ecav_maxpos.LFP) nanmean(ceav_maxpos.LFP) nanmean(eeav_maxpos.LFP)],'r')
 
 
xlim([.5 4.5])
 
 
 
 
 
 
 
%=======
% OR
figure
plot(-100:500,nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),:)), 'k', ...
    -100:500,nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),:)),'b', ...
    -100:500,nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),:)),'r', ...
    -100:500,nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),:)),'g')
 
xlim([-50 300])
 
 
ccav.OR = nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),250:400),2);
ceav.OR = nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),250:400),2);
ecav.OR = nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),250:400),2);
eeav.OR = nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),250:400),2);
 
 
%get averages and find time point of peak of average
 
[max i] = nanmax(nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),250:400)));
ccav_maxpos.OR = nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),250:400)));
ceav_maxpos.OR = nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),250:400)));
ecav_maxpos.OR = nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),250:400)));
eeav_maxpos.OR = nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
 
% ccmax = nanmax(allROC.OR.c_c(find(keeper.history.OR_e_e),250:400),[],2);
% cemax = nanmax(allROC.OR.c_e(find(keeper.history.OR_e_e),250:400),[],2);
% ecmax = nanmax(allROC.OR.e_c(find(keeper.history.OR_e_e),250:400),[],2);
% eemax = nanmax(allROC.OR.e_e(find(keeper.history.OR_e_e),250:400),[],2);
 
figure
fw
plot(1:4,[nanmean(ccav.OR) nanmean(ecav.OR) nanmean(ceav.OR) nanmean(eeav.OR)],'b')
% hold
% plot(1:4,[nanmean(ccmax) nanmean(ecmax) nanmean(cemax) nanmean(eemax)],'k')
hold
plot(1:4,[nanmean(ccav_maxpos.OR) nanmean(ecav_maxpos.OR) nanmean(ceav_maxpos.OR) nanmean(eeav_maxpos.OR)],'r')
 
 
xlim([.5 4.5])
 
 
 
 
%==================================================
 
%===================
% SUBSAMPLED
 
figure
plot(-100:500,nanmean(allROC_sub.neuron.c_c(find(keeper.history.neuron_e_e),:)), 'k', ...
    -100:500,nanmean(allROC_sub.neuron.e_c(find(keeper.history.neuron_e_e),:)),'b', ...
    -100:500,nanmean(allROC_sub.neuron.c_e(find(keeper.history.neuron_e_e),:)),'r', ...
    -100:500,nanmean(allROC_sub.neuron.e_e(find(keeper.history.neuron_e_e),:)),'g')
xlim([-50 300])
 
ccav = nanmean(nanmean(allROC_sub.neuron.c_c(find(keeper.history.neuron_e_e),250:400),2));
ceav = nanmean(nanmean(allROC_sub.neuron.c_e(find(keeper.history.neuron_e_e),250:400),2));
ecav = nanmean(nanmean(allROC_sub.neuron.e_c(find(keeper.history.neuron_e_e),250:400),2));
eeav = nanmean(nanmean(allROC_sub.neuron.e_e(find(keeper.history.neuron_e_e),250:400),2));
 
figure
fw
plot(1:4,[ccav ecav ceav eeav])
xlim([.5 4.5])
 
 
 
 
 
figure
plot(-100:500,nanmean(allROC_sub.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)), 'k', ...
    -100:500,nanmean(allROC_sub.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)),'b', ...
    -100:500,nanmean(allROC_sub.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)),'r', ...
    -100:500,nanmean(allROC_sub.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)),'g')
 
xlim([-50 300])
 
ccav = nanmean(nanmean(allROC_sub.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),250:400),2));
ceav = nanmean(nanmean(allROC_sub.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),250:400),2));
ecav = nanmean(nanmean(allROC_sub.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),250:400),2));
eeav = nanmean(nanmean(allROC_sub.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),250:400),2));
 
figure
fw
plot(1:4,[ccav ecav ceav eeav])
xlim([.5 4.5])
 
 
 
 
 
 
 
figure
plot(-100:500,nanmean(allROC_sub.OR.c_c(find(keeper.history.OR_e_e),:)), 'k', ...
    -100:500,nanmean(allROC_sub.OR.e_c(find(keeper.history.OR_e_e),:)),'b', ...
    -100:500,nanmean(allROC_sub.OR.c_e(find(keeper.history.OR_e_e),:)),'r', ...
    -100:500,nanmean(allROC_sub.OR.e_e(find(keeper.history.OR_e_e),:)),'g')
 
xlim([-50 300])
 
ccav = nanmean(nanmean(allROC_sub.OR.c_c(find(keeper.history.OR_e_e),250:400),2));
ceav = nanmean(nanmean(allROC_sub.OR.c_e(find(keeper.history.OR_e_e),250:400),2));
ecav = nanmean(nanmean(allROC_sub.OR.e_c(find(keeper.history.OR_e_e),250:400),2));
eeav = nanmean(nanmean(allROC_sub.OR.e_e(find(keeper.history.OR_e_e),250:400),2));
 
figure
fw
plot(1:4,[ccav ecav ceav eeav])
xlim([.5 4.5])
%=================
 
 



% %these plot ROC areas computed for each individual session rather than on
% %the averages of the sessions (for that, see 'trial_history_ROC.m')
% 
% win = 100;
% 
% 
% %==========
% %SPIKES
% figure
% plot(-100:500,nanmean(allROC_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),:)), 'k', ...
%     -100:500,nanmean(allROC_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),:)),'b', ...
%     -100:500,nanmean(allROC_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),:)),'r', ...
%     -100:500,nanmean(allROC_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),:)),'g')
% xlim([-50 300])
% 
% ccav.neuron = nanmean(allROC_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),250:400),2);
% ceav.neuron = nanmean(allROC_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),250:400),2);
% ecav.neuron = nanmean(allROC_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),250:400),2);
% eeav.neuron = nanmean(allROC_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),250:400),2);
% 
% 
% %get averages and find time point of peak of average
% 
% 
% [max i] = nanmax(nanmean(allROC_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),:)));
% ccav_maxpos.neuron = nanmean(allROC_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),:)));
% ceav_maxpos.neuron = nanmean(allROC_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),:)));
% ecav_maxpos.neuron = nanmean(allROC_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),:)));
% eeav_maxpos.neuron = nanmean(allROC_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% 
% 
% % ccmax = nanmax(allROC_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),250:400),[],2);
% % cemax = nanmax(allROC_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),250:400),[],2);
% % ecmax = nanmax(allROC_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),250:400),[],2);
% % eemax = nanmax(allROC_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),250:400),[],2);
% 
% % ccavmax_err = std(nanmax(allROC_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% % ecavmax_err = std(nanmax(allROC_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% % ceavmax_err = std(nanmax(allROC_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% % eeavmax_err = std(nanmax(allROC_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),250:400),[],2)) / sqrt(length(find(keeper.history.neuron_e_e)));
% 
% figure
% fw
% plot(1:4,[nanmean(ccav.neuron) nanmean(ecav.neuron) nanmean(ceav.neuron) nanmean(eeav.neuron)],'b')
% % hold
% % plot(1:4,[nanmean(ccmax) nanmean(ecmax) nanmean(cemax) nanmean(eemax)],'k')
% 
% hold
% plot(1:4,[nanmean(ccav_maxpos.neuron) nanmean(ecav_maxpos.neuron) nanmean(ceav_maxpos.neuron) nanmean(eeav_maxpos.neuron)],'r')
% 
% xlim([.5 4.5])
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %============
% % LFP
% figure
% plot(-100:500,nanmean(allROC_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)), 'k', ...
%     -100:500,nanmean(allROC_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)),'b', ...
%     -100:500,nanmean(allROC_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)),'r', ...
%     -100:500,nanmean(allROC_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)),'g')
% 
% xlim([-50 300])
% 
% ccav.LFP = nanmean(allROC_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),250:400),2);
% ceav.LFP = nanmean(allROC_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),250:400),2);
% ecav.LFP = nanmean(allROC_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),250:400),2);
% eeav.LFP = nanmean(allROC_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),250:400),2);
% 
% %get averages and find time point of peak of average
% 
% 
% [max i] = nanmax(nanmean(allROC_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)));
% ccav_maxpos.LFP = nanmean(allROC_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)));
% ceav_maxpos.LFP = nanmean(allROC_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)));
% ecav_maxpos.LFP = nanmean(allROC_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)));
% eeav_maxpos.LFP = nanmean(allROC_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% % ccmax = nanmax(allROC_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),250:400),[],2);
% % cemax = nanmax(allROC_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),250:400),[],2);
% % ecmax = nanmax(allROC_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),250:400),[],2);
% % eemax = nanmax(allROC_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),250:400),[],2);
% 
% figure
% fw
% plot(1:4,[nanmean(ccav.LFP) nanmean(ecav.LFP) nanmean(ceav.LFP) nanmean(eeav.LFP)],'b')
% % hold
% % plot(1:4,[nanmean(ccmax) nanmean(ecmax) nanmean(cemax) nanmean(eemax)],'k')
% hold
% plot(1:4,[nanmean(ccav_maxpos.LFP) nanmean(ecav_maxpos.LFP) nanmean(ceav_maxpos.LFP) nanmean(eeav_maxpos.LFP)],'r')
% 
% 
% xlim([.5 4.5])
% 
% 
% 
% 
% 
% 
% 
% %=======
% % OR
% figure
% plot(-100:500,nanmean(allROC_50msavg.OR.c_c(find(keeper.history.OR_e_e),:)), 'k', ...
%     -100:500,nanmean(allROC_50msavg.OR.e_c(find(keeper.history.OR_e_e),:)),'b', ...
%     -100:500,nanmean(allROC_50msavg.OR.c_e(find(keeper.history.OR_e_e),:)),'r', ...
%     -100:500,nanmean(allROC_50msavg.OR.e_e(find(keeper.history.OR_e_e),:)),'g')
% 
% xlim([-50 300])
% 
% 
% ccav.OR = nanmean(allROC_50msavg.OR.c_c(find(keeper.history.OR_e_e),250:400),2);
% ceav.OR = nanmean(allROC_50msavg.OR.c_e(find(keeper.history.OR_e_e),250:400),2);
% ecav.OR = nanmean(allROC_50msavg.OR.e_c(find(keeper.history.OR_e_e),250:400),2);
% eeav.OR = nanmean(allROC_50msavg.OR.e_e(find(keeper.history.OR_e_e),250:400),2);
% 
% 
% %get averages and find time point of peak of average
% 
% [max i] = nanmax(nanmean(allROC_50msavg.OR.c_c(find(keeper.history.OR_e_e),250:400)));
% ccav_maxpos.OR = nanmean(allROC_50msavg.OR.c_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.OR.c_e(find(keeper.history.OR_e_e),250:400)));
% ceav_maxpos.OR = nanmean(allROC_50msavg.OR.c_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.OR.e_c(find(keeper.history.OR_e_e),250:400)));
% ecav_maxpos.OR = nanmean(allROC_50msavg.OR.e_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% [max i] = nanmax(nanmean(allROC_50msavg.OR.e_e(find(keeper.history.OR_e_e),250:400)));
% eeav_maxpos.OR = nanmean(allROC_50msavg.OR.e_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% 
% % ccmax = nanmax(allROC_50msavg.OR.c_c(find(keeper.history.OR_e_e),250:400),[],2);
% % cemax = nanmax(allROC_50msavg.OR.c_e(find(keeper.history.OR_e_e),250:400),[],2);
% % ecmax = nanmax(allROC_50msavg.OR.e_c(find(keeper.history.OR_e_e),250:400),[],2);
% % eemax = nanmax(allROC_50msavg.OR.e_e(find(keeper.history.OR_e_e),250:400),[],2);
% 
% figure
% fw
% plot(1:4,[nanmean(ccav.OR) nanmean(ecav.OR) nanmean(ceav.OR) nanmean(eeav.OR)],'b')
% % hold
% % plot(1:4,[nanmean(ccmax) nanmean(ecmax) nanmean(cemax) nanmean(eemax)],'k')
% hold
% plot(1:4,[nanmean(ccav_maxpos.OR) nanmean(ecav_maxpos.OR) nanmean(ceav_maxpos.OR) nanmean(eeav_maxpos.OR)],'r')
% 
% 
% xlim([.5 4.5])
% 
% 
% 
% 
% %==================================================
% 
% %===================
% % SUBSAMPLED
% 
% figure
% plot(-100:500,nanmean(allROC_sub_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),:)), 'k', ...
%     -100:500,nanmean(allROC_sub_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),:)),'b', ...
%     -100:500,nanmean(allROC_sub_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),:)),'r', ...
%     -100:500,nanmean(allROC_sub_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),:)),'g')
% xlim([-50 300])
% 
% ccav = nanmean(nanmean(allROC_sub_50msavg.neuron.c_c(find(keeper.history.neuron_e_e),250:400),2));
% ceav = nanmean(nanmean(allROC_sub_50msavg.neuron.c_e(find(keeper.history.neuron_e_e),250:400),2));
% ecav = nanmean(nanmean(allROC_sub_50msavg.neuron.e_c(find(keeper.history.neuron_e_e),250:400),2));
% eeav = nanmean(nanmean(allROC_sub_50msavg.neuron.e_e(find(keeper.history.neuron_e_e),250:400),2));
% 
% figure
% fw
% plot(1:4,[ccav ecav ceav eeav])
% xlim([.5 4.5])
% 
% 
% 
% 
% 
% figure
% plot(-100:500,nanmean(allROC_sub_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)), 'k', ...
%     -100:500,nanmean(allROC_sub_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)),'b', ...
%     -100:500,nanmean(allROC_sub_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)),'r', ...
%     -100:500,nanmean(allROC_sub_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)),'g')
% 
% xlim([-50 300])
% 
% ccav = nanmean(nanmean(allROC_sub_50msavg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),250:400),2));
% ceav = nanmean(nanmean(allROC_sub_50msavg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),250:400),2));
% ecav = nanmean(nanmean(allROC_sub_50msavg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),250:400),2));
% eeav = nanmean(nanmean(allROC_sub_50msavg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),250:400),2));
% 
% figure
% fw
% plot(1:4,[ccav ecav ceav eeav])
% xlim([.5 4.5])
% 
% 
% 
% 
% 
% 
% 
% figure
% plot(-100:500,nanmean(allROC_sub_50msavg.OR.c_c(find(keeper.history.OR_e_e),:)), 'k', ...
%     -100:500,nanmean(allROC_sub_50msavg.OR.e_c(find(keeper.history.OR_e_e),:)),'b', ...
%     -100:500,nanmean(allROC_sub_50msavg.OR.c_e(find(keeper.history.OR_e_e),:)),'r', ...
%     -100:500,nanmean(allROC_sub_50msavg.OR.e_e(find(keeper.history.OR_e_e),:)),'g')
% 
% xlim([-50 300])
% 
% ccav = nanmean(nanmean(allROC_sub_50msavg.OR.c_c(find(keeper.history.OR_e_e),250:400),2));
% ceav = nanmean(nanmean(allROC_sub_50msavg.OR.c_e(find(keeper.history.OR_e_e),250:400),2));
% ecav = nanmean(nanmean(allROC_sub_50msavg.OR.e_c(find(keeper.history.OR_e_e),250:400),2));
% eeav = nanmean(nanmean(allROC_sub_50msavg.OR.e_e(find(keeper.history.OR_e_e),250:400),2));
% 
% figure
% fw
% plot(1:4,[ccav ecav ceav eeav])
% xlim([.5 4.5])
% %=================
% 
% 
