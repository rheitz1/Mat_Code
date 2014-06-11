% Plots T/in D/in SDF along with TDT for a given neuron
% input should be given as a string of the name of the unit you want to
% plot

% RPH
%

function [] = plotSDF_errors(name,rasterFlag)

if nargin < 2; rasterFlag = 0; end

% Get variables from workspace

Spike = evalin('caller',name);
Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');
saccLoc = evalin('caller','saccLoc');
Errors_ = evalin('caller','Errors_');

RF = RFs.(name);
MF = MFs.(name);

if isempty(RF) %if no RF, check for an MF for move cells
    if ~isempty(MF)
        RF = MFs.(name);
    else
        error('No RF or MF')
    end
end

antiRF = mod((RF+4),8);
antiMF = mod((MF+4),8);


if exist('MStim_')
    in = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
    out = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
else
    
    in_RF = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
    out_RF = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
    
    in_MF = find(Correct_(:,2) == 1 & ismember(Target_(:,2),MF));
    out_MF = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiMF));
    
    errors_into_RF = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
    errors_outof_RF = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
        
    errors_into_MF = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
    errors_outof_MF = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
end

SDF = sSDF(Spike,Target_(:,1),[-100 800]);
SDF_resp = sSDF(Spike,SRT(:,1)+Target_(1,1),[-400 200]);

TDT = getTDT_SP(Spike,in_RF,out_RF);
TDT_errors = getTDT_SP(Spike,errors_into_RF,errors_outof_RF);

figure
fw
subplot(1,2,1)
plot(-100:800,nanmean(SDF(in_RF,:)),'k',-100:800,nanmean(SDF(out_RF,:)),'--k', ...
    -100:800,nanmean(SDF(errors_into_RF,:)),'--r',-100:800,nanmean(SDF(errors_outof_RF,:)),'r','linewidth',1);
vline(TDT,'k')
vline(TDT_errors,'r')
xlim([-100 800])
xlabel('Time from Target Onset')
ylabel('Spikes/sec')
title([name '  TDT = ' mat2str(TDT)])

subplot(1,2,2)
plot(-400:200,nanmean(SDF_resp(in_MF,:)),'k',-400:200,nanmean(SDF_resp(out_MF,:)),'--k', ...
    -400:200,nanmean(SDF_resp(errors_into_MF,:)),'--r',-400:200,nanmean(SDF_resp(errors_outof_RF,:)),'r','linewidth',1)

xlim([-400 200])
vline(0,'k')
xlabel('Time from Saccade Onset')

%equate_y

%==============
%Plot Raster
if rasterFlag
    subplot(1,2,1)
    newax
    
    %Sort trials by SRT
    [sorted_SRT sorted_index] = sort(SRT(:,1),1,'ascend');
    
    [bins cdf] = getCDF(SRT(:,1),30);
    
    for trl = 1:length(sorted_index)
        trlSpike = Spike(sorted_index(trl),find(Spike(sorted_index(trl),:)-Target_(1,1) >= -100 & Spike(sorted_index(trl),:)-Target_(1,1) <= 800));
        if ~isempty(trlSpike)
            plot(trlSpike-Target_(1,1),trl,'k');
        end
    end
    
    %turn off tick labels on secondary axes
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    
    %plot CDF
    lim = get(gca,'ylim');
    plot(bins,(lim(2).*cdf),'--b','linewidth',2)
    xlim([-100 800])
end
