function OutNum=CompPhShift(InNum,PhShift,RadOrDeg)
%OutNum=CompPhShift(InNum,PhShift,RadOrDeg)
%
% This shifts the phase of the complex numebr InNum by PhShift without
% adjusting its magnitude. RadOrDeg denotes if PhShift is in radians (1- 
% DEFAULT) or in degrees (2). PhShift shoult be a scalar or be the same
% size as InNum.
%
% This is a quick small function that I'm essentially only writing in case
% I forget how to hsift just the phase of a complex number.

if nargin<3 || isempty(RadOrDeg);       RadOrDeg=1;     end

if RadOrDeg==1
    OutNum=InNum.*( cos(PhShift)+1i*(sin(PhShift)) );
elseif radOrDeg==2;
    OutNum=InNum.*( cosd(PhShift)+1i*(sind(PhShift)) );
else
    error(['In CompPhShift RadOrDeg was: ' num2str(RadOrDeg) '. Must be 1 or 2.'])
end