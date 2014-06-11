% Plots T/in D/in SDF along with TDT for a given neuron
% input should be given as a string of the name of the unit you want to
% plot
%
% This version separates by set size

% RPH
%

function [] = plotSDF_SS(name,rasterFlag)

if nargin < 2; rasterFlag = 0; end

% Get variables from workspace

Spike = evalin('caller',name);
Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');

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


if exist('MStim_')
    in.ss2 = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2 = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.ss4 = find(Target_(:,5) == 4 & isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4 = find(Target_(:,5) == 4 & isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.ss8 = find(Target_(:,5) == 8 & isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8 = find(Target_(:,5) == 8 & isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
else
    
    in.ss2 = find(Target_(:,5) == 2 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2 = find(Target_(:,5) == 2 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.ss4 = find(Target_(:,5) == 4 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4 = find(Target_(:,5) == 4 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.ss8 = find(Target_(:,5) == 8 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8 = find(Target_(:,5) == 8 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
end

SDF = sSDF(Spike,Target_(:,1),[-100 500]);
SDF_resp = sSDF(Spike,SRT(:,1)+500,[-400 200]);

TDT.ss2 = getTDT_SP(Spike,in.ss2,out.ss2);
TDT.ss4 = getTDT_SP(Spike,in.ss4,out.ss4);
TDT.ss8 = getTDT_SP(Spike,in.ss8,out.ss8);


figure
fw
subplot(1,2,1)
plot(-100:500,nanmean(SDF(in.ss2,:)),'b',-100:500,nanmean(SDF(in.ss4,:)),'r',-100:500,nanmean(SDF(in.ss8,:)),'g', ...
    -100:500,nanmean(SDF(out.ss2,:)),'--b',-100:500,nanmean(SDF(out.ss4,:)),'--r',-100:500,nanmean(SDF(out.ss8,:)),'--g')
vline(TDT.ss2,'b')
vline(TDT.ss4,'r')
vline(TDT.ss8,'g')
xlim([-100 500])
xlabel('Time from Target Onset')
ylabel('Spikes/sec')
box off
title([name '  TDT = ' mat2str(TDT.ss2) '  ' mat2str(TDT.ss4) '  ' mat2str(TDT.ss8)])

subplot(1,2,2)
plot(-400:200,nanmean(SDF_resp(in.ss2,:)),'b',-400:200,nanmean(SDF_resp(in.ss4,:)),'r',-400:200,nanmean(SDF_resp(in.ss8,:)),'g', ...
    -400:200,nanmean(SDF_resp(out.ss2,:)),'--b',-400:200,nanmean(SDF_resp(out.ss4,:)),'--r',-400:200,nanmean(SDF_resp(out.ss8,:)),'--g')

xlim([-400 200])
vline(0,'k')
xlabel('Time from Saccade Onset')



%==============
%Plot Raster
if rasterFlag
    subplot(1,2,1)
    newax
    
    %Sort trials by SRT
    [sorted_SRT sorted_index] = sort(SRT(:,1));
    
    [bins cdf] = getCDF(SRT(:,1),30);
    
    for trl = 1:length(sorted_index)
        trlSpike = Spike(sorted_index(trl),find(Spike(sorted_index(trl),:)-500 >= -100 & Spike(sorted_index(trl),:)-500 <= 500));
        if ~isempty(trlSpike)
            plot(trlSpike-500,trl,'k');
        end
    end
    
    %turn off tick labels on secondary axes
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    
    %plot CDF
    lim = get(gca,'ylim');
    plot(bins,(lim(2).*cdf),'--b','linewidth',2)
    xlim([-100 500])
end
