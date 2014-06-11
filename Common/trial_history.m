%finds patterns of correct/errors (trial history)

% capital letter = current trial
% lower case letter = previous trial
% i/I = incorrect
% c/C = correct

% RPH
function [output_iI output_cI output_iC output_cC] = trial_history(plotFlag)

Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');


if nargin < 1; plotFlag = 0; end
SAT_switch = 0;

crt = Correct_(:,2)';


%Correction for SAT task; missed deadlines sometimes coded as incorrect in 'Correct_' variable but are
%technically correct if not for the deadline.
if ~all(isnan(SAT_(:,1)))
    SAT_switch = 1;
    crt(find(Errors_(:,6) == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
    crt(find(Errors_(:,7) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
end

iI.all = strfind(crt,[0 0])' + 1;
cI.all = strfind(crt,[1 0])' + 1;
iC.all = strfind(crt,[0 1])' + 1;
cC.all = strfind(crt,[1 1])' + 1;

if SAT_switch
    %if is SAT task, need to also separate based on condition
    getTrials_SAT
    
    iI.slow = intersect(iI.all,slow_all);
    cI.slow = intersect(cI.all,slow_all);
    iC.slow = intersect(iC.all,slow_all);
    cC.slow = intersect(cC.all,slow_all);
    
    iI.slow_made_dead = intersect(iI.all,slow_all_made_dead);
    cI.slow_made_dead = intersect(cI.all,slow_all_made_dead);
    iC.slow_made_dead = intersect(iC.all,slow_all_made_dead);
    cC.slow_made_dead = intersect(cC.all,slow_all_made_dead);
    
    %     iI.med = intersect(iI.all,med_all);
    %     cI.med = intersect(cI.all,med_all);
    %     iC.med = intersect(iC.all,med_all);
    %     cC.med = intersect(cC.all,med_all);
    
    iI.fast = intersect(iI.all,fast_all_withCleared);
    cI.fast = intersect(cI.all,fast_all_withCleared);
    iC.fast = intersect(iC.all,fast_all_withCleared);
    cC.fast = intersect(cC.all,fast_all_withCleared);
    
    iI.fast_made_dead = intersect(iI.all,fast_all_made_dead_withCleared);
    cI.fast_made_dead = intersect(cI.all,fast_all_made_dead_withCleared);
    iC.fast_made_dead = intersect(iC.all,fast_all_made_dead_withCleared);
    cC.fast_made_dead = intersect(cC.all,fast_all_made_dead_withCleared);
end


%Calculate means and store in struct for outputting
output_iI.all = nanmean(SRT(iI.all,1));
output_cI.all = nanmean(SRT(cI.all,1));
output_iC.all = nanmean(SRT(iC.all,1));
output_cC.all = nanmean(SRT(cC.all,1));

output_iI.slow = nanmean(SRT(iI.slow,1));
output_cI.slow = nanmean(SRT(cI.slow,1));
output_iC.slow = nanmean(SRT(iC.slow,1));
output_cC.slow = nanmean(SRT(cC.slow,1));

output_iI.slow_made_dead = nanmean(SRT(iI.slow_made_dead,1));
output_cI.slow_made_dead = nanmean(SRT(cI.slow_made_dead,1));
output_iC.slow_made_dead = nanmean(SRT(iC.slow_made_dead,1));
output_cC.slow_made_dead = nanmean(SRT(cC.slow_made_dead,1));

output_iI.fast = nanmean(SRT(iI.fast,1));
output_cI.fast = nanmean(SRT(cI.fast,1));
output_iC.fast = nanmean(SRT(iC.fast,1));
output_cC.fast = nanmean(SRT(cC.fast,1));
 
output_iI.fast_made_dead = nanmean(SRT(iI.fast_made_dead,1));
output_cI.fast_made_dead = nanmean(SRT(cI.fast_made_dead,1));
output_iC.fast_made_dead = nanmean(SRT(iC.fast_made_dead,1));
output_cC.fast_made_dead = nanmean(SRT(cC.fast_made_dead,1));

if plotFlag
    figure
    
    if ~SAT_switch
        sems.iI = sem(SRT(iI.all,1));
        sems.cI = sem(SRT(cI.all,1));
        sems.iC = sem(SRT(iC.all,1));
        sems.cC = sem(SRT(cC.all,1));
        
        errorbar(1:4,[nanmean(SRT(iI.all,1)) nanmean(SRT(cI.all,1)) nanmean(SRT(iC.all,1)) nanmean(SRT(cC.all,1))], ...
            [sems.iI sems.cI sems.iC sems.cC],'k')
        hold on
        bar(1:4,[nanmean(SRT(iI,1)) nanmean(SRT(cI,1)) nanmean(SRT(iC,1)) nanmean(SRT(cC,1))],'facecolor','k')
        box off
        set(gca,'xtick',1:4)
        set(gca,'xticklabel',['iI' ; 'cI' ; 'iC' ; 'cC'])
        xlim([.5 4.5])
        title('Trial History:  previous CURRENT')
        xlabel('Sequence Type')
        ylabel('RT (ms')
        
    else
        sems.slow.iI = sem(SRT(iI.slow,1));
        sems.slow.cI = sem(SRT(cI.slow,1));
        sems.slow.iC = sem(SRT(iC.slow,1));
        sems.slow.cC = sem(SRT(cC.slow,1));
        
        sems_made_dead.slow.iI = sem(SRT(iI.slow_made_dead,1));
        sems_made_dead.slow.cI = sem(SRT(cI.slow_made_dead,1));
        sems_made_dead.slow.iC = sem(SRT(iC.slow_made_dead,1));
        sems_made_dead.slow.cC = sem(SRT(cC.slow_made_dead,1));
        
        %     sems.med.iI = sem(SRT(iI.med,1));
        %     sems.med.cI = sem(SRT(cI.med,1));
        %     sems.med.iC = sem(SRT(iC.med,1));
        %     sems.med.cC = sem(SRT(cC.med,1));
        
        sems.fast.iI = sem(SRT(iI.fast,1));
        sems.fast.cI = sem(SRT(cI.fast,1));
        sems.fast.iC = sem(SRT(iC.fast,1));
        sems.fast.cC = sem(SRT(cC.fast,1));
        
        sems_made_dead.fast.iI = sem(SRT(iI.fast_made_dead,1));
        sems_made_dead.fast.cI = sem(SRT(cI.fast_made_dead,1));
        sems_made_dead.fast.iC = sem(SRT(iC.fast_made_dead,1));
        sems_made_dead.fast.cC = sem(SRT(cC.fast_made_dead,1));
        
        
        %MADE + MISSED DEADLINES
        subplot(221)
        
        errorbar(1:4,[nanmean(SRT(iI.slow,1)) nanmean(SRT(cI.slow,1)) nanmean(SRT(iC.slow,1)) nanmean(SRT(cC.slow,1))], ...
            [sems.slow.iI sems.slow.cI sems.slow.iC sems.slow.cC],'r')
        hold on
        bar(1:4,[nanmean(SRT(iI.slow,1)) nanmean(SRT(cI.slow,1)) nanmean(SRT(iC.slow,1)) nanmean(SRT(cC.slow,1))],'facecolor','r')
        box off
        set(gca,'xtick',1:4)
        set(gca,'xticklabel',['iI' ; 'cI' ; 'iC' ; 'cC'])
        xlim([.5 4.5])
        title('ACCURATE Made+Miss')
        xlabel('Sequence Type')
        ylabel('RT (ms')
        
        Y = ylim;
        
        subplot(222)
        
        errorbar(1:4,[nanmean(SRT(iI.fast,1)) nanmean(SRT(cI.fast,1)) nanmean(SRT(iC.fast,1)) nanmean(SRT(cC.fast,1))], ...
            [sems.fast.iI sems.fast.cI sems.fast.iC sems.fast.cC],'g')
        hold on
        bar(1:4,[nanmean(SRT(iI.fast,1)) nanmean(SRT(cI.fast,1)) nanmean(SRT(iC.fast,1)) nanmean(SRT(cC.fast,1))],'facecolor','g')
        box off
        set(gca,'xtick',1:4)
        set(gca,'xticklabel',['iI' ; 'cI' ; 'iC' ; 'cC'])
        xlim([.5 4.5])
        title('FAST Made+Miss')
        xlabel('Sequence Type')
        ylabel('RT (ms')
        
        ylim(Y)
        
        
        
        %MADE DEAD ONLY
        subplot(223)
        errorbar(1:4,[nanmean(SRT(iI.slow_made_dead,1)) nanmean(SRT(cI.slow_made_dead,1)) nanmean(SRT(iC.slow_made_dead,1)) nanmean(SRT(cC.slow_made_dead,1))], ...
            [sems_made_dead.slow.iI sems_made_dead.slow.cI sems_made_dead.slow.iC sems_made_dead.slow.cC],'r')
        hold on
        bar(1:4,[nanmean(SRT(iI.slow_made_dead,1)) nanmean(SRT(cI.slow_made_dead,1)) nanmean(SRT(iC.slow_made_dead,1)) nanmean(SRT(cC.slow_made_dead,1))],'facecolor','r')
        box off
        set(gca,'xtick',1:4)
        set(gca,'xticklabel',['iI' ; 'cI' ; 'iC' ; 'cC'])
        xlim([.5 4.5])
        title('ACCURATE Made Only')
        xlabel('Sequence Type')
        ylabel('RT (ms')
        
        Y = ylim;
        
        subplot(224)
        
        errorbar(1:4,[nanmean(SRT(iI.fast_made_dead,1)) nanmean(SRT(cI.fast_made_dead,1)) nanmean(SRT(iC.fast_made_dead,1)) nanmean(SRT(cC.fast_made_dead,1))], ...
            [sems_made_dead.fast.iI sems_made_dead.fast.cI sems_made_dead.fast.iC sems_made_dead.fast.cC],'g')
        hold on
        bar(1:4,[nanmean(SRT(iI.fast_made_dead,1)) nanmean(SRT(cI.fast_made_dead,1)) nanmean(SRT(iC.fast_made_dead,1)) nanmean(SRT(cC.fast_made_dead,1))],'facecolor','g')
        box off
        set(gca,'xtick',1:4)
        set(gca,'xticklabel',['iI' ; 'cI' ; 'iC' ; 'cC'])
        xlim([.5 4.5])
        title('Fast Made Only')
        xlabel('Sequence Type')
        ylabel('RT (ms')
        
        ylim(Y)
        
        [ax h] = suplabel('Trial History','t');
        set(h,'fontsize',14)
        
    end
end
