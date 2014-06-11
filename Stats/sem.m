% Calculates standard error of the mean of a vector
%
% RPH

function [out] = sem(data)

if length(find(isnan(data))) > 0
    disp(['Removing ' mat2str(length(find(isnan(data)))) ' NaNs'])
    data = removeNaN(data);
end


if isvector(data)
    out = std(data) ./ sqrt(length(data));
else
    out = std(data,1,1) ./ sqrt(size(data,1));
end