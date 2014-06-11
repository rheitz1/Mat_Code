% Returns and displays Spike statistics
% binwidth = window size (in ms) to compute Fano factor on
%
% RPH

function [Fano,real_time] = getFano_resp(Spike,binwidth,stepsz,window,trls,plotFlag)

%variables we'll need
Target_ = evalin('caller','Target_');
TrialStart_ = evalin('caller','TrialStart_');
SRT = evalin('caller','SRT');

if nargin < 6; plotFlag = 0; end
if nargin < 5; trls = 1:size(Target_,1); end
if nargin < 4; window = [-500 2500]; end
if nargin < 3; stepsz = 10; end
if nargin < 2; binwidth = 50; end

if isempty(trls)
    Fano = NaN;
    return
end

%Keep track of old Spike variable for plotting
Spike_orig = Spike;

%To response align, just rescale each spike time by the RT
Spike(find(Spike == 0)) = NaN;
Spike = Spike - repmat(SRT(:,1)+Target_(1,1),1,size(Spike,2));


%compute Fano Factor (computed on spike counts)
if binwidth < 5; error('Fano factor will not be stable with binwidth < 5'); end
if mod(binwidth,2); error('Bin Width must be divisible by 2'); end

bin_index = 1;

for t = window(1) + (binwidth/2):stepsz:window(2) - (binwidth/2)
    arrivals = (sum(Spike(trls,:) >= t-binwidth/2+1 & Spike(trls,:) < t + binwidth/2,2));
    Fano(bin_index) = nanvar(arrivals) / nanmean(arrivals);
    
    real_time(bin_index) = t;
    bin_index = bin_index + 1;
end


if plotFlag == 1
    
    SDF = spikedensityfunct(Spike_orig,SRT(:,1) + Target_(:,1),[window(1) window(2)],trls,TrialStart_);
    figure
    
    subplot(2,1,1)
    plot(window(1):window(2),SDF)
    xlim([window(1) window(2)])
    title('SDF')
    
    subplot(2,1,2)
    plot(real_time,Fano,'r')
    xlim([window(1) window(2)])
    title('Fano Factor computed on Spike Counts')
    
    
end