% PL_GetPars - get parameters
%
% p = PL_GetPars(s)
%
% Input:
%   s - server reference (see PL_Init)
%
% Output:
%   p - 16 by 1 matrix, vector of parameters
%   
%	p(1) = Number of DSP Channels
%	p(2) = Timestamp Tick (in usec)
%	p(3) = Number of Points in Waveform
%	p(4) = Number of Points before Threshold
%	p(5) = Maximum Number of Words In Waveform
%	p(6) = Total Number of A/D channels (16 or 64)
%	p(7) = Number of active A/D channels
%	p(8) = A/D Frequency
%	p(9) = Server Polling Interval
%	p(10) =  Is DSP Program Loaded
%	p(11) =  Is Sort Client Running
%	p(12) = Is Electrode Client Running
%
% Copyright (c) 2000, Plexon Inc
