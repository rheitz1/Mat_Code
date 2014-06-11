function err = shiftreciprobErr(th)
% err = shiftreciprobErr(th) 
% One of three functions that returns minus the log likelihood of observing the
% response times in RT (declared globally) given carpenter model
% parameters th. 
% 
% In this function, th is a 4-vector [b s1 s2 bfactor]. The first 3
% variables are the same as in the functions reciprob3m1 and swivelErr,
% where b is the expected slope of a ramp from 0 to a barrier at h1=1. B
% is normally distributed with stdev = s1.
% This process races with a second "guess" process whose expected slope 
% is 0 and stdev = s2. 
% That accounts for the times in RT1. To get RT2, one simply scales b by
% bfactor (bfactor is the factor you must multiply b1 by to get b2; a
% good guess is the ratio of rt medians). This produces a parallel shift
% on the reciprobit plot. This is different from the function
% reciprob3m1, which only creates RT1. SwivelErr also uses a 4-vector for
% th, but the 4th variable is hfactor, and causes a swivel, rather than a
% parallel shift on the reciprobit plot.
%

%
% Future improvements? I do not normalize right now. So it is conceivable that if b is small and s1 is big
% that the total probability could be less than 1. I have tried normalization in 
% the past and ran into problems with convergence. But this may be worth trying again
% now that many other kinks have been ironed out.
%
% see test_fitSwivel.m fitSwivel.m swivelErr.m shiftreciprobErr.m

% 9/25/01 mns wrote it

global RT1 RT2

rt1 = RT1;
rt2 = RT2;
% n1 = length(rt1);
% n2 = length(rt2);
r1 = 1./rt1;  	% r is reciprocal rt
r2 = 1./rt2;  	% r is reciprocal rt
b1 = th(1);
s1 = th(2);
s2 = th(3);
h = 1;
b2 = th(4) * b1;
% probability of seeing r from the main process is the likelihood of picking
% r from N(b/h,s1/h) times the probability that the other process produces a longer
% rt hence a smaller reciprocal rt. Notice that the negative half of the second process
% must always give rise to a smaller reciprocal time. It's ok to integrate this part
% of the distribution.
p11 = normpdf(r1,b1/h,s1/h) .* normcdf(r1,0,s2/h);
p21 = normpdf(r2,b2/h,s1/h) .* normcdf(r2,0,s2/h);
% The prob of seeing r from the second "guess" process is the likelihood of picking
% r from N(0,s2/h) conditional on getting a positive value times the probability that the main process produces a longer
% rt hence a smaller reciprocal rt. Note that the conditionalization on getting
% a positive value from the guess process is necessary because we are assuming that
% this process actually gives rise to a barrier crossing.
p12 = normpdf(r1,0,s2/h) .* normcdf(r1,b1/h,s1/h);
p22 = normpdf(r2,0,s2/h) .* normcdf(r2,b2/h,s1/h);
p1 = p11 + p12;
p2 = p21 + p22;
err = -(sum(log(p1)) + sum(log(p2)));