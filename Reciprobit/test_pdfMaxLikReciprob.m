% test_pdfMaxLikReciprob.m
%
% makes fake RT using Carpenter's model, plots the theoretical 
% reciprobit plot in blue and the maximum likelihood fit in red
% The dashed lines are the canonical gaussians that are racing to produce
% the RT.
% To understand Roger Carpenter's model, see the notes in makeFakeRT.m,
% or Roger Carpenter's website, 
% http://www.physiol.cam.ac.uk/staff/carpente/recinormal.htm.

%%%%%% test/develop the ml version, following routines:
% makeFakeRT.m nSwivels.m fitReciprob3a.m reciprob3m1.m
% also uses following subfunctions (all from fitReciprob3a)
% cumprob.m reciprob3m1.m nSwivels.m

clear all;
% make fake rt data

medianRT = 300;
h = 1;
cvs1 = .1;
s2factor = 10;
% s2factor = .1;
n = 100;
btrue  = h./medianRT;
s1true = cvs1 * btrue;
s2true = s2factor * s1true;
rt = makeFakeRT(btrue,h,s1true,s2true,n);


h =1;

figure(1),clf
hold on;
% Here is the function we were supposed to make. This is a test
% of the direct method for computing the reciprobit
rtax = [floor(.5*min(rt)):ceil(2*max(rt))];
[p,z,x1j,y1j,x2j,y2j,r] = nSwivels(btrue,s1true,s2true,h,rtax);


plot(-r,z,'b','LineWidth',1)
set(gca,'XLim',sort(-1./[100 inf]))
rtTickVals = [100 200 300 500 1000 inf];
set(gca,'XTick',sort(-1./rtTickVals));
set(gca,'XTickLabel',num2str(rtTickVals'))
set(gca,'YGrid','on')
set(gca,'TickDir','out','FontSize',14)

% find maximum likelihood fit
[cdf_fit,rfit,bfit,s1fit,s2fit,h,llik] = fitReciprob3a(rt);
% compare error on true, guessed and fit parameters
[reciprob3ml([btrue s1true s2true])  reciprob3ml([bfit s1fit s2fit])];

% Plot the fit in red
set(h(2),'Color','r')
set([h(3) h(4)], 'Color','r')
ylim = get(gca,'YLim');
set(gca,'YLim',[floor(norminv(1./length(rt))) ceil(max([y1j(:);y2j(:)]))]);

% One interesting thing is that the fit returns a median rt that would 
% be created by the main process. This is nice. It should be closer to medianRT
% (the one we asked for) than the observed median
median(rt);  % the value from the data
% b = thfit(1);
1./bfit;		% the value from the fit of the main process

return