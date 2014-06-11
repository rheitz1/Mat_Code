% compute joint peri-stimulus time histogram for SAT data
%
% RPH

%=====================================================
% FEF DATA
tic
cd /Users/richardheitz/Desktop/Mat_Code/Analyses/JPSTH/SAT/

cd ~/desktop
[filename1 unit1a unit1b] = textread('JPSTH_SEF_SC_D.txt','%s %s %s');
[filename2 unit2a unit2b] = textread('JPSTH_SEF_SC_E.txt','%s %s %s');

filename = [filename1 ; filename2];

unit1 = [unit1a unit1b];
unit2 = [unit2a unit2b];

unit = [unit1 ; unit2];
% [filename1 unit1a unit1b] = textread('JPSTH_FEF_FEF_Q.txt','%s %s %s');
% [filename2 unit2a unit2b] = textread('JPSTH_FEF_FEF_S.txt','%s %s %s');
% [filename3 unit3a unit3b] = textread('JPSTH_FEF_FEF_D.txt','%s %s %s');
% 
% filename = [filename1 ; filename2 ; filename3];
% unit1a = [unit1a ; unit2a ; unit3a];
% unit1b = [unit1b ; unit2b ; unit3b];
% unit = [unit1a unit1b];
% 



% [filename1 unit1a unit1b] = textread('JPSTH_SEF_SEF_Q.txt','%s %s %s');
% [filename2 unit2a unit2b] = textread('JPSTH_SEF_SEF_D.txt','%s %s %s');
% [filename3 unit3a unit3b] = textread('JPSTH_SEF_SEF_E.txt','%s %s %s');
% filename = filename2;
% unit = [unit2a unit2b];

%
% filename = [filename1 ; filename2 ; filename3];
% unit1a = [unit1a ; unit2a ; unit3a];
% unit1b = [unit1b ; unit2b ; unit3b];
% unit = [unit1a unit1b];
% 



% 
% [filename1 unit1a unit1b] = textread('JPSTH_FEF_SEF_D.txt','%s %s %s');
% [filename2 unit2a unit2b] = textread('JPSTH_FEF_SEF_Q.txt','%s %s %s');
% 
% filename = [filename1 ; filename2];
% unit1a = [unit1a ; unit2a];
% unit1b = [unit1b ; unit2b];
% unit = [unit1a unit1b];
% 



% [filename1 unit1a unit1b] = textread('JPSTH_SEF_SC_D.txt','%s %s %s');
% [filename2 unit2a unit2b] = textread('JPSTH_SEF_SC_E.txt','%s %s %s');

% filename = [filename1 ; filename2];
% unit1a = [unit1a ; unit2a];
% unit1b = [unit1b ; unit2b];
% unit = [unit1a unit1b];



%  [filename unit1a unit1b] = textread('JPSTH_FEF_SC_D.txt','%s %s %s');
%  unit = [unit1a unit1b];



plotFlag = 1;
plot_each_session = 0;

