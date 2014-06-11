% Concatenates ALL behavioral data (each trial) and then computes the main sequence of saccade metrics
%
% RPH

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
%[filename3] = textread('SAT_Beh_Med_S.txt','%s');
%[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename2];


plotFlag = 0;


%for this, use 3001 ms data
cd /volumes/Dump/Search_Data_SAT/
path(path,'/volumes/Dump/Search_Data_SAT/Training/')
% For population, compile all data into one huge dataset
allTarget_ = [];
allCorrect_ = [];
allSRT = [];
allSAT_ = [];
allErrors_ = [];
allEyeX_ = [];
allEyeY_ = [];
allSaccLoc = [];

for file = 1:length(filename)
    load(filename{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_')
    filename{file}
    
    allTarget_ = [allTarget_ ; Target_];
    allCorrect_ = [allCorrect_ ; Correct_];
    allSRT = [allSRT ; SRT(:,1)];
    allSAT_ = [allSAT_ ; SAT_];
    allErrors_ = [allErrors_ ; Errors_];
    allEyeX_ = [allEyeX_ ; EyeX_];
    allEyeY_ = [allEyeY_ ; EyeY_];
    allSaccLoc = [allSaccLoc ; saccLoc];
    
    clear Correct_ Target_ SRT SAT_ Errors_ EyeX_ EyeY_ saccLoc
end

%rename files back to what scripts want
Target_ = allTarget_;
Correct_ = allCorrect_;
SRT = allSRT;
SAT_ = allSAT_;
Errors_ = allErrors_;
EyeX_ = allEyeX_;
EyeY_ = allEyeY_;
saccLoc = allSaccLoc;
clear all*




[PeakAmp PeakVel] = getMainSequence;
getTrials_SAT

Amp.slow = PeakAmp(slow_all);
Amp.med = PeakAmp(med_all);
Amp.fast = PeakAmp(fast_all_withCleared);
Vel.slow = PeakVel(slow_all);
Vel.med = PeakVel(med_all);
Vel.fast = PeakVel(fast_all_withCleared);

Amp.slow_clean = Amp.slow;
Amp.med_clean = Amp.med;
Amp.fast_clean = Amp.fast;
Vel.slow_clean = Vel.slow;
Vel.med_clean = Vel.med;
Vel.fast_clean = Vel.fast;

%Manually remove outliers
Amp.slow_clean(find(Amp.slow < 5 | Amp.slow > 11)) = NaN;
Vel.slow_clean(find(Vel.slow < 300 | Vel.slow > 800)) = NaN;

X = [Amp.slow_clean Vel.slow_clean];
X = removeNaN(X);
Amp.slow_clean = X(:,1);
Vel.slow_clean = X(:,2);
clear X


Amp.med_clean(find(Amp.med < 5 | Amp.med > 11)) = NaN;
Vel.med_clean(find(Vel.med < 300 | Vel.med > 800)) = NaN;

X = [Amp.med_clean Vel.med_clean];
X = removeNaN(X);
Amp.med_clean = X(:,1);
Vel.med_clean = X(:,2);
clear X



Amp.fast_clean(find(Amp.fast < 5 | Amp.fast > 11)) = NaN;
Vel.fast_clean(find(Vel.fast < 300 | Vel.fast > 800)) = NaN;

X = [Amp.fast_clean Vel.fast_clean];
X = removeNaN(X);
Amp.fast_clean = X(:,1);
Vel.fast_clean = X(:,2);
clear X


figure
subplot(121)
plot(Amp.slow_clean,Vel.slow_clean,'color',[.7,.7,.7],'linestyle','o')
hold on
plot(Amp.med_clean,Vel.med_clean,'color',[.5 .5 .5],'linestyle','o')
plot(Amp.fast_clean,Vel.fast_clean,'color',[.25 .25 .25],'linestyle','o')
[elipX.slow elipY.slow] = plotEllipse(Amp.slow_clean,Vel.slow_clean);
[elipX.med elipY.med] = plotEllipse(Amp.med_clean,Vel.med_clean);
[elipX.fast elipY.fast] = plotEllipse(Amp.fast_clean,Vel.fast_clean);
plot(elipX.slow,elipY.slow,'r')
plot(elipX.med,elipY.med,'k')
plot(elipX.fast,elipY.fast,'g')
title('Outliers Removed')

subplot(122)
plot(Amp.slow,Vel.slow,'color',[.7,.7,.7],'linestyle','o')
hold on
plot(Amp.med,Vel.med,'color',[.5 .5 .5],'linestyle','o')
plot(Amp.fast,Vel.fast,'color',[.25 .25 .25],'linestyle','o')
[elipX.slow elipY.slow] = plotEllipse(Amp.slow,Vel.slow);
[elipX.med elipY.med] = plotEllipse(Amp.med,Vel.med);
[elipX.fast elipY.fast] = plotEllipse(Amp.fast,Vel.fast);
plot(elipX.slow,elipY.slow,'r')
plot(elipX.med,elipY.med,'k')
plot(elipX.fast,elipY.fast,'g')
title('Outliers Remain')
