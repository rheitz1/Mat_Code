%function to return the offset (in radians) of two signals at a given 
%frequency given a time offset in seconds

%RPH

%ANGLE IN RADIANS
%FREQUENCY in Hz
%TIME returned in seconds

function [ang] = time2phase(time,freq)

%check to make sure no numbers are greater than pi, which would be a good
%indication that user entered degrees.  Obviously won't catch all such
%instances.

ang = time * 2 * pi * freq;

%display time in ms if scalar input
if isscalar(ang)
    disp(['A ' mat2str(round(time*1000)) ' ms offset at ' mat2str(freq) ' Hz is ' mat2str(round(rad2deg(ang))) ' degrees.'])
end
