cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_Beh_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_Beh_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Beh_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_Beh_Med_S.txt','%s %s');

filename = [filename1 ; filename2 ; filename3 ; filename4];
unit = [unit1 ; unit2 ; unit3 ; unit4];


% For population, compile all data into one huge dataset
allTarget_ = [];
allCorrect_ = [];
allSRT = [];
allSAT_ = [];
allErrors_ = [];

for file = 1:length(filename)
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
    filename{file}
    
    allTarget_ = [allTarget_ ; Target_];
    allCorrect_ = [allCorrect_ ; Correct_];
    allSRT = [allSRT ; SRT(:,1)];
    allSAT_ = [allSAT_ ; SAT_];
    allErrors_ = [allErrors_ ; Errors_];
    
    clear Correct_ Target_ SRT SAT_ Errors_
end

%rename files back to what scripts want
Target_ = allTarget_;
Correct_ = allCorrect_;
SRT = allSRT;
SAT_ = allSAT_;
Errors_ = allErrors_;

clear all*

getTrials_SAT

simBound.slow = [430.25 776.5];
simBound.med = [153.88 412];
simBound.fast = [184 328.25];

srt.slow.correct = SRT(slow_correct_made_dead,1);
srt.slow.errors = SRT(slow_errors_made_dead,1);
srt.med.correct = SRT(med_correct,1);
srt.med.errors = SRT(med_errors,1);
srt.fast.correct = SRT(fast_correct_made_dead_withCleared,1);
srt.fast.errors = SRT(fast_errors_made_dead_withCleared,1);

srt.slow.correct(find(srt.slow.correct < simBound.slow(1) | srt.slow.correct > simBound.slow(2))) = NaN;
srt.med.correct(find(srt.med.correct < simBound.med(1) | srt.med.correct > simBound.med(2))) = NaN;
srt.fast.correct(find(srt.fast.correct < simBound.fast(1) | srt.fast.correct > simBound.fast(2))) = NaN;

srt.slow.errors(find(srt.slow.errors < simBound.slow(1) | srt.slow.errors > simBound.slow(2))) = NaN;
srt.med.errors(find(srt.med.errors < simBound.med(1) | srt.med.errors > simBound.med(2))) = NaN;
srt.fast.errors(find(srt.fast.errors < simBound.fast(1) | srt.fast.errors > simBound.fast(2))) = NaN;


% 
% 
% [bins_slow_med cdf_slow_med] = getCDF(SRT(slow_correct_match_med,1));
% [bins_med_med cdf_med_med] = getCDF(SRT(med_correct_match_med,1));
% [bins_fast_med cdf_fast_med] = getCDF(SRT(fast_correct_match_med,1));
% 
% [bins_slow cdf_slow] = getCDF(SRT(slow_correct_made_dead,1));
% [bins_med cdf_med] = getCDF(SRT(med_correct,1));
% [bins_fast cdf_fast] = getCDF(SRT(fast_correct_made_dead_withCleared,1));
% 
% figure
% plot(bins_slow_med,cdf_slow_med,'--r',bins_med_med,cdf_med_med,'--k',bins_fast_med,cdf_fast_med,'--g', ...
%     bins_slow,cdf_slow,'r',bins_med,cdf_med,'k',bins_fast,cdf_fast,'g')