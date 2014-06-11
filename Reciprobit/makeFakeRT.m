function rt = makeFakeRT(b,h,s1,s2,n)
% rt = makeFakeRT(b,h,s1,s2,n)
% Creates fake data using Roger Carpenter's model, parameterized by
% medianRT,h,s1,s2.  The RT is the winner of a race between two
% linear functions of time, y1 = k1 * t, and y2 = k2 * t. RT occurs when the 
% either of these reach y1=h or y2=h. So h is barrier height or threshold.
% k1 is a random var drawn from N(b,s1).
% k2 is drawn from N(0,s2).
% The second process is strange. Its expected rate is 0, so its expected
% time to barrier is inf. At most it can account for half of the observations
% because half the time the slope is negative (i.e., away from the
% barrier at h).
% This process occasionally gives rise to shorter RT than the second
% process when k2 happens to be drawn from the positive tail of
% N(0,s2). What this represents in real life (i.e., the brain) is a
% matter of debate.
% Note that if there were only the 1st process, median RT would be h/b.

% 9/25/01 mns wrote it as makeFakeRTa
% 12/1/01 mns changed name to makeFakeRT, cleaned documentation

B = normrnd(b,s1,n,1);  % vector of ramp slopes
Bfast = normrnd(0,s2,n,1);  % vector of ramp slopes for the 2nd (faster process)
rtB = h./B;	% vector of rt produced by the standard ramp
rtF = h./Bfast;	% vector of rt produced by the second process
rtF(rtF <= 0) = inf;  % The negative RT from 2nd process is set to inf
% (it must lose)
rt = min([rtB rtF]')';