figure
subplot(3,2,1)


plot(-500:2500,nanmean(allwf.contrastim.contra_stim),'r',-500:2500,nanmean(allwf.contrastim.ipsi_stim),'--r','linewidth',2)
axis ij
set(gca,'YTickLabel',[])
xlim([-50 400])

vline(nanmean(allTDT.contrastim.stim),'r')


newax
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
plot(-500:2500,nanmean(allwf.contrastim.contra_nostim),'b',-500:2500,nanmean(allwf.contrastim.ipsi_nostim),'--b','linewidth',2)
axis ij
xlim([-50 400])

vline(nanmean(allTDT.contrastim.nostim),'b')
title('Contralateral to uStim Electrode')

subplot(3,2,2)


plot(-500:2500,nanmean(allwf.ipsistim.contra_stim),'r',-500:2500,nanmean(allwf.ipsistim.ipsi_stim),'--r')
axis ij
set(gca,'YTickLabel',[])
xlim([-50 400])

vline(nanmean(allTDT.ipsistim.stim),'r')


newax
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
plot(-500:2500,nanmean(allwf.ipsistim.contra_nostim),'b',-500:2500,nanmean(allwf.ipsistim.ipsi_nostim),'--b')
axis ij
xlim([-50 400])

vline(nanmean(allTDT.ipsistim.nostim),'b')
title('Ipsilateral to uStim Electrode')

subplot(3,2,3:4)
plot(-500:2500,nanmean(allROC.contrastim.stim),'r',-500:2500,nanmean(allROC.contrastim.nostim),'b','linewidth',2)
hold on
plot(-500:2500,nanmean(allROC.ipsistim.stim),'r',-500:2500,nanmean(allROC.ipsistim.nostim),'b')
xlim([-50 400])

subplot(3,2,5)

RTerr.contratarg.stim = std(allRT.contratarg.stim) / sqrt(length(allRT.contratarg.stim));
RTerr.contratarg.nostim = std(allRT.contratarg.nostim) / sqrt(length(allRT.contratarg.nostim));
RTerr.ipsitarg.stim = std(allRT.ipsitarg.stim) / sqrt(length(allRT.ipsitarg.stim));
RTerr.ipsitarg.nostim = std(allRT.ipsitarg.nostim) / sqrt(length(allRT.ipsitarg.nostim));

barweb([nanmean(allRT.contratarg.stim) nanmean(allRT.contratarg.nostim) ; ...
    nanmean(allRT.ipsitarg.stim) nanmean(allRT.ipsitarg.nostim)],[RTerr.contratarg.stim ...
    RTerr.contratarg.nostim ; RTerr.ipsitarg.stim RTerr.ipsitarg.nostim])
set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'],'fontsize',10)
% currMaxRT = findMax(allRT.contratarg.nostim,allRT.contratarg.stim,allRT.ipsitarg.nostim,allRT.ipsitarg.stim);
% currMinRT = findMin(allRT.contratarg.nostim,allRT.contratarg.stim,allRT.ipsitarg.nostim,allRT.ipsitarg.stim);
% ylim([currMinRT - 20 currMaxRT + 20])
title('RT')



ACCerr.contratarg.stim = std(allACC.contratarg.stim) / sqrt(length(allACC.contratarg.stim));
ACCerr.contratarg.nostim = std(allACC.contratarg.nostim) / sqrt(length(allACC.contratarg.nostim));
ACCerr.ipsitarg.stim = std(allACC.ipsitarg.stim) / sqrt(length(allACC.ipsitarg.stim));
ACCerr.ipsitarg.nostim = std(allACC.ipsitarg.nostim) / sqrt(length(allACC.ipsitarg.nostim));

subplot(3,2,6)
barweb([nanmean(allACC.contratarg.stim) nanmean(allACC.contratarg.nostim) ; ...
    nanmean(allACC.ipsitarg.stim) nanmean(allACC.ipsitarg.nostim)],[ACCerr.contratarg.stim ...
    ACCerr.contratarg.nostim ; ACCerr.ipsitarg.stim ACCerr.ipsitarg.nostim])

