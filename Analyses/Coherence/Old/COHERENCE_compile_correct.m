%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

cd /volumes/dump2/Coherence/Uber/Matrices/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');


%due to size of matrices, am going to separately save 

%=========================================================

%preallocate
coh_targ_all.correct(1:281,1:206,1:length(batch_list)) = NaN;
%coh_resp_all.correct(1:71,1:206,1:length(batch_list)) = NaN;

%spec1_targ_all.correct(1:281,1:206,1:length(batch_list)) = NaN;
%spec1_resp_all.correct(1:71,1:206,1:length(batch_list)) = NaN;

%spec2_targ_all.correct(1:281,1:206,1:length(batch_list)) = NaN;
%spec2_resp_all.correct(1:71,1:206,1:length(batch_list)) = NaN;

%Note: error in coherence code accidentally set sig1_resp_correct and
%sig1_resp_errors to x_targ_x.

wf_sig1_targ_all.correct(1:length(batch_list),1:3001) = NaN;
%wf_sig1_resp_all.correct(1:length(batch_list),1:901) = NaN;
wf_sig2_targ_all.correct(1:length(batch_list),1:3001) = NaN;
%wf_sig2_resp_all.correct(1:length(batch_list),1:901) = NaN;
n_all.correct(1:length(batch_list),1) = NaN;


for sess = 1:length(batch_list)
    sess
    load(batch_list(sess).name,'coh_targ','coh_resp','f_resp','f_targ','n', ...
        'spec1_resp','spec1_targ','spec2_resp','spec2_targ','tout_resp','tout_targ', ...
        'wf_sig1_resp','wf_sig1_targ','wf_sig2_resp','wf_sig2_targ','-mat')
    
    coh_targ_all.correct(1:281,1:206,sess) = coh_targ.correct;
 %   coh_resp_all.correct(1:71,1:206,sess) = coh_resp.correct;
    
 %   spec1_targ_all.correct(1:281,1:206,sess) = spec1_targ.correct;
  %  spec1_resp_all.correct(1:71,1:206,sess) = spec1_resp.correct;
    
  %  spec2_targ_all.correct(1:281,1:206,sess) = spec2_targ.correct;
   % spec2_resp_all.correct(1:71,1:206,sess) = spec2_resp.correct;
    
    wf_sig1_targ_all.correct(sess,1:3001) = wf_sig1_targ.correct;
   % wf_sig1_resp_all.correct(sess,1:901) = wf_sig1_resp.correct;
    
    wf_sig2_targ_all.correct(sess,1:3001) = wf_sig2_targ.correct;
   % wf_sig2_resp_all.correct(sess,1:901) = wf_sig2_resp.correct;
    
    n_all.correct(sess,1) = n.correct;
    clear coh_targ coh_resp spec1_targ spec1_resp spec2_targ spec2_resp ...
        wf_sig1_targ wf_sig1_resp wf_sig2_targ wf_sig2_resp n
end
clear batch_list i
