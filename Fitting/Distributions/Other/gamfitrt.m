function R=gamfitrt(data, params, options)
%GAMFITRT Gamma distribution fitting function for RTs.
%    FITTED_PARAMS=GAMFITRT(DATA,START_PARAMS,OPTIONS) returns the maximum 
%    likelihood fit of the data to the gamma distribution with an extra
%    parameter XI, which shifts the entire distribution.
%
%    DATA is a vector of values to be fit by the Gamma,
%    START_PARAMS =  [ALPHA,BETA,XI] (not required)
%    OPTIONS are options for fminsearch routine (not required)
%
%    ALPHA = scale  (this is B in gampdf)
%     BETA = shape  (this is A in gampdf)
%       XI = shift  (this is not in gampdf)
%

% Version 1.0 12/20/04 of pure ML fit of this function.
%
% Formula for gamma function comes from: Dolan, van der Maas & Molenaar
% (2002).  This code is cannibalized from Ex-Gaussian code by: 
% Yves Lacouture, UniversitŽ Laval
%
% Pieced together by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu

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
	beta=params(2);
	xi=params(3);
else    
	alpha=std(data-min(data))/2;	                  % set defaut starting parameter values if not explicit
	beta=mean(data-min(data))/std(data-min(data));    % uses heuristic values
	xi=min(data);
end

if  (nargin > 2 & ~isempty(options))  % explicit options values set by user and pass to fmins
	opts(1:3)=options(1:3);           % trace, termination and function tolerances
	opts(14)=options(4);              % maximum number of iterations
else
	opts=[0, 1.e-4,1.e-4];            % default values for trace, termination and function tolerances
    opts(1,4)=500*length(data);       % default max number of iterations
end

pinit = [alpha beta xi];                % put initial parameter values in an array
   LB = [0     0    0];
   UB = [+Inf  +Inf +Inf];


[R,LogL,exitflag] = fminsearchbnd('gamlikert',pinit,LB,UB,opts,data);

if exitflag==0                                    % check for convergence
	error('Search failed to converge. Maximum number of function evaluations or iterations was reached.');
elseif exitflag==-1
    error('Search failed to converge. Algorithm was terminated by the output function.');
end


if R(3)<0
    regfit=gamfit(data);
    R(1)=regfit(2);
    R(2)=regfit(1);
    R(3)=0;
end

    
    
    