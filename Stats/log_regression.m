% Script to compute linear regression of log(Y) on linear x
% Note, this is NOT logistic regression; rather, just a way of doing linear regression on a log-linear
% relationship
% RPH

% Assumes all variables are still in LINEAR scale
function [m b R] = log_regression(y,x,order,plotFlag)

if nargin < 4; plotFlag = 0; end
if nargin < 3; order = 1; end %option to do nth order nonlinear regression


%compute the linear regression of y on x
%[b,bint,r,rint,stats] = regress(y',x')
[p S] = polyfit(x,log(y),order); %NOTE: additing third output argument (MU) forces a centered solution, so will not look correct

%compute Y predicted
y_pred = exp(polyval(p,x));

m = p(1);
b = p(2);
R = corr(x,log10(y))^2;

if plotFlag == 1
    
    fig
    semilogy(x,y,'k',x,y_pred,'r')
    text(.05,.95,['Y = ' mat2str(m) 'x + ' mat2str(b)],'units','normalized','fontsize',14)
    text(.05,.90,['r = ' mat2str(R)],'units','normalized','fontsize',14)
    title(['Regression of Y on x with order = ' mat2str(order)])
    
end