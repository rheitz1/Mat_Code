%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all
plotFlag = 0;

cd /volumes/Dump2/Coherence/RFoverlap/Matrices/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');



%due to size of matrices, am going to separately save

%=========================================================

%preallocate
coh_targ_all.correct_in(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_out(1:281,1:206,1:length(batch_list)) = NaN;
spec1_targ_all.correct_in(1:281,1:206,1:length(batch_list)) = NaN;
spec1_targ_all.correct_out(1:281,1:206,1:length(batch_list)) = NaN;
spec2_targ_all.correct_in(1:281,1:206,1:length(batch_list)) = NaN;
spec2_targ_all.correct_out(1:281,1:206,1:length(batch_list)) = NaN;
wf_sig1_targ_all.correct_in(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_out(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_in(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_out(1:length(batch_list),1:3001) = NaN;
n_all.correct_in(1:length(batch_list),1) = NaN;
n_all.correct_out(1:length(batch_list),1) = NaN;


for sess = 1:length(batch_list)
    sess
    
    f_list{sess,1} = batch_list(sess).name;
    
    load(batch_list(sess).name,'coh_targ','n','spec1_targ', ...
        'spec2_targ','wf_sig1_targ','wf_sig2_targ','-mat')

    coh_targ_all.correct_in(1:281,1:206,sess) = coh_targ.correct_in;
    coh_targ_all.correct_out(1:281,1:206,sess) = coh_targ.correct_out;
    spec1_targ_all.correct_in(1:281,1:206,sess) = spec1_targ.correct_in;
    spec1_targ_all.correct_out(1:281,1:206,sess) = spec1_targ.correct_out;
    spec2_targ_all.correct_in(1:281,1:206,sess) = spec2_targ.correct_in;
    spec2_targ_all.correct_out(1:281,1:206,sess) = spec2_targ.correct_out;
    n_all.correct_in = n.correct_in;
    n_all.correct_out = n.correct_out;
    wf_sig1_targ_all.correct_in(sess,1:3001) = wf_sig1_targ.correct_in;
    wf_sig1_targ_all.correct_out(sess,1:3001) = wf_sig1_targ.correct_out;
    wf_sig2_targ_all.correct_in(sess,1:3001) = wf_sig2_targ.correct_in;
    wf_sig2_targ_all.correct_out(sess,1:3001) = wf_sig2_targ.correct_out;
end
%forgot to save tout and f in matrices

cd /volumes/Dump2/Coherence/RFoverlap/
load('f.mat')

tout = -400:10:2400;

keep *_all f_targ tout f_list plotFlag
%==================================================

%take baselines

for sess = 1:size(coh_targ_all.correct_in,3);
    sess
    coh_rot_in = abs(coh_targ_all.correct_in(:,:,sess)');
    coh_rot_out = abs(coh_targ_all.correct_out(:,:,sess)');
    %take mean of -400:-300 which is first 11 columns in rotated coherence
    %matrix
    coh_in_base = repmat(nanmean(coh_rot_in(:,1:11),2),1,281);
    coh_out_base = repmat(nanmean(coh_rot_out(:,1:11),2),1,281);

    coh_targ_all_bc.correct_in(1:206,1:281,sess) = coh_rot_in - coh_in_base;
    coh_targ_all_bc.correct_out(1:206,1:281,sess) = coh_rot_out - coh_out_base;

    
    av_power_in(sess,1:length(tout)) = nanmean(coh_rot_in(find(f_targ >=0 & f_targ <= 10),:));
    av_power_out(sess,1:length(tout)) = nanmean(coh_rot_out(find(f_targ >=0 & f_targ <= 10),:));

    av_power_in_bc(sess,1:length(tout)) = nanmean(coh_targ_all_bc.correct_in(find(f_targ >=0 & f_targ <= 10),:,sess));
    av_power_out_bc(sess,1:length(tout)) = nanmean(coh_targ_all_bc.correct_out(find(f_targ >=0 & f_targ <= 10),:,sess));

    av_diff(sess,1:length(tout)) = av_power_in(sess,:) - av_power_out(sess,:);

    %calculate approximate onset time - use 2 sd above diff wave
    crit = 2*std(av_diff(sess,:));
    try
        time(sess,1) = tout(find(av_diff(sess,:) > crit,1));
    catch
        time(sess,1) = NaN;
    end
    
    if plotFlag == 1
    plot(tout,av_diff(sess,:))
    line([1 1000],[crit crit])
    title(time(sess,1))
    pause
    cla
    end
end


