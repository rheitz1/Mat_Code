% Creates a PSTH normalized by # of trials and bin width to convert to spikes/sec, for comparison with
% SDFs

function [] = PSTH(Spike,Plot_Time,nBins,plotFlag)

if nargin < 4; plotFlag = 1; end
if nargin < 3; nBins = 100; end
if nargin < 2; Plot_Time = [-100 1000]; end

Target_ = evalin('caller','Target_');


%Fix spike times
Spike(find(Spike == 0)) = NaN;
Spike = Spike - Target_(1,1);

bin_size = length(Plot_Time(1):Plot_Time(2)) / nBins;
bins = Plot_Time(1):bin_size:Plot_Time(2);

counts = histc(Spike(:),bins);

%normalize by bin size and # of trials
counts = (counts ./ (size(Spike,1)) ./ bin_size);

% this gives you counts / ms
% multiply by 1000 to get spikes/sec
counts = counts * 1000;

if plotFlag
    figure
    plot(Plot_Time(1):bin_size:Plot_Time(2),counts)
    xlim([Plot_Time(1) Plot_Time(2)]);
    box off
    ylabel('Spikes/Sec','fontsize',12,'fontweight','bold')
    xlabel('Time from Array Onset (ms)','fontsize',12,'fontweight','bold')
end



