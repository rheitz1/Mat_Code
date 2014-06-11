% Equates spike rates within a window by randomly removing spikes from the unit with the lower firing
% rate. This is done across any number of conditions, the trials of which are input into varargin
%
% win is window in REAL time (i.e., if you ask for [200 300] it is 200:300 ms post target onset

%
% See Gregorious et al., 2009
% RPH

function [spike] = match_spike_rate(spike,win,varargin)

if size(spike,2) == 3001
    error('Matrix of 3001 suggests LFP...spike train required...')
end

plotFlag = 0;

if plotFlag
    figure
    subplot(1,2,2)
    hold on
    colvec = {'b','r','g','k'};
end

nRemove = 50; %number of spikes to remove per loop
Plot_Time = [-500 2500];
Target_ = evalin('caller','Target_');

allSDF = sSDF(spike,Target_(:,1),Plot_Time);

for var = 1:length(varargin)
    cur_trl_set = varargin{var};
    
    SDF(var,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(allSDF(cur_trl_set,:));
    
end

%find mean firing rates within a window, then rank-order them
[~,cond_sorted] = sort(nanmean(SDF(:,win(1)+500:win(2)+500),2));

%using the lowest (first) as the goal-point, start removing spikes randomly from trials until the spike
%rate in that window is <= the goal

goal_mean = nanmean(SDF(cond_sorted(1),win(1)+500:win(2)+500));


%keep reference spike unaltered.
varargout{1} = {cond_sorted};
varargout{2} = spike(varargin{cond_sorted(1)},:);

for cond = 2:length(cond_sorted)
    
    %start with full matrix of spike times for current condition
    cond_spike = spike(varargin{cond_sorted(cond)},:);
    cond_spike_mean = 9999;
    
    
    %this will be used to un-vectorize spike
    unvectorize = reshape(1:numel(cond_spike),size(cond_spike));
    
    
    while cond_spike_mean >= goal_mean
        %vectorize spike
        vectorized = cond_spike(:);
        
        
        %current set of valid spike times that may be set to 0.
        valid = find(vectorized > 0);
        
        %to-be-eliminated trials.
        t = randperm(length(valid));
        vectorized(valid(t(1:nRemove))) = 0;
        
        %unvectorize, recompute spike rate in window, and repeat if necessary
        
        cond_spike = vectorized(unvectorize);
        
        tempSDF = sSDF(cond_spike,Target_(:,1),[-500 2500]);
        cond_spike_mean = nanmean(nanmean(tempSDF(:,win(1)+500:win(2)+500),1));
        
    end
    
    %when loop breaks, keep as lowered spike channel.
    varargout{cond+1} = cond_spike;
    
    if plotFlag; plot(-500:2500,nanmean(tempSDF),colvec{cond_sorted(cond)}); end
end

%easier handling of output variables.  Overwrite original spike train with alter spike train(s)
%Reference condition (1st one) need not be altered but the rest do.
for cond = 2:length(cond_sorted)
    spike(varargin{cond_sorted(cond)},:) = varargout{cond+1};
end


if plotFlag
    %add back in reference (lowest) condition SDF
    plot(-500:2500,SDF(cond_sorted(1),:),colvec{cond_sorted(1)})
    xlim([-100 500])
    title('After Spike Removal')
    
    if plotFlag == 1
        subplot(1,2,1)
        plot(-500:2500,SDF(1,:),'b',-500:2500,SDF(2,:),'r',-500:2500,SDF(3,:),'g')
        xlim([-100 500])
        title('Before Spike Removal')
    end
    
    %equate y-axes
    equate_y
end