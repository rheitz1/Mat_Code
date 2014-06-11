% fix clipped trials.  Sets them to NaN
% runs = criterion number of consecutive repeating values (saturation) to
% call a clipped trial (defaults to 50).
% window == window within which we care that saturation occurred.  This is
% important because mStim trials will necessarily have saturation;
% therefore, consider only later time points.
%
% if 'toRemove' included as output, the signal itself is NOT MODIFIED, but
% a vector of trials that are clipped is returned.  This is useful
% when you want to eliminate trials from an analyis but don't want to have
% NaN's in your signal matrix (e.g., Coherence analysis).

% RPH
function [sig remove] = fixClipped(sig,window,runs)
Target_ = evalin('caller','Target_');

if nargin < 3; runs = 50; end %50 ms of saturating signal

if nargin < 2
    window = [Target_(1,1) Target_(1,1)+500];
    disp(['Saturation window = ' mat2str(window)])
end

remove = find(FindClipTrs(sig(:,window(1):window(2)),runs));

if nargout < 2
    sig(remove,:) = NaN;
    disp(['Removing ' mat2str(length(remove)) ' trials (' mat2str(round(length(remove) / size(sig,1) * 100)) '%) due to saturation']);
elseif nargout == 2
    disp(['Signal unaltered; vector of ' mat2str(length(remove)) ' trials to remove returned.'])
end