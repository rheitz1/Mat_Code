function [Onset] = getOnset(trajectory,start_index,win)
%getOnset:
%   Compute the time when activity began increasing by computing the 
%   Spearman's correlation coefficient over a backwards sliding window.  
%   Onset is determined as the point when the correlation is
%   nonsignificant (alpha=0.05) for 2 consecutive time points.
%
%
%INPUT:
%   trajectory=vector of activity
%   start_index=when to begin the backwards sliding window
%   win=time to add before/after current time point for sliding window 
%      (i.e., window size = 2*win)
%
%Braden Purcell
%12.2.2010
%


%values for debugging
    % trajectory=ones(1,3001);
    % trajectory(550:999)=1:450;
    % trajectory(1000:end)=450;
    % start_index=1000;
    % win=20;
%debugging

%set default window_size to 40
if nargin<3
    win=20;
end

%initialize
min_onset_activity=min(trajectory((start_index-20):start_index));
nonsig_vector=zeros(1,length(trajectory));
Onset=0;

%get Spearman correlation for sliding window
for time = round(start_index)-(win):-1:(win+1)
    %get activation in current window
    window = time-(win):time+(win);
        if max(window)>length(trajectory)
            window = time-(win):length(trajectory);
        end
    %compute correlation
    x = trajectory(window)';
    y = window';
    [rho,pval]=corr(x,y,'type','spearman','tail','right');
    %flag if correlation is not significant
    if pval>=.05 || isnan(pval)
        nonsig_vector(time)=1;
    end
    %check for 20 sequential non-significant correlations
    if sum(nonsig_vector(time:time+(win-1)))==(win) && trajectory(time+(win-1)) < min_onset_activity
        Onset=time+(win)-1;
    end
    %end when Onset determined
    if Onset ~= 0,break,end
end

