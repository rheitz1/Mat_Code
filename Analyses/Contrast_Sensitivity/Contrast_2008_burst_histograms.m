%Neuron onset time histograms
%run associated files
Contrast_2008_burst_slopes
Contrast_2008_maxFire_slopes


plotFlag = 1;


%hist for Bursts
%only need to get bins once since we are defining what
%the bin centers are
[S_hist_burst bins] = hist(S_meanBurst_maxDiff,-50:5:120);
[Q_hist_burst] = hist(Q_meanBurst_maxDiff,-50:5:120);

%hist for maxFire
[S_hist_maxFire] = hist(S_maxFire_maxDiff,-50:5:120);
[Q_hist_maxFire] = hist(Q_maxFire_maxDiff,-50:5:120);

Hist_Bursts = cat(1,Q_hist_burst,S_hist_burst);
Hist_maxFire = cat(1,Q_hist_maxFire,S_hist_maxFire);


if plotFlag == 1
    figure
    orient landscape
    set(gcf,'color','white')
    bar(bins,Hist_Bursts','stacked')
    title('Burst Onset Times')
    
    figure
    orient landscape
    set(gcf,'color','white')
    bar(bins,Hist_maxFire','stacked')
    title('Peak Firing Rates')
end