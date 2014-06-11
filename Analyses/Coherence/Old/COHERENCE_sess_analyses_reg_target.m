%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

cd /volumes/dump2/Coherence/Matrices/LFP-LFP/WithinHemi
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');

%preallocate
coh_correct_all(1:281,1:206,1:length(batch_list)) = NaN;
coh_errors_all(1:281,1:206,1:length(batch_list)) = NaN;
spec1_correct_all(1:281,1:206,1:length(batch_list)) = NaN;
spec2_correct_all(1:281,1:206,1:length(batch_list)) = NaN;
spec1_errors_all(1:281,1:206,1:length(batch_list)) = NaN;
spec2_errors_all(1:281,1:206,1:length(batch_list)) = NaN;
cor_correct_all(1:length(batch_list),1:401) = NaN;
cor_errors_all(1:length(batch_list),1:401) = NaN;

for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'coh_correct','coh_errors','cor_correct','cor_errors','freqind','freqvals','spec1_correct','spec1_errors','spec2_correct','spec2_errors','tind','tvals')
    
    coh_correct_all(1:281,1:206,i) = coh_correct;
    coh_errors_all(1:281,1:206,i) = coh_errors;
    spec1_correct_all(1:281,1:206,i) = spec1_correct;
    spec2_correct_all(1:281,1:206,i) = spec2_correct;
    spec1_errors_all(1:281,1:206,i) = spec1_errors;
    spec2_errors_all(1:281,1:206,i) = spec2_errors;
    cor_correct_all(i,1:401) = nanmean(cor_correct);
    cor_errors_all(i,1:401) = nanmean(cor_errors);
    
    
    clear coh_correct coh_errors spec1_correct spec2_correct ...
        spec1_errors spec2_errors cor_correct cor_errors
end
clear batch_list i

figure
set(gcf,'color','white')
orient landscape
subplot(2,2,1)
imagesc(nanmean(abs(coh_correct_all),3)')
axis xy
colorbar
axhand = gca;
set(axhand,'YTickLabel',freqvals);
set(axhand,'YTick',freqind);
set(axhand,'XTickLabel',tvals);
set(axhand,'XTick',tind);
title('Mean Coherence - Correct')

subplot(2,2,2)
imagesc(nanmean(abs(coh_errors_all),3)')
axis xy
colorbar
axhand = gca;
set(axhand,'YTickLabel',freqvals);
set(axhand,'YTick',freqind);
set(axhand,'XTickLabel',tvals);
set(axhand,'XTick',tind);
title('Mean Coherence - Errors')

subplot(2,2,3)
plot(-200:200,nanmean(cor_correct_all),'r',-200:200,nanmean(cor_errors_all),'b')
legend('Correct','Errors')
title('Correlogram')
xlabel('Lag')
ylabel('r')