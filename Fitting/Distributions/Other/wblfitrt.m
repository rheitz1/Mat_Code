function R=wblfitrt(data, params, options)
%WBLFITRT Weibull distribution fitting function for RTs with parameter boundaries.
%
%    This is the bound version of the Weibull RT fitting function.  Lower and
%    upper bounds for the parameter search can be defined by the variables
%    LB and UB.  This search function uses fminsearchbnd.
%
%    FITTED_PARAMS=WBLFITRTBND(DATA,START_PARAMS,OPTIONS) returns the maximum 
%    likelihood fit of the data to the weibull distribution with an extra
%    parameter XI, which shifts the entire distribution.
%
%    DATA is a vector of values to be fit by the Weibull,
%    START_PARAMS =  [ALPHA,GAMMA,XI] (not required)
%    OPTIONS are options for fminsearch routine (not required)
%
%    ALPHA = scale 
%    GAMMA = shape 
%       XI = shift 
%
%
%

% Version 1.0 12/20/04 of pure ML fit of this function.
%
% Formula for gamma function comes from: Dolan, van der Maas & Molenaar
% (2002).  This code is cannibalized from Ex-Gaussian code by: 
% Yves Lacouture, UniversitŽ Laval
%
% Revised version by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu
%
% Added parameter restrictions, 10/03/05
% 
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
	alpha=params(1);
	gamma=params(2);
	xi=params(3);
else    
	alpha=mean(data-min(data))/2;	  % set defaut starting parameter values if not explicit
	gamma=mean(data)/std(data);       % uses heuristic values
    if gamma>=5, gamma=2.5;, end;
	xi=min(data);
end

if  (nargin > 2 & ~isempty(options))  % explicit options values set by user and pass to fmins
	opts(1:3)=options(1:3);           % trace, termination and function tolerances
	opts(1,4)=options(4);              % maximum number of iterations
else
	opts=[0, 1.e-4,1.e-4];            % default values for trace, termination and function tolerances
    opts(1,4)=500*length(data);       % default max number of iterations
end

pinit = [alpha gamma xi];             % put initial parameter values in an array
   LB = [0     0     0];
   UB = [+Inf  7    +Inf];

[R,LogL,exitflag] = fminsearchbnd('wbllikert',pinit,LB,UB,opts,data);

if exitflag==0                                    % check for convergence
	error('Search failed to converge. Maximum number of function evaluations or iterations was reached.');
elseif exitflag==-1
    error('Search failed to converge. Algorithm was terminated by the output function.');
end


if R(3)<0
    regfit=wblfit(data);
    R(1)=regfit(1);
    R(2)=regfit(2);
    R(3)=0;
end