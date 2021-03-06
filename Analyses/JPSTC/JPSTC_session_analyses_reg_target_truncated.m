%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

batch_list1 = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_vs_errors_target_truncated/LFP-LFP/BetweenHemi/*.mat');
batch_list2 = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_vs_errors_target_truncated/LFP-LFP/WithinHemi/*.mat');
batch_list = cat(1,batch_list1,batch_list2);

%preallocate
above_close_correct_all(1:length(batch_list),1:251) = NaN;
above_close_errors_all(1:length(batch_list),1:251) = NaN;

below_close_correct_all(1:length(batch_list),1:251) = NaN;
below_close_errors_all(1:length(batch_list),1:251) = NaN;

main_correct_all(1:length(batch_list),1:251) = NaN;
main_errors_all(1:length(batch_list),1:251) = NaN;

thickdiagonal_correct_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_errors_all(1:length(batch_list),1:251) = NaN;

thindiagonal_correct_all(1:length(batch_list),1:251) = NaN;
thindiagonal_errors_all(1:length(batch_list),1:251) = NaN;

JPSTC_correct_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_errors_all(1:451,1:451,1:length(batch_list)) = NaN;

wf_sig1_correct_all(1:length(batch_list),1:451) = NaN;
wf_sig2_correct_all(1:length(batch_list),1:451) = NaN;
wf_sig1_errors_all(1:length(batch_list),1:451) = NaN;
wf_sig2_errors_all(1:length(batch_list),1:451) = NaN;

%ABOVE close & main & thickdiagonal
for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'wf_sig1_correct','wf_sig2_correct','wf_sig1_errors','wf_sig2_errors','JPSTC_correct','JPSTC_errors','above_close_correct','above_close_errors','below_close_correct','below_close_errors','main_correct','main_errors','thickdiagonal_correct','thickdiagonal_errors','t_vector')

    thin_temp(1:3,1:length(t_vector)) = NaN;

    above_close_correct_all(i,1:length(t_vector)) = above_close_correct;
    above_close_errors_all(i,1:length(t_vector)) = above_close_errors;

    below_close_correct_all(i,1:length(t_vector)) = below_close_correct;
    below_close_errors_all(i,1:length(t_vector)) = below_close_errors;

    main_correct_all(i,1:length(t_vector)) = main_correct;
    main_errors_all(i,1:length(t_vector)) = main_errors;

    thickdiagonal_correct_all(i,1:length(t_vector)) = thickdiagonal_correct;
    thickdiagonal_errors_all(i,1:length(t_vector)) = thickdiagonal_errors;

    thin_temp(1,1:length(t_vector)) = below_close_correct;
    thin_temp(2,1:length(t_vector)) = above_close_correct;
    thin_temp(3,1:length(t_vector)) = main_correct;
    thindiagonal_correct_all(i,1:length(t_vector)) = nanmean(thin_temp);

    thin_temp(1,1:length(t_vector)) = below_close_errors;
    thin_temp(2,1:length(t_vector)) = above_close_errors;
    thin_temp(3,1:length(t_vector)) = main_errors;
    thindiagonal_errors_all(i,1:length(t_vector)) = nanmean(thin_temp);

    wf_sig1_correct_all(i,1:451) = wf_sig1_correct;
    wf_sig2_correct_all(i,1:451) = wf_sig2_correct;
    wf_sig1_errors_all(i,1:451) = wf_sig1_errors;
    wf_sig2_errors_all(i,1:451) = wf_sig2_errors;
    
    clear thin_temp

    %mean JPSTC
    JPSTC_correct_all(1:451,1:451,i) = JPSTC_correct;
    JPSTC_errors_all(1:451,1:451,i) = JPSTC_errors;

    clear above_close_correct above_close_errors below_close_correct below_close_errors ...
        main_correct main_errors thickdiagonal_correct thickdiagonal_errors ...
        JPSTC_correct JPSTC_errors wf_sig1_correct wf_sig2_correct ...
        wf_sig1_errors wf_sig2_errors
end
clear batch_list i
