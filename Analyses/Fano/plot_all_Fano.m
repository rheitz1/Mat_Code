figure

subplot(331)
plot(real_time_targ,nanmean(allFano_targ.all_longest),'r',real_time_targ,nanmean(allFano_targ.all_middle),'k', ...
    real_time_targ,nanmean(allFano_targ.all_shortest),'g')
xlim([-2000 500])
box off
title('target aligned by hold time')

subplot(332)
plot(real_time_fix,nanmean(allFano_fix.all_longest),'r',real_time_fix,nanmean(allFano_fix.all_middle),'k', ...
    real_time_fix,nanmean(allFano_fix.all_shortest),'g')
xlim([min(real_time_fix) max(real_time_fix)])
box off
title('fix aligned by hold time')

subplot(333)
plot(real_time_fix,nanmean(allFano_by_RT_fix.slowest),'r',real_time_fix,nanmean(allFano_by_RT_fix.middle),'k', ...
    real_time_fix,nanmean(allFano_by_RT_fix.fastest),'g')
xlim([min(real_time_fix) max(real_time_fix)])
box off
title('fix aligned by RT')

subplot(334)
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.slow_longest),'r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.slow_middle),'--r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.slow_shortest),'-.r', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.fast_longest),'g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.fast_middle),'--g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allPupils_fix_bc_made_dead.fast_shortest),'-.g')
    
xlim([Plot_Time_Fix(1) Plot_Time_Fix(2)])
box off
title('pupil size by SAT, fix aligned')



subplot(337)
plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_by_RT_targ.fastest),'g', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_by_RT_targ.middle),'k', ...
    Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDFs_by_RT_targ.slowest),'r')
xlim([Plot_Time_Targ(1) Plot_Time_Targ(2)])
box off
title('target aligned SDF by RT')

subplot(338)
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_by_RT_fix.fastest),'g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_by_RT_fix.middle),'k', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_by_RT_fix.slowest),'r')
xlim([Plot_Time_Fix(1) Plot_Time_Fix(2)])
box off
title('fix aligned SDF by RT')




figure
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_shortest),'g', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_middle),'k', ...
    Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDFs_fix.all_longest),'r')
xlim([-50 1600])
box off

newax
plot(real_time_fix,nanmean(allFano_fix.all_shortest),'--g',real_time_fix,nanmean(allFano_fix.all_middle),'--k', ...
    real_time_fix,nanmean(allFano_fix.all_longest),'--r')
xlim([-50 1600])
box off