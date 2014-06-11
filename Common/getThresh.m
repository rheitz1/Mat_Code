% If cell is a vis-move or move, plots the threshold activity (20-10) ms before
% response-aligned SRT by n RT bins
function [thresh,baseline,onset,rate,labels] = getThresh(Spike,RF,MF,trials,numBins,plotFlag)

Target_= evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
TrialStart_ = evalin('caller','TrialStart_');

if nargin < 6; plotFlag = 1; end
if nargin < 5; numBins = 5; end
if nargin < 4; trials = find(Correct_(:,2) == 1); end

Plot_Time_r = [-400 200];
Plot_Time_t = [-200 1000];

normalize = 0;

if normalize; disp('Normalizing SDFs'); end

%calculate n RT bins
divideby = round(100/numBins);

j = 1;
for i = divideby:divideby:100
    percentile_array(j) = prctile(SRT(trials,1),i);
    j = j + 1;
end

SDF_targ = sSDF(Spike,Target_(:,1),Plot_Time_t);
SDF_resp = sSDF(Spike,Target_(:,1)+SRT(:,1),Plot_Time_r);

if normalize
    SDF_targ = normalize_SP(SDF_targ);
    SDF_resp = normalize_SP(SDF_resp);
end

% Get overall SDF regardless of SRT
if ~isempty(RF)
    trls_RF_all = intersect(trials,find(ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,2) > 50));
    %SDF_t_all = spikedensityfunct(Spike,Target_(:,1),Plot_Time_t,trls_RF_all,TrialStart_);
    SDF_t_all = SDF_targ(trls_RF_all,:);
else
    trls_RF_all = [];
end

if ~isempty(MF)
    trls_MF_all = intersect(trials,find(ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,2) > 50));
    %SDF_r_all = spikedensityfunct(Spike,SRT(:,1)+Target_(1,1),Plot_Time_r,trls_MF_all,TrialStart_);
    SDF_r_all = SDF_resp(trls_MF_all,:);
else
    trls_MF_all = [];
end





