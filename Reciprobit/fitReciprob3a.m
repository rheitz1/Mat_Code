function [cdf_fit,rfit,b,s1,s2,h,llik] = fitReciprob3a(rt)
% [cdf_fit,rfit,b,s1,s2,h,llik] = fitReciprob3a(rt)
% Fits a carpenter style graph to the times in vector rt (in msec). 
% This function makes a plot (disable by editing the function)
% cdf_fit are the vals of the cdf (0..1) at the reciprocal times in rfit
%    plot(-rfit,norminv(cdf_fit)) is a reciprobit graph
% rfit    reciprocal times used for the fit
% b  max like estimate of slope of main process
% s1 max like estimate of stdev of the slope of main process
% s2  max like estimate of the stdev of the process governed by 0 mean slope
% h   handle of curves and lines
% llik log likelihood of rt given fit
%
% see reciprob3ml.m for more details

% 9/15/01 mns wrote it

makeplot = 1;
plotlines = 1;

global RT 
% POBS

S2Factor = 30;  % make this bigger if fit fails to catch the early saccades


[p,rtsorted] = cumprob(rt);
RT = rtsorted;
% POBS = 1-p;

% It is very important to guess a high value for s2. Otherwise, it
% is highly likely that you hit a local minimum.
th_guess = [1./median(rt) std(1./rt) S2Factor*std(1./rt)];
% fmins is obsolete after version 5.3, fminsearch does not exist before 5.3
whichone = which('fminsearch');
if isempty(whichone)
  theta = fmins('reciprob3ml',th_guess);
else
  theta = fminsearch('reciprob3ml',th_guess);
end
llik = -reciprob3ml(theta);  % log likelihood (bigger is better)

% calc the fitted function
% rtmin = 10; rtmax = 1000; n=2000;
b = theta(1);
s1 = theta(2);
s2 = theta(3);
h = 1;
% nfit = 1000;
% [cdf_fit,zfit,rfit] = direct_pdfMethod2(b,s1,s2,h,rtmin,rtmax,nfit);
% [cdf_fit,zfit,rfit,x1,y1,x2,y2] = direct_pdfMethod2a(b,s1,s2,h,[min(rt):max(rt)]');
rtax = [floor(.5*min(rt)):ceil(2*max(rt))];
[cdf_fit,zfit,x1,y1,x2,y2,rfit] = nSwivels(b,s1,s2,h,rtax);


if makeplot
	hold on
	% plot data
	h(1) = plot(-1./rtsorted, norminv(p), 'ko','MarkerSize',2);
	h(2) = plot([0; -rfit], [b/s1; zfit], 'k');
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
		hl2 = line(x2,y2);
		hl1 = line(x1,y1);
		set([hl1 hl2],'LineStyle','--')
		h(3) = hl1;
		h(4) = hl2;
	end

end

	