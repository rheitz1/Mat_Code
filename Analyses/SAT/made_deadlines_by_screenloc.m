% Report the number of "correct made deadline" trials for each condition.
% Useful to ensure that there is no systematic bias that will make condition
% comparisons difficult.


pos0 = find(Target_(:,2) == 0);
pos1 = find(Target_(:,2) == 1);
pos2 = find(Target_(:,2) == 2);
pos3 = find(Target_(:,2) == 3);
pos4 = find(Target_(:,2) == 4);
pos5 = find(Target_(:,2) == 5);
pos6 = find(Target_(:,2) == 6);
pos7 = find(Target_(:,2) == 7);

getTrials_SAT

N0.slow = length(intersect(slow_correct_made_dead,pos0));
N1.slow = length(intersect(slow_correct_made_dead,pos1));
N2.slow = length(intersect(slow_correct_made_dead,pos2));
N3.slow = length(intersect(slow_correct_made_dead,pos3));
N4.slow = length(intersect(slow_correct_made_dead,pos4));
N5.slow = length(intersect(slow_correct_made_dead,pos5));
N6.slow = length(intersect(slow_correct_made_dead,pos6));
N7.slow = length(intersect(slow_correct_made_dead,pos7));

N0.fast = length(intersect(fast_correct_made_dead_withCleared,pos0));
N1.fast = length(intersect(fast_correct_made_dead_withCleared,pos1));
N2.fast = length(intersect(fast_correct_made_dead_withCleared,pos2));
N3.fast = length(intersect(fast_correct_made_dead_withCleared,pos3));
N4.fast = length(intersect(fast_correct_made_dead_withCleared,pos4));
N5.fast = length(intersect(fast_correct_made_dead_withCleared,pos5));
N6.fast = length(intersect(fast_correct_made_dead_withCleared,pos6));
N7.fast = length(intersect(fast_correct_made_dead_withCleared,pos7));

figure
bar(0:7,[N0.slow N0.fast ; N1.slow N1.fast ; ...
    N2.slow N2.fast ; N3.slow N3.fast ; ...
    N4.slow N4.fast ; N5.slow N5.fast ; ...
    N6.slow N6.fast ; N7.slow N7.fast],'grouped','barwidth',1)
box off
title('ACCurate = BLUE ; FAST = Red')