function out=GenSecDimVarInds(nd1,nd2)
% function out=GenSecDimVarInds(nd1,nd2)
%
% for example, GenSecDimVarInds(3,4) returns
%   1     1     1     2     2     2     3     3     3     4     4     4
%
%   This is very useful for varying two variables with respect to each
%   other without using a single for loop. In the example above, this
%   output for the second varibale would be compared to the indices of
%   repmat(1:nd1,1,nd2) for the first variable.

out=floor(1: 1/nd1: nd2+1-1/nd1);