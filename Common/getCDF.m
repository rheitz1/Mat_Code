%return cumulative distribution function with n bins
%
% RPH

% Can ask for any number of bins, but will always be between .1 and .9.  Chop off extremes
function [bins,ntiles] = getCDF(RTs,num_bins,plotFlag)

RTs = removeNaN(RTs);


if nargin < 3; plotFlag = 0; end
if nargin < 2; num_bins = 11; end

ntiles = linspace(0,1,num_bins);

RTs = sort(RTs(find(~isnan(RTs))));

indices = ceil(ntiles .* length(RTs));
%Change first index to first value
indices(1) = 1;

if isempty(RTs)
    bins(1:length(indices)) = NaN;
    return
end


bins = RTs(indices);

if plotFlag == 1
    figure
    plot(bins,ntiles,'-or')
    ylim([0 1])
end


%==============
% OLD METHOD
% 
% if nargin < 3; plotFlag = 0; end
% 
% RTs = RTs(find(~isnan(RTs)));
% 
% [counts,bins] = hist(RTs,num_bins);
% RT_cdf = (cumsum(counts))/length(RTs) * 100;
% 
% %RPH 12/3/08
% %0 pad so that CDF functions always start at 0
% 
% %RT_cdf = [zeros(1,length(1:bins(1)-1)) RT_cdf];
% %bins = [zeros(1,length(1:bins(1)-1)) bins];
% 
% RT_cdf = [RT_cdf];
% bins = [bins];
% 
% %change scale to 0:1 rather than 0:100
% RT_cdf = RT_cdf / 100;
% 
% if plotFlag == 1
%     figure
%     plot(bins,RT_cdf)
% end

