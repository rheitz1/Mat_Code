function y = Weibull(p,x)
%y = Weibull(p,x)
%
% this is a reparamaterized Weibull function to support psychometric functions.
% reference: http://courses.washington.edu/matlab2/Lesson_5.html


%Parameters:  p.b slope
%             p.t threshold yeilding ~80% correct
%             x   intensity values.

g = 0.5;  %chance performance
e = .80;% (.5)^(1/3);  %threshold performance ( ~80%) -- where curves cross on y-axis

% e is the performance level expected at threshold
% p.t is the intensity LEVEL at threshold -- what x-value do you want when the curve crosses threshold
% performance on the y-axis

%here it is.
k = (-log( (1-e)/(1-g)))^(1/p.b);
y = 1- (1-g)*exp(- (k*x/p.t).^p.b);