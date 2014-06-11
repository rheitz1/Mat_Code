function [p,v] = cumprob(x,s)
% [p,v] = cumprob(x) returns the cumulative probability distribution for the data
%     in x. It's just the prob that there are values less than each value. The
%      second vector returned, v, is just x sorted into ascending order.

% 9/9/01 mns wrote it

v = sort(x);
p = cumsum(x./x)/(length(x)+1);

	