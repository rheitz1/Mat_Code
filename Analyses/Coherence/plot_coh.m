
% %==================================
% Plot significant clusters across sessions activity period - baseline and
% Tin - Din
% period separately for Tin and Din

for sess = 1:size(shuff_all.base_v_act.in.all.Pos,3)
    subplot(4,2,1)
    
    imagesc(tout,f,abs(Pcoh_all.in.all(:,:,sess)'))
    axis xy
    %xlim([100 700])
    colorbar
    z = get(gca,'clim');
    
    subplot(4,2,2)  
    imagesc(tout_shuff,f,shuff_all.base_v_act.in.all.Pos(:,:,sess)')
    axis xy
    %xlim([100 700])
    
    
    subplot(4,2,3)
    imagesc(tout,f,abs(Pcoh_all.out.all(:,:,sess)'))
    axis xy
    colorbar
    %xlim([100 700])
    set(gca,'clim',z)
    
    subplot(4,2,4)
    imagesc(tout_shuff,f,shuff_all.base_v_act.out.all.Pos(:,:,sess)')
    axis xy
    %xlim([100 700])
    
    subplot(4,2,5)
    d = abs(Pcoh_all.in.all(:,:,sess)) - abs(Pcoh_all.out.all(:,:,sess));
    imagesc(tout,f,d')
    axis xy
    colorbar
    %xlim([100 700])
    set(gca,'clim',[-.3 .3])
    
    subplot(4,2,6)
    imagesc(tout_shuff,f,shuff_all.in_v_out.all.Pos(:,:,sess)')
    axis xy
    %xlim([100 700])
    
    %imagesc(tout_shuff,f,normshuff_all.in_v_out.all.Pos(:,:,sess)')
    %axis xy
    
    % Plot Waveforms
    subplot(4,2,7)
    plot(-500:2500,wf_all.sig1.in.all(sess,:),'k',-500:2500,wf_all.sig1.out.all(sess,:),'--k')
    axis ij
    %xlim([100 700])
    
    subplot(4,2,8)
    plot(-500:2500,wf_all.sig2.in.all(sess,:),'k',-500:2500,wf_all.sig2.out.all(sess,:),'--k')
    %xlim([100 700])
    
    suplabel(mat2str(file_list(sess).name),'t');
    
  %   keeper(sess,1) = input('keep?');
    pause
end



%========================
% PLOT EVERY SESSION, TIN
% fi = figure;
% for sess = 1:size(Pcoh_all.in.all,3)
%     
%     subplot(2,2,1)
%     imagesc(tout,f,abs(Pcoh_all.in.all(:,:,sess)'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('All')
%     
%     subplot(2,2,2)
%     imagesc(tout,f,abs(Pcoh_all.in.ss2(:,:,sess)'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('ss2')
%     
%     subplot(2,2,3)
%     imagesc(tout,f,abs(Pcoh_all.in.ss4(:,:,sess)'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('ss4')
%     
%     subplot(2,2,4)
%     imagesc(tout,f,abs(Pcoh_all.in.ss8(:,:,sess)'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('ss8')
%     
%     rescale_subplots(fi,[2 2],'c')
%     
%     pause
% end
    




% 
% 
% % ========================
% % PLOT EVERY SESSION, TIN ANGLES
% fi = figure;
% for sess = 1:size(Pcoh_all.in.all,3)
%     
%     
%     
% %     allang_high(:,:,sess) = angle(Pcoh_all.in.all(find(tout >= 150 & tout <= 300),find(f >=35 & f <= 100),sess));
% %     allang_low(:,:,sess) = angle(Pcoh_all.in.all(find(tout >= 150 & tout <= 300),find(f <= 10),sess));
% %     
% %     temphigh = allang_high(:,:,sess);
% %     temphigh = temphigh(:);
% %     
% %     templow = allang_low(:,:,sess);
% %     templow = templow(:);
% %     
% %     statshigh = circ_stats(temphigh);
% %     statslow = circ_stats(templow);
% %     
% %     mean_ang_high(sess,1) = statshigh.mean;
% %     mean_ang_low(sess,1) = statslow.mean;
% %     
% %     
% %     
%     
%     subplot(2,2,1)
%     imagesc(tout,f,angle(Pcoh_all.in.all(:,:,sess).'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('All')
%     
%     
%     subplot(2,2,2)
%     imagesc(tout,f,angle(Pcoh_all.in.ss2(:,:,sess).'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('ss2')
%     
%     subplot(2,2,3)
%     imagesc(tout,f,angle(Pcoh_all.in.ss4(:,:,sess).'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('ss4')
%     
%     subplot(2,2,4)
%     imagesc(tout,f,angle(Pcoh_all.in.ss8(:,:,sess).'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     title('ss8')
%     
%     %rescale_subplots(fi,[2 2],'c')
%     
%     suplabel(mat2str(file_list(sess).name),'t');
%     
%     pause
%     clear temphigh templow statshigh statslow
%     
%  end
% 
% 


% 
% figure
% fw
% for sess = 1:size(Pcoh_all.in.all,3)
%     d = abs(Pcoh_all.in.all(:,:,sess)) - abs(Pcoh_all.out.all(:,:,sess));
%     
%     imagesc(tout,f,d')
%     axis xy
%     xlim([-50 500])
%     colorbar
%     
%     title(file_list(sess).name)
%     pause
% end



% figure
% fw
% for sess = 1:size(Pcoh_all.in.all,3)
%     subplot(1,2,1)
%     imagesc(tout,f,abs(Pcoh_all.in.err(:,:,sess)'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     z = get(gca,'clim');
%     title(mat2str(file_list(sess).name))
%     
%     subplot(1,2,2)
%     imagesc(tout,f,abs(Pcoh_all.out.err(:,:,sess)'))
%     axis xy
%     xlim([-100 500])
%     colorbar
%     set(gca,'clim',z)
%     
%     title(mat2str(sess))
%     pause
% end

all_sub = abs(Pcoh_all.in.all_sub);
all = abs(Pcoh_all.in.all);
ss2 = abs(Pcoh_all.in.ss2);
ss4 = abs(Pcoh_all.in.ss4);
ss8 = abs(Pcoh_all.in.ss8);

fast = abs(Pcoh_all.in.fast);
slow = abs(Pcoh_all.in.slow);

err = abs(Pcoh_all.in.err);

dif.all_sub = abs(Pcoh_all.in.all_sub) - abs(Pcoh_all.out.all_sub);
dif.all = abs(Pcoh_all.in.all) - abs(Pcoh_all.out.all);
dif.ss2 = abs(Pcoh_all.in.ss2) - abs(Pcoh_all.out.ss2);
dif.ss4 = abs(Pcoh_all.in.ss4) - abs(Pcoh_all.out.ss4);
dif.ss8 = abs(Pcoh_all.in.ss8) - abs(Pcoh_all.out.ss8);
dif.fast = abs(Pcoh_all.in.fast) - abs(Pcoh_all.out.fast);
dif.slow = abs(Pcoh_all.in.slow) - abs(Pcoh_all.out.slow);
dif.err = abs(Pcoh_all.in.err) - abs(Pcoh_all.out.err);



%=============================
% Percentage increase
% Baseline correct averages first
in_all_sub = nanmean(abs(Pcoh_all.in.all_sub),3);
out_all_sub = nanmean(abs(Pcoh_all.out.all_sub),3);
in_all = nanmean(abs(Pcoh_all.in.all),3);
out_all = nanmean(abs(Pcoh_all.out.all),3);
in_fast = nanmean(abs(Pcoh_all.in.fast),3);
out_fast = nanmean(abs(Pcoh_all.out.fast),3);
in_slow = nanmean(abs(Pcoh_all.in.slow),3);
out_slow = nanmean(abs(Pcoh_all.out.slow),3);
in_ss2 = nanmean(abs(Pcoh_all.in.ss2),3);
out_ss2 = nanmean(abs(Pcoh_all.out.ss2),3);
in_ss4 = nanmean(abs(Pcoh_all.in.ss4),3);
out_ss4 = nanmean(abs(Pcoh_all.out.ss4),3);
in_ss8 = nanmean(abs(Pcoh_all.in.ss8),3);
out_ss8 = nanmean(abs(Pcoh_all.out.ss8),3);
in_err = nanmean(abs(Pcoh_all.in.err),3);
out_err = nanmean(abs(Pcoh_all.out.err),3);

in_all_sub = baseline_correct(in_all_sub',[find(tout == -100) find(tout == 0)]);
out_all_sub = baseline_correct(out_all_sub',[find(tout == -100) find(tout == 0)]);
in_all = baseline_correct(in_all',[find(tout == -100) find(tout == 0)]);
out_all = baseline_correct(out_all',[find(tout == -100) find(tout == 0)]);
in_fast = baseline_correct(in_fast',[find(tout == -100) find(tout == 0)]);
out_fast = baseline_correct(out_fast',[find(tout == -100) find(tout == 0)]);
in_slow = baseline_correct(in_slow',[find(tout == -100) find(tout == 0)]);
out_slow = baseline_correct(out_slow',[find(tout == -100) find(tout == 0)]);
in_ss2 = baseline_correct(in_ss2',[find(tout == -100) find(tout == 0)]);
out_ss2 = baseline_correct(out_ss2',[find(tout == -100) find(tout == 0)]);
in_ss4 = baseline_correct(in_ss4',[find(tout == -100) find(tout == 0)]);
out_ss4 = baseline_correct(out_ss4',[find(tout == -100) find(tout == 0)]);
in_ss8 = baseline_correct(in_ss8',[find(tout == -100) find(tout == 0)]);
out_ss8 = baseline_correct(out_ss8',[find(tout == -100) find(tout == 0)]);
in_err = baseline_correct(in_err',[find(tout == -100) find(tout == 0)]);
out_err = baseline_correct(out_err',[find(tout == -100) find(tout == 0)]);


freqwin = [35 100];

in_all_sub = nanmean(in_all_sub(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_all_sub = nanmean(out_all_sub(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_all = nanmean(in_all(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_all = nanmean(out_all(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_fast = nanmean(in_fast(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_fast = nanmean(out_fast(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_slow = nanmean(in_slow(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_slow = nanmean(out_slow(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_ss2 = nanmean(in_ss2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_ss2 = nanmean(out_ss2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_ss4 = nanmean(in_ss4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_ss4 = nanmean(out_ss4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_ss8 = nanmean(in_ss8(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_ss8 = nanmean(out_ss8(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
in_err = nanmean(in_err(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);
out_err = nanmean(out_err(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1);


propdif.all_sub = in_all_sub ./ out_all_sub;
propdif.all = in_all ./ out_all;
propdif.ss2 = in_ss2 ./ out_ss2;
propdif.ss4 = in_ss4 ./ out_ss4;
propdif.ss8 = in_ss8 ./ out_ss8;
propdif.fast = in_fast ./ out_fast;
propdif.slow = in_slow ./ out_slow;


%error is percentage decrease
propdif.err = (out_err ./ in_err)*-1;
%===============================




% USE BELOW IF WISH TO BASELINE CORRECT
%take mean across desired frequency window
asub = baseline_correct(transpose3(all_sub),[find(tout == -100) find(tout == 0)]);
al = baseline_correct(transpose3(all),[find(tout == -100) find(tout == 0)]);
s2 = baseline_correct(transpose3(ss2),[find(tout == -100) find(tout == 0)]);
s4 = baseline_correct(transpose3(ss4),[find(tout == -100) find(tout == 0)]);
s8 = baseline_correct(transpose3(ss8),[find(tout == -100) find(tout == 0)]);
fs = baseline_correct(transpose3(fast),[find(tout == -100) find(tout == 0)]);
sl = baseline_correct(transpose3(slow),[find(tout == -100) find(tout == 0)]);
err = baseline_correct(transpose3(err),[find(tout == -100) find(tout == 0)]);

allsubdif = baseline_correct(transpose3(dif.all_sub),[find(tout == -100) find(tout == 0)]);
alldif = baseline_correct(transpose3(dif.all),[find(tout == -100) find(tout == 0)]);
s2dif = baseline_correct(transpose3(dif.ss2),[find(tout == -100) find(tout == 0)]);
s4dif = baseline_correct(transpose3(dif.ss4),[find(tout == -100) find(tout == 0)]);
s8dif = baseline_correct(transpose3(dif.ss8),[find(tout == -100) find(tout == 0)]);
fsdif = baseline_correct(transpose3(dif.fast),[find(tout == -100) find(tout == 0)]);
sldif = baseline_correct(transpose3(dif.slow),[find(tout == -100) find(tout == 0)]);
errdif = baseline_correct(transpose3(dif.err),[find(tout == -100) find(tout == 0)]);




% USE BELOW IF DO NOT WISH TO BASELINE CORRECT
% asub = transpose3(all_sub);
% al = transpose3(all);
% s2 = transpose3(ss2);
% s4 = transpose3(ss4);
% s8 = transpose3(ss8);
% fs = transpose3(fast);
% sl = transpose3(slow);
% err = transpose3(err);
% 
% allsubdif = transpose3(dif.all_sub);
% alldif = transpose3(dif.all);
% s2dif = transpose3(dif.ss2);
% s4dif = transpose3(dif.ss4);
% s8dif = transpose3(dif.ss8);
% fsdif = transpose3(dif.fast);
% sldif = transpose3(dif.slow);
% errdif = transpose3(dif.err);

%freqwin = [40 70]; %same as Wolmelsdorf et al., 2006 and also seems best of windows i tested
freqwin = [35 100];

asub = squeeze(nanmean(asub(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
al = squeeze(nanmean(al(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s2 = squeeze(nanmean(s2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s4 = squeeze(nanmean(s4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s8 = squeeze(nanmean(s8(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fs = squeeze(nanmean(fs(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sl = squeeze(nanmean(sl(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
err = squeeze(nanmean(err(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));

allsubdif = squeeze(nanmean(allsubdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
alldif = squeeze(nanmean(alldif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s2dif = squeeze(nanmean(s2dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s4dif = squeeze(nanmean(s4dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s8dif = squeeze(nanmean(s8dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fsdif = squeeze(nanmean(fsdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sldif = squeeze(nanmean(sldif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif = squeeze(nanmean(errdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
% 
% figure
% subplot(3,1,1)
% plot(tout,nanmean(s2,2),'b',tout,nanmean(s4,2),'r',tout,nanmean(s8,2),'g')
% xlim([-100 500])
% title('T in Only')
% 
% subplot(3,1,2)
% plot(tout,nanmean(fs,2),'r',tout,nanmean(sl,2),'b')
% xlim([-100 500])
% title('T in Only')
% 
% subplot(3,1,3)
% plot(tout,nanmean(al,2),'k',tout,nanmean(asub,2),'--k',tout,nanmean(err,2),'r')
% xlim([-100 500])

figure

subplot(3,1,1)
plot(tout,nanmean(s2dif,2),'b',tout,nanmean(s4dif,2),'r',tout,nanmean(s8dif,2),'g')
xlim([-100 500])
title('Tin - Din')

subplot(3,1,2)
plot(tout,nanmean(fsdif,2),'r',tout,nanmean(sldif,2),'b')
xlim([-100 500])
title('Tin - Din')

subplot(3,1,3)
plot(tout,nanmean(alldif,2),'k',tout,nanmean(allsubdif,2),'--k',tout,nanmean(errdif,2),'r')
xlim([-100 500])
hline(0,'k')




%======================
% Use Wilcoxon signrank test (versus 0) to find timing of fast vs slow
% gamma band coherence. Start at 100 ms
start = find(tout == 100);

for t = start:size(fsdif,1)
    [fsp(t) fsh(t)] = signrank(fsdif(t,:));
end

temp = tout(findRuns(fsh,10));
time_fast = min(temp(find(temp > 0)));
clear temp

for t = start:size(sldif,1)
    [slp(t) slh(t)] = signrank(sldif(t,:));
end

temp = tout(findRuns(slh,10));
time_slow = min(temp(find(temp > 0)));
clear temp

figure
plot(tout,nanmean(fsdif,2),'r',tout,nanmean(sldif,2),'b')
vline(time_fast,'r')
vline(time_slow,'b')
xlim([-50 500])