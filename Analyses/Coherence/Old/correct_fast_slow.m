%neuron-neuron Tin_vs_Din historgram showing incidence of alpha power
%runs on compiled data
%figure

for sess = 1:size(coh_targ_all.correct_fast,3)
    %if is a nan, move on
    
        %correct by shift predictor
        uncorrected_correct_fast(1:206,1:281,sess) = abs(coh_targ_all.correct_fast(:,:,sess))';% - abs(coh_targ_all_SHIFT.correct_ss2(:,:,sess));
        uncorrected_correct_slow(1:206,1:281,sess) = abs(coh_targ_all.correct_slow(:,:,sess))' ;%- abs(coh_targ_all_SHIFT.correct_ss4(:,:,sess));
                
        corrected_correct_fast(1:206,1:281,sess) = (abs(coh_targ_all.correct_fast(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_fast(:,:,sess)))';
        corrected_correct_slow(1:206,1:281,sess) = (abs(coh_targ_all.correct_slow(:,:,sess)) - abs(coh_targ_all_SHIFT.correct_slow(:,:,sess)))';
         
        %baseline correct
        uncorrected_correct_fast(1:206,1:281,sess) = baseline_correct(uncorrected_correct_fast(:,:,sess),[1 11]); %corresponds to -400:-300
        uncorrected_correct_slow(1:206,1:281,sess) = baseline_correct(uncorrected_correct_slow(:,:,sess),[1 11]);
        
        corrected_correct_fast(1:206,1:281,sess) = baseline_correct(corrected_correct_fast(:,:,sess),[1 11]);
        corrected_correct_slow(1:206,1:281,sess) = baseline_correct(corrected_correct_slow(:,:,sess),[1 11]);
        
%         


		uncorrectedpow_correct_fast_theta(sess,1:21) = mean(uncorrected_correct_fast(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_fast_alpha(sess,1:21) = mean(uncorrected_correct_fast(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_fast_beta(sess,1:21) = mean(uncorrected_correct_fast(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_fast_gamma(sess,1:21) = mean(uncorrected_correct_fast(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        uncorrectedpow_correct_slow_theta(sess,1:21) = mean(uncorrected_correct_slow(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_slow_alpha(sess,1:21) = mean(uncorrected_correct_slow(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_slow_beta(sess,1:21) = mean(uncorrected_correct_slow(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_slow_gamma(sess,1:21) = mean(uncorrected_correct_slow(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        
        correctedpow_correct_fast_theta(sess,1:21) = mean(corrected_correct_fast(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_fast_alpha(sess,1:21) = mean(corrected_correct_fast(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_fast_beta(sess,1:21) = mean(corrected_correct_fast(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_fast_gamma(sess,1:21) = mean(corrected_correct_fast(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_correct_slow_theta(sess,1:21) = mean(corrected_correct_slow(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_slow_alpha(sess,1:21) = mean(corrected_correct_slow(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_slow_beta(sess,1:21) = mean(corrected_correct_slow(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_slow_gamma(sess,1:21) = mean(corrected_correct_slow(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));

end

%for Shift-predictor corrected

figure

subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_correct_fast,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Uncorrected Correct Fast')
z = get(gca,'clim');


subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_correct_slow,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Uncorrected Correct Slow')
set(gca,'clim',z)

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_correct_fast,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Shift-Corrected Correct Fast')
set(gca,'clim',z)

subplot(2,2,4)
imagesc(tout_targ,f_targ,nanmean(corrected_correct_slow,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Shift-Corrected Correct Slow')
set(gca,'clim',z)

[ax h] = suplabel('Time from Target Onset');
set(h,'fontsize',14,'fontweight','bold')
[ax h] = suplabel('Frequency','y');
set(h,'fontsize',14,'fontweight','bold')
% [ax h] = suplabel('Uncorrected Coherence by Set Size','t');
% set(h,'fontsize',14,'fontweight','bold')



 
 
%for uncorrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(uncorrectedpow_correct_fast_theta),'r',0:10:200,nanmean(uncorrectedpow_correct_slow_theta),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 0-7 Hz (Theta)')
legend('Correct Fast','Correct Slow','fontsize',14,'fontweight','bold','location','southeast')
 
subplot(4,1,2)
plot(0:10:200,nanmean(uncorrectedpow_correct_fast_alpha),'r',0:10:200,nanmean(uncorrectedpow_correct_slow_alpha),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 7-12 Hz (Alpha)')
 
 
subplot(4,1,3)
plot(0:10:200,nanmean(uncorrectedpow_correct_fast_beta),'r',0:10:200,nanmean(uncorrectedpow_correct_slow_beta),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 12-30 Hz (Beta)')
 
 
subplot(4,1,4)
plot(0:10:200,nanmean(uncorrectedpow_correct_fast_gamma),'r',0:10:200,nanmean(uncorrectedpow_correct_slow_gamma),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 30-80 Hz (Gamma)')
 
 
 
 
%for corrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(correctedpow_correct_fast_theta),'r',0:10:200,nanmean(correctedpow_correct_slow_theta),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 0-7 Hz (Theta)')
legend('Correct Fast','Correct Slow','fontsize',14,'fontweight','bold','location','southeast')
 
subplot(4,1,2)
plot(0:10:200,nanmean(correctedpow_correct_fast_alpha),'r',0:10:200,nanmean(correctedpow_correct_slow_alpha),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 7-12 Hz (Alpha)')
 
 
subplot(4,1,3)
plot(0:10:200,nanmean(correctedpow_correct_fast_beta),'r',0:10:200,nanmean(correctedpow_correct_slow_beta),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 12-30 Hz (Beta)')
 
 
subplot(4,1,4)
plot(0:10:200,nanmean(correctedpow_correct_fast_gamma),'r',0:10:200,nanmean(correctedpow_correct_slow_gamma),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 30-80 Hz (Gamma)')




