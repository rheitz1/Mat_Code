function out = isint(input)
%function out = isint(input)
%
% outputs a one for each position in the array input that is an integer
% value

out = floor(input)==input;