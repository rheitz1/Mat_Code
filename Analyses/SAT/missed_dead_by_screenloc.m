% Calculates the N's and percent of missed deadlines by
% ACTUAL saccade end point
%
% COLLAPSES OVER CORRECT/INCORRECT

if ~exist('saccLoc')
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
end

slow_made_dead(1) = length(find(saccLoc == 0 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(2) = length(find(saccLoc == 1 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(3) = length(find(saccLoc == 2 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(4) = length(find(saccLoc == 3 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(5) = length(find(saccLoc == 4 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(6) = length(find(saccLoc == 5 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(7) = length(find(saccLoc == 6 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));
slow_made_dead(8) = length(find(saccLoc == 7 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3)));

slow_missed_dead(1) = length(find(saccLoc == 0 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(2) = length(find(saccLoc == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(3) = length(find(saccLoc == 2 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(4) = length(find(saccLoc == 3 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(5) = length(find(saccLoc == 4 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(6) = length(find(saccLoc == 5 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(7) = length(find(saccLoc == 6 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
slow_missed_dead(8) = length(find(saccLoc == 7 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));

fast_made_dead_withCleared(1) = length(find(saccLoc == 0 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(2) = length(find(saccLoc == 1 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(3) = length(find(saccLoc == 2 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(4) = length(find(saccLoc == 3 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(5) = length(find(saccLoc == 4 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(6) = length(find(saccLoc == 5 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(7) = length(find(saccLoc == 6 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));
fast_made_dead_withCleared(8) = length(find(saccLoc == 7 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3)));

fast_missed_dead_withCleared(1) = length(find(saccLoc == 0 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(2) = length(find(saccLoc == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(3) = length(find(saccLoc == 2 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(4) = length(find(saccLoc == 3 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(5) = length(find(saccLoc == 4 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(6) = length(find(saccLoc == 5 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(7) = length(find(saccLoc == 6 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));
fast_missed_dead_withCleared(8) = length(find(saccLoc == 7 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));


missPrc_slow = slow_missed_dead ./ (slow_made_dead + slow_missed_dead);
missPrc_fast = fast_missed_dead_withCleared ./ (fast_made_dead_withCleared + fast_missed_dead_withCleared);

figure
bar([missPrc_slow' missPrc_fast'])
Z = findobj(gca,'type','patch');
set(Z(1),'facecolor','green')
set(Z(2),'facecolor','red')
ylim([0 1])
box off
set(gca,'XTickLabel',[0:7])
xlabel('Saccade endpoint screen position')
ylabel('Percent missed deadlines')