function wilcoxon_paired(varargin)
%Wilcoxon non parametric test for paired samples.
%This file execute the non parametric Wilcoxon test to evaluate the
%difference between paired samples. If the number of difference is less
%than 15, the algorithm calculate the exact ranks distribution; else it
%uses a normal distribution approximation.
%
% Syntax: 	WILCOXON(X1,X2,ALPHA)
%      
%     Inputs:
%           X1 and X2 - data vectors. 
%           ALPHA - significance level (default = 0.05).
%     Outputs:
%           - W value and p-value when exact ranks distribution is used.
%           - W value, Z value, Standard deviation (Mean=0), p-value when normal distribution is used
%
%      Example: 
%
%           X1=[77 79 79 80 80 81 81 81 81 82 82 82 82 83 83 84 84 84 84 85
%           85 86 86 87 87];
%
%           X2=[82 82 83 84 84 85 85 86 86 86 86 86 86 86 86 86 87 87 87 88
%           88 88 89 90 90];
%
%           Calling on Matlab the function: wilcoxon(X1,X2)
%
%           Answer is:
%
%           WILCOXON TEST
%           Sample size is good enough to use the normal distribution approximation
%           W = -325
%           zw = 4.4354     mw = 0     sw = 73.1608     p = 0
%           Null hypothesis is rejected
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2006). Wilcoxon test: non parametric Wilcoxon test for paired samples.
% http://www.mathworks.com/matlabcentral/fileexchange/12702

%Input Error handling
global p alpha
args=cell(varargin);
nu=numel(args);
if isempty(nu) || nu==1
    error('Warning: Two input vectors are required')
elseif nu>3
    error('Warning: Max three input data are required')
end
default.values = {[],[],0.05};
default.values(1:nu) = args;
[x1 x2 alpha] = deal(default.values{:});
if ~isvector(x1) || ~isvector(x2)
   error('WILCOXON requires vector rather than matrix data.');
end 
if (numel(x1) ~= numel(x2))
   error('Warning: WILCOXON requires the data vectors to have the same number of elements.');
end
if ~all(isfinite(x1)) || ~all(isnumeric(x1)) || ~all(isfinite(x2)) || ~all(isnumeric(x2))
    error('Warning: all X1 and X2 values must be numeric and finite')
end
if nu==3
    if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha) || isempty(alpha)
        error('Warning: it is required a numeric, finite and scalar ALPHA value.');
    end
    if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
        error('Warning: ALPHA must be comprised between 0 and 1.')
    end
end
clear args default nu

disp('WILCOXON TEST')
dff=x2-x1; %difference between x1 and x2

nodiff = find(dff == 0);  %find null variations
dff(nodiff) = []; %eliminate null variations
if isempty(nodiff)==0 %tell me if there are null variations
    fprintf('There are %d null variations that will be deleted\n',length(nodiff))
end
if isempty(dff) %if all variations are null variations exit function
    disp('There are not variations. Wilcoxon test can''t be performed')
    return       
end
clear nodiff %clear unnecessary variable

%Ranks of absolute value of samples differences with sign
[r,t]=tiedrank(abs(dff)); %ranks and ties
w=r*sign(dff)'; %Wilcoxon statics (sum of ranks with sign)
n=length(dff); %number of ranks
clear dff %clear unnecessary variable

%If the number of elements N<15 calculate the exact distribution of the
%signed ranks (the number of combinations is 2^N); else use the normal
%distribution approximation.

if n<=15
    disp('Because N<15 it is possible to use the exact ranks distributions')
    ap=ff2n(n); %the all possibilities based on two-level full-factorial design.
    ap(ap~=1)=-1; %change 0 with -1
    k=1:1:n; 
    J=ap*k'; %all possible sums of ranks for k elements
    I=length(J(abs(J)>=abs(w))); %find w and more extreme combinations
    p=I/2^n; %p-value
    fprintf('W = %11.4f         p = %11.4f\n',w,p)
    exitus(alpha)
else
    disp('Sample size is good enough to use the normal distribution approximation')
    sw=sqrt((2*n^3+3*n^2+n-t)/6); %standard deviations
    zw=(abs(w)-0.5)/sw; %z-value with correction for continuity
    p=1-min([1 2*normcdf(zw,0,sw)]); %p-value
    disp('     W             zw      mw      sw             p')
    fprintf('%11.4f %11.4f     0 %11.4f %11.4f\n',w,zw,sw,p)
    exitus(alpha)
end
return

function exitus %Hypothesis accept/reject
global p alpha
if p >= alpha;
   disp('Ho accepted.');
else
   disp('Ho rejected.');
end    
return