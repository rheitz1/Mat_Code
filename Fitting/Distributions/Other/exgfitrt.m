function R=exgfitrt(data, params, options)
%EXGFIT Exgaussian distribution fitting function.
%
%    This is the bound version of the ex-Gaussian fitting function.  Lower 
%    and upper bounds for the parameter search can be defined by the 
%    variables LB and UB.  This search function uses fminsearchbnd.
%
%    FITTED_PARAMS=EXGFIT(DATA,START_PARAMS,OPTIONS) returns the maximum 
%    likelihood fit of the data to an exgaussian distribution.
%
%    DATA is a vector of values to be fit by the Ex-Gaussian,
%    START_PARAMS =  [MU,SIGMA,TAU] (not required)
%    OPTIONS are options for fminsearch routine (not required)
%
%    MU    = Mean of Gaussian component
%    SIGMA = S.D. of Gaussian component
%    TAU   = Mean of Exponential component
%
%   See also EXGCDF, EXGPDF, EXGRND, EXGINV and EXGLIKE.

% Version 2.2 12/09/04
% Revised by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu
%
% Version 2.1 02/27/03
% (c) Yves Lacouture, UniversitŽ Laval

[n,m]=size(data);
if min(n,m) > 1
   error('First argument must be a vector');
end
if  n == 1        	                   %case of a row vector of data
	data = data';
	n = m;
end
if min(data)<=0                  	   % get rid of zeros and negative numbers
	warning('WARNING data include zero(s) and/or negative number(s)\n');
	nc=length(find(data<=0));
	fprintf('%d values out of %d are truncated\n', nc, n);
	data=data(find(data>0));
end
if  (nargin > 1 & ~isempty(params))   % explicit starting parameter values set by user
	mu=params(1);
	sig=params(2);
	tau=params(3);
else    
	tau=std(data).*0.8;			      % set defaut starting parameter values if not explicit
	mu=mean(data)-tau;                % uses heuristic values
	sig=sqrt(var(data)-(tau^2));
end
if  (nargin > 2 & ~isempty(options))  % explicit options values set by user and pass to fmins
	opts(1:3)=options(1:3);           % trace, termination and function tolerances
	opts(1,4)=options(4);              % maximum number of iterations
else
	opts=[0, 1.e-4,1.e-4];            % default values for trace, termination and function tolerances
    opts(14)=200*length(data);        % default max number of iterations
end

pinit = [mu   sig  tau];                % put initial parameter values in an array
   LB = [0    0    0];
   UB = [+Inf +Inf +Inf];

[R,LogL,exitflag] = fminsearchbnd('exglike',pinit,LB,UB,opts,data);

if exitflag==0                                    % check for convergence
	error('Search failed to converge.\nMaximum number of function evaluations or iterations was reached.');
elseif exitflag==-1
    error('Search failed to converge.\nAlgorithm was terminated by the output function.');
end
