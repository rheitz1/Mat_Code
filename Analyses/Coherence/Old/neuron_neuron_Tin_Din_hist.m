%neuron-neuron Tin_vs_Din historgram showing incidence of alpha power
%runs on compiled data
%figure

for sess = 1:size(coh_targ_all.correct_Tin,3)
    %if is a nan, move on
    
        %not corrected by shift predictor
        uncorrected_in(1:206,1:281,sess) = abs(coh_targ_all.correct_Tin(:,:,sess))';% - abs(coh_targ_all_SHIFT.correct_Tin(:,:,sess));
        uncorrected_out(1:206,1:281,sess) = abs(coh_targ_all.correct_Din(:,:,sess))';% - abs(coh_targ_all_SHIFT.correct_Din(:,:,sess));
        
        
        %correct by shift predictor
        corrected_in(1:206,1:281,sess) = (abs(coh_targ_all.correct_Tin(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_Tin(:,:,sess)))';
        corrected_out(1:206,1:281,sess) = (abs(coh_targ_all.correct_Din(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_Din(:,:,sess)))';
        
        SHIFT_in(1:206,1:281,sess) = abs(coh_targ_all_SHIFT.correct_Tin(:,:,sess))';
        SHIFT_out(1:206,1:281,sess) = abs(coh_targ_all_SHIFT.correct_Din(:,:,sess))';

        
        uncorrectedpow_Tin_theta(sess,1:21) = mean(uncorrected_in(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_Tin_alpha(sess,1:21) = mean(uncorrected_in(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_Tin_beta(sess,1:21) = mean(uncorrected_in(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_Tin_gamma(sess,1:21) = mean(uncorrected_in(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        uncorrectedpow_Din_theta(sess,1:21) = mean(uncorrected_out(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_Din_alpha(sess,1:21) = mean(uncorrected_out(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_Din_beta(sess,1:21) = mean(uncorrected_out(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_Din_gamma(sess,1:21) = mean(uncorrected_out(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_Tin_theta(sess,1:21) = mean(corrected_in(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_Tin_alpha(sess,1:21) = mean(corrected_in(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_Tin_beta(sess,1:21) = mean(corrected_in(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_Tin_gamma(sess,1:21) = mean(corrected_in(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_Din_theta(sess,1:21) = mean(corrected_out(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_Din_alpha(sess,1:21) = mean(corrected_out(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_Din_beta(sess,1:21) = mean(corrected_out(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_Din_gamma(sess,1:21) = mean(corrected_out(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        SHIFTpow_Tin_theta(sess,1:21) = mean(SHIFT_in(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_Tin_alpha(sess,1:21) = mean(SHIFT_in(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_Tin_beta(sess,1:21) = mean(SHIFT_in(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_Tin_gamma(sess,1:21) = mean(SHIFT_in(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        SHIFTpow_Din_theta(sess,1:21) = mean(SHIFT_out(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_Din_alpha(sess,1:21) = mean(SHIFT_out(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_Din_beta(sess,1:21) = mean(SHIFT_out(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_Din_gamma(sess,1:21) = mean(SHIFT_out(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        

end


%Wilcoxon test of alpha band SHIFT PREDICTOR coherence

%find non-nan sessions (sessions where neurons had overlapping RFs
for sess = 1:size(coh_targ_all.correct_Tin,3)
    if ~isnan(coh_targ_all.correct_Tin(1,1,sess)) & ~isnan(coh_targ_all.correct_Din(1,1,sess))
        yesCoh(sess) = 1;
    else
        yesCoh(sess) = 0;
    end
end

%test SHIFT PRED power in alpha band
for time = 1:length(0:10:200)
    [p(time) h(time)] = ranksum(SHIFTpow_Tin_alpha(find(yesCoh),time),SHIFTpow_Din_alpha(find(yesCoh),time),'alpha',.05);
end

%test Corrected Coh power in alpha band
for time = 1:length(0:10:200)
    [p(time) h(time)] = ranksum(correctedpow_Tin_alpha(find(yesCoh),time),correctedpow_Din_alpha(find(yesCoh),time),'alpha',.05);
end




figure

subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_in,3))
axis xy
xlim([-100 500])
ylim([0 100])
z = get(gca,'clim');
zz = get(gca,'clim'); %use this for plot of SHIFT PRED coherence clims
colorbar
fon
title('Uncorrected Target in RF')

subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_out,3))
axis xy
xlim([-100 500])
ylim([0 100])
set(gca,'clim',z)
colorbar
fon
title('Uncorrected Distractor in RF')

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_in,3))
axis xy
xlim([-100 500])
ylim([0 100])
z = get(gca,'clim');
colorbar
fon
title('Shift-Corrected Target in RF')

subplot(2,2,4)
imagesc(tout_targ,f_targ,nanmean(corrected_out,3))
axis xy
xlim([-100 500])
ylim([0 100])
set(gca,'clim',z)
colorbar
fon
title('Shift-Corrected Distractor in RF')


[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')



%Plot Coherence of SHIFT PREDICTOR and grand average signals
figure
subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(SHIFT_in,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
%color lims set to be same as uncorrected Target in COH lims
set(gca,'clim',zz)
fon
ylabel('Frequency')
title('SHIFT PRED Target in RF')

subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(SHIFT_out,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
set(gca,'clim',zz)
fon
title('SHIFT PRED Distractor in RF')


subplot(2,2,3)
plot(-500:2500,nanmean(wf_sig1_targ_all.correct_Tin),'r',-500:2500,nanmean(wf_sig1_targ_all.correct_Din),'--r','linewidth',2)
xlim([-100 500])
fon
legend('Targ in RF','Dist in RF','location','southeast')
title('Signal 1 Grand Average')
ylabel('Spikes / s')

subplot(2,2,4)
plot(-500:2500,nanmean(wf_sig2_targ_all.correct_Tin),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_Din),'--r','linewidth',2)
xlim([-100 500])
fon
title('Signal 2 Grand Average')
 






%SHIFT PREDICTOR frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(SHIFTpow_Tin_theta),'r',0:10:200,nanmean(SHIFTpow_Din_theta),'--r','linewidth',2)
xlim([-10 210])
fon
title('SHIFT Coherence 0-7 Hz (Theta)')
legend('Target in RF','Distractor in RF','fontsize',14,'fontweight','bold','location','southeast')
 
 
subplot(4,1,2)
plot(0:10:200,nanmean(SHIFTpow_Tin_alpha),'r',0:10:200,nanmean(SHIFTpow_Din_alpha),'--r','linewidth',2)
xlim([-10 210])
fon
title('SHIFT Coherence 7-12 Hz (Alpha)')
 
subplot(4,1,3)
plot(0:10:200,nanmean(SHIFTpow_Tin_beta),'r',0:10:200,nanmean(SHIFTpow_Din_beta),'--r','linewidth',2)
xlim([-10 210])
fon
title('SHIFT Coherence 12-30 Hz (Beta)')
 
subplot(4,1,4)
plot(0:10:200,nanmean(SHIFTpow_Tin_gamma),'r',0:10:200,nanmean(SHIFTpow_Din_gamma),'--r','linewidth',2)
xlim([-10 210])
fon
title('SHIFT Coherence 30-80 Hz (Gamma)')
 
[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')






%for uncorrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(uncorrectedpow_Tin_theta),'r',0:10:200,nanmean(uncorrectedpow_Din_theta),'--r','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 0-7 Hz (Theta)')
legend('Target in RF','Distractor in RF','fontsize',14,'fontweight','bold','location','southeast')
 
 
subplot(4,1,2)
plot(0:10:200,nanmean(uncorrectedpow_Tin_alpha),'r',0:10:200,nanmean(uncorrectedpow_Din_alpha),'--r','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 7-12 Hz (Alpha)')
 
subplot(4,1,3)
plot(0:10:200,nanmean(uncorrectedpow_Tin_beta),'r',0:10:200,nanmean(uncorrectedpow_Din_beta),'--r','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 12-30 Hz (Beta)')
 
subplot(4,1,4)
plot(0:10:200,nanmean(uncorrectedpow_Tin_gamma),'r',0:10:200,nanmean(uncorrectedpow_Din_gamma),'--r','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 30-80 Hz (Gamma)')

[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')

 



%for corrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(correctedpow_Tin_theta),'r',0:10:200,nanmean(correctedpow_Din_theta),'--r','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 0-7 Hz (Theta)')
legend('Target in RF','Distractor in RF','fontsize',14,'fontweight','bold','location','southeast')
 
 
subplot(4,1,2)
plot(0:10:200,nanmean(correctedpow_Tin_alpha),'r',0:10:200,nanmean(correctedpow_Din_alpha),'--r','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 7-12 Hz (Alpha)')
 
subplot(4,1,3)
plot(0:10:200,nanmean(correctedpow_Tin_beta),'r',0:10:200,nanmean(correctedpow_Din_beta),'--r','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 12-30 Hz (Beta)')
 
subplot(4,1,4)
plot(0:10:200,nanmean(correctedpow_Tin_gamma),'r',0:10:200,nanmean(correctedpow_Din_gamma),'--r','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 30-80 Hz (Gamma)')
 
[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')



%plot alpha band power across sessions
figure
plot(0:10:200,uncorrectedpow_Tin_alpha)
fon
title('Uncorrected Alpha Band Power across Sessions')




%now limit analyses to sessions with increased, uncorrected theta band
%power for Target in RF
for sess = 1:size(uncorrectedpow_Tin_theta,1)
    if max(uncorrectedpow_Tin_theta(sess,:)) >= .2
        thetaTrials(sess,1) = 1;
    else
        thetaTrials(sess,1) = 0;
    end
end

figure
subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_in(:,:,find(thetaTrials)),3))
z = get(gca,'clim');
axis xy
colorbar
xlim([-100 500])
ylim([0 100])
fon
title('Uncorrected Target in RF')

subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_out(:,:,find(thetaTrials)),3))
set(gca,'clim',z)
axis xy
colorbar
xlim([-100 500])
ylim([0 100])
fon
title('Uncorrected Distractor in RF')

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_in(:,:,find(thetaTrials)),3))
z = get(gca,'clim');
axis xy
colorbar
xlim([-100 500])
ylim([0 100])
fon
title('Corrected Target in RF')

subplot(2,2,4)
imagesc(tout_targ,f_targ,nanmean(corrected_out(:,:,find(thetaTrials)),3))
set(gca,'clim',z)
axis xy
colorbar
xlim([-100 500])
ylim([0 100])
fon
title('Corrected Distractor in RF')

[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')

maximize

[ax h] = suplabel(['Coherence for sessions with elevated Theta band power (n = ' mat2str(sum(thetaTrials)) ')'],'t');
set(h,'fontsize',14,'fontweight','bold')

