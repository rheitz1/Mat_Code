function [pSwivelVs2Funcs, pShiftVs2Funcs, pShift, pSwivel, llik12,llikS, llikB,v1,v1CI,v2,v2CI,vS,vSCI,vB,vBCI] = fitSwivel(rt1,rt2,alpha)
% [pSwivelVs2Funcs, pShiftVs2Funcs, pShift, pSwivel llik12,llikS, llikB]
% = fitSwivel(rt1,rt2)
% Fits Carpenter models to two reaction time distributions, rt1 and rt2
% (in msec). The function makes 3 kinds of fits which show up in Figs
% 1-3. 
% 
% Fig 1. Fits separate Carpenter models for the two distributions (see
% below). df = 6.
%
% Fig 2. Fits a swivel model. Only barrier height changes to affect RT. df = 4.
%
% Fig 3. Fits a shift model. Only the slope changes to affect RT. df = 4.
%
% pSwivelVs2Funcs tests whether the extra 2 df to make 2 plots is
% warranted over a swivel (change in h)
% pShiftVs2Funcs tests whether the extra 2 df to make 2 plots is
% warranted over a shift (change in b)
% pShift and pSwivel give the p value that tests whether the shift or
% swivel is the better model.
%
% These models have the same df. So what I do is decide which is the
% better model based on the likelihood. The worse model gets pSxxx =
% nan. The other model is tested by asking whether a change of
% parameter warrants the improvement in fit. In other words, I use the
% chi2 cdf with 1 df.
%
% llik12 is the log likelihood of data given the two fits
% llikS is the log likelihood of data given the swivel model (change in
% barrier height).
% llikB is the log likelihood of data given the shift model (change in slope).
%
% The following (full blown) syntax works only on versions of matlab that
% use fminunc (i.e., not the Mac)
% [pSwivelVs2Funcs, pShiftVs2Funcs, pShift, pSwivel, llik12,llikS, llikB,v1,v1CI,v2,v2CI,vS,vSCI,vB,vBCI] = fitSwivel(rt1,rt2,alpha)
%
% alpha is the error (0.05 by default)
% v1,v1CI the 3 parameters and their confidence intervals for set 1
%         [b s1 s2]
% v2,v2CI the 3 parameters and their confidence intervals for set 2
%         [b s1 s2]
% vS,vSCI the 4 parameters for the swivel constraint and CIs
%         [b s1 s2 hfactor]' 
% vB,vBCI the 4 parameters for slope constraint and CIs
%         [b s1 s2 bfactor]'  
% The model is Carpenter's race between two processes to a barrier at height, h.
% The first (main) process is a ramp with expected slope, b, 
% and standard deviation s1.  The second process (guess) is a ramp with 
% expected slope 0 and standard deviation s2. This process accounts for a
% small fraction of the data at short RT.
%
% Note that b would be the reciprocal of the median rt that would be
% generated from a single ramp process without the short times. It is
% also helpful to note that the barrier crossing would occur at t=inf if
% the slope of the main ramp is 0. This means that the intersection of
% the reciprocal time = 0 occurs at b/s1 standard deviations, regardless
% of barrier height. So long as b and s1 stay the same this limit does
% not change. Hence the swivel.
%
% Known bugs and undesirable features. When fitting two separate
% reciprobit functions, I am allowing s2 free. It might make more sense
% to constrain s2 to a common value. This would make 5 df and would focus
% the likelihood ratio test on the one degree of freedom that matters to
% us (two versus one value for h or for b).
% 
%
% see also test_fitSwivel.m reciprob3ml.m swivelErr.m shiftreciprobErr.m
% nSwivels.m

% 9/25/01 mns wrote it
% 1/20/02 mm added SE
% 1/27/02 mns uses SE to return CI

% Fits a carpenter style graph to the times in vector rt (in msec). The function m
% rt vector of reaction times

makeplot = 1;
plotlines = 1;

global RT RT1 RT2
% POBS

S2Factor = 30;  % make this bigger if fit fails to catch the early saccades

if nargin < 3
  alpha = .05; 
end

[p1,rtsorted1] = cumprob(rt1);
[p2,rtsorted2] = cumprob(rt2);
RT1 = rtsorted1;
RT2 = rtsorted2;
q = [rt1(:);rt2(:)];
rtax = [floor(.5*min(q)):ceil(2*max(q))]';

% POBS = 1-p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Part 1. Find the fit for each function individually
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This just makes 2 calls to the single distribution fits
RT = RT1;
th_guess = [1./median(RT) std(1./RT) S2Factor*std(1./RT)];
% fmins is obsolete after version 5.3, fminsearch does not exist before 5.3
whichone = which('fminsearch');
%otherone = which('fminunc');
if isempty(whichone)
  theta1 = fmins('reciprob3ml',th_guess);  
  theta1 = fmins('reciprob3ml',theta1);
