% Calculates a weighted mean
% Assumes a matrix of sessions x time, with a vector of weights corresponding to the N (trial counts)
% associated with each session
%
% RPH

function [weighted_mean] = wmean(data,weights)

    weighted_mean = nansum(data .* repmat(weights,1,size(data,2))) ./ nansum(weights);
end