%neuron-neuron Tin_vs_Din historgram showing incidence of alpha power
%runs on compiled data
%figure

for sess = 1:size(coh_targ_all.correct_ss2,3)
    %if is a nan, move on
    
        %correct by shift predictor
        uncorrected_ss2(1:206,1:281,sess) = abs(coh_targ_all.correct_ss2(:,:,sess))' ;% - abs(coh_targ_all_SHIFT.correct_ss2(:,:,sess));
        uncorrected_ss4(1:206,1:281,sess) = abs(coh_targ_all.correct_ss4(:,:,sess))' ;%- abs(coh_targ_all_SHIFT.correct_ss4(:,:,sess));
        uncorrected_ss8(1:206,1:281,sess) = abs(coh_targ_all.correct_ss8(:,:,sess))' ;%- abs(coh_targ_all_SHIFT.correct_ss8(:,:,sess));
        
        corrected_ss2(1:206,1:281,sess) = (abs(coh_targ_all.correct_ss2(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_ss2(:,:,sess)))';
        corrected_ss4(1:206,1:281,sess) = (abs(coh_targ_all.correct_ss4(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_ss4(:,:,sess)))';
        corrected_ss8(1:206,1:281,sess) = (abs(coh_targ_all.correct_ss8(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_ss8(:,:,sess)))';
        
        
        SHIFT_ss2(1:206,1:281,sess) = abs(coh_targ_all_SHIFT.correct_ss2(:,:,sess))' ;
        SHIFT_ss4(1:206,1:281,sess) = abs(coh_targ_all_SHIFT.correct_ss4(:,:,sess))' ;
        SHIFT_ss8(1:206,1:281,sess) = abs(coh_targ_all_SHIFT.correct_ss8(:,:,sess))' ;
%         
        %get power in theta-alpha range
        %get power 
        uncorrectedpow_ss2_theta(sess,1:21) = mean(uncorrected_ss2(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss2_alpha(sess,1:21) = mean(uncorrected_ss2(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss2_beta(sess,1:21) = mean(uncorrected_ss2(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss2_gamma(sess,1:21) = mean(uncorrected_ss2(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        uncorrectedpow_ss4_theta(sess,1:21) = mean(uncorrected_ss4(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss4_alpha(sess,1:21) = mean(uncorrected_ss4(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss4_beta(sess,1:21) = mean(uncorrected_ss4(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss4_gamma(sess,1:21) = mean(uncorrected_ss4(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        uncorrectedpow_ss8_theta(sess,1:21) = mean(uncorrected_ss8(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss8_alpha(sess,1:21) = mean(uncorrected_ss8(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss8_beta(sess,1:21) = mean(uncorrected_ss8(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_ss8_gamma(sess,1:21) = mean(uncorrected_ss8(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_ss2_theta(sess,1:21) = mean(corrected_ss2(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss2_alpha(sess,1:21) = mean(corrected_ss2(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss2_beta(sess,1:21) = mean(corrected_ss2(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss2_gamma(sess,1:21) = mean(corrected_ss2(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_ss4_theta(sess,1:21) = mean(corrected_ss4(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss4_alpha(sess,1:21) = mean(corrected_ss4(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss4_beta(sess,1:21) = mean(corrected_ss4(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss4_gamma(sess,1:21) = mean(corrected_ss4(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_ss8_theta(sess,1:21) = mean(corrected_ss8(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss8_alpha(sess,1:21) = mean(corrected_ss8(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss8_beta(sess,1:21) = mean(corrected_ss8(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_ss8_gamma(sess,1:21) = mean(corrected_ss8(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        SHIFTpow_ss2_theta(sess,1:21) = mean(SHIFT_ss2(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss2_alpha(sess,1:21) = mean(SHIFT_ss2(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss2_beta(sess,1:21) = mean(SHIFT_ss2(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss2_gamma(sess,1:21) = mean(SHIFT_ss2(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        SHIFTpow_ss4_theta(sess,1:21) = mean(SHIFT_ss4(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss4_alpha(sess,1:21) = mean(SHIFT_ss4(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss4_beta(sess,1:21) = mean(SHIFT_ss4(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss4_gamma(sess,1:21) = mean(SHIFT_ss4(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        SHIFTpow_ss8_theta(sess,1:21) = mean(SHIFT_ss8(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss8_alpha(sess,1:21) = mean(SHIFT_ss8(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss8_beta(sess,1:21) = mean(SHIFT_ss8(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        SHIFTpow_ss8_gamma(sess,1:21) = mean(SHIFT_ss8(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        

end

%for Shift-predictor corrected

figure

subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_ss2,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 2')
z = get(gca,'clim');


subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_ss4,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 4')
set(gca,'clim',z)

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(uncorrected_ss8,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 8')
set(gca,'clim',z)

[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Uncorrected Coherence by Set Size','t');
set(h,'fontsize',14,'fontweight','bold')



%for uncorrected
figure

subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(corrected_ss2,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 2')
z = get(gca,'clim');


subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(corrected_ss4,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 4')
set(gca,'clim',z)

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_ss8,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 8')
set(gca,'clim',z)

[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Shift-Corrected Coherence by Set Size','t');
set(h,'fontsize',14,'fontweight','bold')

 
%for uncorrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(uncorrectedpow_ss2_theta),'r',0:10:200,nanmean(uncorrectedpow_ss4_theta),'k',0:10:200,nanmean(uncorrectedpow_ss8_theta),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 0-7 Hz (Theta)')
legend('Set Size 2','Set Size 4','Set Size 8','fontsize',14,'fontweight','bold','location','southeast')
 
 
subplot(4,1,2)
plot(0:10:200,nanmean(uncorrectedpow_ss2_alpha),'r',0:10:200,nanmean(uncorrectedpow_ss4_alpha),'k',0:10:200,nanmean(uncorrectedpow_ss8_alpha),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 7-12 Hz (Alpha)')
 
subplot(4,1,3)
plot(0:10:200,nanmean(uncorrectedpow_ss2_beta),'r',0:10:200,nanmean(uncorrectedpow_ss4_beta),'k',0:10:200,nanmean(uncorrectedpow_ss8_beta),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 12-30 Hz (Beta)')
 
subplot(4,1,4)
plot(0:10:200,nanmean(uncorrectedpow_ss2_gamma),'r',0:10:200,nanmean(uncorrectedpow_ss4_gamma),'k',0:10:200,nanmean(uncorrectedpow_ss8_gamma),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 30-80 Hz (Gamma)')
% subplot(1,2,2)
% plot(-500:2500,nanmean(wf_sig2_targ_all.correct_ss2),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_ss4),'k',-500:2500,nanmean(wf_sig2_targ_all.correct_ss8),'b','linewidth',2)
% xlim([-100 500])
% fon
% title('Grand Average LFP')
% ylabel('Spikes / sec')
% axis ij
 
[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')
 
 
 
 
%for corrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(correctedpow_ss2_theta),'r',0:10:200,nanmean(correctedpow_ss4_theta),'k',0:10:200,nanmean(correctedpow_ss8_theta),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 0-7 Hz (Theta)')
legend('Set Size 2','Set Size 4','Set Size 8','fontsize',14,'fontweight','bold','location','southeast')
 
 
subplot(4,1,2)
plot(0:10:200,nanmean(correctedpow_ss2_alpha),'r',0:10:200,nanmean(correctedpow_ss4_alpha),'k',0:10:200,nanmean(correctedpow_ss8_alpha),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 7-12 Hz (Alpha)')
 
subplot(4,1,3)
plot(0:10:200,nanmean(correctedpow_ss2_beta),'r',0:10:200,nanmean(correctedpow_ss4_beta),'k',0:10:200,nanmean(correctedpow_ss8_beta),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 12-30 Hz (Beta)')
 
subplot(4,1,4)
plot(0:10:200,nanmean(correctedpow_ss2_gamma),'r',0:10:200,nanmean(correctedpow_ss4_gamma),'k',0:10:200,nanmean(correctedpow_ss8_gamma),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 30-80 Hz (Gamma)')
% subplot(1,2,2)
% plot(-500:2500,nanmean(wf_sig2_targ_all.correct_ss2),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_ss4),'k',-500:2500,nanmean(wf_sig2_targ_all.correct_ss8),'b','linewidth',2)
% xlim([-100 500])
% fon
% title('Grand Average LFP')
% ylabel('Spikes / sec')
% axis ij
 
[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')
 
 



%for uncorrected frequency bands across sessions
figure
subplot(2,2,1)
plot(0:10:200,uncorrectedpow_ss2_theta)
ylim([-.25 .7])
fon
title('Set Size 2')

subplot(2,2,2)
plot(0:10:200,uncorrectedpow_ss4_theta)
ylim([-.25 .7])
fon
title('Set Size 4')

subplot(2,2,3)
plot(0:10:200,uncorrectedpow_ss8_theta)
ylim([-.25 .7])
fon
title('Set Size 8')
[ax h] = suplabel('UNCORRECTED Delta-Theta Band Power','t');
set(h,'fontsize',14,'fontweight','bold')



%for corrected frequency bands across sessions
figure
subplot(2,2,1)
plot(0:10:200,correctedpow_ss2_theta)
ylim([-.25 .7])
fon
title('Set Size 2')

subplot(2,2,2)
plot(0:10:200,correctedpow_ss4_theta)
ylim([-.25 .7])
fon
title('Set Size 4')

subplot(2,2,3)
plot(0:10:200,correctedpow_ss8_theta)
ylim([-.25 .7])
fon
title('Set Size 8')
[ax h] = suplabel('SHIFT-CORRECTED Delta-Theta Band Power','t');
set(h,'fontsize',14,'fontweight','bold')


%for shift predictor frequency bands across sessions
figure
subplot(2,2,1)
plot(0:10:200,SHIFTpow_ss2_theta)
ylim([-.25 .7])
fon
title('Set Size 2')

subplot(2,2,2)
plot(0:10:200,SHIFTpow_ss4_theta)
ylim([-.25 .7])
fon
title('Set Size 4')

subplot(2,2,3)
plot(0:10:200,SHIFTpow_ss8_theta)
ylim([-.25 .7])
fon
title('Set Size 8')

[ax h] = suplabel('SHIFT PREDICTOR Delta-Theta Band Power','t');
set(h,'fontsize',14,'fontweight','bold')


%=========================
% Histogram 50-150 ms post-target
% uncorrected_ss2_theta_hist = nanmean(uncorrectedpow_ss2_theta,2);
% uncorrected_ss4_theta_hist = nanmean(uncorrectedpow_ss4_theta,2);
% uncorrected_ss8_theta_hist = nanmean(uncorrectedpow_ss8_theta,2);
% 
% uncorrected_ss2_alpha_hist = nanmean(uncorrectedpow_ss2_alpha,2);
% uncorrected_ss4_alpha_hist = nanmean(uncorrectedpow_ss4_alpha,2);
% uncorrected_ss8_alpha_hist = nanmean(uncorrectedpow_ss8_alpha,2);
% 
% uncorrected_ss2_beta_hist = nanmean(uncorrectedpow_ss2_beta,2);
% uncorrected_ss4_beta_hist = nanmean(uncorrectedpow_ss4_beta,2);
% uncorrected_ss8_beta_hist = nanmean(uncorrectedpow_ss8_beta,2);
% 
% uncorrected_ss2_gamma_hist = nanmean(uncorrectedpow_ss2_gamma,2);
% uncorrected_ss4_gamma_hist = nanmean(uncorrectedpow_ss4_gamma,2);
% uncorrected_ss8_gamma_hist = nanmean(uncorrectedpow_ss8_gamma,2);
% 
% corrected_ss2_theta_hist = nanmean(correctedpow_ss2_theta,2);
% corrected_ss4_theta_hist = nanmean(correctedpow_ss4_theta,2);
% corrected_ss8_theta_hist = nanmean(correctedpow_ss8_theta,2);
%  
% corrected_ss2_alpha_hist = nanmean(correctedpow_ss2_alpha,2);
% corrected_ss4_alpha_hist = nanmean(correctedpow_ss4_alpha,2);
% corrected_ss8_alpha_hist = nanmean(correctedpow_ss8_alpha,2);
%  
% corrected_ss2_beta_hist = nanmean(correctedpow_ss2_beta,2);
% corrected_ss4_beta_hist = nanmean(correctedpow_ss4_beta,2);
% corrected_ss8_beta_hist = nanmean(correctedpow_ss8_beta,2);
%  
% corrected_ss2_gamma_hist = nanmean(correctedpow_ss2_gamma,2);
% corrected_ss4_gamma_hist = nanmean(correctedpow_ss4_gamma,2);
% corrected_ss8_gamma_hist = nanmean(correctedpow_ss8_gamma,2);



%find sessions with elevated power in the alpha range (not shift-corrected)
%for set size 8
for sess = 1:size(uncorrectedpow_ss8_theta,1)
    if max(uncorrectedpow_ss8_theta(sess,:)) >= .2
        thetaTrials(sess,1) = 1;
    else
        thetaTrials(sess,1) = 0;
    end
end

uncorrected_thetaTrials_ss2 = uncorrected_ss2(:,:,find(thetaTrials));
uncorrected_thetaTrials_ss4 = uncorrected_ss4(:,:,find(thetaTrials));
uncorrected_thetaTrials_ss8 = uncorrected_ss8(:,:,find(thetaTrials));

corrected_thetaTrials_ss2 = corrected_ss2(:,:,find(thetaTrials));
corrected_thetaTrials_ss4 = corrected_ss4(:,:,find(thetaTrials));
corrected_thetaTrials_ss8 = corrected_ss8(:,:,find(thetaTrials));


uncorrectedpow_thetaTrials_ss2 = uncorrectedpow_ss2_alpha(find(thetaTrials),:);
uncorrectedpow_thetaTrials_ss4 = uncorrectedpow_ss4_alpha(find(thetaTrials),:);
uncorrectedpow_thetaTrials_ss8 = uncorrectedpow_ss8_alpha(find(thetaTrials),:);

correctedpow_thetaTrials_ss2 = correctedpow_ss2_theta(find(thetaTrials),:);
correctedpow_thetaTrials_ss4 = correctedpow_ss4_theta(find(thetaTrials),:);
correctedpow_thetaTrials_ss8 = correctedpow_ss8_theta(find(thetaTrials),:);


%test power band
for time = 1:length(0:10:200)
    [p(time) h(time)] = ranksum(uncorrected_thetaTrials_ss2(:,time),uncorrected_thetaTrials_ss4(:,time),'alpha',.01);
end

%Plot coherence limited to trials that actually show theta band power
figure
subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_thetaTrials_ss2,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 2')

subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_thetaTrials_ss4,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 4')

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(uncorrected_thetaTrials_ss8,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 8')

z = get(gca,'clim');
subplot(2,2,1)
set(gca,'clim',z)
subplot(2,2,2)
set(gca,'clim',z)

[ax h] = suplabel('Center of Time Window');
set(h,'fontsize',14,'fontweight','bold')

[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')

[ax h] = suplabel('Uncorrected','t');




%Plot coherence limited to trials that actually show theta band power
figure
subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(corrected_thetaTrials_ss2,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 2')

subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(corrected_thetaTrials_ss4,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 4')

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_thetaTrials_ss8,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Set Size 8')

z = get(gca,'clim');
subplot(2,2,1)
set(gca,'clim',z)
subplot(2,2,2)
set(gca,'clim',z)

[ax h] = suplabel('Center of Time Window');
set(h,'fontsize',14,'fontweight','bold')

[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')

[ax h] = suplabel('Corrected','t');