% PL_GetAD - get A/D data
%
% [n, t, d] = PL_GetAD(s)
%
% Input:
%   s - server reference (see PL_Init)
%
% Output:
%   n - 1 by 1 matrix, number of data points retrieved (for each channel)
%   t - 1 by 1 matrix, timestamp of the first data point (in seconds)
%   d - n by nch matrix, where nch is the number of active A/D channels,
%       A/D data
%       d(:, 1) - a/d values for the first active channel 
%       d(:, 2) - a/d values for the second active channel
%       etc.
%
% Copyright (c) 2000, Plexon Inc
