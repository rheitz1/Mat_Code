% compute joint peri-stimulus time histogram for SAT data
%
% RPH

%=====================================================
% FEF DATA

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/JPSTH/TL/
[filename unit1a unit1b] = textread('JPSTH_TL_S.txt','%s %s %s');

unit = [unit1a unit1b];

plotFlag = 0;
plot_each_session = 0;

for file = 1:length(filename)
    
    load(filename{file},unit{file,1},unit{file,2},'TrialStart_','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile','Hemi')
    filename{file}

    sig1 = eval(unit{file,1});
    sig2 = eval(unit{file,2});
    
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
    
       
    
    
    %plottime_prestim = [-1500 0];
    plottime_prestim = [-2500 300];
    plotttime_stim = [0 1000];
    win_size = 5;
    coin_width = 20; % average over coin_width/2 on either side of main diagonal
    
    
    %Before even checking to see if there are RFs, compute JPSTH for
    %baseline activity
    out.all = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],win_size,coin_width,1:size(sig1,1),0);
%     out.slow = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],win_size,coin_width,slow_all,0);
%     out.fast = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],win_size,coin_width,fast_all_withCleared,0);
%     
    allJPSTH.baseline.all.psth_1(1,:,file) = out.all.psth_1;
    allJPSTH.baseline.all.psth_2(1,:,file) = out.all.psth_2;
    allJPSTH.baseline.all.normalized_jpsth(1:size(out.all.normalized_jpsth,1),1:size(out.all.normalized_jpsth,2),file) = out.all.normalized_jpsth;
    allJPSTH.baseline.all.unnormalized_jpsth(1:size(out.all.unnormalized_jpsth,1),1:size(out.all.unnormalized_jpsth,2),file) = out.all.unnormalized_jpsth;
    allJPSTH.baseline.all.xcorr_hist(1,:,file) = out.all.xcorr_hist;
    allJPSTH.baseline.all.pstch(1,:,file) = out.all.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.baseline.all.covariogram(1,:,file) = out.all.covariogram;
    allJPSTH.baseline.all.sig_low(1,:,file) = out.all.sig_low;
    allJPSTH.baseline.all.sig_high(1,:,file) = out.all.sig_high;
    
    
