%neuron-neuron Tin_vs_Din historgram showing incidence of alpha power
%runs on compiled data
%figure

for sess = 1:size(coh_targ_all.correct,3)
    %if is a nan, move on
    
        %NOTE: using transposed matrices
        uncorrected_correct(1:206,1:281,sess) = abs(coh_targ_all.correct(:,:,sess))';% - abs(coh_targ_all_SHIFT.correct_ss2(:,:,sess));
        uncorrected_errors(1:206,1:281,sess) = abs(coh_targ_all.errors(:,:,sess))' ;%- abs(coh_targ_all_SHIFT.correct_ss4(:,:,sess));
                
        corrected_correct(1:206,1:281,sess) = (abs(coh_targ_all.correct(:,:,sess)) - abs(coh_targ_all_SHIFT.correct(:,:,sess)))';
        corrected_errors(1:206,1:281,sess) = (abs(coh_targ_all.errors(:,:,sess)) - abs(coh_targ_all_SHIFT.errors(:,:,sess)))';
         
        %baseline correct
        uncorrected_correct(1:206,1:281,sess) = baseline_correct(uncorrected_correct(:,:,sess),[1 11]); %corresponds to -400:-300
        uncorrected_errors(1:206,1:281,sess) = baseline_correct(uncorrected_errors(:,:,sess),[1 11]);
        
        corrected_correct(1:206,1:281,sess) = baseline_correct(corrected_correct(:,:,sess),[1 11]);
        corrected_errors(1:206,1:281,sess) = baseline_correct(corrected_errors(:,:,sess),[1 11]);
        
%         
        %get power in theta-alpha range

        uncorrectedpow_correct_theta(sess,1:21) = mean(uncorrected_correct(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_alpha(sess,1:21) = mean(uncorrected_correct(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_beta(sess,1:21) = mean(uncorrected_correct(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_correct_gamma(sess,1:21) = mean(uncorrected_correct(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        uncorrectedpow_errors_theta(sess,1:21) = mean(uncorrected_errors(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_alpha(sess,1:21) = mean(uncorrected_errors(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_beta(sess,1:21) = mean(uncorrected_errors(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_gamma(sess,1:21) = mean(uncorrected_errors(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        
        correctedpow_correct_theta(sess,1:21) = mean(corrected_correct(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_alpha(sess,1:21) = mean(corrected_correct(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_beta(sess,1:21) = mean(corrected_correct(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_correct_gamma(sess,1:21) = mean(corrected_correct(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_errors_theta(sess,1:21) = mean(corrected_errors(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_alpha(sess,1:21) = mean(corrected_errors(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_beta(sess,1:21) = mean(corrected_errors(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_gamma(sess,1:21) = mean(corrected_errors(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
end

%for Shift-predictor corrected

figure

subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_correct,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Uncorrected Correct')
z = get(gca,'clim');


subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_errors,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Uncorrected Errors')
set(gca,'clim',z)

subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_correct,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Shift-Corrected Correct')
set(gca,'clim',z)

subplot(2,2,4)
imagesc(tout_targ,f_targ,nanmean(corrected_errors,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Shift-Corrected Errors')
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
plot(0:10:200,nanmean(uncorrectedpow_correct_theta),'r',0:10:200,nanmean(uncorrectedpow_errors_theta),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 0-7 Hz (Theta)')
legend('Correct','Errors','fontsize',14,'fontweight','bold','location','southeast')
 
subplot(4,1,2)
plot(0:10:200,nanmean(uncorrectedpow_correct_alpha),'r',0:10:200,nanmean(uncorrectedpow_errors_alpha),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 7-12 Hz (Alpha)')


subplot(4,1,3)
plot(0:10:200,nanmean(uncorrectedpow_correct_beta),'r',0:10:200,nanmean(uncorrectedpow_errors_beta),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 12-30 Hz (Beta)')


subplot(4,1,4)
plot(0:10:200,nanmean(uncorrectedpow_correct_gamma),'r',0:10:200,nanmean(uncorrectedpow_errors_gamma),'b','linewidth',2)
xlim([-10 210])
fon
title('Uncorrected Coherence 30-80 Hz (Gamma)')




%for corrected frequency bands
figure
subplot(4,1,1)
plot(0:10:200,nanmean(correctedpow_correct_theta),'r',0:10:200,nanmean(correctedpow_errors_theta),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 0-7 Hz (Theta)')
legend('Correct','Errors','fontsize',14,'fontweight','bold','location','southeast')
 
subplot(4,1,2)
plot(0:10:200,nanmean(correctedpow_correct_alpha),'r',0:10:200,nanmean(correctedpow_errors_alpha),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 7-12 Hz (Alpha)')


subplot(4,1,3)
plot(0:10:200,nanmean(correctedpow_correct_beta),'r',0:10:200,nanmean(correctedpow_errors_beta),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 12-30 Hz (Beta)')


subplot(4,1,4)
plot(0:10:200,nanmean(correctedpow_correct_gamma),'r',0:10:200,nanmean(correctedpow_errors_gamma),'b','linewidth',2)
xlim([-10 210])
fon
title('Corrected Coherence 30-80 Hz (Gamma)')
