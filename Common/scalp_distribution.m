%plots scalp distribution grand-average, across all trials, target-aligned
trls = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50);

if newfile(1) == 'Q'
    OL = AD03;
    OR = AD02;
    
    figure
    subplot(1,2,1)
    plot(-500:2500,nanmean(OL(trls,:)));
    xlim([-100 500])
    fon
    title('OL')
    
    subplot(1,2,2)
    plot(-500:2500,nanmean(OR(trls,:)));
    xlim([-100 500])
    fon
    title('OR')
    
    
    
elseif newfile(1) == 'S'
    Oz = AD01;
    OR = AD02;
    OL = AD03;
    C4 = AD04;
    C3 = AD05;
    F4 = AD06;
    F3 = AD07;
    
    subplot(7,7,[1:2 8:9])
    plot(-500:2500,nanmean(F3(trls,:)))
    xlim([-100 500])
    fon
    title('F3')
    
    subplot(7,7,[6:7 13:14])
    plot(-500:2500,nanmean(F4(trls,:)))
    xlim([-100 500])
    fon
    title('F4')
    
    subplot(7,7,[17:18 24:25])
    plot(-500:2500,nanmean(C3(trls,:)))
    xlim([-100 500])
    fon
    title('C3')
    
    subplot(7,7,[19:20 26:27])
    plot(-500:2500,nanmean(C4(trls,:)))
    xlim([-100 500])
    fon
    title('C4')
    
    subplot(7,7,[30:31 37:38])
    plot(-500:2500,nanmean(OL(trls,:)))
    xlim([-100 500])
    fon
    title('OL')
    
    subplot(7,7,[34:35 41:42])
    plot(-500:2500,nanmean(OR(trls,:)))
    xlim([-100 500])
    fon
    title('OR')
    
    subplot(7,7,[39:40 46:47])
    plot(-500:2500,nanmean(Oz(trls,:)))
    xlim([-100 500])
    fon
    title('Oz')
end