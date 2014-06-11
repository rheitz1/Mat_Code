
for n = 1:size(allwf_targ.in.slow_correct_made_dead,1)
    x = allwf_targ.in.slow_correct_made_dead(n,:);
    x(100 + round(RTs.slow_correct_made_dead(n)):end) = NaN;
    allx(n,:) = x;
    
    y = allwf_targ.in.fast_correct_made_dead_withCleared(n,:);
    y(100 + round(RTs.fast_correct_made_dead_withCleared(n)):end) = NaN;
    ally(n,:) = y;
    %plot(-100:900,x,'r',-100:900,y,'g')
    
    %ylim([0 1.9])
    
    clear x y 
    %box off
    %pause
    %cla
end