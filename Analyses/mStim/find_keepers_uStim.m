%plots waveforms and asks for input 'keepers'
%runs on Q.mat or S.mat in

for sess = 1:size(allROC.contrastim.stim)
    
    figure
    subplot(2,2,1)
    plot(-500:2500,allwf.contrastim.contra_stim(sess,:),'r',-500:2500,allwf.contrastim.ipsi_stim(sess,:),'--r', ...
        -500:2500,allwf.contrastim.contra_nostim(sess,:),'b',-500:2500,allwf.contrastim.ipsi_nostim(sess,:),'--b')
    xlim([-50 400])
    axis ij
    title('contra to stim')
    
    subplot(2,2,2)
    plot(-500:2500,allwf.ipsistim.contra_stim(sess,:),'r',-500:2500,allwf.ipsistim.ipsi_stim(sess,:),'--r', ...
        -500:2500,allwf.ipsistim.contra_nostim(sess,:),'b',-500:2500,allwf.ipsistim.ipsi_nostim(sess,:),'--b')
    xlim([-50 400])
    axis ij
    title('ipsi to stim')
    legend('stim','nostim')
    
    subplot(2,2,3)
    plot(-500:2500,allROC.contrastim.stim(sess,:),'r',-500:2500,allROC.contrastim.nostim(sess,:),'--r', ...
        -500:2500,allROC.ipsistim.stim(sess,:),'b',-500:2500,allROC.ipsistim.nostim(sess,:),'--b')
    
    xlim([-50 400])
    
    
    keeper(sess,1) = input('keep? ');
    
    
    cla
end


f_


%clear 0's
allwf.contrastim.contra_stim(find(allwf.contrastim.contra_stim == 0)) = NaN;
allwf.contrastim.ipsi_stim(find(allwf.contrastim.ipsi_stim == 0)) = NaN;
allwf.ipsistim.contra_stim(find(allwf.ipsistim.contra_stim == 0)) = NaN;
allwf.ipsistim.ipsi_stim(find(allwf.ipsistim.ipsi_stim == 0)) = NaN;

allwf.contrastim.contra_stim(find(allwf.contrastim.contra_nostim == 0)) = NaN;
allwf.contrastim.ipsi_stim(find(allwf.contrastim.ipsi_nostim == 0)) = NaN;
allwf.ipsistim.contra_stim(find(allwf.ipsistim.contra_nostim == 0)) = NaN;
allwf.ipsistim.ipsi_stim(find(allwf.ipsistim.ipsi_nostim == 0)) = NaN;

allROC.contrastim.stim(find(allROC.contrastim.stim == 0)) = NaN;
allROC.contrastim.nostim(find(allROC.contrastim.nostim == 0)) = NaN;
allROC.ipsistim.stim(find(allROC.ipsistim.stim == 0)) = NaN;
allROC.ipsistim.nostim(find(allROC.ipsistim.nostim == 0)) = NaN;

figure
subplot(2,2,1)
plot(-500:2500,nanmean(allwf.contrastim.contra_stim(find(keeper),:)),'r',-500:2500,nanmean(allwf.contrastim.ipsi_stim(find(keeper),:)),'--r', ...
    -500:2500,nanmean(allwf.contrastim.contra_nostim(find(keeper),:)),'b',-500:2500,nanmean(allwf.contrastim.ipsi_nostim(find(keeper),:)),'--b')
xlim([-50 400])
axis ij
title('contra to stim')

subplot(2,2,2)
plot(-500:2500,nanmean(allwf.ipsistim.contra_stim(find(keeper),:)),'r',-500:2500,nanmean(allwf.ipsistim.ipsi_stim(find(keeper),:)),'--r', ...
    -500:2500,nanmean(allwf.ipsistim.contra_nostim(find(keeper),:)),'b',-500:2500,nanmean(allwf.ipsistim.ipsi_nostim(find(keeper),:)),'--b')
xlim([-50 400])
axis ij
title('ipsi to stim')
legend('stim','nostim')

subplot(2,2,3)
plot(-500:2500,nanmean(allROC.contrastim.stim(find(keeper),:)),'r',-500:2500,nanmean(allROC.contrastim.nostim(find(keeper),:)),'--r', ...
    -500:2500,nanmean(allROC.ipsistim.stim(find(keeper),:)),'b',-500:2500,nanmean(allROC.ipsistim.nostim(find(keeper),:)),'--b')
xlim([-50 400])







%for truncated signals (keeper selection done on non-truncated signals
figure
subplot(2,2,1)
plot(-500:2500,nanmean(allwf_trunc.contrastim.contra_stim(find(keeper),:)),'r',-500:2500,nanmean(allwf_trunc.contrastim.ipsi_stim(find(keeper),:)),'--r', ...
    -500:2500,nanmean(allwf_trunc.contrastim.contra_nostim(find(keeper),:)),'b',-500:2500,nanmean(allwf_trunc.contrastim.ipsi_nostim(find(keeper),:)),'--b')
xlim([-50 400])
axis ij
title('contra to stim')
 
subplot(2,2,2)
plot(-500:2500,nanmean(allwf_trunc.ipsistim.contra_stim(find(keeper),:)),'r',-500:2500,nanmean(allwf_trunc.ipsistim.ipsi_stim(find(keeper),:)),'--r', ...
    -500:2500,nanmean(allwf_trunc.ipsistim.contra_nostim(find(keeper),:)),'b',-500:2500,nanmean(allwf_trunc.ipsistim.ipsi_nostim(find(keeper),:)),'--b')
xlim([-50 400])
axis ij
title('ipsi to stim')
legend('stim','nostim')
 
subplot(2,2,3)
plot(-500:2500,nanmean(allROC_trunc.contrastim.stim(find(keeper),:)),'r',-500:2500,nanmean(allROC_trunc.contrastim.nostim(find(keeper),:)),'--r', ...
    -500:2500,nanmean(allROC_trunc.ipsistim.stim(find(keeper),:)),'b',-500:2500,nanmean(allROC_trunc.ipsistim.nostim(find(keeper),:)),'--b')
xlim([-50 400])


