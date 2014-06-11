% after finding microsaccade times, eliminate spikes (on each trial) that fall +/- x ms of each saccade.
% This can help eliminate influence of microsaccades (e.g., Fano Factor over baseline period).
% ASSUMES SPIKE TIMES HAVE BEEN UNCORRECTED; ARE CORRECTED HERE

function [sig_clean] = removeMicrosaccades(Spike,uSaccades,halfWin)

Target_ = evalin('caller','Target_');

if nargin < 3; halfWin = 5; end %what is window size (half: 5ms would be 11 ms total, 5 on either side of each microsaccade


%throw an error if it appears spike trains have already been 'correted' (target aligned)
if any(any(Spike < 0)); error('Negative Spike Times Detected: send uncorrected spike train'); end


Spike(find(Spike == 0)) = NaN;
Spike = Spike - Target_(1,1);

for trl = 1:size(Spike,1)
    cur_uSaccades = uSaccades(trl,~isnan(uSaccades(trl,:)))';
    
    %create matric of times you do NOT want based on uSaccade times and window
    
    removeWin = repmat(-halfWin:halfWin,size(cur_uSaccades,1),1);
    
    removeTimes = repmat(cur_uSaccades,1,size(removeWin,2));
    
    SpikeRemovalTimes = removeWin + removeTimes;
    
    %Vectorize, then see if any spikes on the current trial fall within that window
    Spike(trl,find(ismember(Spike(trl,:),SpikeRemovalTimes(:)))) = NaN;
end


%Return Spike back to original format (no NaNs, 0's as placeholders, sorted, all positive values (shifted
%so that 0 = arbitrary start point and Target_(1,1) = target onset.
sig_clean = Spike;
sig_clean = sort(sig_clean + Target_(1,1),2);
sig_clean(find(isnan(sig_clean))) = 0;
