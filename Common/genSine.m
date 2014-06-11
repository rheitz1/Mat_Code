%generate sine wave
%
% RPH

function [wave] = genSine(Hz,amp,sampling,length)
%Hz is frequency
%amp is amplitude, defaults to 1
%1000Hz default sampling rate

if nargin < 4; length = 1000; end
if nargin < 3; sampling = 1000; end
if nargin < 2; amp = 1; end

endp = length / sampling;

t = 0:(1/sampling):(endp - (1/sampling));

wave = amp*sin(2*pi*Hz*t);