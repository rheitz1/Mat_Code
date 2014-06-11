%get CDFs of burst onset times

%Run associated scripts
Contrast_2008_burst_histograms

plotFlag = 1;

[Q_CDF_low Q_bins_low] = getCDF(cell2mat(Q_meanBurst(:,1)),30);
[Q_CDF_med Q_bins_med] = getCDF(cell2mat(Q_meanBurst(:,2)),30);
[Q_CDF_high Q_bins_high] = getCDF(cell2mat(Q_meanBurst(:,3)),30);

[S_CDF_low S_bins_low] = getCDF(cell2mat(S_meanBurst(:,1)),30);
[S_CDF_med S_bins_med] = getCDF(cell2mat(S_meanBurst(:,2)),30);
[S_CDF_high S_bins_high] = getCDF(cell2mat(S_meanBurst(:,3)),30);

%0 pad to ensure all CDFs start at 0
Q_CDF_low = [0 Q_CDF_low];
Q_CDF_med = [0 Q_CDF_med];
Q_CDF_high = [0 Q_CDF_high];

Q_bins_low = [0 Q_bins_low];
Q_bins_med = [0 Q_bins_med];
Q_bins_high = [0 Q_bins_high];

S_CDF_low = [0 S_CDF_low];
S_CDF_med = [0 S_CDF_med];
S_CDF_high = [0 S_CDF_high];

S_bins_low = [0 S_bins_low];
S_bins_med = [0 S_bins_med];
S_bins_high = [0 S_bins_high];

if plotFlag == 1
    figure
    orient landscape
    hold
    set(gcf,'color','white')
    
    plot(Q_bins_low, Q_CDF_low,'b')
    plot(Q_bins_med, Q_CDF_med,'b')
    plot(Q_bins_high, Q_CDF_high,'b')
    plot(S_bins_low, S_CDF_low,'r')
    plot(S_bins_med, S_CDF_med,'r')
    plot(S_bins_high, S_CDF_high,'r')  
end