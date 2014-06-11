% Returns and displays Spike statistics
% binwidth = window size (in ms) to compute Fano factor on
%
% RPH

function [stats,real_time] = getSpikeStats(Spike,binwidth,stepsz,window,trls,plotFlag)

%variables we'll need
Target_ = evalin('caller','Target_');
TrialStart_ = evalin('caller','TrialStart_');

if nargin < 6; plotFlag = 0; end
if nargin < 5; trls = 1:size(Target_,1); end
if nargin < 4; window = [-500 2500]; end
if nargin < 3; stepsz = 10; end
if nargin < 2; binwidth = 50; end

if isempty(trls)
    stats.CV = NaN;
    stats.Fano = NaN;
    stats.NV = NaN;
    return
end

Spike(find(Spike == 0)) = NaN;
Spike = Spike - Target_(1,1);

%compute CV (computed on ISI distribution)
ISI = diff(Spike(trls,:),1,2);
stats.CV = nanstd(ISI(:)) / nanmean(ISI(:));


%compute Fano Factor (computed on spike counts)
%if binwidth < 5; error('Fano factor will not be stable with binwidth < 5'); end
if mod(binwidth,2); error('Bin Width must be divisible by 2'); end

bin_index = 1;
% for t = window(1) + binwidth/2:stepsz:window(2)+ binwidth/2
%     arrivals = sum(Spike(trls,:) >= t-binwidth/2+1 & Spike(trls,:) < t + binwidth/2,2);
%     stats.Fano(bin_index) = nanvar(arrivals) / nanmean(arrivals);
%     
%     real_time(bin_index) = t;
%     bin_index = bin_index + 1;
% end

for t = window(1) + (binwidth/2):stepsz:window(2) - (binwidth/2)
    arrivals = (sum(Spike(trls,:) >= t-binwidth/2+1 & Spike(trls,:) < t + binwidth/2,2));
    stats.Fano(bin_index) = nanvar(arrivals) / nanmean(arrivals);
    
    %     last_edge = t + binwidth;
    real_time(bin_index) = t;
    bin_index = bin_index + 1;
end


%compute Neural Variability (computed on Spike Rates from PSP filter)
stats.NV = getNV(Spike,trls);

if plotFlag == 1
    
    SDF = spikedensityfunct(Spike,Target_(:,1),[window(1) window(2)],trls,TrialStart_);
    figure
    
    subplot(3,1,1)
    plot(window(1):window(2),SDF)
    xlim([-50 500])
    title(['SDF   Coef of Variation computed on ISI distribution = ' mat2str(stats.CV)])
    
    subplot(3,1,2)
    plot(real_time,stats.Fano,'r')
    xlim([-200 500])
    title('Fano Factor computed on Spike Counts')
    
%     subplot(3,1,3)
%     plot(window(1):window(2),stats.NV,'b')
%     xlim([-200 500])
%     title('Neural Variability computed on Spike rates')
end