else
  theta1 = fminsearch('reciprob3ml',th_guess);
  [theta1,fval,exitflag,output,grad,hess] = fminunc('reciprob3ml', ...
																  theta1);
  invhess = inv(hess);
  diaginv = diag(invhess);
  standerror1 = sqrt(diaginv);
  zval = norminv(1-alpha/2);
  v1 = theta1(:);
  v1CI = [v1-zval*standerror1 v1+zval*standerror1]; 
end
llik1 = -reciprob3ml(theta1);  % log likelihood (bigger is better)
RT = RT2;
th_guess = [1./median(RT) std(1./RT) S2Factor*std(1./RT)];
% fmins is obsolete after version 5.3, fminsearch does not exist before 5.3
whichone = which('fminsearch');
if isempty(whichone)
  theta2 = fmins('reciprob3ml',th_guess);
  theta2 = fmins('reciprob3ml',theta2);
  v4 - theta2(:);
  v4CI = [];
else
  theta2 = fminsearch('reciprob3ml',th_guess);
  [theta2,fval,exitflag,output,grad,hess] = fminunc('reciprob3ml', ...
																  theta2);
  invhess = inv(hess);
  diaginv = diag(invhess);
  standerror2 = sqrt(diaginv);
  zval = norminv(1-alpha/2);
  v2 = theta2(:);
  v2CI = [v2-zval*standerror2 v2+zval*standerror2]; 
end
llik2 = -reciprob3ml(theta2);  % log likelihood (bigger is better)
llik12 = llik1 + llik2;

b = [theta1(1);theta2(1)];
s1 = [theta1(2);theta2(2)];
s2 = [theta1(3);theta2(3)];
h = [1;1];
[p,z,x1j,y1j,x2j,y2j,r] = nSwivels(b,s1,s2,h,rtax);
if makeplot
	figure(1), clf
	hold on
	h1(1) = plot(-1./rtsorted1, norminv(p1), 'bo','MarkerSize',2);
	h1(2) = plot([0; -r], [b(1)/s1(1); z(:,1)], 'b');
	set(gca, 'XLim', sort(-1./[200 inf]));
	xtickvals = [200 300 500 1000 inf]';
	xtick = sort(-1./xtickvals);
	
	set(gca,'XTick', xtick)
	set(gca,'XTickLabel',num2str(xtickvals))
	set(gca,'TickDir','out')
	set(gca,'FontSize',14)
	xlabel('Time (reciprocal scale)')
	ylabel('z-score')
	if plotlines
		h1(3) = line(x2j(:,1),y2j(:,1));
		h1(4) = line(x1j(:,1),y1j(:,1));
		set([h1(3) h1(4)],'LineStyle','--')
	end
	set(h1,'Color','b')

	h2(1) = plot(-1./rtsorted2, norminv(p2), 'ro','MarkerSize',2);
	h2(2) = plot([0; -r], [b(2)/s1(2); z(:,2)], 'r');
	if plotlines
		h2(3) = line(x2j(:,2),y2j(:,2));
		h2(4) = line(x1j(:,2),y1j(:,2));
		set([h2(3) h2(4)],'LineStyle','--')
	end
	set(h2,'Color','r')
	set(gca,'YLim',[floor(norminv(1./max([length(rt1) length(rt2)]))) ceil(max([y1j(:);y2j(:)]))]);
  str = sprintf('predicted medians from main processes (independent fits): %d %d',round(h./b));
	title(str)
	set(gca,'YGrid','on')
	drawnow
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Part 2. Find the fit for both functions under the swivel constraint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
th_guess = [1./median(RT1) std(1./RT1) S2Factor*std(1./RT1) median(RT2)/ ...
				median(RT1)];

% fmins is obsolete after version 5.3, fminsearch does not exist before 5.3
whichone = which('fminsearch');
if isempty(whichone)
  thetaS = fmins('swivelErr',th_guess);
else
  thetaS = fminsearch('swivelErr',th_guess);
  [thetaS,fval,exitflag,output,grad,hess] = fminunc('swivelErr', ...
																  thetaS);
  invhess = inv(hess);
  diaginv = diag(invhess);
  standerrorS = sqrt(diaginv);
  vS = thetaS(:);
  vSCI = [vS vS] + [-zval*standerrorS(:) zval*standerrorS(:)];
end


llikS = -swivelErr(thetaS);  % log likelihood (bigger is better)
b = thetaS(1) * [1;1];
s1 = thetaS(2) * [1;1];
s2 = thetaS(3) * [1;1];
h = [1;thetaS(4)];
[p,z,x1j,y1j,x2j,y2j,r] = nSwivels(b,s1,s2,h,rtax);
	
