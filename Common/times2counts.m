%Converts a matrix of spike times to counts, where each column is 1 ms of data.  Used in Fano Factor
%analyses
%
% RPH
function [out] = times2counts(Spike)

[sz(1) sz(2)] = evalin('caller','size(EyeX_)'); %use for evaluating how much data (time) we have per trial

out = zeros(sz(1),sz(2));
out = out'; %have to transpose before correcting (vector indexing goes down rows first)

shift = (((1:sz(1))*sz(2)) - (sz(2)))';
shift = repmat(shift,1,size(Spike,2));

newSpike = Spike;
newSpike(find(newSpike == 0)) = NaN;
newSpike = newSpike + shift;

out(newSpike(find(~isnan(newSpike)))) = 1;

out = out'; %re-transpose

% Old method
% for trl = 1:size(Spike,1)
%     out(trl,Spike(trl,find(Spike(trl,:)))) = 1;
% end
