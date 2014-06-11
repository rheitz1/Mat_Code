%normalizes AD channel based on window and whether you want to use maximum
%positive or negative value (Seymour's OL electrode has a positive N1
%componenet)

function [normalized_sig] = normalize_AD(sig)%,window,posneg)

% if nargin < 3; posneg = 'neg'; end
% if nargin < 2; window = [550 650]; end %corresponds to 50-150 ms, which covers the latency of the N1
% 
% 
% if posneg == 'neg'
%     normalize_by = nanmin(sig(:,window(1):window(2))')';
%    % normalize_by = normalize_by * -1; %make sure component are not flipped by division.
% elseif posneg == 'pos'
%     normalize_by = nanmax(sig(:,window(1):window(2))')';
%    % normalize_by = normalize_by * -1; %make sure component are not flipped by division
% end
% 
% normalize_by = repmat(normalize_by,1,size(sig,2));
% 
% normalized_sig = sig./normalize_by;

min_val = nanmin(nanmean(sig));
max_val = nanmax(nanmean(sig));

normalized_sig = (sig - min_val) ./ (max_val - min_val);

end