%Computes trial-by-trial spike rate correlations.  Spike rate is simply
%number of observed spikes within an interval divided by the length of the
%interval.  Spike rate correlations are exactly equal to spike count
%correlations.
%
%RPH

function [noise_r,noise_p] = noise_correlation(sig1,sig2,win_start,win_stop,trls)

if nargin < 5; trls = 1:size(sig1,1); end

if nargin < 3
    win(1:size(sig1,1),1) = 0;
    win(1:size(sig1,1),2) = 500;
else
    if isscalar(win_stop)
        win(1:size(sig1,1),1) = win_start;
        win(1:size(sig1,1),2) = win_stop;
    elseif isvector(win_stop)
        win(1:size(sig1,1),1) = win_start;
        win(:,2) = win_stop;
    end
end



SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');

%correct spike times
sig1(find(sig1 == 0)) = NaN;
sig2(find(sig2 == 0)) = NaN;
sig1 = sig1 - Target_(1,1);
sig2 = sig2 - Target_(1,1);

for trl = 1:length(trls)
    sig1_rate(trl,1) = length(find(sig1(trls(trl),:) >= win(trls(trl),1) & sig1(trls(trl),:) <= win(trls(trl),2))) / length(win(trls(trl),1):win(trls(trl),2));
    sig2_rate(trl,1) = length(find(sig2(trls(trl),:) >= win(trls(trl),1) & sig2(trls(trl),:) <= win(trls(trl),2))) / length(win(trls(trl),1):win(trls(trl),2));
end

[noise_r noise_p] = corr(sig1_rate,sig2_rate);