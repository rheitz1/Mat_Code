function [] = plot_reciprobit(varargin)

% Plots RT distribution on reciprocal RT/probit scale
% each varargin is an RT distribution
%
% RPH


%for plotting multiple variables
color = {'b','r','k','g','m','y','b','r','g','k','m','y'};

%find largest set of RTs for initialization
maxRTvals = max(cellfun(@length,varargin));

%initialize allRT variable
allRT(1:length(varargin),1:maxRTvals) = NaN;

for var = 1:length(varargin)
    vals_to_enter = sort(removeNaN(varargin{var}));
    allRT(1:length(vals_to_enter),var) = vals_to_enter;
end

%change all 0's to NaN;
allRT(find(allRT == 0)) = NaN;

figure
hold on

for var = 1:length(varargin)
    
    RT = allRT(:,var);
    %first, get the cumulative distribution of observed RTs
    
    %this does not need to be sorted to get the cumulative probability, because
    %its always just a portion of the RTD so far.  But you have to *PLOT* it by
    %the sorted RTs or it won't work. Thus, if your distribution was
    % [1 2 3 1000 1000 1000], the cumulative p values would be the same as if
    % it wasn't sorted, but the plotting wouldn't be right.
    p = cumsum(RT./RT)/length(RT);
    
    %now change RT distribution to reciprocal scale
    RT_recip = 1./RT;
    
    
    %Why we use norminv:
        %The inverse of any CDF is known as the 'quantile function', and expresses the value a
        %distribution will take at that probability.  Because the CDF is ogival, this will result in a
        %vector that has most of its numbers clustered near the middle, with fewer in the tails; in other
        %words, they will be normally distributed.  For this reason, a straight line will result with the
        %y-axis being a gaussian.
    plot(-RT_recip,norminv(p), 'color',color{var},'MarkerSize',2,'linewidth',2)
end

fon
title('Inverse CDF as function of -(1/RT) [Reciprobit]')
xlabel('Observed RT')
ylabel('Z-score')



%the time axis is strange, so lets plot it as actual RT

%first set the xlim to range from 150 ms to infinity.
set(gca,'xlim',-1./[150 inf])

%what are the exact RT values you'd like to see on the plot?
xtickvals = [200 300 500 1000 inf]';

%convert the desired x tick values into the reciprocal scale
xtick = sort(-1./xtickvals);

%now set the tick marks to desired locations
set(gca,'xtick',xtick)

%now put the appropriated modified lables
set(gca,'xticklabel',xtickvals)