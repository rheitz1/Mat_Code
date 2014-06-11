% compute joint peri-stimulus time histogram for SAT data
%
% RPH

%=====================================================
% FEF DATA

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT/JPSTH/
[filename unit1 unit2] = textread('Blocking_JPSTH.txt','%s %s %s');




unit = [unit1 unit2];

plotFlag = 1;
plot_each_session = 1;

for file = 1:length(filename)
    cd /volumes/Dump/Search_Data_longBase/
    load(filename{file},unit{file,1},unit{file,2},'Correct_','Target_','SRT','newfile')
    filename{file}
    
    sig1 = eval(unit{file,1});
    sig2 = eval(unit{file,2});
    
%     RF1 = RFs.(unit{file,1});
%     RF2 = RFs.(unit{file,2});
%     
%     n_overlapRF(file,1) = length(intersect(RF1,RF2));
%     
%     
%     if Hemi.(unit{file,1}) == Hemi.(unit{file,2})
%         sameHemi(file,1) = 1;
%     else
%         sameHemi(file,1) = 0;
%     end
    
    set2blk = find(Target_(:,6) == 0);
    set4blk = find(Target_(:,6) == 1);
    set8blk = find(Target_(:,6) == 2);

    set2rnd = find(Target_(:,6) == 3 & Target_(:,5) == 2);
    set4rnd = find(Target_(:,6) == 3 & Target_(:,5) == 4);
    set8rnd = find(Target_(:,6) == 3 & Target_(:,5) == 8);
    
    allblock = find(Target_(:,6) < 3);
    allrand = find(Target_(:,6) == 3);
    
    %plottime_prestim = [-1500 0];
    plottime_prestim = [-2500 300];
    win_size = 5;
    coin_width = 20; % average over coin_width/2 on either side of main diagonal
    
    
    %Before even checking to see if there are RFs, compute JPSTH for
    %baseline activity
    out.all = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],win_size,coin_width,1:size(sig1,1),0);
    out.block = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],win_size,coin_width,allblock,0);
    out.rand = getJPSTH(sig1,sig2,[plottime_prestim(1) plottime_prestim(2)],win_size,coin_width,allrand,0);

    
    allJPSTH.all.psth_1(1,:,file) = out.all.psth_1;
    allJPSTH.all.psth_2(1,:,file) = out.all.psth_2;
    allJPSTH.all.normalized_jpsth(1:size(out.all.normalized_jpsth,1),1:size(out.all.normalized_jpsth,2),file) = out.all.normalized_jpsth;
    allJPSTH.all.unnormalized_jpsth(1:size(out.all.unnormalized_jpsth,1),1:size(out.all.unnormalized_jpsth,2),file) = out.all.unnormalized_jpsth;
    allJPSTH.all.xcorr_hist(1,:,file) = out.all.xcorr_hist;
    allJPSTH.all.pstch(1,:,file) = out.all.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.all.covariogram(1,:,file) = out.all.covariogram;
    allJPSTH.all.sig_low(1,:,file) = out.all.sig_low;
    allJPSTH.all.sig_high(1,:,file) = out.all.sig_high;
    
    
    allJPSTH.block.psth_1(1,:,file) = out.block.psth_1;
    allJPSTH.block.psth_2(1,:,file) = out.block.psth_2;
    allJPSTH.block.normalized_jpsth(1:size(out.block.normalized_jpsth,1),1:size(out.block.normalized_jpsth,2),file) = out.block.normalized_jpsth;
    allJPSTH.block.unnormalized_jpsth(1:size(out.block.unnormalized_jpsth,1),1:size(out.block.unnormalized_jpsth,2),file) = out.block.unnormalized_jpsth;
    allJPSTH.block.xcorr_hist(1,:,file) = out.block.xcorr_hist;
    allJPSTH.block.pstch(1,:,file) = out.block.pstch; %peri-stimulus time coincidence histogram
    allJPSTH.block.covariogram(1,:,file) = out.block.covariogram;
    allJPSTH.block.sig_low(1,:,file) = out.block.sig_low;
    allJPSTH.block.sig_high(1,:,file) = out.block.sig_high;
    
    
    allJPSTH.rand.psth_1(1,:,file) = out.rand.psth_1;
    allJPSTH.rand.psth_2(1,:,file) = out.rand.psth_2;
    allJPSTH.rand.normalized_jpsth(1:size(out.rand.normalized_jpsth,1),1:size(out.rand.normalized_jpsth,2),file) = out.rand.normalized_jpsth;
    allJPSTH.rand.unnormalized_jpsth(1:size(out.rand.unnormalized_jpsth,1),1:size(out.rand.unnormalized_jpsth,2),file) = out.rand.unnormalized_jpsth;
    allJPSTH.rand.xcorr_hist(1,:,file) = out.rand.xcorr_hist;
    allJPSTH.rand.pstch(1,:,file) = out.rand.pstch;
    allJPSTH.rand.covariogram(1,:,file) = out.rand.covariogram;
    allJPSTH.rand.sig_low(1,:,file) = out.rand.sig_low;
    allJPSTH.rand.sig_high(1,:,file) = out.rand.sig_high;
    
    if plot_each_session
        subplot(2,2,1)
        imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
            out.block.normalized_jpsth)
        colorbar
        axis xy
        x1 = get(gca,'clim');
        title('Block')
        
        subplot(222)
        imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
            out.rand.normalized_jpsth)
        colorbar
        axis xy
        x2 = get(gca,'clim');
        title('Rand')
        
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
        plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,out.block.pstch,'k')
        hold on
        plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,out.rand.pstch,'--k')
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
        nanmean(allJPSTH.block.normalized_jpsth,3))
    title('Block')
    colorbar
    axis xy
    %dline
    x1 = get(gca,'clim');
    
    subplot(222)
    imagesc(plottime_prestim(1):plottime_prestim(2),plottime_prestim(1):plottime_prestim(2), ...
        nanmean(allJPSTH.rand.normalized_jpsth,3))
    title('Rand')
    colorbar
    axis xy
    %dline
    x2 = get(gca,'clim');
    
    %make sure 0 is always the same color
    set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
    subplot(221)
    set(gca,'clim',[-max(abs([x1 x2])) max(abs([x1 x2]))])
    
    %     d = nanmean(allJPSTH.slow.normalized_jpsth,3) - nanmean(allJPSTH.fast.normalized_jpsth,3);
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
        nanmean(allJPSTH.all.normalized_jpsth,3))
    title('All')
    colorbar
    axis xy
    
    x = get(gca,'clim');
    set(gca,'clim',[-max(abs(x)) max(abs(x))])
    %     dline
    
    subplot(224)
    plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,nanmean(allJPSTH.block.pstch,3),'k')
    hold on
    plot(plottime_prestim(1):win_size:plottime_prestim(2)-1,nanmean(allJPSTH.rand.pstch,3),'--k')
    xlim([plottime_prestim(1) plottime_prestim(2)])
    title(['Average Coincidence Histogram of width ' mat2str(coin_width) ' ms'])
    box off
    hline(0,'k')
    
end
