%function to return the approximat time delay between signals that are
%offset by a given angle at a given frequency.  If scalar input, displays
%delay in ms.

%RPH

%ANGLE IN RADIANS
%FREQUENCY in Hz
%TIME returned in seconds

function [delay] = phase2time(ang,freq)

%check to make sure no numbers are greater than pi, which would be a good
%indication that user entered degrees.  Obviously won't catch all such
%instances.
if find(abs(ang) > pi)
    disp('Did you enter angle in radians?')
end

delay = ang ./(2*pi*freq);

%display time in ms if scalar input. multiplying by 10000, round, then
%divide by 10 so we can have more precision
if isscalar(delay)
    disp([mat2str(round(rad2deg(ang))) ' degrees at ' mat2str(freq) ' Hz is a delay of ' mat2str(round(delay*10000)/10) ' ms.'])
end
