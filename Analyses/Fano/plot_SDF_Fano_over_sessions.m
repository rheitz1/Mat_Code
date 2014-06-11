figure

for sess = 266:size(allFano_fix.all,1)
    plot(Plot_Time_Fix(1):Plot_Time_Fix(2),allSDFs_fix.all(sess,:),'k')
    xlim([-50 2000])
    box off
    title(mat2str(sess))
    
    
    newax
    plot(real_time_fix,allFano_fix.all(sess,:),'r')
    xlim([-50 2000])
    box off
    
    pause
    clf
end