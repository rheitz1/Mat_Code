%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-errors_slowed)
clear all
 
cd /volumes/dump2/Coherence/Uber/Matrices/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/errors_slow_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');
 
 
%due to size of matrices, am going to separately save 
 
%=========================================================
 
%preallocate
coh_targ_all.errors_slow(1:281,1:206,1:length(batch_list)) = NaN;
coh_resp_all.errors_slow(1:71,1:206,1:length(batch_list)) = NaN;
 
spec1_targ_all.errors_slow(1:281,1:206,1:length(batch_list)) = NaN;
spec1_resp_all.errors_slow(1:71,1:206,1:length(batch_list)) = NaN;
 
spec2_targ_all.errors_slow(1:281,1:206,1:length(batch_list)) = NaN;
spec2_resp_all.errors_slow(1:71,1:206,1:length(batch_list)) = NaN;
 
%Note: error in coherence code accidentally set sig1_resp_errors_slow and
%sig1_resp_errors_slow to x_targ_x.
 
wf_sig1_targ_all.errors_slow(1:length(batch_list),1:3001) = NaN;
wf_sig1_resp_all.errors_slow(1:length(batch_list),1:901) = NaN;
wf_sig2_targ_all.errors_slow(1:length(batch_list),1:3001) = NaN;
wf_sig2_resp_all.errors_slow(1:length(batch_list),1:901) = NaN;
n_all.errors_slow(1:length(batch_list),1) = NaN;
 
 
for sess = 1:length(batch_list)
    sess
    load(batch_list(sess).name,'coh_targ','coh_resp','f_resp','f_targ','n', ...
        'spec1_resp','spec1_targ','spec2_resp','spec2_targ','tout_resp','tout_targ', ...
        'wf_sig1_resp','wf_sig1_targ','wf_sig2_resp','wf_sig2_targ','-mat')
    
    coh_targ_all.errors_slow(1:281,1:206,sess) = coh_targ.errors_slow;
    coh_resp_all.errors_slow(1:71,1:206,sess) = coh_resp.errors_slow;
    
    spec1_targ_all.errors_slow(1:281,1:206,sess) = spec1_targ.errors_slow;
    spec1_resp_all.errors_slow(1:71,1:206,sess) = spec1_resp.errors_slow;
    
    spec2_targ_all.errors_slow(1:281,1:206,sess) = spec2_targ.errors_slow;
    spec2_resp_all.errors_slow(1:71,1:206,sess) = spec2_resp.errors_slow;
    
    wf_sig1_targ_all.errors_slow(sess,1:3001) = wf_sig1_targ.errors_slow;
    wf_sig1_resp_all.errors_slow(sess,1:901) = wf_sig1_resp.errors_slow;
    
    wf_sig2_targ_all.errors_slow(sess,1:3001) = wf_sig2_targ.errors_slow;
    wf_sig2_resp_all.errors_slow(sess,1:901) = wf_sig2_resp.errors_slow;
    
    n_all.errors_slow(sess,1) = n.errors_slow;
    clear coh_targ coh_resp spec1_targ spec1_resp spec2_targ spec2_resp ...
        wf_sig1_targ wf_sig1_resp wf_sig2_targ wf_sig2_resp n
end
clear batch_list i
 
 

