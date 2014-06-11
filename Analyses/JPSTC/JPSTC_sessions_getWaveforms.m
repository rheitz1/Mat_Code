%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all
cd /volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_vs_errors_postsaccade_truncated/LFP-LFP/
batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_vs_errors_postsaccade_truncated/LFP-LFP/*.mat');
%batch_list = dir('/volumes/dump2/analyses/JPSTC/JPSTC_matrices/reg/correct_vs_errors_postsaccade/LFP-LFP/*.mat');
%batch_list2 = dir('/volumes/dump/analyses/JPSTC_Final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/Bad-Spurious/*.mat');
%batch_list = cat(1,batch_list1,batch_list2);


%initialize between-session variables
wf_sig1_correct_all(1:length(batch_list),1:451) = NaN;
wf_sig1_errors_all(1:length(batch_list),1:451) = NaN;
wf_sig2_correct_all(1:length(batch_list),1:451) = NaN;
wf_sig2_errors_all(1:length(batch_list),1:451) = NaN;
for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'wf_sig1_correct_saccade','wf_sig1_errors_saccade','wf_sig2_correct_saccade','wf_sig2_errors_saccade','-mat')
    
    wf_sig1_correct_all(i,1:451) = wf_sig1_correct_saccade;
    wf_sig1_errors_all(i,1:451) = wf_sig1_errors_saccade;
    wf_sig2_correct_all(i,1:451) = wf_sig2_correct_saccade;
    wf_sig2_errors_all(i,1:451) = wf_sig2_errors_saccade;
    
end
clear batch_list i