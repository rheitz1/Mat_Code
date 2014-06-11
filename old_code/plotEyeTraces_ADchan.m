function [] = plotEyeTraces_ADchan(EyeX_,EyeY_,SRT,CorrectTrials,ValidTrials,Decide_,plot_time,Align_Time,ad_list,varargin)
%Will plot, for each trial, the eye traces and SRT estimated from the eye
%traces using the function getSRT.
h = figure;
set(gcf,'Color','white');


%==========Plot Average ERP/LFP=================

%AD values stored in 1 x n Cell array.  Need to
%use cell indexing
for chan = 1:size(varargin,2)
    currAD = varargin{chan};
    %For AD channels, we can use all correct trials, not just ValidTrials
    %(SRT - Decide_ < 45)
    currMean = nanmean(currAD(CorrectTrials,:));
    clear currAD
    subplot(4,3,chan + 3)
    plot(plot_time,currMean)
    xlim([400 1500]);
    title(ad_list(chan));
    set(gca,'Xtick',400:100:1500);
    set(gca,'XTickLabel',-100:100:1000)
end
%================================================
%Plot Eyes on each trial

for nTrial = 1:size(ValidTrials)
    figure(h)
    subplot(4,3,[1:3])
    plot(plot_time,EyeX_(ValidTrials(nTrial),:),'Color','r')
    %title(['File: ' mat2str(filename) '   Date Generated: ' date]);
    text(2200,2,['Trial: ' mat2str(ValidTrials(nTrial))],'FontWeight','bold')
    hold on
    plot(plot_time,EyeY_(ValidTrials(nTrial),:),'Color','b')
    xlim([400 2500]);
    %set max values of eye trace to the maximum value of the X and Y
    %eye traces for current trial, plus a fraction for good measure.
    lim1 = -1*max(max(abs(EyeX_(ValidTrials(nTrial),:))),max(abs(EyeY_(ValidTrials(nTrial),:))));
    lim2 = max(max(abs(EyeX_(ValidTrials(nTrial),:))),max(abs(EyeY_(ValidTrials(nTrial),:))));
    ylim([lim1 + lim1*.5 lim2 + lim2*.5]);
    set(gca,'Xtick',400:100:2500)
    set(gca,'XTickLabel',-100:100:2000)
    set(gca,'FontSize',8)

    %draw target onset time
    line([Align_Time Align_Time],[-2 2],'Color','g')

    %draw Tempo estimated saccade latency
    line([Decide_(ValidTrials(nTrial),1) + 500 Decide_(ValidTrials(nTrial),1) + 500], [-2 2],'Color','k')

    %draw Saccade onset estimated by "getSRT" function
    %SRT(ValidTrials(nTrial))
    trialSacc = nonzeros(SRT(ValidTrials(nTrial),:));
    for nSacc = 1:length(trialSacc)
        %line([SRT(nTrial,nSacc) + 500 SRT(nTrial,nSacc)+500],[-2 2],'Color','b')
        line([SRT(ValidTrials(nTrial),nSacc) + 500 SRT(ValidTrials(nTrial),nSacc) + 500],[-2 2],'Color','b')
    end
    pause
    cla
end
