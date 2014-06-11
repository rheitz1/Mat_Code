function err = reciprob3ml(th)
% err = reciprob3ml(th) 
% One of three functions that returns minus the log likelihood of observing the
% response times in RT (declared globally) given carpenter model parameters th.

% In this function, th is a 3 vector [b s1 s2].  (For the other two functions,
% shiftreciprobErr and swivelErr, th is a 4 vector, where the first three
% variables are the same as in this function.)   b is the expected slope
% of a ramp from 0 to a barrier at h=1. B is normally distributed with
% stdev = s1. This process races with a second "guess" process whose
% expected slope is 0 and stdev = s2.  In the other two functions, the
% 4th term is used to create RT2, to produce either a parallel shift
% (shiftreciprobErr), or a swivel shift (swivelErr).
% 

% 
% Improvements. I do not normalize right now. So it is conceivable that
% if b is small and s1 is big, that the total probability could be less
% than 1. I have tried normalization in the past and ran into problems
% with convergence. But this may be worth trying again now that many
% other kinks have been ironed out.

%
% see test_pdfMaxLikReciprob.m fitSwivel.m swivelErr.m shiftreciprobErr.m


global RT

rt = RT;
% n = length(rt);
r = 1./rt;  	% r is reciprocal rt
b = th(1);
s1 = th(2);
s2 = th(3);
h = 1;   		% here for compatibility with future 
% probability of seeing r from the main process is the likelihood of picking
% r from N(b/h,s1/h) times the probability that the other process produces a longer
% rt hence a smaller reciprocal rt. Notice that the negative half of the second process
% must always give rise to a smaller reciprocal time. It's ok to integrate this part
% of the distribution.
p1 = normpdf(r,b/h,s1/h) .* normcdf(r,0,s2/h);
% The prob of seeing r from the second "guess" process is the likelihood of picking
% r from N(0,s2/h) times the probability that the main process produces a longer
% rt hence a smaller reciprocal rt. I had considered some conditionalization
% of these distributions in the past, e.g., getting a positive value, but that
% turns out to be unnecessary.
p2 = normpdf(r,0,s2/h) .* normcdf(r,b/h,s1/h);
p = p1 + p2;
err = -sum(log(p));