if makeplot
	figure(2), clf
	hold on
	h1(1) = plot(-1./rtsorted1, norminv(p1), 'bo','MarkerSize',2);
	h1(2) = plot([0; -r], [b(1)/s1(1); z(:,1)], 'b');
	set(gca, 'XLim', sort(-1./[200 inf]));
	xtickvals = [200 300 500 1000 inf]';
	xtick = sort(-1./xtickvals);
	
	set(gca,'XTick', xtick)
	set(gca,'XTickLabel',num2str(xtickvals))
	set(gca,'TickDir','out')
	set(gca,'FontSize',14)
	xlabel('Time (reciprocal scale)')
	ylabel('z-score')
	if plotlines
		h1(3) = line(x2j(:,1),y2j(:,1));
		h1(4) = line(x1j(:,1),y1j(:,1));
		set([h1(3) h1(4)],'LineStyle','--')
	end
	set(h1,'Color','b')

	h2(1) = plot(-1./rtsorted2, norminv(p2), 'ro','MarkerSize',2);
	h2(2) = plot([0; -r], [b(2)/s1(2); z(:,2)], 'r');
	if plotlines
		h2(3) = line(x2j(:,2),y2j(:,2));
		h2(4) = line(x1j(:,2),y1j(:,2));
		set([h2(3) h2(4)],'LineStyle','--')
	end
	set(h2,'Color','r')
	set(gca,'YLim',[floor(norminv(1./max([length(rt1) length(rt2)]))) ceil(max([y1j(:);y2j(:)]))]);
  str = sprintf('predicted medians from swivel constraint: %d %d',round(h./b));
	title(str)
	set(gca,'YGrid','on')
	drawnow
end

%%%%%%%
% Part 3. Compare the swivel fit to the pair of fits
%%%%%%

lamda = llik12 - llikS;
if lamda > 0
	pSwivelVs2Funcs = 1 - chi2cdf(2*lamda,2);
else
	pSwivelVs2Funcs = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Part 4. Find the fit for both functions under the slope shift constraint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
th_guess = [1./median(RT1) std(1./RT1) S2Factor*std(1./RT1) median(RT1)/ ...
				median(RT2)];

% fmins is obsolete after version 5.3, fminsearch does not exist before 5.3
whichone = which('fminsearch');
if isempty(whichone)
  thetaB = fmins('shiftreciprobErr',th_guess);
else
  thetaB = fminsearch('shiftreciprobErr',th_guess);
  assignin('base','thetaB',thetaB);
  [thetaB,fval,exitflag,output,grad,hess] = fminunc('shiftreciprobErr', ...
																  thetaB);
  invhess = inv(hess);
  diaginv = diag(invhess);
  standerrorB = sqrt(diaginv);
  vB = thetaB(:);
  vBCI = [vB vB] + [-zval*standerrorB(:) zval*standerrorB(:)];
end

llikB = -shiftreciprobErr(thetaB);  % log likelihood (bigger is better)
b = [thetaB(1) thetaB(4)*thetaB(1)]';
s1 = thetaB(2) * [1;1];
s2 = thetaB(3) * [1;1];
h = [1;1];
[p,z,x1j,y1j,x2j,y2j,r] = nSwivels(b,s1,s2,h,rtax);
if makeplot
	figure(3), clf
	hold on
	h1(1) = plot(-1./rtsorted1, norminv(p1), 'bo','MarkerSize',2);
	h1(2) = plot([0; -r], [b(1)/s1(1); z(:,1)], 'b');
	set(gca, 'XLim', sort(-1./[200 inf]));
	xtickvals = [200 300 500 1000 inf]';
	xtick = sort(-1./xtickvals);
	
	set(gca,'XTick', xtick)
	set(gca,'XTickLabel',num2str(xtickvals))
	set(gca,'TickDir','out')
	set(gca,'FontSize',14)
	xlabel('Time (reciprocal scale)')
	ylabel('z-score')
	if plotlines
		h1(3) = line(x2j(:,1),y2j(:,1));
		h1(4) = line(x1j(:,1),y1j(:,1));
		set([h1(3) h1(4)],'LineStyle','--')
	end
	set(h1,'Color','b')

	h2(1) = plot(-1./rtsorted2, norminv(p2), 'ro','MarkerSize',2);
	h2(2) = plot([0; -r], [b(2)/s1(2); z(:,2)], 'r');
	if plotlines
		h2(3) = line(x2j(:,2),y2j(:,2));
		h2(4) = line(x1j(:,2),y1j(:,2));
		set([h2(3) h2(4)],'LineStyle','--')
	end
	set(h2,'Color','r')
	set(gca,'YLim',[floor(norminv(1./max([length(rt1) length(rt2)]))) ceil(max([y1j(:);y2j(:)]))]);
  str = sprintf('predicted medians from shift constraint: %d %d',round(h./b));
	title(str)
	set(gca,'YGrid','on')
	drawnow
end

%%%%%%%
% Part 5. Compare the slope shift fit to the pair of fits
%%%%%%

lamda = llik12 - llikB;
if lamda > 0
	pShiftVs2Funcs = 1 - chi2cdf(2*lamda,2);
else
	pShiftVs2Funcs = 1;
end

%%%%
% Part 6. Compare the two constrained fits. Which is better?
%%%%
if llikB > llikS
	% a shift is more likely than a swivel
	pShift = 1 - chi2cdf(2*(llikB - llikS), 1);
	pSwivel = nan;
else
	% a swivel is more likely than a shift
	pSwivel = 1 - chi2cdf(2*(llikS - llikB), 1);
	pShift = nan;
end
