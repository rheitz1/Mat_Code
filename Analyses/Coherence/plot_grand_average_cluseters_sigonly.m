%make grand average coherence plots
% this plots the averages of all significant clusters, and sets all
% nonsignificant clusters to NaN.
%
% this script is different from 'plot_grand_average_coh' in that THAT
% script takes the entire coherence matrix IF that matrix had at least 1
% pixel of significance within some t/f region

% RPH

% frequency windows to average over
freqwin = [35 100];
%freqwin;
basewin = [-200 -100];
allGrandaverage = 1;

basecorrect_coh = 0; % THIS HAS TO BE 0 FOR THE 'SIGNIFICANT ONLY' MATRICES BECAUSE THERE IS NOT PRESTIMULUS PERIOD TO BASELINE TO
propFlag = 0; %do you want to plot Tin / Din or Tin - Din.  Set to 1 for former

%set all nonsignificant regions to NaN
%have to use non-padded matrices from shuffle tests.  This corrects the
%frequency side but time side have to use intersection of tout and
%tout_shuff
[c ix] = intersect(tout,tout_shuff);

Pcoh_all.in.all = shuff_all.in.all.Pcoh(ix,:,:);
Pcoh_all.in.ss2 = shuff_all.in.ss2.Pcoh(ix,:,:);
Pcoh_all.in.ss4 = shuff_all.in.ss4.Pcoh(ix,:,:);
Pcoh_all.in.ss8 = shuff_all.in.ss8.Pcoh(ix,:,:);
Pcoh_all.in.fast = shuff_all.in.fast.Pcoh(ix,:,:);
Pcoh_all.in.slow = shuff_all.in.slow.Pcoh(ix,:,:);
Pcoh_all.in.err = shuff_all.in.err.Pcoh(ix,:,:);

Pcoh_all.out.all = shuff_all.out.all.Pcoh(ix,:,:);
Pcoh_all.out.ss2 = shuff_all.out.ss2.Pcoh(ix,:,:);
Pcoh_all.out.ss4 = shuff_all.out.ss4.Pcoh(ix,:,:);
Pcoh_all.out.ss8 = shuff_all.out.ss8.Pcoh(ix,:,:);
Pcoh_all.out.fast = shuff_all.out.fast.Pcoh(ix,:,:);
Pcoh_all.out.slow = shuff_all.out.slow.Pcoh(ix,:,:);
Pcoh_all.out.err = shuff_all.out.err.Pcoh(ix,:,:);

%Now set to NaN nonsignificant regions
Pcoh_all.in.all(find(shuff_all.in_v_out.all.Pos == 0)) = NaN;
Pcoh_all.in.ss2(find(shuff_all.in_v_out.ss2.Pos == 0)) = NaN;
Pcoh_all.in.ss4(find(shuff_all.in_v_out.ss4.Pos == 0)) = NaN;
Pcoh_all.in.ss8(find(shuff_all.in_v_out.ss8.Pos == 0)) = NaN;
Pcoh_all.in.fast(find(shuff_all.in_v_out.fast.Pos == 0)) = NaN;
Pcoh_all.in.slow(find(shuff_all.in_v_out.slow.Pos == 0)) = NaN;
Pcoh_all.in.err(find(shuff_all.in_v_out.err.Neg == 0)) = NaN; %NOTE SWITCH TO NEG FOR ERRORS

Pcoh_all.out.all(find(shuff_all.in_v_out.all.Pos == 0)) = NaN;
Pcoh_all.out.ss2(find(shuff_all.in_v_out.ss2.Pos == 0)) = NaN;
Pcoh_all.out.ss4(find(shuff_all.in_v_out.ss4.Pos == 0)) = NaN;
Pcoh_all.out.ss8(find(shuff_all.in_v_out.ss8.Pos == 0)) = NaN;
Pcoh_all.out.fast(find(shuff_all.in_v_out.fast.Pos == 0)) = NaN;
Pcoh_all.out.slow(find(shuff_all.in_v_out.slow.Pos == 0)) = NaN;
Pcoh_all.out.err(find(shuff_all.in_v_out.err.Neg == 0)) = NaN; %NOTE SWITCH TO NEG FOR ERRORS


