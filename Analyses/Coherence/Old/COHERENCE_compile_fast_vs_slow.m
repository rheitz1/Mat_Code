%batch for across-session Coherence analyses

plotFlag = 1;

cd /volumes/Dump2/Coherence/Uber/Matrices/SPK-SPK/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');



%due to size of matrices, am going to separately save

%=========================================================

%preallocate
coh_targ_all.correct_fast(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_slow(1:281,1:206,1:length(batch_list)) = NaN;
coh_resp_all.correct_fast(1:71,1:206,1:length(batch_list)) = NaN;
coh_resp_all.correct_slow(1:71,1:206,1:length(batch_list)) = NaN;

n_all.correct_fast(1:length(batch_list),1) = NaN;
n_all.correct_slow(1:length(batch_list),1) = NaN;

wf_sig1_targ_all.correct_fast(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_slow(1:length(batch_list),1:3001) = NaN;
wf_sig1_resp_all.correct_fast(1:length(batch_list),1:901) = NaN;
wf_sig1_resp_all.correct_slow(1:length(batch_list),1:901) = NaN;

wf_sig2_targ_all.correct_fast(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_slow(1:length(batch_list),1:3001) = NaN;
wf_sig2_resp_all.correct_fast(1:length(batch_list),1:901) = NaN;
wf_sig2_resp_all.correct_slow(1:length(batch_list),1:901) = NaN;


coh_targ_all_SHIFT.correct_fast(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct_slow(1:281,1:206,1:length(batch_list)) = NaN;
coh_resp_all_SHIFT.correct_fast(1:71,1:206,1:length(batch_list)) = NaN;
coh_resp_all_SHIFT.correct_slow(1:71,1:206,1:length(batch_list)) = NaN;

for sess = 1:length(batch_list)
    sess
    
    f_list{sess,1} = batch_list(sess).name;
    
    load(batch_list(sess).name,'coh_targ','coh_resp','n','wf_sig1_targ','wf_sig2_targ', ...
        'wf_sig1_resp','wf_sig2_resp','tout_targ','tout_resp','f_targ','f_resp','-mat')
    
    
    %TRY to do this: it will fail when Tin or Din does not exist
    try
        coh_targ_all.correct_fast(1:281,1:206,sess) = coh_targ.correct_fast;
        coh_targ_all.correct_slow(1:281,1:206,sess) = coh_targ.correct_slow;
        coh_resp_all.correct_fast(1:71,1:206,sess) = coh_resp.correct_fast;
        coh_resp_all.correct_slow(1:71,1:206,sess) = coh_resp.correct_slow;
        
        n_all.correct_fast(sess,1) = n.correct_fast;
        n_all.correct_slow(sess,1) = n.correct_slow;
        
        wf_sig1_targ_all.correct_fast(sess,1:3001) = wf_sig1_targ.correct_fast;
        wf_sig1_targ_all.correct_slow(sess,1:3001) = wf_sig1_targ.correct_slow;
        wf_sig1_resp_all.correct_fast(sess,1:901) = wf_sig1_resp.correct_fast;
        wf_sig1_resp_all.correct_slow(sess,1:901) = wf_sig1_resp.correct_slow;
        
        wf_sig2_targ_all.correct_fast(sess,1:3001) = wf_sig2_targ.correct_fast;
        wf_sig2_targ_all.correct_slow(sess,1:3001) = wf_sig2_targ.correct_slow;
        wf_sig2_resp_all.correct_fast(sess,1:901) = wf_sig2_resp.correct_fast;
        wf_sig2_resp_all.correct_slow(sess,1:901) = wf_sig2_resp.correct_slow;
    catch
        disp('Skipping...')
        continue
    end
    
    
    %Now get SHIFT PREDICTOR
    
    keep *_all* tout_targ tout_resp f_targ f_resp plotFlag sess batch_list
    
    try %if missing data file, skip
        load([batch_list(sess).name(1:end-4) '_SHIFT_PREDICTOR.mat'],'coh_targ','coh_resp','-mat')
        
        coh_targ_all_SHIFT.correct_fast(1:281,1:206,sess) = coh_targ.correct_fast;
        coh_targ_all_SHIFT.correct_slow(1:281,1:206,sess) = coh_targ.correct_slow;
        
        coh_resp_all_SHIFT.correct_fast(1:71,1:206,sess) = coh_resp.correct_fast;
        coh_resp_all_SHIFT.correct_slow(1:71,1:206,sess) = coh_resp.correct_slow;
    catch
        disp('Missing SHIFT PREDICTOR file')
        continue
    end
end
%forgot to save tout and f in matrices

keep *_all* tout_targ tout_resp f_targ f_resp plotFlag
%==================================================


figure
orient landscape
set(gcf,'color','white')

subplot(2,2,1)
plot(-500:2500,nanmean(wf_sig1_targ_all.correct_fast),'b',-500:2500,nanmean(wf_sig1_targ_all.correct_slow),'--b',-500:2500,nanmean(wf_sig2_targ_all.correct_fast),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_slow),'--r')
legend('sig1 fast','sig1 slow','sig2 fast','sig2 slow')
xlim([-100 500])

subplot(2,2,2)
coh = nanmean(coh_targ_all.correct_fast,3) - nanmean(coh_targ_all_SHIFT.correct_fast,3);
imagesc(tout_targ,f_targ,abs(coh)')
axis xy
x = get(gca,'clim');
colorbar
xlim([-100 500])
title('Coherence Fast')

subplot(2,2,4)
coh = nanmean(coh_targ_all.correct_slow,3) - nanmean(coh_targ_all_SHIFT.correct_slow,3);
imagesc(tout_targ,f_targ,abs(coh)')
axis xy
set(gca,'clim',x)
colorbar
xlim([-100 500])
title('Coherence Slow')

suplabel('NEURON NEURON COHERENCE FAST VS SLOW','t')



figure
orient landscape
set(gcf,'color','white')

subplot(2,2,1)
plot(-600:300,nanmean(wf_sig1_resp_all.correct_fast),'b',-600:300,nanmean(wf_sig1_resp_all.correct_slow),'--b',-600:300,nanmean(wf_sig2_resp_all.correct_fast),'r',-600:300,nanmean(wf_sig2_resp_all.correct_slow),'--r')
legend('sig1 fast','sig1 slow','sig2 fast','sig2 slow','location','northwest')
xlim([-600 300])

subplot(2,2,2)
coh = nanmean(coh_resp_all.correct_fast,3) - nanmean(coh_resp_all_SHIFT.correct_fast,3);
imagesc(tout_resp,f_resp,abs(coh)')
axis xy
x = get(gca,'clim');
colorbar
title('Coherence Fast')

subplot(2,2,4)
coh = nanmean(coh_resp_all.correct_slow,3) - nanmean(coh_resp_all_SHIFT.correct_slow,3);
imagesc(tout_resp,f_resp,abs(coh)')
axis xy
set(gca,'clim',x)
colorbar
title('Coherence Slow')

suplabel('NEURON NEURON COHERENCE FAST VS SLOW','t');

%take baselines

% for sess = 1:size(coh_targ_all.correct_in,3);
%     sess
%     coh_rot_in = abs(coh_targ_all.correct_in(:,:,sess)');
%     coh_rot_out = abs(coh_targ_all.correct_out(:,:,sess)');
%     %take mean of -400:-300 which is first 11 columns in rotated coherence
%     %matrix
%     coh_in_base = repmat(nanmean(coh_rot_in(:,1:11),2),1,281);
%     coh_out_base = repmat(nanmean(coh_rot_out(:,1:11),2),1,281);
%
%     coh_targ_all_bc.correct_in(1:206,1:281,sess) = coh_rot_in - coh_in_base;
%     coh_targ_all_bc.correct_out(1:206,1:281,sess) = coh_rot_out - coh_out_base;
%
%
%     av_power_in(sess,1:length(tout)) = nanmean(coh_rot_in(find(f_targ >=0 & f_targ <= 10),:));
%     av_power_out(sess,1:length(tout)) = nanmean(coh_rot_out(find(f_targ >=0 & f_targ <= 10),:));
%
%     av_power_in_bc(sess,1:length(tout)) = nanmean(coh_targ_all_bc.correct_in(find(f_targ >=0 & f_targ <= 10),:,sess));
%     av_power_out_bc(sess,1:length(tout)) = nanmean(coh_targ_all_bc.correct_out(find(f_targ >=0 & f_targ <= 10),:,sess));
%
%     av_diff(sess,1:length(tout)) = av_power_in(sess,:) - av_power_out(sess,:);
%
%     %calculate approximate onset time - use 2 sd above diff wave
%     crit = 2*std(av_diff(sess,:));
%     try
%         time(sess,1) = tout(find(av_diff(sess,:) > crit,1));
%     catch
%         time(sess,1) = NaN;
%     end
%
%     if plotFlag == 1
%     plot(tout,av_diff(sess,:))
%     line([1 1000],[crit crit])
%     title(time(sess,1))
%     pause
%     cla
%     end
% end


