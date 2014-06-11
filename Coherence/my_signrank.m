function [p,h,stat]=my_signrank(x,varargin)
%[p,h,stat]=my_signrank(x,varargin)
%
% This is exactly like matlab's signrank, but adjusts the output of the
% fields zval and signedranl in the output stats structure to reflect the
% sign of the test, i.e. whether x or y is higher.... a positive value for
% signedrank or zval indicates that x is higher than 1, or for a one smaple
% test, is higher than 0. A neg. value indicates the opposite.

switch nargin
    case 1;     [p,h,stat]=signrank(x);
    case 2;     [p,h,stat]=signrank(x,varargin{1});
    case 3;     [p,h,stat]=signrank(x,varargin{1},varargin{2});
    case 4;     [p,h,stat]=signrank(x,varargin{1},varargin{2},varargin{3});
end

%note that default behavior from signrank is for stat.zval to always be
%negative, and signedrank to always be positive
if nargin==1
    if mean(x)>0
        stat.zval=-stat.zval;
    else
        stat.signedrank=-stat.signedrank;
    end
else
    if mean(x)>mean(varargin{1})
        stat.zval=-stat.zval;
    else
        stat.signedrank=-stat.signedrank;
    end
end