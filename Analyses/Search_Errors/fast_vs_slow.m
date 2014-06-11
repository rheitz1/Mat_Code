if exist('saccLoc') == 0
    srt
end

fixErrors

Spike = DSP10a;
RF = RFs.DSP10a;
antiRF = mod((RF+4),8);

%========================================================
% Spike
cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
eMed = nanmedian(SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));

inTrials_cor_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
inTrials_cor_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);

outTrials_cor_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
outTrials_cor_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);

inTrials_err_fast = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) < eMed & SRT(:,1) > 50);
inTrials_err_slow = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) >= eMed & SRT(:,1) < 2000);

outTrials_err_fast = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) < eMed & SRT(:,1) > 50);
outTrials_err_slow = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) >= eMed & SRT(:,1) < 2000);

%=====================================
% Super fast <150 ms error saccades
% inTrials_err_superfast = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) <= 150);
% outTrials_err_superfast = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) <= 150);
%=====================================


SDF = sSDF(Spike,Target_(:,1),[-100 500]);

TDT_cor_fast = getTDT_SP(Spike,inTrials_cor_fast,outTrials_cor_fast,0,.05,5);
TDT_cor_slow = getTDT_SP(Spike,inTrials_cor_slow,outTrials_cor_slow,0,.05,5);
TDT_err_fast = getTDT_SP(Spike,inTrials_err_fast,outTrials_err_fast,0,.05,5);
TDT_err_slow = getTDT_SP(Spike,inTrials_err_slow,outTrials_err_slow,0,.05,5);

figure
subplot(2,1,1)
plot(-100:500,nanmean(SDF(inTrials_cor_fast,:)),'r',-100:500,nanmean(SDF(outTrials_cor_fast,:)),'--r',-100:500,nanmean(SDF(inTrials_cor_slow,:)),'b',-100:500,nanmean(SDF(outTrials_cor_slow,:)),'--b')
xlim([-50 300])
fon
title('Correct')
vline(TDT_cor_fast,'r')
vline(TDT_cor_slow,'b')

subplot(2,1,2)
plot(-100:500,nanmean(SDF(inTrials_err_fast,:)),'r',-100:500,nanmean(SDF(outTrials_err_fast,:)),'--r',-100:500,nanmean(SDF(inTrials_err_slow,:)),'b',-100:500,nanmean(SDF(outTrials_err_slow,:)),'--b')
xlim([-50 300])
fon
title('Errors')
vline(TDT_err_fast,'r')
vline(TDT_err_slow,'b')


%=======================================================
% LFP
LFP = AD10;

LFP = fixClipped(LFP);
LFP = baseline_correct(LFP,[400 500]);

TDT_cor_fast = getTDT_AD(LFP,inTrials_cor_fast,outTrials_cor_fast,0,.05,5);
TDT_cor_slow = getTDT_AD(LFP,inTrials_cor_slow,outTrials_cor_slow,0,.05,5);
TDT_err_fast = getTDT_AD(LFP,inTrials_err_fast,outTrials_err_fast,0,.05,5);
TDT_err_slow = getTDT_AD(LFP,inTrials_err_slow,outTrials_err_slow,0,.05,5);

figure
subplot(2,1,1)
plot(-500:2500,nanmean(LFP(inTrials_cor_fast,:)),'r',-500:2500,nanmean(LFP(outTrials_cor_fast,:)),'--r',-500:2500,nanmean(LFP(inTrials_cor_slow,:)),'b',-500:2500,nanmean(LFP(outTrials_cor_slow,:)),'--b')
xlim([-50 300])
axis ij
fon
title('Correct')
vline(TDT_cor_fast,'r')
vline(TDT_cor_slow,'b')

subplot(2,1,2)
plot(-500:2500,nanmean(LFP(inTrials_err_fast,:)),'r',-500:2500,nanmean(LFP(outTrials_err_fast,:)),'--r',-500:2500,nanmean(LFP(inTrials_err_slow,:)),'b',-500:2500,nanmean(LFP(outTrials_err_slow,:)),'--b')
xlim([-50 300])
axis ij
fon
title('Errors')
vline(TDT_err_fast,'r')
vline(TDT_err_slow,'b')



%======================================================
% OL
OL = AD03;

OL = fixClipped(OL);
OL = baseline_correct(OL,[400 500]);

