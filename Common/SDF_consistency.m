% Plots the unsorted raster of a given neuron and then plots
% the total spike counts within a window. Fluctuations in the
% spike counts are indicative of a changing sort

% RPH
%

function [] = SDF_consistency(name,bin_width,window)

if nargin < 3; window = [0 100]; end
if nargin < 2; bin_width = 10; end



% Get variables from workspace

Spike = evalin('caller',name);
Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');



SDF = sSDF(Spike,Target_(:,1),[-100 800]);
%SDF_resp = sSDF(Spike,SRT(:,1)+Target_(1,1),[-400 200]);

%TDT = getTDT_SP(Spike,in_RF,out_RF);


figure
fw
subplot(1,2,1)
plot(-100:800,nanmean(SDF),'k',-100:800,nanmean(SDF),'--k','linewidth',2);
xlim([-100 800])
xlabel('Time from Target Onset')
ylabel('Spikes/sec')


% subplot(1,2,2)
% plot(-400:200,nanmean(SDF_resp(in_MF,:)),'k',-400:200,nanmean(SDF_resp(out_MF,:)),'--k','linewidth',2)
% xlim([-400 200])
% vline(0,'k')
% xlabel('Time from Saccade Onset')

%equate_y

%==============
%Plot Raster
subplot(1,2,1)
newax

%Sort trials by SRT
%[sorted_SRT sorted_index] = sort(SRT(:,1),1,'ascend');

[bins cdf] = getCDF(SRT(:,1),30);

for trl = 1:size(Spike,1)
    trlSpike = Spike(trl,find(Spike(trl,:)-Target_(1,1) >= -100 & Spike(trl,:)-Target_(1,1) <= 800));
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

spike = Spike;
spike(find(spike == 0)) = NaN;
spike = spike - Target_(1,1);
%calculate spike counts in a window in bins of N trials
binDex = 1;
for bin = 1:bin_width:size(Spike,1)-bin_width
    spike_times = spike(bin:bin+bin_width-1,:);
    spike_counts(binDex,1) = length(find(spike_times >= window(1) & spike_times <= window(2)));
    binDex = binDex + 1;
end

%normalize spike_counts by bin width so it is an average/trial
spike_counts = spike_counts / bin_width;

subplot(122)
plot(1:bin_width:size(Spike,1)-bin_width,spike_counts,'-ok','linewidth',2)
xlabel('Bin #')
ylabel('Spike Counts')
%ylim([0 100])
xlim([0 bin_width*length(spike_counts)])