%FULL DATA SET
% load('/Volumes/Dump/SAT_behavioral_data.mat')
% 
% m1_slow = find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 1);
% m1_fast = find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 3);
% m2_slow = find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 1);
% m2_fast = find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 3);
% 
% [solution_norm.slow1 minval_norm.slow1 AIC_norm.slow1 BIC_norm.slow1] = fitModel(Trial_Mat(m1_slow,4),nanmean(Trial_Mat(m1_slow,4)),nanstd(Trial_Mat(m1_slow,4)),'norm');
% [solution_exGauss.slow1 minval_exGauss.slow1 AIC_exGauss.slow1 BIC_exGauss.slow1] = fitModel(Trial_Mat(m1_slow,4),nanmean(Trial_Mat(m1_slow,4)),nanstd(Trial_Mat(m1_slow,4)),nanstd(Trial_Mat(m1_slow,4)),'exGauss');
% 
% [solution_norm.slow2 minval_norm.slow2 AIC_norm.slow2 BIC_norm.slow2] = fitModel(Trial_Mat(m2_slow,4),nanmean(Trial_Mat(m2_slow,4)),nanstd(Trial_Mat(m2_slow,4)),'norm');
% [solution_exGauss.slow2 minval_exGauss.slow2 AIC_exGauss.slow2 BIC_exGauss.slow2] = fitModel(Trial_Mat(m2_slow,4),nanmean(Trial_Mat(m2_slow,4)),nanstd(Trial_Mat(m2_slow,4)),nanstd(Trial_Mat(m1_slow,4)),'exGauss');
% 
% 



 [filename1] = textread('SAT_Beh_Med_Q.txt','%s');
 [filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
 [filename3] = textread('SAT_Beh_Med_S.txt','%s');
 [filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename2];

for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_')
    filename{file}
    
    
getTrials_SAT  
  

f = figure;
hist(SRT(slow_all,1),100)
title(mat2str(filename{file}))
pause
close(f)
    keep solution* minval* AIC* BIC* file filename
end