% Get SDFs for different RT bins and calculate parameters
for k = 1:length(percentile_array) %you don't do last bin
    
    %rule is different when bin is first or last
    
    if k == 1
        trls_RF = intersect(trls_RF_all,find(SRT(:,1) <= percentile_array(k) & ismember(Target_(:,2),RF)));
        trls_MF = intersect(trls_MF_all,find(SRT(:,1) <= percentile_array(k) & ismember(Target_(:,2),MF)));
    elseif k == length(percentile_array)
        trls_RF = intersect(trls_RF_all,find(SRT(:,1) > percentile_array(k-1) & ismember(Target_(:,2),RF)));
        trls_MF = intersect(trls_MF_all,find(SRT(:,1) > percentile_array(k-1) & ismember(Target_(:,2),MF)));        
    else
        trls_RF = intersect(trls_RF_all,find(SRT(:,1) <= percentile_array(k) & SRT(:,1) > percentile_array(k-1) & ismember(Target_(:,2),RF)));
        trls_MF = intersect(trls_MF_all,find(SRT(:,1) <= percentile_array(k) & SRT(:,1) > percentile_array(k-1) & ismember(Target_(:,2),MF)));
    end
    
    
    SDF_r(:,k) = nanmean(SDF_resp(trls_MF,:));
    SDF_t(:,k) = nanmean(SDF_targ(trls_RF,:));
    %SDF_r(:,k) = spikedensityfunct(Spike,SRT(:,1)+Target_(1,1),Plot_Time_r,trls_MF,TrialStart_);
    %SDF_t(:,k) = spikedensityfunct(Spike,Target_(:,1),Plot_Time_t,trls_MF,TrialStart_);
    
    %allSDF_r = sSDF(Spike,SRT(:,1) + 500,Plot_Time_r); %needed for estimation of onset times
    
    %note using abs(Plot_Time) will put you at saccade time.
    if ~isempty(MF)
        thresh(k) = mean(SDF_r(abs(Plot_Time_r(1))-20:abs(Plot_Time_r(1))-10,k));
    else
        thresh(k) = NaN;
    end
    %sderr_thresh(k) = std(SDF_r(abs(Plot_Time_r(1))-20:abs(Plot_Time_r(1))-10)) / sqrt(11); %divide by 11 because always using times -20:-10 before saccade onset.
    
    if ~isempty(RF)
        baseline(k) = mean(SDF_t(abs(Plot_Time_t(1))-100:abs(Plot_Time_t(1)),k));
    else
        baseline(k) = NaN;
    end
    
    %sderr_baseline(k) = std(SDF_t(1:abs(Plot_Time_t((1))))) / sqrt(length(1:abs(Plot_Time_t(1))));
    
    %onset(k) = move_onset(SDF_t(:,k),Plot_Time_t,.05) - abs(Plot_Time_t(1));
    %onset(k) = find(SDF_r(:,k) > (std(SDF_r(:,k))*2 + min(SDF_r(:,k))),1) + Plot_Time_r(1);
    
    %base = nanmean(allSDF_r(trls,1:20),2);
    %     for t = 50:size(allSDF_r,2)
    %         [p(t) h(t)] = ranksum(allSDF_r(trls,t),base);
    %     end
    %     onset(k) = Plot_Time_r(1) + min(findRuns(h,10));
    
    if ~isempty(MF)
        %Regression Method
        %onset_ind(k) = change_point(SDF_r(:,k)');
        
        %Woodman Method
        % start at max value in 100 ms surrounding saccade
        [~,dex] = max(SDF_r(300:500,k));
        dex = dex + 300;
        
        onset_ind(k) = getOnset(SDF_r(:,k)',dex);

        
        %actual time of onset
        time_vec = Plot_Time_r(1):Plot_Time_r(2);
        
        if ~isnan(onset_ind(k)) && onset_ind(k) ~= 0
            onset(k) = time_vec(onset_ind(k));
        else
            onset(k) = NaN;
        end
        
    else
        onset(k) = NaN;
    end
    
    
    if ~isempty(MF) && ~isnan(onset_ind(k)) && onset_ind(k) ~= 0
        rate(k) = (thresh(k) - SDF_r(onset_ind(k),k)) / abs(onset(k)); %onset will always be length of time from response, time 0. Just take abs val
    else
        rate(k) = NaN;
    end

    
    if ~isempty(MF)
        labels(k) = round(nanmean(SRT(trls_MF,1)));
    else
        labels(k) = round(nanmean(SRT(trls_RF,1)));
    end
    
end

graycolorscale = 1/numBins;
graymap = 0:graycolorscale:length(numBins);


if plotFlag == 1
    fig
    
    %Plot Response-aligned SDFs
    subplot(3,2,1)
    hold
    for plt = 1:size(SDF_r,2)
        plot(Plot_Time_r(1):Plot_Time_r(2),SDF_r(:,plt),'Color',[graymap(plt) graymap(plt) graymap(plt)],'linewidth',2)
    end
    v = vline(0,'k');
    set(v,'linewidth',2)
    xlabel('Time from Response','fontsize',12,'fontweight','bold')
    ylabel('Firing Rate (Hz)','fontsize',12,'fontweight','bold')
    xlim([Plot_Time_r(1) Plot_Time_r(2)])
    
    if normalize
        ylim([0 2.5])
    else
        ylim([min(min(SDF_r))-20 max(max(SDF_r))+20])
    end
    
    title('Black = Fastest Bin')
    
    %Plot Threshold estimates
    subplot(3,2,2)
    %plot(thresh,'d','markeredgecolor','k','markerfacecolor','k','markersize',8)
    %errorbar(1:numBins,thresh,sderr_thresh,'dk','linestyle','none','markerfacecolor','k')
    plot(1:numBins,thresh,'ok','markerfacecolor','k')
    ylim([min(min(SDF_r))-20 max(max(SDF_r))+20])
    set(gca,'xtick',1:numBins,'xticklabel',labels)
    xlim([0 numBins+1])
    
    if normalize
        ylim([0 2.5])
    end
    %xlabel('Time Bin Center','fontsize',12,'fontweight','bold')
    title('Threshold','fontsize',12,'fontweight','bold')
    
    %Plot Target-aligned SDFs
    subplot(3,2,3)
    hold
    for plt = 1:size(SDF_t,2)
        plot(Plot_Time_t(1):Plot_Time_t(2),SDF_t(:,plt),'Color',[graymap(plt) graymap(plt) graymap(plt)],'linewidth',2)
    end
    v = vline(0,'k');
    set(v,'linewidth',2)
    xlabel('Time from Target','fontsize',12,'fontweight','bold')
    ylabel('Firing Rate (Hz)','fontsize',12,'fontweight','bold')
    xlim([Plot_Time_t(1) Plot_Time_t(2)])
    
    if normalize
        ylim([0 2.5])
    else
        ylim([0 max(max(SDF_t))+20])
    end
    
    %Plot Baseline Estimation
    subplot(3,2,4)
    % errorbar(1:numBins,baseline,sderr_baseline,'dk','linestyle','none','markerfacecolor','k')
    plot(1:numBins,baseline,'ok','markerfacecolor','k')
    % ylim([min(min(SDF_r))-20 max(max(SDF_r))+20])
    set(gca,'xtick',1:numBins,'xticklabel',labels)
    xlabel('RT Bin Center','fontsize',12,'fontweight','bold')
    title('Baseline','fontsize',12,'fontweight','bold')
    xlim([0 numBins+1])
    
    if normalize
        ylim([0 2.5])
    else
        ylim([0 max(max(SDF_t))+20])
    end
    
    
    %Plot Onset estimation w/ vlines on first plot
    subplot(3,2,5)
    plot(1:numBins,onset,'ok','markerfacecolor','k')
    set(gca,'xtick',1:numBins,'xticklabel',labels)
    xlim([0 numBins+1])
    xlabel('RT Bin Center','fontsize',12,'fontweight','bold')
    ylabel('Onset Time (ms)','fontsize',12,'fontweight','bold')
    title('Onset','fontsize',12,'fontweight','bold')
    
    if ~isempty(MF)
            ylim([min(onset) - 50 max(onset) + 50])
    else
        ylim([0 1])
    end
    
    axis ij
    
    subplot(3,2,1)
    extent = ylim;
    for plt = 1:size(SDF_t,2)
        line([onset(plt) onset(plt)],[extent(1) extent(2)],'Color',[graymap(plt) graymap(plt) graymap(plt)],'linewidth',2)
    end
    
    %Plot Rate estimate. Note that threshold estimated from
    %response-aligned and baseline estimated from target aligned.  Might
    %want to also try this using baseline from response-aligned.
    subplot(3,2,6)
    plot(1:numBins,rate,'ok','markerfacecolor','k')
    set(gca,'xtick',1:numBins,'xticklabel',labels)
    xlim([0 numBins+1])
    xlabel('RT Bin Center','fontsize',12,'fontweight','bold')
    ylabel('Rate (spikes / sec / sec)','fontsize',12,'fontweight','bold')
    title('Growth Rate','fontsize',12,'fontweight','bold')
    
    if ~isempty(MF)
            ylim([min(rate) - .02 max(rate + .02)])
    else
        ylim([0 1])
    end
end