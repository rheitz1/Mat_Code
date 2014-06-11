function [R, ind] = randinterval(N, Interval, Weight)
% RANDINTERVAL - random numbers within multiple intervals
%
%   R = RANDINTERVAL(N, INTERVALS) returns a N-by-N matrix R of random numbers
%   taken from a uniform distribution over multiple intervals.
%
%   Similar to RAND, RANDINTERVAL([N M],..) returns a N-by-M matrix, and
%   RANDINTERVAL([N M P ...],..) returns a N-by-M-by-P-by-.. array. Note
%   that a notation similar to rand(N,M,P,..) is not available.
%
%   INTERVALS is a N-by-2 matrix in which the rows specify the intervals from
%   which the numbers are drawn. Each interval is given by a lower bound
%   (in the first column of INTERVALS) and an upper bound (2nd column of
%   INTERVALS). If the lower bound equals the upper bound, no numbers will
%   be drawn from that interval. The upper bound cannot be smaller than the
%   lower bound. 
%   If INTERVALS is a vector (K-by-1 or 1-by-K), the intervals are
%   formed as (INTERVALS(1),INTERVALS(2)), (INTERVALS(2),INTERVALS(3)),  
%   ... , (INTERVALS(K-1),INTERVALS(K)). In this case, the number of
%   intervals N is one less than the number of elements K, i.e., N=K-1.
%   The relative length of an interval determines the likelihood that a
%   number is drawn from that interval. For instance, when INTERVALS is [1
%   2 ; 10 12], the probablity that a number is drawn from the first
%   interval (1,2) is 1 out of 3, vs 2 out of 3 for the second interval (10,12).
%
%   R = RANDINTERVAL(N, INTERVALS, WEIGHTS) allow for weighting each
%   interval specifically. WEIGHTS is vector with N numbers. These numbers
%   specify, in combination with the length of the corresponding interval,
%   the relative likelihood for each interval (i.e., the weight). Larger
%   values of W(k) increases the likelihood that a number is drawn from the
%   k-th interval.
%   For instance, when INTERVALS is [11 12 ; 20 21] and WEIGHTS is [3 1], the
%   probability that a numbers is drawn from the first interval is 3 out of
%   4, vs 1 out of 4 for the second interval. Note that both intervals have
%   the same length. When the intervals do not have the same lengths, the
%   likelihood that a number is drawn from an interval k, with length L(k)
%   and weight W(k) is given by the formula:
%      p(k) = (W(k) x L(k)) / sum(W(i) ./ L(i)),i=1:N
%
%   [R, IND] = RANDINTERVAL(..) also returns a index array IND, which has the
%   same size as R. IND contains numbers between 1 and the number of
%   intervals. Intervals with zero length and/or a weight of zero will not
%   be present in IND.
%
%   Notes:
%   - overlapping intervals are allowed, but may produce hard-to-debug
%     results. In this case a warning is issued. On the other, such
%     overlapping intervals could be (ab-)used to draw from specific
%     distributions.
%   - for a single interval (A B) this function is equivalent to
%     A + (B-A) * rand(N)
%   
%   Examples:
%     % Basic use, no weights
%     R = randinterval([1,10000], [1 3 ; 5 7 ; 10 15 ; 20 26]) ;
%       % returns a row vector with 10000 numbers between 1 and 3, between
%       % 5 and 7, between 10 and 15, or between 20 and 26. Approximately
%       % 2/5 of the numbers is between 20 and 26:
%     N = histc(R,[-Inf 1 3 5 7 10 15 20 26 Inf]), N = N ./ sum(N), bar(N)
%
%     % Weights
%     [R,n] = randinterval([10,100], [1 2 ; 100 200 ; -2 -1 ; 12 12], [1 0 2 3]) ;
%       % returns a 10-by-100 matrix with values in the intervals (-2,-1)
%       % or (1,2). Roughly 666 numbers are negative:
%     sum(R(:)<0), sum(n(:)==3)
%       % The interval (100,200) has a weight of zero, and the interval
%       % (12,12) has zero length; these are "ignored". 
%     histc(n(:),1:4)
%
%     % Adjacent intervals with weights:
%     [R,n] = randinterval([10000,1], [-2:2],[1 4 2 8]) ;
%     bar(-2:2,histc(R,-2:2)/100,'histc') ; ylabel('Percentage')
%
%   See also RAND, RANDN, RANDPERM
%       RANDSAMPLE (Stats Toolbox)
%       RANDP (File Exchange)

