ADname = 'AD09';
spkname = 'DSP12a';
win = [100 2000];


AD = eval(ADname);
spk = eval(spkname);

RF = RFs.(spkname);

in = find(ismember(Target_(:,2),RF));

getTrials_SAT


slow = intersect(slow_correct_made_dead,in);
med = intersect(med_correct,in);
fast = intersect(fast_correct_made_dead_withCleared,in);

STA.slow = getSTA(spk(slow,:),AD(slow,:),win,100,20);
STA.med = getSTA(spk(med,:),AD(med,:),win,100,20);
STA.fast = getSTA(spk(fast,:),AD(fast,:),win,100,20);

figure
plot(-100:100,detrend(nanmean(STA.slow)),'r',-100:100,detrend(nanmean(STA.med)),'k',-100:100,detrend(nanmean(STA.fast)),'g')
xlim([-100 100])
axis ij
box off