function out = isbetween(input,limits,excflag)

% function out = isbetween(limits,input)
%
% Outputs 1 or 0 for each input based on whether 
% or not it is between the specified limits. input 
% is between limits.
%
% Limits is a 2x1 or 1x2 row or column vector. 
% Output is of the same dimension as input.
% If Excflag is set to one, equality with results in a zero.
% Excflag defaults to zero.

if nargin<3
    excflag=0;
end

limits=sort(limits);
if excflag
    out=(input>limits(1))&(input<limits(2));
else
    out=(input>=limits(1))&(input<=limits(2));
end