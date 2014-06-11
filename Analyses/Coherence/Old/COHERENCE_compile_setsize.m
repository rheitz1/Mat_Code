%batch for across-session Coherence analyses

plotFlag = 1;

cd /volumes/Dump2/Coherence/Uber/Matrices/SPK-LFP/CrossHemi/
%batch_list = dir('/volumes/dump2/JPSTC/JPSTC_matrices/reg/correct_target_truncated_filtered_nosaturation/LFP-LFP/*.mat');
batch_list = dir('*.mat');



%due to size of matrices, am going to separately save

%=========================================================

%preallocate
coh_targ_all.correct_ss2(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_ss4(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all.correct_ss8(1:281,1:206,1:length(batch_list)) = NaN;

% coh_resp_all.correct_ss2(1:71,1:206,1:length(batch_list)) = NaN;
% coh_resp_all.correct_ss4(1:71,1:206,1:length(batch_list)) = NaN;
% coh_resp_all.correct_ss8(1:71,1:206,1:length(batch_list)) = NaN;


n_all.correct_ss2(1:length(batch_list),1) = NaN;
n_all.correct_ss4(1:length(batch_list),1) = NaN;
n_all.correct_ss8(1:length(batch_list),1) = NaN;

wf_sig1_targ_all.correct_ss2(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_ss4(1:length(batch_list),1:3001) = NaN;
wf_sig1_targ_all.correct_ss8(1:length(batch_list),1:3001) = NaN;

% wf_sig1_resp_all.correct_ss2(1:length(batch_list),1:901) = NaN;
% wf_sig1_resp_all.correct_ss4(1:length(batch_list),1:901) = NaN;
% wf_sig1_resp_all.correct_ss8(1:length(batch_list),1:901) = NaN;

wf_sig2_targ_all.correct_ss2(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_ss4(1:length(batch_list),1:3001) = NaN;
wf_sig2_targ_all.correct_ss8(1:length(batch_list),1:3001) = NaN;

% wf_sig2_resp_all.correct_ss2(1:length(batch_list),1:901) = NaN;
% wf_sig2_resp_all.correct_ss4(1:length(batch_list),1:901) = NaN;
% wf_sig2_resp_all.correct_ss8(1:length(batch_list),1:901) = NaN;


coh_targ_all_SHIFT.correct_ss2(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct_ss4(1:281,1:206,1:length(batch_list)) = NaN;
coh_targ_all_SHIFT.correct_ss8(1:281,1:206,1:length(batch_list)) = NaN;

% coh_resp_all_SHIFT.correct_ss2(1:71,1:206,1:length(batch_list)) = NaN;
% coh_resp_all_SHIFT.correct_ss4(1:71,1:206,1:length(batch_list)) = NaN;
% coh_resp_all_SHIFT.correct_ss8(1:71,1:206,1:length(batch_list)) = NaN;


for sess = 1:length(batch_list)
    sess
    
    f_list{sess,1} = batch_list(sess).name;
    
    load(batch_list(sess).name,'RTs','coh_targ','coh_resp','n','wf_sig1_targ','wf_sig2_targ', ...
        'wf_sig1_resp','wf_sig2_resp','tout_targ','tout_resp','f_targ','f_resp','-mat')
    

    
    try
        coh_targ_all.correct_ss2(1:281,1:206,sess) = coh_targ.correct_ss2;
        coh_targ_all.correct_ss4(1:281,1:206,sess) = coh_targ.correct_ss4;
        coh_targ_all.correct_ss8(1:281,1:206,sess) = coh_targ.correct_ss8;
        
%         coh_resp_all.correct_ss2(1:71,1:206,sess) = coh_resp.correct_ss2;
%         coh_resp_all.correct_ss4(1:71,1:206,sess) = coh_resp.correct_ss4;
%         coh_resp_all.correct_ss8(1:71,1:206,sess) = coh_resp.correct_ss8;
        
        n_all.correct_ss2(sess,1) = n.correct_ss2;
        n_all.correct_ss4(sess,1) = n.correct_ss4;
        n_all.correct_ss8(sess,1) = n.correct_ss8;
        
        
        RTs_all.correct_ss2(1:length(RTs.correct_ss2),1,sess) = RTs.correct_ss2;
        RTs_all.correct_ss4(1:length(RTs.correct_ss4),1,sess) = RTs.correct_ss4;
        RTs_all.correct_ss8(1:length(RTs.correct_ss8),1,sess) = RTs.correct_ss8;
        
        
        wf_sig1_targ_all.correct_ss2(sess,1:3001) = wf_sig1_targ.correct_ss2;
        wf_sig1_targ_all.correct_ss4(sess,1:3001) = wf_sig1_targ.correct_ss4;
        wf_sig1_targ_all.correct_ss8(sess,1:3001) = wf_sig1_targ.correct_ss8;
        
        wf_sig2_targ_all.correct_ss2(sess,1:3001) = wf_sig2_targ.correct_ss2;
        wf_sig2_targ_all.correct_ss4(sess,1:3001) = wf_sig2_targ.correct_ss4;
        wf_sig2_targ_all.correct_ss8(sess,1:3001) = wf_sig2_targ.correct_ss8;
        
%         wf_sig1_resp_all.correct_ss2(sess,1:901) = wf_sig1_resp.correct_ss2;
%         wf_sig1_resp_all.correct_ss4(sess,1:901) = wf_sig1_resp.correct_ss4;
%         wf_sig1_resp_all.correct_ss8(sess,1:901) = wf_sig1_resp.correct_ss8;
%         
%         wf_sig2_resp_all.correct_ss2(sess,1:901) = wf_sig2_resp.correct_ss2;
%         wf_sig2_resp_all.correct_ss4(sess,1:901) = wf_sig2_resp.correct_ss4;
%         wf_sig2_resp_all.correct_ss8(sess,1:901) = wf_sig2_resp.correct_ss8;
    catch
        disp('Skipping...')
        continue
    end
    
    
    %Now get SHIFT PREDICTOR
    
    keep *_all* tout_targ tout_resp f_targ f_resp plotFlag sess batch_list
    
    try %if missing data file, skip
        load([batch_list(sess).name(1:end-4) '_SHIFT_PREDICTOR.mat'],'coh_targ','coh_resp','-mat')
        
        coh_targ_all_SHIFT.correct_ss2(1:281,1:206,sess) = coh_targ.correct_ss2;
        coh_targ_all_SHIFT.correct_ss4(1:281,1:206,sess) = coh_targ.correct_ss4;
        coh_targ_all_SHIFT.correct_ss8(1:281,1:206,sess) = coh_targ.correct_ss8;
        
%         coh_resp_all_SHIFT.correct_ss2(1:71,1:206,sess) = coh_resp.correct_ss2;
%         coh_resp_all_SHIFT.correct_ss4(1:71,1:206,sess) = coh_resp.correct_ss4;
%         coh_resp_all_SHIFT.correct_ss8(1:71,1:206,sess) = coh_resp.correct_ss8;
    catch
        disp('Missing SHIFT PREDICTOR file')
        continue
    end
end
%forgot to save tout and f in matrices

keep *_all* tout_targ tout_resp f_targ f_resp plotFlag
%==================================================

% 
% figure
% orient landscape
% set(gcf,'color','white')
% 
% subplot(2,2,1)
% plot(-500:2500,nanmean(wf_sig1_targ_all.correct_ss2),'b',-500:2500,nanmean(wf_sig1_targ_all.correct_ss4),'--b',-500:2500,nanmean(wf_sig1_targ_all.correct_ss8),':b',-500:2500,nanmean(wf_sig2_targ_all.correct_ss2),'r',-500:2500,nanmean(wf_sig2_targ_all.correct_ss4),'--r',-500:2500,nanmean(wf_sig2_targ_all.correct_ss8),':r')
% legend('sig1 ss2','sig1 ss4','sig1 ss8','sig2 ss2','sig2 ss4','sig2 ss8')
% xlim([-100 500])
% 
% subplot(2,2,2)
% coh = nanmean(coh_targ_all.correct_ss2,3) - nanmean(coh_targ_all_SHIFT.correct_ss2,3);
% 
% imagesc(tout_targ,f_targ,abs(coh)')
% axis xy
% x(1,1:2) = get(gca,'clim');
% colorbar
% xlim([-100 500])
% title('Coherence SS2')
% 
% subplot(2,2,3)
% coh = nanmean(coh_targ_all.correct_ss4,3) - nanmean(coh_targ_all_SHIFT.correct_ss4,3);
% imagesc(tout_targ,f_targ,abs(coh)')
% axis xy
% x(2,1:2) = get(gca,'clim');
% colorbar
% xlim([-100 500])
% title('Coherence ss4')
% 
% subplot(2,2,4)
% coh = nanmean(coh_targ_all.correct_ss8,3) - nanmean(coh_targ_all_SHIFT.correct_ss8,3);
% imagesc(tout_targ,f_targ,abs(coh)')
% axis xy
% x(3,1:2) = get(gca,'clim');
% colorbar
% xlim([-100 500])
% title('Coherence ss8')
% suplabel('NEURON NEURON COHERENCE SET SIZE TARGET ALIGNED','t');
% 
% %reset to min and max of coherence
% y = [min(x(:,1)) max(x(:,2))];
% subplot(2,2,2)
% set(gca,'clim',y)
% subplot(2,2,3)
% set(gca,'clim',y)
% subplot(2,2,4)
% set(gca,'clim',y)
% 
% 
% 
% figure
% orient landscape
% set(gcf,'color','white')
% 
% subplot(2,2,1)
% plot(-600:300,nanmean(wf_sig1_resp_all.correct_ss2),'b',-600:300,nanmean(wf_sig1_resp_all.correct_ss4),'--b',-600:300,nanmean(wf_sig1_resp_all.correct_ss8),':b',-600:300,nanmean(wf_sig2_resp_all.correct_ss2),'r',-600:300,nanmean(wf_sig2_resp_all.correct_ss4),'--r',-600:300,nanmean(wf_sig2_resp_all.correct_ss8),':r')
% legend('sig1 ss2','sig1 ss4','sig1 ss8','sig2 ss2','sig2 ss4','sig2 ss8')
% xlim([-600 300])
% 
% subplot(2,2,2)
% coh = nanmean(coh_resp_all.correct_ss2,3) - nanmean(coh_resp_all_SHIFT.correct_ss2,3);
% imagesc(tout_resp,f_resp,abs(coh)')
% axis xy
% x(1,1:2) = get(gca,'clim');
% colorbar
% 
% title('Coherence SS2')
% 
% subplot(2,2,3)
% coh = nanmean(coh_resp_all.correct_ss4,3) - nanmean(coh_resp_all_SHIFT.correct_ss4,3);
% imagesc(tout_resp,f_resp,abs(coh)')
% axis xy
% x(2,1:2) = get(gca,'clim');
% colorbar
% 
% title('Coherence ss4')
% 
% subplot(2,2,4)
% coh = nanmean(coh_resp_all.correct_ss8,3) - nanmean(coh_resp_all_SHIFT.correct_ss8,3);
% imagesc(tout_resp,f_resp,abs(coh)')
% axis xy
% x(3,1:2) = get(gca,'clim');
% colorbar
% 
% title('Coherence ss8')
% suplabel('NEURON NEURON COHERENCE SET SIZE RESPONSE ALIGNED','t');
% 
% %reset to min and max of coherence
% y = [min(x(:,1)) max(x(:,2))];
% subplot(2,2,2)
% set(gca,'clim',y)
% subplot(2,2,3)
% set(gca,'clim',y)
% subplot(2,2,4)
% set(gca,'clim',y)
% 
% clear x y
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


