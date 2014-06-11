function R=exwaldfitrt(data, params, options)
%EXWALDFITRT Ex-Wald distribution fitting function.
%
%    This is the bound version of the ex-Wald fitting function.  Lower and
%    upper bounds for the parameter search can be defined by the variables
%    LB and UB.  This search function uses fminsearchbnd.
%
%    FITTED_PARAMS=EXWALDFITRT(DATA,START_PARAMS,OPTIONS) returns the maximum 
%    likelihood fit of the data to an ex-Wald distribution.
%
%    DATA is a vector of values to be fit by the ex-Wald,
%    START_PARAMS =  [MU,SIGMA,A,GAMMA] (not required)
%    OPTIONS are options for fminsearch routine (not required)
%
%    MU    = Drift Rate (The mean gain of information per unit of time)
%    SIGMA = Standard Deviation of Drift Rate
%    A     = Evidence Criterion (Location of absorbing boundary)
%    GAMMA = Mean/StDev of Exponential.
%
%   See also EXWALDCDF, EXWALDPDF, **EXWALDRND, EXWALDINV and EXWALDLIKE**.

% By: Evan M. Palmer
%     BWH Visual Attention Laboratory
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
if  n == 1        	                  %case of a row vector of data
	data = data';
	n = m;
end
if min(data)<=0                  	  % get rid of zeros and negative numbers
	warning('WARNING data include zero(s) and/or negative number(s)\n');
	nc=length(find(data<=0));
	fprintf('%d values out of %d are truncated\n', nc, n);
	data=data(find(data>0));
end
if  (nargin > 1 & ~isempty(params))   % explicit starting parameter values set by user
	mu=params(1);
	sig=params(2);
	a=params(3);
    gam=params(4);
else    
	gam=0.02;			              % set defaut starting parameter values if not explicit
    mu=0.25;                          % These are heuristic values...
	sig=1;                            % <-- Default = 1
    a=100;                            % THIS IS JUST A GUESS FOR NOW...
end
if  (nargin > 2 & ~isempty(options))  % explicit options values set by user and pass to fmins
	opts(1:3)=options(1:3);           % trace, termination and function tolerances
	opts(1,4)=options(4);              % maximum number of iterations
else
    %opts=['sig',1];                  % MESSING AROUND WITH OPTIONS
    opts=[0, 1.e-4,1.e-4];            % default values for trace, termination and function tolerances
    opts(4)=400*length(data);         % default max number of iterations
end

pinit  = [mu    sig   a      gam  ];  % put initial parameter values in an array
LB     = [0+eps 1-eps 0+eps  0+eps];  % These parameter values can't go below 0
UB     = [+Inf  1     +Inf   1    ];  % These are heuristic starting values based on personal communication w/ W. Schwarz  

[R,LogL,exitflag] = fminsearchbnd('exwaldlike',pinit,LB,UB,opts,data);

if exitflag==0                                    % check for convergence
	error('Search failed to converge.  Maximum number of function evaluations or iterations was reached.');
elseif exitflag==-1
    error('Search failed to converge.  Algorithm was terminated by the output function.');
end
