mx = max(allFano_targ.all,[],2);
remove = find(mx >=4);
allFano_targ.all(remove,:) = NaN;

allFano_targ.all(remove,:) = NaN;
allFano_targ.all_shortest(remove,:) = NaN;
allFano_targ.all_middle(remove,:) = NaN;
allFano_targ.all_longest(remove,:) = NaN;

allFano_fix.all(remove,:) = NaN;
allFano_fix.all_shortest(remove,:) = NaN;
allFano_fix.all_middle(remove,:) = NaN;
allFano_fix.all_longest(remove,:) = NaN;

% figure
% plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all),'k')
% xlim([-750 1000])
% 
% figure
% plot(real_time_targ,nanmean(allFano_targ.all))
% xlim([-750 1000])
% box off

figure
plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all),'k')
xlim([-750 1000])
box off

sems.allSDFs_targ = sem(allSDFs_targ.all);
hold
plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all)-sems.allSDFs_targ,'--k', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all)+sems.allSDFs_targ,'--k')

newax
plot(real_time_targ,nanmean(allFano_targ.all),'b')
xlim([-750 1000])

sems.allFano_targ = sem(allFano_targ.all);
plot(real_time_targ,nanmean(allFano_targ.all)-sems.allFano_targ,'--b', ...
    real_time_targ,nanmean(allFano_targ.all)+sems.allFano_targ,'--b')



figure
plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all_shortest),'g', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all_middle),'k', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_targ.all_longest),'r')
xlim([-500 1000])
box off

% 
% figure
% plot(real_time_fix,nanmean(allFano_fix.all_longest),'r', ...
%     real_time_fix,nanmean(allFano_fix.all_middle),'k', ...
%     real_time_fix,nanmean(allFano_fix.all_shortest),'g')
% xlim([-50 3000])
% box off
% 
% 
% figure
% plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_shortest),'g', ...
%     Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_middle),'k', ...
%     Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_longest),'r')
% xlim([-50 3000])
% box off


figure
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all),'k')
xlim([-50 3000])
box off

sems.allSDFs_fix = sem(allSDFs_fix.all);

hold on

plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all)-sems.allSDFs_fix,'--k', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all)+sems.allSDFs_fix,'--k')

newax

sems.allFano_fix = sem(allFano_fix.all);

plot(real_time_fix,nanmean(allFano_fix.all),'b', ...
    real_time_fix,nanmean(allFano_fix.all)-sems.allFano_fix,'--b', ...
    real_time_fix,nanmean(allFano_fix.all)+sems.allFano_fix,'--b')
xlim([-50 3000])




figure

plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_shortest),'g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_middle),'k', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_longest),'r')
xlim([-50 3000])
box off

hold on

sems.allSDFs_fix_longest = sem(allSDFs_fix.all_longest);
sems.allSDFs_fix_middle = sem(allSDFs_fix.all_middle);
sems.allSDFs_fix_shortest = sem(allSDFs_fix.all_shortest);

plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_shortest)-sems.allSDFs_fix_shortest,'--g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_shortest)+sems.allSDFs_fix_shortest,'--g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_middle)-sems.allSDFs_fix_middle,'--k', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_middle)+sems.allSDFs_fix_middle,'--k', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_longest)-sems.allSDFs_fix_longest,'--r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_longest)+sems.allSDFs_fix_longest,'--r')


newax

plot(real_time_fix,nanmean(allFano_fix.all_longest),'r', ...
    real_time_fix,nanmean(allFano_fix.all_middle),'k', ...
    real_time_fix,nanmean(allFano_fix.all_shortest),'g')
xlim([-50 3000])
box off

sems.allFano_fix_longest = sem(allFano_fix.all_longest);
sems.allFano_fix_middle = sem(allFano_fix.all_middle);
sems.allFano_fix_shortest = sem(allFano_fix.all_shortest);

plot(real_time_fix,nanmean(allFano_fix.all_longest)-sems.allFano_fix_longest,'--r', ...
    real_time_fix,nanmean(allFano_fix.all_longest)+sems.allFano_fix_longest,'--r', ...
    real_time_fix,nanmean(allFano_fix.all_middle)-sems.allFano_fix_middle,'--k', ...
    real_time_fix,nanmean(allFano_fix.all_middle)+sems.allFano_fix_middle,'--k', ...
    real_time_fix,nanmean(allFano_fix.all_shortest)-sems.allFano_fix_shortest,'--g', ...
    real_time_fix,nanmean(allFano_fix.all_shortest)+sems.allFano_fix_shortest,'--g')




%=====================
% BY RT
figure
plot(real_time_fix,nanmean(allFano_by_RT_fix.fastest),'g', ...
    real_time_fix,nanmean(allFano_by_RT_fix.slowest),'r')
xlim([50 3000])



%====================
% SAT
figure
plot(real_time_fix,nanmean(allFano_fix_made_dead.slow_shortest),'r', ...
    real_time_fix,nanmean(allFano_fix_made_dead.slow_middle),'r', ...
    real_time_fix,nanmean(allFano_fix_made_dead.slow_longest),'r', ...
    real_time_fix,nanmean(allFano_fix_made_dead.fast_shortest),'g', ...
    real_time_fix,nanmean(allFano_fix_made_dead.fast_middle),'g', ...
    real_time_fix,nanmean(allFano_fix_made_dead.fast_longest),'g')

figure
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix_made_dead.slow_shortest),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix_made_dead.slow_middle),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix_made_dead.slow_longest),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix_made_dead.fast_shortest),'g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix_made_dead.fast_middle),'g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix_made_dead.fast_longest),'g')
 



%=================
% PUPIL SIZE
figure
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.slow_longest),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.slow_middle),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.slow_shortest),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.fast_longest),'g', ...
Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.fast_middle),'g', ...
Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.fast_shortest),'g')


figure
plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allPupils_targ_bc_made_dead.slow_longest),'r', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allPupils_targ_bc_made_dead.slow_middle),'r', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allPupils_targ_bc_made_dead.slow_shortest),'r', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allPupils_targ_bc_made_dead.fast_longest),'g', ...
Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allPupils_targ_bc_made_dead.fast_middle),'g', ...
Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allPupils_targ_bc_made_dead.fast_shortest),'g')
xlim([-2000 500])
box off