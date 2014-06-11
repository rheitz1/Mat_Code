%plots RTs and SDF baseline effects around time of block switches
%take note that not all trials will have been correct, nor are they always
%of a made deadline for the RTs.  For the SDFs, only correct, made
%deadlines, and then only the grand means are displayed.
%
%Note that since this is a *baseline* period, we collapse across all screen
%locations.  However, made/missed and correct MAY make a difference since
%it suggests a certain preparatory state.

function [SDF] = block_switch_thresh(name,plotFlag)

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
sig = evalin('caller',name);


normal = 1;

if nargin < 2; plotFlag = 1; end


%=======================
% RTs first

%keep first column only of SRT for indexing purposes
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


lag_window = -2:2;

%================================
%5 trial window centered on switch

%FAST to SLOW
fast_to_slow = repmat(fast_to_slow,1,5);
fast_to_slow = fast_to_slow + repmat(lag_window,size(fast_to_slow,1),1);
fast_to_slow(any(fast_to_slow > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.fast_to_slow = curr_SRT(fast_to_slow);

%SLOW to FAST
slow_to_fast = repmat(slow_to_fast,1,5);
slow_to_fast = slow_to_fast + repmat(lag_window,size(slow_to_fast,1),1);
slow_to_fast(any(slow_to_fast > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.slow_to_fast = curr_SRT(slow_to_fast);

%SLOW to MED
slow_to_med = repmat(slow_to_med,1,5);
slow_to_med = slow_to_med + repmat(lag_window,size(slow_to_med,1),1);
slow_to_med(any(slow_to_med > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.slow_to_med = curr_SRT(slow_to_med);

%MED to FAST
med_to_fast = repmat(med_to_fast,1,5);
med_to_fast = med_to_fast + repmat(lag_window,size(med_to_fast,1),1);
med_to_fast(any(med_to_fast > size(curr_SRT,1),2),:) = []; %removes any indices that are out of bounds

RTs.med_to_fast = curr_SRT(med_to_fast);

%=============================


%=============================
% Now for SDFs

%do only if an RF is present and user specifies a unit name
trunc_RT = 4000;
slow_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
correct_made_dead = [slow_correct_made_dead ; fast_correct_made_dead_withCleared];


thresh_SDF = sSDF(sig,SRT(:,1)+500,[-400 200]);

if normal; thresh_SDF = normalize_SP(thresh_SDF); end

thresh_SDF = thresh_SDF(:,350:400);
thresh_SDF = mean(thresh_SDF,2); %since a vector, we can now index just as we did the SRTs
thresh_SDF(find(thresh_SDF == 0)) = NaN;

%alter trial vectors to eliminate trials that were not correct or where
%deadline was not met
slow_to_fast_SDF = slow_to_fast;
fast_to_slow_SDF = fast_to_slow;
slow_to_med_SDF = slow_to_med;
med_to_fast_SDF = med_to_fast;

% DO NOT LIMIT TO RF-IN ONLY.  NEURON DOESN'T KNOW WHERE UPCOMING TARGET WILL BE YET
%     slow_to_fast_SDF(~ismember(slow_to_fast_SDF,correct_made_dead)) = NaN;
%     fast_to_slow_SDF(~ismember(fast_to_slow_SDF,correct_made_dead)) = NaN;
%     slow_to_med_SDF(~ismember(slow_to_med_SDF,correct_made_dead)) = NaN;
%     med_to_fast_SDF(~ismember(med_to_fast_SDF,correct_made_dead)) = NaN;

for win = 1:5
    SDF.fast_to_slow(win) = nanmean(thresh_SDF(fast_to_slow_SDF(~isnan(fast_to_slow_SDF(:,win)),win)));
    SDF.slow_to_fast(win) = nanmean(thresh_SDF(slow_to_fast_SDF(~isnan(slow_to_fast_SDF(:,win)),win)));
    SDF.slow_to_med(win) = nanmean(thresh_SDF(slow_to_med_SDF(~isnan(slow_to_med_SDF(:,win)),win)));
    SDF.med_to_fast(win) = nanmean(thresh_SDF(med_to_fast_SDF(~isnan(med_to_fast_SDF(:,win)),win)));
end




if plotFlag
    if med_included == 0
        % SESSIONS NOT INCLUDING MEDIUM
        figure
        fon
        plot(-2:2,RTs.slow_to_fast,'r',-2:2,RTs.fast_to_slow,'g')
        set(gca,'xtick',-2:2)
        xlabel('Trials from Block Switch')
        ylabel('RT (ms)')
        y = ylim;
        box off
        
        newax
        plot(-2:2,nanmean(RTs.slow_to_fast),'k',-2:2,nanmean(RTs.fast_to_slow),'--k','linewidth',2)
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        ylim(y)
        box off
        legend('Slow to Fast','Fast to Slow','location','northwest')
        
        
    else
        % SESSIONS INCLUDING MEDIUM
        figure
        fon
        plot(-2:2,RTs.slow_to_med,'r',-2:2,RTs.med_to_fast,'k',-2:2,RTs.fast_to_slow,'g')
        set(gca,'xtick',-2:2)
        xlabel('Trials from Block Switch')
        ylabel('RT (ms)')
        y = ylim;
        
        newax
        plot(-2:2,nanmean(RTs.slow_to_med),'k',-2:2,nanmean(RTs.med_to_fast),'--k',-2:2,nanmean(RTs.fast_to_slow),':k','linewidth',2)
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        ylim(y)
        legend('Slow to Med','Med to Fast','Fast to Slow','location','northwest')
    end
    
    if nargin > 0 && med_included == 0
        figure
        fon
        plot(-2:2,SDF.slow_to_fast,'r',-2:2,SDF.fast_to_slow,'g','linewidth',2)
        xlabel('Trial relative to block change')
        ylabel('Spikes/s')
        legend('Slow to Fast','Fast to Slow','location','northwest')
        title('Baseline Effects for Correct, Made Deadlines relative to block switch')
    elseif nargin > 0 && med_included == 1
        figure
        fon
        plot(-2:2,SDF.slow_to_med,'r',-2:2,SDF.med_to_fast,'k',-2:2,SDF.fast_to_slow,'g','linewidth',2)
        xlabel('Trial relative to block change')
        ylabel('Spikes/s')
        legend('Slow to Med','Med to Fast','Fast to Slow','location','northwest')
        title('Baseline Effects for Correct, Made Deadlines relative to block switch');
    end
end