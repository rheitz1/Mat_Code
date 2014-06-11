%plots RTs around time of block switches
%take note that not all trials will have been correct, nor are they always
%of a made deadline

%keep first column only of SRT for indexing purposes
function [RTs,ACCs] = block_switch_RTs(plotFlag)

if nargin < 1; plotFlag = 1; end

SRT = evalin('caller','SRT');
SAT_ = evalin('caller','SAT_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');

getTrials_SAT

lag_window = -2:2;


%NOTE: Have to correct the accuracy rate variable to account
%for missed deadline trials.  Here I will score them as
%correct, because the saccade was in fact to the correct
%location, but this is sort of a debatable issue
Correct_(slow_correct_missed_dead,2) = 1;
Correct_(fast_correct_missed_dead_withCleared,2) = 1;

%Now keep only the 2nd column so that vector indexing
%won't fail
Correct_(:,1) = [];

curr_SRT = SRT(:,1);


blk_switch = find(abs(diff(SAT_(:,1))) ~= 0) + 1;

%find corresponding conditions
fast_to_slow = blk_switch(find(SAT_(blk_switch-1,1) == 3 & SAT_(blk_switch,1) == 1));
slow_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 3));

slow_to_med = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 2));

if ~isempty(slow_to_med)
    med_included = 1;
else
    med_included = 0;
end

med_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 2 & SAT_(blk_switch,1) == 3));



%================================
%5 trial window centered on switch

%FAST to SLOW
fast_to_slow = repmat(fast_to_slow,1,length(lag_window));
fast_to_slow = fast_to_slow + repmat(lag_window,size(fast_to_slow,1),1);
fast_to_slow(any(fast_to_slow > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.fast_to_slow = curr_SRT(fast_to_slow);
ACCs.fast_to_slow = Correct_(fast_to_slow);

%SLOW to FAST
slow_to_fast = repmat(slow_to_fast,1,length(lag_window));
slow_to_fast = slow_to_fast + repmat(lag_window,size(slow_to_fast,1),1);
slow_to_fast(any(slow_to_fast > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

%if first trial happens to be close to block switch, will fail.  Remove if
%so.  This was done primarily for training sessions w/ flipCond == 3 (e.g.,
%S0217001_SEARCH
if length(slow_to_fast) > 0 && length(find(slow_to_fast(1,:) == 0)) > 0
    slow_to_fast(1,:) = [];
end

RTs.slow_to_fast = curr_SRT(slow_to_fast);
ACCs.slow_to_fast = Correct_(slow_to_fast);

%SLOW to MED
slow_to_med = repmat(slow_to_med,1,length(lag_window));
slow_to_med = slow_to_med + repmat(lag_window,size(slow_to_med,1),1);
slow_to_med(any(slow_to_med > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.slow_to_med = curr_SRT(slow_to_med);

%MED to FAST
med_to_fast = repmat(med_to_fast,1,length(lag_window));
med_to_fast = med_to_fast + repmat(lag_window,size(med_to_fast,1),1);
med_to_fast(any(med_to_fast > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.med_to_fast = curr_SRT(med_to_fast);

if plotFlag
    if med_included == 0
        % SESSIONS NOT INCLUDING MEDIUM
        figure
        fon
        plot(lag_window,RTs.slow_to_fast,'r',lag_window,RTs.fast_to_slow,'g')
        set(gca,'xtick',lag_window)
        xlabel('Trials from Block Switch')
        ylabel('RT (ms)')
        legend('Slow to Fast','Fast to Slow','location','northwest')
        y = ylim;
        
        hold on
        plot(lag_window,nanmean(RTs.slow_to_fast),'k',lag_window,nanmean(RTs.fast_to_slow),'--k','linewidth',2)
        box off
    else
        % SESSIONS INCLUDING MEDIUM
        figure
        fon
        plot(lag_window,RTs.slow_to_med,'r',lag_window,RTs.med_to_fast,'k',lag_window,RTs.fast_to_slow,'g')
        set(gca,'xtick',lag_window)
        xlabel('Trials from Block Switch')
        ylabel('RT (ms)')
        y = ylim;
        
        hold on
        plot(lag_window,nanmean(RTs.slow_to_med),'k',lag_window,nanmean(RTs.med_to_fast),'--k',lag_window,nanmean(RTs.fast_to_slow),':k','linewidth',2)
        legend('Slow to Med','Med to Fast','Fast to Slow','location','northwest')
        box off
    end
end