%neuron-neuron Tin_vs_Din historgram showing incidence of alpha power
%runs on compiled data
%figure
 
for sess = 1:size(coh_targ_all.errors_fast,3)
    %if is a nan, move on
    
        %correct by shift predictor
        uncorrected_errors_fast(1:206,1:281,sess) = abs(coh_targ_all.errors_fast(:,:,sess))';% - abs(coh_targ_all_SHIFT.errors_ss2(:,:,sess));
        uncorrected_errors_slow(1:206,1:281,sess) = abs(coh_targ_all.errors_slow(:,:,sess))' ;%- abs(coh_targ_all_SHIFT.errors_ss4(:,:,sess));
                
        corrected_errors_fast(1:206,1:281,sess) = (abs(coh_targ_all.errors_fast(:,:,sess)) - abs(coh_targ_all_SHIFT.errors_fast(:,:,sess)))';
        corrected_errors_slow(1:206,1:281,sess) = (abs(coh_targ_all.errors_slow(:,:,sess)) - abs(coh_targ_all_SHIFT.errors_slow(:,:,sess)))';
         
        %baseline correct
        uncorrected_errors_fast(1:206,1:281,sess) = baseline_correct(uncorrected_errors_fast(:,:,sess),[1 11]); %corresponds to -400:-300
        uncorrected_errors_slow(1:206,1:281,sess) = baseline_correct(uncorrected_errors_slow(:,:,sess),[1 11]);
        
        corrected_errors_fast(1:206,1:281,sess) = baseline_correct(corrected_errors_fast(:,:,sess),[1 11]);
        corrected_errors_slow(1:206,1:281,sess) = baseline_correct(corrected_errors_slow(:,:,sess),[1 11]);
        
%         
 
 
        uncorrectedpow_errors_fast_theta(sess,1:21) = mean(uncorrected_errors_fast(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_fast_alpha(sess,1:21) = mean(uncorrected_errors_fast(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_fast_beta(sess,1:21) = mean(uncorrected_errors_fast(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_fast_gamma(sess,1:21) = mean(uncorrected_errors_fast(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        uncorrectedpow_errors_slow_theta(sess,1:21) = mean(uncorrected_errors_slow(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_slow_alpha(sess,1:21) = mean(uncorrected_errors_slow(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_slow_beta(sess,1:21) = mean(uncorrected_errors_slow(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        uncorrectedpow_errors_slow_gamma(sess,1:21) = mean(uncorrected_errors_slow(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        
        correctedpow_errors_fast_theta(sess,1:21) = mean(corrected_errors_fast(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_fast_alpha(sess,1:21) = mean(corrected_errors_fast(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_fast_beta(sess,1:21) = mean(corrected_errors_fast(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_fast_gamma(sess,1:21) = mean(corrected_errors_fast(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
        
        correctedpow_errors_slow_theta(sess,1:21) = mean(corrected_errors_slow(find(f_targ >= 0 & f_targ <= 7),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_slow_alpha(sess,1:21) = mean(corrected_errors_slow(find(f_targ > 7 & f_targ <= 12),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_slow_beta(sess,1:21) = mean(corrected_errors_slow(find(f_targ > 12 & f_targ <= 30),find(tout_targ >= 0 & tout_targ <= 200),sess));
        correctedpow_errors_slow_gamma(sess,1:21) = mean(corrected_errors_slow(find(f_targ > 30 & f_targ <= 80),find(tout_targ >= 0 & tout_targ <= 200),sess));
 
end
 
%for Shift-predictor corrected
 
figure
 
subplot(2,2,1)
imagesc(tout_targ,f_targ,nanmean(uncorrected_errors_fast,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Uncorrected Correct Fast')
z = get(gca,'clim');
 
 
subplot(2,2,2)
imagesc(tout_targ,f_targ,nanmean(uncorrected_errors_slow,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Uncorrected Correct Slow')
set(gca,'clim',z)
 
subplot(2,2,3)
imagesc(tout_targ,f_targ,nanmean(corrected_errors_fast,3))
axis xy
xlim([-100 500])
ylim([0 100])
colorbar
fon
title('Shift-Corrected Correct Fast')
set(gca,'clim',z)
 
subplot(2,2,4)
imagesc(tout_targ,f_targ,nanmean(corrected_errors_slow,3))
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
 