for file = 1:length(filename)
    
    load(filename{file},unit{file,1},unit{file,2},'Depth','Correct_','Target_','SRT','SAT_','Errors_','RFs','MFs','newfile','Hemi')
    %load(filename{file},unit{file,1},unit{file,2},'Correct_','Target_','SRT','SAT_','Errors_','RFs','MFs','newfile','Hemi')
    filename{file}
    
    sig1 = eval(unit{file,1});
    sig2 = eval(unit{file,2});
    
    try
        depthDiff(file,1) = abs(Depth.(unit{file,1}) - Depth.(unit{file,2}));
    catch
        depthDiff(file,1) = NaN;
    end
    
    RF1 = RFs.(unit{file,1});
    RF2 = RFs.(unit{file,2});
    
    n_overlapRF(file,1) = length(intersect(RF1,RF2));
    
    q = '''';
    c = ',';
    qcq = [q c q];
    
    if Hemi.(unit{file,1}) == Hemi.(unit{file,2})
        sameHemi(file,1) = 1;
    else
        sameHemi(file,1) = 0;
    end
    
    getTrials_SAT
    
    %============================
    % JPSTH PARAMETERS
    bin_width = 20; %size of bins to count spikes within
    coin_width = 50; % average over coin_width/2 on either side of main diagonal
    
    
    %plottime_prestim = [-1500 0];
    plottime_full = [-750 800];
    plottime_prestim = [-750 0];
    plottime_stim = [0 400];
    plottime_sacc = [400 800];
    
    bin_centers.full = plottime_full(1)+(bin_width/2):bin_width:plottime_full(2)-(bin_width/2);
    bin_centers.prestim = plottime_prestim(1)+(bin_width/2):bin_width:plottime_prestim(2)-(bin_width/2);
    bin_centers.stim = plottime_stim(1)+(bin_width/2):bin_width:plottime_stim(2)-(bin_width/2);
    bin_centers.sacc = plottime_sacc(1)+(bin_width/2):bin_width:plottime_sacc(2)-(bin_width/2);
    
    %=============================

    
    
    %Before even checking to see if there are RFs, compute JPSTH for
    %baseline activity
    out.full.all = getJPSTH(sig1,sig2,[plottime_full(1) plottime_full(2)],bin_width,coin_width,1:size(sig1,1),0);
    out.full.slow = getJPSTH(sig1,sig2,[plottime_full(1) plottime_full(2)],bin_width,coin_width,slow_all,0);
    out.full.fast = getJPSTH(sig1,sig2,[plottime_full(1) plottime_full(2)],bin_width,coin_width,fast_all_withCleared,0);
    
    
    out.baseline.all = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],bin_width,coin_width,1:size(sig1,1),0);
    out.baseline.slow = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],bin_width,coin_width,slow_all,0);
    out.baseline.fast = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],bin_width,coin_width,fast_all_withCleared,0);
    
    out.stim.all = getJPSTH(sig1,sig2,[plottime_stim(1) plottime_stim(2)],bin_width,coin_width,1:size(sig1,1),0);
    out.stim.slow = getJPSTH(sig1,sig2,[plottime_stim(1) plottime_stim(2)],bin_width,coin_width,slow_all,0);
    out.stim.fast = getJPSTH(sig1,sig2,[plottime_stim(1) plottime_stim(2)],bin_width,coin_width,fast_all_withCleared,0);
    
    out.sacc.all = getJPSTH(sig1,sig2,[plottime_sacc(1) plottime_sacc(2)],bin_width,coin_width,1:size(sig1,1),0);
    out.sacc.slow = getJPSTH(sig1,sig2,[plottime_sacc(1) plottime_sacc(2)],bin_width,coin_width,slow_all,0);
    out.sacc.fast = getJPSTH(sig1,sig2,[plottime_sacc(1) plottime_sacc(2)],bin_width,coin_width,fast_all_withCleared,0);
    
    
    
    
    %=================
    % FULL TRIAL PERIOD
    allJPSTH.full.all.psth_1(1,:,file) = out.full.all.psth_1;
    allJPSTH.full.all.psth_2(1,:,file) = out.full.all.psth_2;
    allJPSTH.full.all.normalized_jpsth(1:size(out.full.all.normalized_jpsth,1),1:size(out.full.all.normalized_jpsth,2),file) = out.full.all.normalized_jpsth;
    allJPSTH.full.all.unnormalized_jpsth(1:size(out.full.all.unnormalized_jpsth,1),1:size(out.full.all.unnormalized_jpsth,2),file) = out.full.all.unnormalized_jpsth;
    allJPSTH.full.all.xcorr_hist(1,:,file) = out.full.all.xcorr_hist;
    allJPSTH.full.all.pstch(1,:,file) = out.full.all.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.full.all.covariogram(1,:,file) = out.full.all.covariogram;
    allJPSTH.full.all.sig_low(1,:,file) = out.full.all.sig_low;
    allJPSTH.full.all.sig_high(1,:,file) = out.full.all.sig_high;
    
    
    allJPSTH.full.slow.psth_1(1,:,file) = out.full.slow.psth_1;
    allJPSTH.full.slow.psth_2(1,:,file) = out.full.slow.psth_2;
    allJPSTH.full.slow.normalized_jpsth(1:size(out.full.slow.normalized_jpsth,1),1:size(out.full.slow.normalized_jpsth,2),file) = out.full.slow.normalized_jpsth;
    allJPSTH.full.slow.unnormalized_jpsth(1:size(out.full.slow.unnormalized_jpsth,1),1:size(out.full.slow.unnormalized_jpsth,2),file) = out.full.slow.unnormalized_jpsth;
    allJPSTH.full.slow.xcorr_hist(1,:,file) = out.full.slow.xcorr_hist;
    allJPSTH.full.slow.pstch(1,:,file) = out.full.slow.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.full.slow.covariogram(1,:,file) = out.full.slow.covariogram;
    allJPSTH.full.slow.sig_low(1,:,file) = out.full.slow.sig_low;
    allJPSTH.full.slow.sig_high(1,:,file) = out.full.slow.sig_high;
    
    
    allJPSTH.full.fast.psth_1(1,:,file) = out.full.fast.psth_1;
    allJPSTH.full.fast.psth_2(1,:,file) = out.full.fast.psth_2;
    allJPSTH.full.fast.normalized_jpsth(1:size(out.full.fast.normalized_jpsth,1),1:size(out.full.fast.normalized_jpsth,2),file) = out.full.fast.normalized_jpsth;
    allJPSTH.full.fast.unnormalized_jpsth(1:size(out.full.fast.unnormalized_jpsth,1),1:size(out.full.fast.unnormalized_jpsth,2),file) = out.full.fast.unnormalized_jpsth;
    allJPSTH.full.fast.xcorr_hist(1,:,file) = out.full.fast.xcorr_hist;
    allJPSTH.full.fast.pstch(1,:,file) = out.full.fast.pstch;
    allJPSTH.full.fast.covariogram(1,:,file) = out.full.fast.covariogram;
    allJPSTH.full.fast.sig_low(1,:,file) = out.full.fast.sig_low;
    allJPSTH.full.fast.sig_high(1,:,file) = out.full.fast.sig_high;
    
    
    
    
    
    %=================
    % BASELINE PERIOD
    allJPSTH.baseline.all.psth_1(1,:,file) = out.baseline.all.psth_1;
    allJPSTH.baseline.all.psth_2(1,:,file) = out.baseline.all.psth_2;
    allJPSTH.baseline.all.normalized_jpsth(1:size(out.baseline.all.normalized_jpsth,1),1:size(out.baseline.all.normalized_jpsth,2),file) = out.baseline.all.normalized_jpsth;
    allJPSTH.baseline.all.unnormalized_jpsth(1:size(out.baseline.all.unnormalized_jpsth,1),1:size(out.baseline.all.unnormalized_jpsth,2),file) = out.baseline.all.unnormalized_jpsth;
    allJPSTH.baseline.all.xcorr_hist(1,:,file) = out.baseline.all.xcorr_hist;
    allJPSTH.baseline.all.pstch(1,:,file) = out.baseline.all.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.baseline.all.covariogram(1,:,file) = out.baseline.all.covariogram;
    allJPSTH.baseline.all.sig_low(1,:,file) = out.baseline.all.sig_low;
    allJPSTH.baseline.all.sig_high(1,:,file) = out.baseline.all.sig_high;
    
    
    allJPSTH.baseline.slow.psth_1(1,:,file) = out.baseline.slow.psth_1;
    allJPSTH.baseline.slow.psth_2(1,:,file) = out.baseline.slow.psth_2;
    allJPSTH.baseline.slow.normalized_jpsth(1:size(out.baseline.slow.normalized_jpsth,1),1:size(out.baseline.slow.normalized_jpsth,2),file) = out.baseline.slow.normalized_jpsth;
    allJPSTH.baseline.slow.unnormalized_jpsth(1:size(out.baseline.slow.unnormalized_jpsth,1),1:size(out.baseline.slow.unnormalized_jpsth,2),file) = out.baseline.slow.unnormalized_jpsth;
    allJPSTH.baseline.slow.xcorr_hist(1,:,file) = out.baseline.slow.xcorr_hist;
    allJPSTH.baseline.slow.pstch(1,:,file) = out.baseline.slow.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.baseline.slow.covariogram(1,:,file) = out.baseline.slow.covariogram;
    allJPSTH.baseline.slow.sig_low(1,:,file) = out.baseline.slow.sig_low;
    allJPSTH.baseline.slow.sig_high(1,:,file) = out.baseline.slow.sig_high;
    
    
    allJPSTH.baseline.fast.psth_1(1,:,file) = out.baseline.fast.psth_1;
    allJPSTH.baseline.fast.psth_2(1,:,file) = out.baseline.fast.psth_2;
    allJPSTH.baseline.fast.normalized_jpsth(1:size(out.baseline.fast.normalized_jpsth,1),1:size(out.baseline.fast.normalized_jpsth,2),file) = out.baseline.fast.normalized_jpsth;
    allJPSTH.baseline.fast.unnormalized_jpsth(1:size(out.baseline.fast.unnormalized_jpsth,1),1:size(out.baseline.fast.unnormalized_jpsth,2),file) = out.baseline.fast.unnormalized_jpsth;
    allJPSTH.baseline.fast.xcorr_hist(1,:,file) = out.baseline.fast.xcorr_hist;
    allJPSTH.baseline.fast.pstch(1,:,file) = out.baseline.fast.pstch;
    allJPSTH.baseline.fast.covariogram(1,:,file) = out.baseline.fast.covariogram;
    allJPSTH.baseline.fast.sig_low(1,:,file) = out.baseline.fast.sig_low;
    allJPSTH.baseline.fast.sig_high(1,:,file) = out.baseline.fast.sig_high;
    
    
    %==========================
    % STIMULATION (TASK) PERIOD
    allJPSTH.stim.all.psth_1(1,:,file) = out.stim.all.psth_1;
    allJPSTH.stim.all.psth_2(1,:,file) = out.stim.all.psth_2;
    allJPSTH.stim.all.normalized_jpsth(1:size(out.stim.all.normalized_jpsth,1),1:size(out.stim.all.normalized_jpsth,2),file) = out.stim.all.normalized_jpsth;
    allJPSTH.stim.all.unnormalized_jpsth(1:size(out.stim.all.unnormalized_jpsth,1),1:size(out.stim.all.unnormalized_jpsth,2),file) = out.stim.all.unnormalized_jpsth;
    allJPSTH.stim.all.xcorr_hist(1,:,file) = out.stim.all.xcorr_hist;
    allJPSTH.stim.all.pstch(1,:,file) = out.stim.all.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.stim.all.covariogram(1,:,file) = out.stim.all.covariogram;
    allJPSTH.stim.all.sig_low(1,:,file) = out.stim.all.sig_low;
    allJPSTH.stim.all.sig_high(1,:,file) = out.stim.all.sig_high;
    
    
    allJPSTH.stim.slow.psth_1(1,:,file) = out.stim.slow.psth_1;
    allJPSTH.stim.slow.psth_2(1,:,file) = out.stim.slow.psth_2;
    allJPSTH.stim.slow.normalized_jpsth(1:size(out.stim.slow.normalized_jpsth,1),1:size(out.stim.slow.normalized_jpsth,2),file) = out.stim.slow.normalized_jpsth;
    allJPSTH.stim.slow.unnormalized_jpsth(1:size(out.stim.slow.unnormalized_jpsth,1),1:size(out.stim.slow.unnormalized_jpsth,2),file) = out.stim.slow.unnormalized_jpsth;
    allJPSTH.stim.slow.xcorr_hist(1,:,file) = out.stim.slow.xcorr_hist;
    allJPSTH.stim.slow.pstch(1,:,file) = out.stim.slow.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.stim.slow.covariogram(1,:,file) = out.stim.slow.covariogram;
    allJPSTH.stim.slow.sig_low(1,:,file) = out.stim.slow.sig_low;
    allJPSTH.stim.slow.sig_high(1,:,file) = out.stim.slow.sig_high;
    
    
    allJPSTH.stim.fast.psth_1(1,:,file) = out.stim.fast.psth_1;
    allJPSTH.stim.fast.psth_2(1,:,file) = out.stim.fast.psth_2;
    allJPSTH.stim.fast.normalized_jpsth(1:size(out.stim.fast.normalized_jpsth,1),1:size(out.stim.fast.normalized_jpsth,2),file) = out.stim.fast.normalized_jpsth;
    allJPSTH.stim.fast.unnormalized_jpsth(1:size(out.stim.fast.unnormalized_jpsth,1),1:size(out.stim.fast.unnormalized_jpsth,2),file) = out.stim.fast.unnormalized_jpsth;
    allJPSTH.stim.fast.xcorr_hist(1,:,file) = out.stim.fast.xcorr_hist;
    allJPSTH.stim.fast.pstch(1,:,file) = out.stim.fast.pstch;
    allJPSTH.stim.fast.covariogram(1,:,file) = out.stim.fast.covariogram;
    allJPSTH.stim.fast.sig_low(1,:,file) = out.stim.fast.sig_low;
    allJPSTH.stim.fast.sig_high(1,:,file) = out.stim.fast.sig_high;
    
    
    
    %=========================
    % SACCADE PERIOD
    allJPSTH.sacc.all.psth_1(1,:,file) = out.sacc.all.psth_1;
    allJPSTH.sacc.all.psth_2(1,:,file) = out.sacc.all.psth_2;
    allJPSTH.sacc.all.normalized_jpsth(1:size(out.sacc.all.normalized_jpsth,1),1:size(out.sacc.all.normalized_jpsth,2),file) = out.sacc.all.normalized_jpsth;
    allJPSTH.sacc.all.unnormalized_jpsth(1:size(out.sacc.all.unnormalized_jpsth,1),1:size(out.sacc.all.unnormalized_jpsth,2),file) = out.sacc.all.unnormalized_jpsth;
    allJPSTH.sacc.all.xcorr_hist(1,:,file) = out.sacc.all.xcorr_hist;
    allJPSTH.sacc.all.pstch(1,:,file) = out.sacc.all.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.sacc.all.covariogram(1,:,file) = out.sacc.all.covariogram;
    allJPSTH.sacc.all.sig_low(1,:,file) = out.sacc.all.sig_low;
    allJPSTH.sacc.all.sig_high(1,:,file) = out.sacc.all.sig_high;
    
    
    allJPSTH.sacc.slow.psth_1(1,:,file) = out.sacc.slow.psth_1;
    allJPSTH.sacc.slow.psth_2(1,:,file) = out.sacc.slow.psth_2;
    allJPSTH.sacc.slow.normalized_jpsth(1:size(out.sacc.slow.normalized_jpsth,1),1:size(out.sacc.slow.normalized_jpsth,2),file) = out.sacc.slow.normalized_jpsth;
    allJPSTH.sacc.slow.unnormalized_jpsth(1:size(out.sacc.slow.unnormalized_jpsth,1),1:size(out.sacc.slow.unnormalized_jpsth,2),file) = out.sacc.slow.unnormalized_jpsth;
    allJPSTH.sacc.slow.xcorr_hist(1,:,file) = out.sacc.slow.xcorr_hist;
    allJPSTH.sacc.slow.pstch(1,:,file) = out.sacc.slow.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.sacc.slow.covariogram(1,:,file) = out.sacc.slow.covariogram;
    allJPSTH.sacc.slow.sig_low(1,:,file) = out.sacc.slow.sig_low;
    allJPSTH.sacc.slow.sig_high(1,:,file) = out.sacc.slow.sig_high;
    
    
    allJPSTH.sacc.fast.psth_1(1,:,file) = out.sacc.fast.psth_1;
    allJPSTH.sacc.fast.psth_2(1,:,file) = out.sacc.fast.psth_2;
    allJPSTH.sacc.fast.normalized_jpsth(1:size(out.sacc.fast.normalized_jpsth,1),1:size(out.sacc.fast.normalized_jpsth,2),file) = out.sacc.fast.normalized_jpsth;
    allJPSTH.sacc.fast.unnormalized_jpsth(1:size(out.sacc.fast.unnormalized_jpsth,1),1:size(out.sacc.fast.unnormalized_jpsth,2),file) = out.sacc.fast.unnormalized_jpsth;
    allJPSTH.sacc.fast.xcorr_hist(1,:,file) = out.sacc.fast.xcorr_hist;
    allJPSTH.sacc.fast.pstch(1,:,file) = out.sacc.fast.pstch;
    allJPSTH.sacc.fast.covariogram(1,:,file) = out.sacc.fast.covariogram;
    allJPSTH.sacc.fast.sig_low(1,:,file) = out.sacc.fast.sig_low;
    allJPSTH.sacc.fast.sig_high(1,:,file) = out.sacc.fast.sig_high;
    
    %
    %     if plot_each_session
    %         subplot(2,2,1)
    %         imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
    %             out.slow.normalized_jpsth)
    %         colorbar
    %         axis xy
    %         x1 = get(gca,'clim');
    %         title('Slow')
    %
    %         subplot(222)
    %         imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
    %             out.fast.normalized_jpsth)
    %         colorbar
    %         axis xy
    %         x2 = get(gca,'clim');
    %         title('Fast')
    %
    %         %make sure 0 is always the same color
    %         set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
    %         subplot(221)
    %         set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
    %
    %         %         d = out.slow.normalized_jpsth - out.fast.normalized_jpsth;
    %         %
    %         %         subplot(223)
    %         %         imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2),d)
    %         %         colorbar
    %         %         axis xy
    %         %         x = get(gca,'clim');
    %         %         m = max(abs(x));
    %         %         set(gca,'clim',[-m m]);
    %         %         title('Difference')
    %
    %         subplot(223)
    %         imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
    %             out.all.normalized_jpsth)
    %         colorbar
    %         axis xy
    %         x = get(gca,'clim');
    %         set(gca,'clim',[-max(abs(x)) max(abs(x))])
    %         title('All trials')
    %
    %         subplot(224)
    %         plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,out.fast.pstch,'g')
    %         hold on
    %         plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,out.slow.pstch,'r')
    %         xlim([plottime_prestim(1) plottime_prestim(2)])
    %         title(['Coincidence Histogram of width ' mat2str(coin_width) ' ms'])
    %         box off
    %         hline(0,'k')
    %
    %         pause
    %         cla
    %         subplot(222)
    %         cla
    %         subplot(221)
    %         cla
    %     end
    %
    keep depthDiff file filename unit plotFlag plot_each_session plottime* allJPSTH n_overlapRF* bin_width coin_width sameHemi bin_centers
end




if plotFlag
    
    figure
    set(gcf,'position',[1134         583        1141         755])
    subplot(3,2,[1 3])
    imagesc(bin_centers.full,bin_centers.full, ...
        nanmean(allJPSTH.full.all.normalized_jpsth,3))
    title('All Trials')
    colorbar
    axis xy
    dline
    xlabel('Spike 1')
    ylabel('Spike 2')
    
    
    subplot(325)
    plot(bin_centers.full,nanmean(allJPSTH.full.all.pstch,3),'k', ...
        bin_centers.full,nanmean(allJPSTH.full.slow.pstch,3),'r', ...
        bin_centers.full,nanmean(allJPSTH.full.fast.pstch,3),'g')
    xlim([bin_centers.full(1) bin_centers.full(end)])
    y0 = ylim;
    ylim([-y0(2) y0(2)])
    xlabel('Bin Center')
    hline(0,'k')
    title(['Coincidence Histogram over ' mat2str(coin_width) ' ms'])
    box off
    
    subplot(322)
    plot(-50:50,nanmean(allJPSTH.baseline.all.covariogram,3),'k', ...
        -50:50,nanmean(allJPSTH.baseline.slow.covariogram,3),'r', ...
        -50:50,nanmean(allJPSTH.baseline.fast.covariogram,3),'g')
    xlim([-50 50])
    y1 = ylim;%ylim([-.5 2])
    box off
    vline(0,'k')
    xlabel('<-- Spike 1 Leads                Spike 1 Follows -->')
    title(mat2str(plottime_prestim))
    
    subplot(324)
    plot(-50:50,nanmean(allJPSTH.stim.all.covariogram,3),'k', ...
        -50:50,nanmean(allJPSTH.stim.slow.covariogram,3),'r', ...
        -50:50,nanmean(allJPSTH.stim.fast.covariogram,3),'g')
    xlim([-50 50])
    %ylim([-.5 2])
    y2 = ylim;
    box off
    vline(0,'k')
    xlabel('<-- Spike 1 Leads                Spike 1 Follows -->')
    title(mat2str(plottime_stim))
    
    subplot(326)
    plot(-50:50,nanmean(allJPSTH.sacc.all.covariogram,3),'k', ...
        -50:50,nanmean(allJPSTH.sacc.slow.covariogram,3),'r', ...
        -50:50,nanmean(allJPSTH.sacc.fast.covariogram,3),'g')
    xlim([-50 50])
    y3 = ylim;%ylim([-.5 2])
    box off
    vline(0,'k')
    xlabel('<-- Spike 1 Leads                Spike 1 Follows -->')
    title(mat2str(plottime_sacc))
    
    %equate ylims
    y(1) = min([y1(1) y2(1) y3(1)]);
    y(2) = max([y1(2) y2(2) y3(2)]);
    
    subplot(322)
    ylim(y)
    vline(0,'k')
    
    subplot(324)
    ylim(y)
    vline(0,'k')
    
    subplot(326)
    ylim(y)
    vline(0,'k')
    
    
    
end
toc