% for Matlab R13 and up
% version 1.0 (oct 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% Created: oct 2008
% Revisions: -

% Argument checks
error(nargchk(2,3,nargin)) ;

if ndims(Interval) ~= 2 || ~isnumeric(Interval) || numel(Interval)<2,
    error([mfilename ':IntervalWrongSize'],...
        'INTERVALS should be a N-by-2 (or N-by-1, with N>1) numeric matrix.')
end

if min(size(Interval)) == 1,
    % Interval is a vector. Make the bounds column vectors
    LowerBound = reshape(Interval(1:end-1),[],1) ;
    UpperBound = reshape(Interval(2:end),[],1) ;
elseif size(Interval,2) ~= 2
    error([mfilename ':IntervalWrongSize'],...
        'INTERVALS should be a N-by-2 (or N-by-1) numeric matrix.')
else
    % Get the lower and upper bounds of the intervals
    LowerBound = Interval(:,1) ;
    UpperBound = Interval(:,2) ;
end

if any(UpperBound < LowerBound),
    error([mfilename ':NegativeInterval'],...
        'Intervals cannot be smaller than 0') ;
end

if nargin==3 && (~isempty(Weight) || ~isnumeric(Weight)),
    if numel(Weight) ~= numel(LowerBound),
        error([mfilename ':WeightsWrongSize'],...
            'The number of weights should match the number of intervals.') ;
    end
    if any(Weight < 0)
        error([mfilename ':WeightsNegative'],...
            'Weights cannot be negative.')
    end
else
    % default, all intervals are equally likely
    Weight = 1 ;
end

tmp = [LowerBound UpperBound] ;
if any(isnan(tmp(:)) | isinf(tmp(:))) || any(isnan(Weight(:)) | isinf(Weight(:))),
    error('Intervals or weights cannot contain NaNs or Infs.') ;
end

% It is nice to give a warning when intervals overlap. If they do, the
% lowerbound of an interval is smaller than the upperbound of a previous
% interval, when the intervals are in sorted order
tmp = sortrows(tmp) ;
if any(tmp(2:end,1) < tmp(1:end-1,2)),
    warning([mfilename ':OverlappingIntervals'], ...
        'Intervals overlap.') ;
end

% The trick is to put all the intervals next to each other. Intervals with
% larger weights should become larger, so they are more likely. The whole
% range spans numbers between 0 and IntervalEdges(end):
IntervalSize = (UpperBound - LowerBound) ;
IntervalEdges = [0 ; cumsum(Weight(:) .* IntervalSize(:))].' ;

if IntervalEdges(end) == 0,
    % all intervals had a zero length and/or a zero weight, so there is
    % nothing to do!
    error([mfilename ':AllZero'],...
        'All intervals have a length and/or weight of zero.') ;
end

try
    % let RAND catch the errors in the size argument
    R = rand(N) ; % random numbers between 0 and 1
catch
    % rephrase the error
    ERR = lasterror ;
    ERR.message = strrep(ERR.message,'rand',[mfilename ' (in a call to RAND) ']) ;    
    rethrow(ERR) ;
end

if isempty(R),
    % nothing to do, e.g. when N contains zero.
    ind = [] ;
    return
end

% To which interval do these random random numbers belong
[ind,ind] = histc(IntervalEdges(end) * R(:),IntervalEdges) ; %#ok, first output is not used

% now map a new series of random numbers between 0 and 1 to their
% respective interval. We have to create a new series, otherwise not the
% all values in an interval are possible.
R(:) = LowerBound(ind) + IntervalSize(ind) .* rand(numel(R),1) ;

% also return interval numbers in same shape as R
ind = reshape(ind,size(R)) ;

% %#debug plots
%  E = linspace(min(Interval(:)), max(Interval(:)),100) ;
%  N2 = histc(R(:),E) ;
%  figure ;
%  subplot(2,1,1) ; bar(E,N2,'histc')
%  subplot(2,1,2) ; plot(sort(R(:)),'k.')

