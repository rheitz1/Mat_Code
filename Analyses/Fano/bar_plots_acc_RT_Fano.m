acc.all_shortest = nanmean(unique(allACCs.all_shortest));
acc_sems.all_shortest = sem(unique(allACCs.all_shortest));

acc.all_middle = nanmean(unique(allACCs.all_middle));
acc_sems.all_middle = sem(unique(allACCs.all_middle));

acc.all_longest = nanmean(unique(allACCs.all_longest));
acc_sems.all_longest = sem(unique(allACCs.all_longest));

rt.all_shortest = nanmean(unique(allRTs.all_shortest));
rt_sems.all_shortest = sem(unique(allRTs.all_shortest));
 
rt.all_middle = nanmean(unique(allRTs.all_middle));
rt_sems.all_middle = sem(unique(allRTs.all_middle));
 
rt.all_longest = nanmean(unique(allRTs.all_longest));
rt_sems.all_longest = sem(unique(allRTs.all_longest));


acc.slow_shortest = nanmean(unique(allACCs.slow_shortest));
acc_sems.slow_shortest = sem(unique(allACCs.slow_shortest));
 
acc.slow_middle = nanmean(unique(allACCs.slow_middle));
acc_sems.slow_middle = sem(unique(allACCs.slow_middle));
 
acc.slow_longest = nanmean(unique(allACCs.slow_longest));
acc_sems.slow_longest = sem(unique(allACCs.slow_longest));
 
rt.slow_shortest = nanmean(unique(allRTs.slow_shortest));
rt_sems.slow_shortest = sem(unique(allRTs.slow_shortest));
 
rt.slow_middle = nanmean(unique(allRTs.slow_middle));
rt_sems.slow_middle = sem(unique(allRTs.slow_middle));
 
rt.slow_longest = nanmean(unique(allRTs.slow_longest));
rt_sems.slow_longest = sem(unique(allRTs.slow_longest));
 

acc.fast_shortest = nanmean(unique(allACCs.fast_shortest));
acc_sems.fast_shortest = sem(unique(allACCs.fast_shortest));
 
acc.fast_middle = nanmean(unique(allACCs.fast_middle));
acc_sems.fast_middle = sem(unique(allACCs.fast_middle));
 
acc.fast_longest = nanmean(unique(allACCs.fast_longest));
acc_sems.fast_longest = sem(unique(allACCs.fast_longest));
 
rt.fast_shortest = nanmean(unique(allRTs.fast_shortest));
rt_sems.fast_shortest = sem(unique(allRTs.fast_shortest));
 
rt.fast_middle = nanmean(unique(allRTs.fast_middle));
rt_sems.fast_middle = sem(unique(allRTs.fast_middle));
 
rt.fast_longest = nanmean(unique(allRTs.fast_longest));
rt_sems.fast_longest = sem(unique(allRTs.fast_longest));
 




fig1
errorbar(1:3,[acc.all_shortest acc.all_middle acc.all_longest], ...
    [acc_sems.all_shortest acc_sems.all_middle acc_sems.all_longest],'MarkerEdgeColor','none','MarkerFaceColor','none','linestyle','none')
hold
bar(1:3,[acc.all_shortest acc.all_middle acc.all_longest])
ylim([.6 1])
title('ACCs')




fig2
errorbar(1:3,[rt.all_shortest rt.all_middle rt.all_longest], ...
    [rt_sems.all_shortest rt_sems.all_middle rt_sems.all_longest],'MarkerEdgeColor','none','MarkerFaceColor','none','linestyle','none')
hold
bar(1:3,[rt.all_shortest rt.all_middle rt.all_longest])
title('RTs')





fig3
errorbar(1:6,[acc.slow_shortest acc.slow_middle acc.slow_longest ...
    acc.fast_shortest acc.fast_middle acc.fast_longest], ...
    [acc_sems.slow_shortest acc_sems.slow_middle acc_sems.slow_longest ...
    acc_sems.fast_shortest acc_sems.fast_middle acc_sems.fast_longest],'MarkerEdgeColor','none','MarkerFaceColor','none','linestyle','none')
hold
bar(1:6,[acc.slow_shortest acc.slow_middle acc.slow_longest ...
    acc.fast_shortest acc.fast_middle acc.fast_longest])
ylim([.6 1])
title('ACCs')
 
 
 
 
fig4
errorbar(1:6,[rt.slow_shortest rt.slow_middle rt.slow_longest ...
    rt.fast_shortest rt.fast_middle rt.fast_longest], ...
    [rt_sems.slow_shortest rt_sems.slow_middle rt_sems.slow_longest ...
    rt_sems.fast_shortest rt_sems.fast_middle rt_sems.fast_longest],'MarkerEdgeColor','none','MarkerFaceColor','none','linestyle','none')
hold
bar(1:6,[rt.slow_shortest rt.slow_middle rt.slow_longest ...
    rt.fast_shortest rt.fast_middle rt.fast_longest])
title('rts')
