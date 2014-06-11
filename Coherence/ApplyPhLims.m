function Ph=ApplyPhLims(Ph,PhLims)
% function Ph=ApplyPhLims(Ph,PhLims)
%
% just uses two quickly terminating while loops to adjust Ph to be within
% PhLims, a 1x2 array of the lower and upper limits. Warning that this
% could create an infinite loop if PhLims are not at least 360 degrees
% apart. PhLims defaults to [0 360]. (PhLims and Ph assumed to be in 
% degrees) The current behavior is that the output will be >= the lower 
% lim, but < the higher lim.
%
% coming in, Ph can be an array of an any size. 

if nargin<2 PhLims=[0 2*pi]; end

[r,c]=size(Ph);
for ir=1:r
    for ic=1:c
        while Ph(ir,ic)>=PhLims(2)  Ph(ir,ic)=Ph(ir,ic)-2*pi;   end
        while Ph(ir,ic)<PhLims(1)  Ph(ir,ic)=Ph(ir,ic)+2*pi;    end
    end
end