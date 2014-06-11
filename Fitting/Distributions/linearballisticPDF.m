% PDF of the linear ballistic accumulator model
% from Brown & Heathcote (2008) p.159
%
% t is vector of x-values
% A is upper limit on starting point of evidence accumulation. 
% b is threshold
% v is the drift rate.
% s is s.d. of the drift rate

function [f] = linearballisticPDF(t,A,b,v,s)


%PDF
f = (1./A) .* ...
    (-v .* normcdf( (b-A-(t.*v) ) ./ (t.*s)  ) ...
    + s .* normpdf( (b-A-(t.*v)) ./ (t.*s)  ) ...
    + v .* normcdf( (b-(t.*v)) ./ (t.*s)  ) ...
    - s .* normpdf( (b-(t.*v)) ./ (t.*s)  ));



%Note on parameter "A":
%   Common question is why would you assume "A" to be the same for the winner accumulator and the loser
%   accumulator.  They are not the same.  A is the maxima of a uniform distribution.  If you were running
%   simulations (as in iLBA), you WOULD do random draws from U(0,A) for each accumulator.  However, here
%   this is taken care of by the closed-form solutions.  The LBA f and F calculations are only concerned
%   with FIRST PASSAGE TIME DISTRIBUTIONS.  Thus, the equations take into account the possibility that A
%   is a distribution, and that A can be different for correct/error accumulators.  It takes all that
%   into account, as well as the drift rate distributions, and returns the distribution of first-passage
%   times.  In other words, for a given set of parameters at time t, there is a given probability that
%   accumulator x will produce faster RT, and a probability that accumulator y will produce faster RT.
%   This will take into account the possibility that A could be lower or higher for a given accumulator;
%   it all just contributes to the first passage time distribution.
%   Combined, this gives the defective CDF for that time t:
%
%   f1 .* (1-F2) = what is the probability that accumulator 1 has finished | accumulator 2 has not
%   finished