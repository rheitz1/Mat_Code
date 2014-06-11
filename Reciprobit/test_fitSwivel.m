% test_fitSwivel.m
%  
% Script to test the maximum likelihood method for fitting Carpenter style
% reciprobit functions to 2 sets of data under a variety of constraints.
% The script serves to illustrate the principle and use of the routines.
%
% To understand Roger Carpenter's model, see the notes in makeFakeRT.m,
% or Roger Carpenter's website, 
% http://www.physiol.cam.ac.uk/staff/carpente/recinormal.htm.
% This script makes two sets of fake RT data using either a change in barrier
% height or a change in ramp slope. This should produce swivel or parallel shift
% of reciprobit plots, respectively. Play with the values that generate the
% fake RT to see how well the constrained fits (swivel vs. parallel) conform to 
% expectation.
% 
% To understand the 3 graphs, type help fitSwivel
% 
% Tests the following routines:
% makeFakeRT.m  fitSwivel.m
% Subfunctions used (all from fitSwivel.m):
% nSwivels.m shiftreciprobErr.m swivelErr.m reciprob3ml.m cumprob.m
%

% History 9/2001 mns wrote it
%         12/6/01 mns cleaned up comments
%         1/27/02 mns added call to the version that returns CIs
%
clear all;

% Which kind of fake data do you want to generate? 
% RT distributions that result from change in barrier height: Swivel
% RT distributions that result from change in ramp slope: Shift
%
% Set one of these options to 1. 
chooseSwivel = 1
chooseShift = 0

% In addition to these choices, you can play with the numbers used to
% create the fake data. This can be useful when determining the power of
% the statistical tests.

%
% set number of random samples in each of the fake RT distributions
n = 200;
% set desired median RT for fake data (faster of the 2 distributions)
medianRT = 300;
% Barrier height for fake data is always 1
h1 = 1;
% Control the stdev of the ramp for process 1 by setting the coefficient of
% variation. 0.1 is a good choice.
cvs1 = .1;
% Control the stdev of the second "guess" process that gives rise to the shorter
% RT. The stdev should be relatively large if this process is to account for any 
% observations. 10 is a good value
s2factor = 10;

% The inputs to makeFakeRT are slope of ramp, its stdev and the stdev of the
% "guess" process (0-mean slope).
b1true  = 1./medianRT;
s1true = cvs1 * b1true;
s2true = s2factor * s1true;

% The change in barrier height or ramp slope by 1.3 corresponds to a pretty substantial change
% in RT. It should be easily detectable with 200 samples, but may be on the border with n=100.
if chooseSwivel
	b2true = b1true;
	h2 = 1.3;
elseif chooseShift
	b2true = b1true/1.3;
	h2 = 1;
end

rt1 = makeFakeRT(b1true,h1,s1true,s2true,n);
rt2 = makeFakeRT(b2true,h2,s1true,s2true,n);

% Call the fitting function. 
[pSwivelVs2Funcs, pShiftVs2Funcs, pShift, pSwivel, llik12,llikS, llikB] = fitSwivel(rt1,rt2);

% This one returns the vectors and confidence intervals
[pSwivelVs2Funcs, pShiftVs2Funcs, pShift, pSwivel, llik12,llikS,llikB,v1,v1CI,v2,v2CI,vS,vSCI,vB,vBCI] = fitSwivel(rt1,rt2,.05) ;

% Slopes and CI for the 2 data sets
[v1(1) v1CI(1,:); v2(1) v2CI(1,:)]
% The stdev parameters
[v1(2) v1CI(2,:); v2(2) v2CI(2,:)]
[v1(3) v1CI(3,:); v2(3) v2CI(3,:)]
% Median RT based on process 1.

fprintf(1,'median RT from the independent fits with CI:\n')
round(1./[v1(1) v1CI(1,:); v2(1) v2CI(1,:)])

% The Swivel constraint returns 4 params
[vS vSCI]
% Here's the estimate for median RT from the swivel constraint with CI
fprintf(1,'median RT from the swivel constraint with CI:\n')
round(1./[vS(1) vSCI(1,:); ([vS(1) vSCI(1,:)]./[vS(4) vSCI(4,:)])])

% The shift constraint returns 4 params
[vB vBCI]
% Here's the estimate for the median RT from the shift constraint with CI
fprintf(1,'median RT from the shift constraint with CI:\n')
round(1./[vB(1) vBCI(1,:); ([vB(1) vBCI(1,:)].*[vB(4) vBCI(4,:)])])



fprintf(1,'Are 2 independent fits better than a swivel constraint? P = %g\n\n', pSwivelVs2Funcs);
fprintf(1,'Are 2 independent fits better than a shift constraint? P = %g\n\n', pShiftVs2Funcs);

if isnan(pSwivel)
	fprintf(1,'Shift provided a better fit than swivel (p = %g)\n', pShift);
else
	fprintf(1,'Swivel provided a better fit than shift (p = %g)\n', pSwivel);
end

return
