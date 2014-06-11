cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
%[filename3] = textread('SAT_Beh_Med_S.txt','%s');
%[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename2];

%[filename] = textread('SAT2_Beh_Med_Q.txt','%s');

%
%
% To estimate microsaccades without actually counting them, just use the variability in the velocity
% profile.  If more microsaccades, should be more variability in the velocity profile.
%
%

for file = 1:length(filename)
    
    load(filename{file},'EyeX_','EyeY_','newfile','Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_')
    filename{file}
    
    %============
    % FIND TRIALS
    %===================================================================
    if exist('SRT') == 0
        SRT = getSRT(EyeX_,EyeY_);
    end
    
    getTrials_SAT
    
    SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial
    
    smEyeX_= convn(EyeX_',SMFilter,'same')';
    % clear EyeX_
    
    smEyeY_= convn(EyeY_',SMFilter,'same')';
    % clear EyeY_
    
    Diff_XX=(diff(smEyeX_'))'; %Successive differences in X
    clear smEyeX_
    
    Diff_YY=(diff(smEyeY_'))'; %Successive differences in Y
    clear smEyeY_
    
    absXY = (Diff_XX.^2)+(Diff_YY.^2);
    
    %====================
    absXY_baseline = absXY(:,Target_(1,1)-400:Target_(1,1));
    
    RMSE = nanstd(absXY_baseline,[],2);
    
    allRMSE(file,1) = nanmean(RMSE(slow_all));
    allRMSE(file,2) = nanmean(RMSE(fast_all_withCleared));
    
    file_list{file,1} = filename;
    
    keep allRMSE filename file file_list
    
end


