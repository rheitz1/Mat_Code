% truncate target-aligned AD channel x ms before saccade
% 20 ms is default
% RPH

function [AD] = truncateAD_targ(AD,SRT,span)
Target_ = evalin('caller','Target_');

if nargin < 3; span = 20; end

disp(['Truncating ' mat2str(span) ' ms before saccade...'])

%check to make sure full matrix -- if assumption not met indexing wrong
if size(AD,2) < 3001
    error('Requires full 3001 ms matrix')
end

for trl = 1:size(AD,1)
    if ~isnan(SRT(trl,1))
        AD(trl,(Target_(1,1)+round(SRT(trl,1))-span):end) = NaN;
    else
        AD(trl,1:size(AD,2)) = NaN;
    end
end


%=========
% Here is an alternate methold that does not appear to save any time

% time_mat = repmat(-3500:2500,size(AD,1),1);
% SRT_mat = repmat(SRT(:,1),1,size(AD,2));
% 
% logical_mat = +(time_mat >= (SRT_mat + Target_(1,1) - span));
% 
% logical_mat(logical_mat == 1) = NaN;
% 
% AD_new = AD + logical_mat;
%=========