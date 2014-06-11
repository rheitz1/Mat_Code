function out = isdivisible(input,div)
% function out = isdivisible(input,div)
%
% outputs a one for each position in the array input that is divisible by
% the scalar div. div can also be an array of the same length as input, in
% which case each position in input is checked to see if it's divisible by
% the number at the corresponding position of div.

out=isint(input./div);