set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'],'fontsize',10)
% currMaxACC = findMax(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
% currMinACC = findMin(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
% ylim([currMinACC - .1 currMaxACC + .1])
title('ACC')











%=========================================================
% TRUNCATED SIGNALS


figure
subplot(3,2,1)
 
 
plot(-500:2500,nanmean(allwf_trunc.contrastim.contra_stim),'r',-500:2500,nanmean(allwf_trunc.contrastim.ipsi_stim),'--r','linewidth',2)
axis ij
set(gca,'YTickLabel',[])
xlim([-50 400])
 
vline(nanmean(allTDT_trunc.contrastim.stim),'r')
 
 
newax
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
plot(-500:2500,nanmean(allwf_trunc.contrastim.contra_nostim),'b',-500:2500,nanmean(allwf_trunc.contrastim.ipsi_nostim),'--b','linewidth',2)
axis ij
xlim([-50 400])
 
vline(nanmean(allTDT_trunc.contrastim.nostim),'b')
title('Contralateral to uStim Electrode')
 
subplot(3,2,2)
 
 
plot(-500:2500,nanmean(allwf_trunc.ipsistim.contra_stim),'r',-500:2500,nanmean(allwf_trunc.ipsistim.ipsi_stim),'--r')
axis ij
set(gca,'YTickLabel',[])
xlim([-50 400])
 
vline(nanmean(allTDT_trunc.ipsistim.stim),'r')
 
 
newax
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
plot(-500:2500,nanmean(allwf_trunc.ipsistim.contra_nostim),'b',-500:2500,nanmean(allwf_trunc.ipsistim.ipsi_nostim),'--b')
axis ij
xlim([-50 400])
 
vline(nanmean(allTDT_trunc.ipsistim.nostim),'b')
title('Ipsilateral to uStim Electrode')
 
subplot(3,2,3:4)
plot(-500:2500,nanmean(allROC_trunc.contrastim.stim),'r',-500:2500,nanmean(allROC_trunc.contrastim.nostim),'b','linewidth',2)
hold on
plot(-500:2500,nanmean(allROC_trunc.ipsistim.stim),'r',-500:2500,nanmean(allROC_trunc.ipsistim.nostim),'b')
xlim([-50 400])
 
subplot(3,2,5)
 
RTerr.contratarg.stim = std(allRT.contratarg.stim) / sqrt(length(allRT.contratarg.stim));
RTerr.contratarg.nostim = std(allRT.contratarg.nostim) / sqrt(length(allRT.contratarg.nostim));
RTerr.ipsitarg.stim = std(allRT.ipsitarg.stim) / sqrt(length(allRT.ipsitarg.stim));
RTerr.ipsitarg.nostim = std(allRT.ipsitarg.nostim) / sqrt(length(allRT.ipsitarg.nostim));
 
barweb([nanmean(allRT.contratarg.stim) nanmean(allRT.contratarg.nostim) ; ...
    nanmean(allRT.ipsitarg.stim) nanmean(allRT.ipsitarg.nostim)],[RTerr.contratarg.stim ...
    RTerr.contratarg.nostim ; RTerr.ipsitarg.stim RTerr.ipsitarg.nostim])
set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'],'fontsize',10)
% currMaxRT = findMax(allRT.contratarg.nostim,allRT.contratarg.stim,allRT.ipsitarg.nostim,allRT.ipsitarg.stim);
% currMinRT = findMin(allRT.contratarg.nostim,allRT.contratarg.stim,allRT.ipsitarg.nostim,allRT.ipsitarg.stim);
% ylim([currMinRT - 20 currMaxRT + 20])
title('RT')
 
 
 
ACCerr.contratarg.stim = std(allACC.contratarg.stim) / sqrt(length(allACC.contratarg.stim));
ACCerr.contratarg.nostim = std(allACC.contratarg.nostim) / sqrt(length(allACC.contratarg.nostim));
ACCerr.ipsitarg.stim = std(allACC.ipsitarg.stim) / sqrt(length(allACC.ipsitarg.stim));
ACCerr.ipsitarg.nostim = std(allACC.ipsitarg.nostim) / sqrt(length(allACC.ipsitarg.nostim));
 
subplot(3,2,6)
barweb([nanmean(allACC.contratarg.stim) nanmean(allACC.contratarg.nostim) ; ...
    nanmean(allACC.ipsitarg.stim) nanmean(allACC.ipsitarg.nostim)],[ACCerr.contratarg.stim ...
    ACCerr.contratarg.nostim ; ACCerr.ipsitarg.stim ACCerr.ipsitarg.nostim])
 
set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'],'fontsize',10)
% currMaxACC = findMax(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
% currMinACC = findMin(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
% ylim([currMinACC - .1 currMaxACC + .1])
title('ACC')