%grand average coherence using all data
if allGrandaverage == 1 & propFlag == 1
    
    %============
    % ALL
    d_all = nanmean(abs(Pcoh_all.in.all),3) ./ nanmean(abs(Pcoh_all.out.all),3);
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_all')
    axis xy
    xlim([100 700])
    colorbar
    z.all = get(gca,'clim');
    fw
    title('Tin - Tout ALL Full data set')
    
    
    
    %============
    % SS2
    d_ss2 = nanmean(abs(Pcoh_all.in.ss2),3) ./ nanmean(abs(Pcoh_all.out.ss2),3);
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_ss2')
    axis xy
    xlim([100 700])
    colorbar
    z.ss2 = get(gca,'clim');
    fw
    title('Tin - Tout SS2 Full data set')
    
    
    
    %============
    % ss4
    d_ss4 = nanmean(abs(Pcoh_all.in.ss4),3) ./ nanmean(abs(Pcoh_all.out.ss4),3);
    
    figure
    imagesc(tout_shuff,f_shuff,d_ss4')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.ss2) %set to ss2
    fw
    title('Tin - Tout ss4 Full data set')
    
    
    
    
    %============
    % ss8
    d_ss8 = nanmean(abs(Pcoh_all.in.ss8),3) ./ nanmean(abs(Pcoh_all.out.ss8),3);
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_ss8')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.ss2) %set to ss2
    fw
    title('Tin - Tout ss8 Full data set')
    
    
    
    %============
    % fast
    d_fast = nanmean(abs(Pcoh_all.in.fast),3) ./ nanmean(abs(Pcoh_all.out.fast),3);
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_fast')
    axis xy
    xlim([100 700])
    colorbar
    z.fast = get(gca,'clim');
    fw
    title('Tin - Tout fast Full data set')
    
    %============
    % slow
    d_slow = nanmean(abs(Pcoh_all.in.slow),3) ./ nanmean(abs(Pcoh_all.out.slow),3);
    
    %     in_removed = Pcoh_all.in.slow;
    %     in_removed(:,:,find(remove)) = NaN;
    %
    %     out_removed = Pcoh_all.out.slow;
    %     out_removed(:,:,find(remove)) = NaN;
    %
    %     d_removed = nanmean(abs(in_removed),3) ./ nanmean(abs(out_removed),3);
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_slow')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.fast)
    fw
    title('Tin - Tout slow Full data set')
    
    %============
    
    
    %============
    % err
    d_err = nanmean(abs(Pcoh_all.in.err),3) ./ nanmean(abs(Pcoh_all.out.err),3);
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_err')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.all) %rescale to all correct trial matrix
    fw
    title('Tin - Tout err Full data set')
    
    
elseif allGrandaverage == 1 & propFlag == 0
    
    %============
    % ALL
    d_all = nanmean(abs(Pcoh_all.in.all),3) - nanmean(abs(Pcoh_all.out.all),3);
    
    if basecorrect_coh == 1
        d_all = baseline_correct(d_all',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_all')
    axis xy
    xlim([100 700])
    colorbar
    z.all = get(gca,'clim');
    fw
    title('Tin - Tout ALL Full data set')
    
    
    %============
    % SS2
    d_ss2 = nanmean(abs(Pcoh_all.in.ss2),3) - nanmean(abs(Pcoh_all.out.ss2),3);
    
    if basecorrect_coh == 1
        d_ss2 = baseline_correct(d_ss2',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_ss2')
    axis xy
    xlim([100 700])
    colorbar
    z.ss2 = get(gca,'clim');
    fw
    title('Tin - Tout SS2 Full data set')
    
    
    %============
    % ss4
    d_ss4 = nanmean(abs(Pcoh_all.in.ss4),3) - nanmean(abs(Pcoh_all.out.ss4),3);
    
    if basecorrect_coh == 1
        d_ss4 = baseline_correct(d_ss4',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_ss4')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.ss2)
    fw
    title('Tin - Tout ss4 Full data set')
    
    
    %============
    % ss8
    d_ss8 = nanmean(abs(Pcoh_all.in.ss8),3) - nanmean(abs(Pcoh_all.out.ss8),3);
    
    if basecorrect_coh == 1
        d_ss8 = baseline_correct(d_ss8',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_ss8')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.ss2)
    fw
    title('Tin - Tout ss8 Full data set')
    
    
    
    %============
    % fast
    d_fast = nanmean(abs(Pcoh_all.in.fast),3) - nanmean(abs(Pcoh_all.out.fast),3);
    
    if basecorrect_coh == 1
        d_fast = baseline_correct(d_fast',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_fast')
    axis xy
    xlim([100 700])
    colorbar
    z.fast = get(gca,'clim');
    fw
    title('Tin - Tout fast Full data set')
    
    
    %============
    % slow
    d_slow = nanmean(abs(Pcoh_all.in.slow),3) - nanmean(abs(Pcoh_all.out.slow),3);
    
    
    if basecorrect_coh == 1
        d_slow = baseline_correct(d_slow',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_slow')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.fast)
    fw
    title('Tin - Tout slow Full data set')
    
    
    
    %============
    % err
    d_err = nanmean(abs(Pcoh_all.in.err),3) - nanmean(abs(Pcoh_all.out.err),3);
    
    
    if basecorrect_coh == 1
        d_err = baseline_correct(d_err',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    
    figure
    imagesc(tout_shuff,f_shuff,d_err')
    axis xy
    xlim([100 700])
    colorbar
    set(gca,'clim',z.all)
    fw
    title('Tin - Tout err Full data set')
    
    
end
%========================
%========================
% Time based-analyses


dif.all_sub = abs(Pcoh_all.in.all_sub) - abs(Pcoh_all.out.all_sub);
dif.all = abs(Pcoh_all.in.all) - abs(Pcoh_all.out.all);
dif.ss2 = abs(Pcoh_all.in.ss2) - abs(Pcoh_all.out.ss2);
dif.ss4 = abs(Pcoh_all.in.ss4) - abs(Pcoh_all.out.ss4);
dif.ss8 = abs(Pcoh_all.in.ss8) - abs(Pcoh_all.out.ss8);
dif.fast = abs(Pcoh_all.in.fast) - abs(Pcoh_all.out.fast);
dif.slow = abs(Pcoh_all.in.slow) - abs(Pcoh_all.out.slow);
dif.err = abs(Pcoh_all.in.err) - abs(Pcoh_all.out.err);

%======
% Baseline corrected versions
allsubdif_bc = baseline_correct(transpose3(dif.all_sub),[find(tout == basewin(1)) find(tout == basewin(2))]);
alldif_bc = baseline_correct(transpose3(dif.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
s2dif_bc = baseline_correct(transpose3(dif.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
s4dif_bc = baseline_correct(transpose3(dif.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
s8dif_bc = baseline_correct(transpose3(dif.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);
fsdif_bc = baseline_correct(transpose3(dif.fast),[find(tout == basewin(1)) find(tout == basewin(2))]);
sldif_bc = baseline_correct(transpose3(dif.slow),[find(tout == basewin(1)) find(tout == basewin(2))]);
errdif_bc = baseline_correct(transpose3(dif.err),[find(tout == basewin(1)) find(tout == basewin(2))]);

allsubdif_bc = squeeze(nanmean(allsubdif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
alldif_bc = squeeze(nanmean(alldif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
s2dif_bc = squeeze(nanmean(s2dif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
s4dif_bc = squeeze(nanmean(s4dif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
s8dif_bc = squeeze(nanmean(s8dif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
fsdif_bc = squeeze(nanmean(fsdif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
sldif_bc = squeeze(nanmean(sldif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
errdif_bc = squeeze(nanmean(errdif_bc(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));


%===========
% No baseline correction version
allsubdif = transpose3(dif.all_sub);
alldif = transpose3(dif.all);
s2dif = transpose3(dif.ss2);
s4dif = transpose3(dif.ss4);
s8dif = transpose3(dif.ss8);
fsdif = transpose3(dif.fast);
sldif = transpose3(dif.slow);
errdif = transpose3(dif.err);


allsubdif = squeeze(nanmean(allsubdif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
alldif = squeeze(nanmean(alldif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
s2dif = squeeze(nanmean(s2dif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
s4dif = squeeze(nanmean(s4dif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
s8dif = squeeze(nanmean(s8dif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
fsdif = squeeze(nanmean(fsdif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
sldif = squeeze(nanmean(sldif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));
errdif = squeeze(nanmean(errdif(find(f_shuff>=freqwin(1) & f_shuff<=freqwin(2)),:,:),1));



% % Time Tests for fast vs. slow
% % Use Wilcoxon signrank test (versus 0) to find timing of fast vs slow
% % gamma band coherence. Start at 100 ms
% start = find(tout_shuff == 100);
% 
% for t = start:size(fsdif,1)
%     [fsp(t) fsh(t)] = signrank(fsdif(t,:));
%     [fsp_bc(t) fsh_bc(t)] = signrank(fsdif_bc(t,:));
% end
% 
% temp = tout(findRuns(fsh,10));
% time_fast = min(temp(find(temp > 0)));
% clear temp
% 
% temp = tout(findRuns(fsh_bc,10));
% time_fast_bc = min(temp(find(temp > 0)));
% clear temp
% 
% 
% for t = start:size(sldif,1)
%     [slp(t) slh(t)] = signrank(sldif(t,:));
%     [slp_bc(t) slh_bc(t)] = signrank(sldif_bc(t,:));
% end
% 
% temp = tout(findRuns(slh,10));
% time_slow = min(temp(find(temp > 0)));
% clear temp
% 
% temp = tout(findRuns(slh_bc,10));
% time_slow_bc = min(temp(find(temp > 0)));
% clear temp

%=========
figure
subplot(3,2,1)
plot(tout_shuff,nanmean(s2dif,2),'b',tout_shuff,nanmean(s4dif,2),'r',tout_shuff,nanmean(s8dif,2),'g')
xlim([100 700])
title('Tin - Din Full No Baseline Correction')

subplot(3,2,3)
plot(tout_shuff,nanmean(fsdif,2),'r',tout_shuff,nanmean(sldif,2),'b')
xlim([100 700])
title('Tin - Din Full no Baseline Correction')

subplot(3,2,5)
plot(tout_shuff,nanmean(alldif,2),'k',tout_shuff,nanmean(errdif,2),'r')
xlim([100 700])
hline(0,'k')
title('Errors Full no Baseline Correction')

subplot(3,2,2)
plot(tout_shuff,nanmean(s2dif_bc,2),'b',tout_shuff,nanmean(s4dif_bc,2),'r',tout_shuff,nanmean(s8dif_bc,2),'g')
xlim([100 700])
title('Tin - Din Full Baseline Correction')

subplot(3,2,4)
plot(tout_shuff,nanmean(fsdif_bc,2),'r',tout_shuff,nanmean(sldif_bc,2),'b')
xlim([100 700])
title('Tin - Din Full Baseline Correction')

subplot(3,2,6)
plot(tout_shuff,nanmean(alldif_bc,2),'k',tout_shuff,nanmean(errdif_bc,2),'r')
xlim([100 700])
hline(0,'k')
title('Errors Full Baseline Correction')
%=========

% 
% %=======
% figure
% subplot(2,2,1)
% plot(tout,nanmean(fsdif,2),'r',tout,nanmean(sldif,2),'b')
% vline(time_fast,'r')
% vline(time_slow,'b')
% xlim([100 700])
% title('No baseline correct, full data set')
% 
% 
% subplot(2,2,3)
% plot(tout,nanmean(fsdif_bc,2),'r',tout,nanmean(sldif_bc,2),'b')
% vline(time_fast_bc,'r')
% vline(time_slow_bc,'b')
% xlim([100 700])
% title('Baseline corrected, full data set')