RF = [7 0 1];
antiRF = [3 4 5];

%specify new trials using hemifield
inTrials_cor_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
inTrials_cor_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);

outTrials_cor_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
outTrials_cor_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);

inTrials_err_fast = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) < eMed & SRT(:,1) > 50);
inTrials_err_slow = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) >= eMed & SRT(:,1) < 2000);

outTrials_err_fast = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) < eMed & SRT(:,1) > 50);
outTrials_err_slow = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) >= eMed & SRT(:,1) < 2000);

TDT_cor_fast = getTDT_AD(OL,inTrials_cor_fast,outTrials_cor_fast,0,.05,5);
TDT_cor_slow = getTDT_AD(OL,inTrials_cor_slow,outTrials_cor_slow,0,.05,5);
TDT_err_fast = getTDT_AD(OL,inTrials_err_fast,outTrials_err_fast,0,.05,5);
TDT_err_slow = getTDT_AD(OL,inTrials_err_slow,outTrials_err_slow,0,.05,5);

figure
subplot(2,1,1)
plot(-500:2500,nanmean(OL(inTrials_cor_fast,:)),'r',-500:2500,nanmean(OL(outTrials_cor_fast,:)),'--r',-500:2500,nanmean(OL(inTrials_cor_slow,:)),'b',-500:2500,nanmean(OL(outTrials_cor_slow,:)),'--b')
xlim([-50 300])
axis ij
fon
title('Correct')
vline(TDT_cor_fast,'r')
vline(TDT_cor_slow,'b')
 
subplot(2,1,2)
plot(-500:2500,nanmean(OL(inTrials_err_fast,:)),'r',-500:2500,nanmean(OL(outTrials_err_fast,:)),'--r',-500:2500,nanmean(OL(inTrials_err_slow,:)),'b',-500:2500,nanmean(OL(outTrials_err_slow,:)),'--b')
xlim([-50 300])
axis ij
fon
title('Errors')
vline(TDT_err_fast,'r')
vline(TDT_err_slow,'b')

 
%======================================================
% OR
OR = AD02;
 
OR = fixClipped(OR);
OR = baseline_correct(OR,[400 500]);
 
RF = [3 4 5];
antiRF = [7 0 1];
 
%specify new trials using hemifield
inTrials_cor_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
inTrials_cor_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
 
outTrials_cor_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
outTrials_cor_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
 
inTrials_err_fast = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) < eMed & SRT(:,1) > 50);
inTrials_err_slow = find(ismember(saccLoc,antiRF) & ismember(Target_(:,2),RF) & SRT(:,1) >= eMed & SRT(:,1) < 2000);
 
outTrials_err_fast = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) < eMed & SRT(:,1) > 50);
outTrials_err_slow = find(ismember(saccLoc,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) >= eMed & SRT(:,1) < 2000);
 
TDT_cor_fast = getTDT_AD(OR,inTrials_cor_fast,outTrials_cor_fast,0,.05,5);
TDT_cor_slow = getTDT_AD(OR,inTrials_cor_slow,outTrials_cor_slow,0,.05,5);
TDT_err_fast = getTDT_AD(OR,inTrials_err_fast,outTrials_err_fast,0,.05,5);
TDT_err_slow = getTDT_AD(OR,inTrials_err_slow,outTrials_err_slow,0,.05,5);

figure
subplot(2,1,1)
plot(-500:2500,nanmean(OR(inTrials_cor_fast,:)),'r',-500:2500,nanmean(OR(outTrials_cor_fast,:)),'--r',-500:2500,nanmean(OR(inTrials_cor_slow,:)),'b',-500:2500,nanmean(OR(outTrials_cor_slow,:)),'--b')
xlim([-50 300])
axis ij
fon
title('Correct')
vline(TDT_cor_fast,'r')
vline(TDT_cor_slow,'b')
 
subplot(2,1,2)
plot(-500:2500,nanmean(OR(inTrials_err_fast,:)),'r',-500:2500,nanmean(OR(outTrials_err_fast,:)),'--r',-500:2500,nanmean(OR(inTrials_err_slow,:)),'b',-500:2500,nanmean(OR(outTrials_err_slow,:)),'--b')
xlim([-50 300])
axis ij
fon
title('Errors')
vline(TDT_err_fast,'r')
vline(TDT_err_slow,'b')

