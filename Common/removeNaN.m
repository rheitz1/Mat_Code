%function to remove NaNs from n vectors or matrices, returning only values in the n
%vectors that EACH have non-nan values
% e.g.:
% 1 NaN 3
% NaN 3 3
% 3 5 3
% returns:  3 5 3
%
% RPH

function [varargout] = removeNaN(varargin)
%disp('Removing NaNs and equating matrices...')
for var = 1:length(varargin)
    remove(1:size(varargin{var},1),var) = any(isnan(varargin{var}),2);
    if size(remove,1) ~= length(any(isnan(varargin{var}),2))
        error('Matrix dimensions not equal')
    end
end

all_remove = any(remove,2);

if any(all_remove); disp(['Removing ' mat2str(sum(all_remove)) ' trials with NaNs']); end

for var = 1:length(varargin)
    x = varargin{var};
    x(all_remove,:) = [];
    varargout{var} = x;
    clear x
end