% PL_GetTS - get timestamps
%
% [n, t] = PL_GetTS(s)
%
% Input:
%   s - server reference (see PL_Init)
%
% Output:
%   n - 1 by 1 matrix, number of timestamps retrieved
%   t - n by 4 matrix, timestamp info:
%       t(:, 1) - timestamp types (1 - neuron, 4 - external event)
%       t(:, 2) - channel numbers
%       t(:, 3) - unit numbers
%       t(:, 4) - timestamps in seconds
%
% Copyright (c) 2000, Plexon Inc