%     allJPSTH.baseline.slow.psth_1(1,:,file) = out.slow.psth_1;
%     allJPSTH.baseline.slow.psth_2(1,:,file) = out.slow.psth_2;
%     allJPSTH.baseline.slow.normalized_jpsth(1:size(out.slow.normalized_jpsth,1),1:size(out.slow.normalized_jpsth,2),file) = out.slow.normalized_jpsth;
%     allJPSTH.baseline.slow.unnormalized_jpsth(1:size(out.slow.unnormalized_jpsth,1),1:size(out.slow.unnormalized_jpsth,2),file) = out.slow.unnormalized_jpsth;
%     allJPSTH.baseline.slow.xcorr_hist(1,:,file) = out.slow.xcorr_hist;
%     allJPSTH.baseline.slow.pstch(1,:,file) = out.slow.pstch; %peri-stimulus time coincidence histogram
%     allJPSTH.baseline.slow.covariogram(1,:,file) = out.slow.covariogram;
%     allJPSTH.baseline.slow.sig_low(1,:,file) = out.slow.sig_low;
%     allJPSTH.baseline.slow.sig_high(1,:,file) = out.slow.sig_high;
%     
%     
%     allJPSTH.baseline.fast.psth_1(1,:,file) = out.fast.psth_1;
%     allJPSTH.baseline.fast.psth_2(1,:,file) = out.fast.psth_2;
%     allJPSTH.baseline.fast.normalized_jpsth(1:size(out.fast.normalized_jpsth,1),1:size(out.fast.normalized_jpsth,2),file) = out.fast.normalized_jpsth;
%     allJPSTH.baseline.fast.unnormalized_jpsth(1:size(out.fast.unnormalized_jpsth,1),1:size(out.fast.unnormalized_jpsth,2),file) = out.fast.unnormalized_jpsth;
%     allJPSTH.baseline.fast.xcorr_hist(1,:,file) = out.fast.xcorr_hist;
%     allJPSTH.baseline.fast.pstch(1,:,file) = out.fast.pstch;
%     allJPSTH.baseline.fast.covariogram(1,:,file) = out.fast.covariogram;
%     allJPSTH.baseline.fast.sig_low(1,:,file) = out.fast.sig_low;
%     allJPSTH.baseline.fast.sig_high(1,:,file) = out.fast.sig_high;
    
    if plot_each_session
        subplot(2,2,1)
        imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
            out.slow.normalized_jpsth)
        colorbar
        axis xy
        x1 = get(gca,'clim');
        title('Slow')
        
        subplot(222)
        imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
            out.fast.normalized_jpsth)
        colorbar
        axis xy
        x2 = get(gca,'clim');
        title('Fast')
        
        %make sure 0 is always the same color
        set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
        subplot(221)
        set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
        
        %         d = out.slow.normalized_jpsth - out.fast.normalized_jpsth;
        %
        %         subplot(223)
        %         imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2),d)
        %         colorbar
        %         axis xy
        %         x = get(gca,'clim');
        %         m = max(abs(x));
        %         set(gca,'clim',[-m m]);
        %         title('Difference')
        
        subplot(223)
        imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
            out.all.normalized_jpsth)
        colorbar
        axis xy
        x = get(gca,'clim');
        set(gca,'clim',[-max(abs(x)) max(abs(x))])
        title('All trials')
        
        subplot(224)
        plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,out.fast.pstch,'g')
        hold on
        plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,out.slow.pstch,'r')
        xlim([plottime_prestim(1) plottime_prestim(2)])
        title(['Coincidence Histogram of width ' mat2str(coin_width) ' ms'])
        box off
        hline(0,'k')
        
        pause
        cla
        subplot(222)
        cla
        subplot(221)
        cla
    end
    
    keep  file filename unit plotFlag plot_each_session plottime* allJPSTH n_overlapRF* win_size coin_width sameHemi
end




if plotFlag
    figure
    subplot(221)
    imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
        nanmean(allJPSTH.baseline.all.normalized_jpsth,3))
    title('Accurate')
    colorbar
    axis xy
    %dline
    x1 = get(gca,'clim');
    
%     subplot(222)
%     imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
%         nanmean(allJPSTH.baseline.fast.normalized_jpsth,3))
%     title('Fast')
%     colorbar
%     axis xy
%     %dline
%     x2 = get(gca,'clim');
%     
%     %make sure 0 is always the same color
%     set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
%     subplot(221)
%     set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
%     
    %     d = nanmean(allJPSTH.baseline.slow.normalized_jpsth,3) - nanmean(allJPSTH.baseline.fast.normalized_jpsth,3);
    %
    %     subplot(223)
    %     imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2),d)
    %     title('Accurate - Fast')
    %     colorbar
    %     axis xy
    %     dline
    
    %equate range of +/1 clim
    %     x = get(gca,'clim');
    %     m = max(abs(x));
    %     set(gca,'clim',[-m m]);
    
    
    subplot(223)
    imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
        nanmean(allJPSTH.baseline.all.normalized_jpsth,3))
    title('All')
    colorbar
    axis xy
    
    x = get(gca,'clim');
    set(gca,'clim',[-max(abs(x)) max(abs(x))])
    %     dline
    
    subplot(224)
    plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,nanmean(allJPSTH.baseline.all.pstch,3),'g')
%     hold on
%     plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,nanmean(allJPSTH.baseline.slow.pstch,3),'r')
    xlim([plottime_prestim(1) plottime_prestim(2)])
    title(['Average Coincidence Histogram of width ' mat2str(coin_width) ' ms'])
    box off
    hline(0,'k')
    
end
