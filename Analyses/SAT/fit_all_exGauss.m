cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
[filename3] = textread('SAT_Beh_Med_S.txt','%s');
[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
[filename5] = textread('SAT2_Beh_NoMed_D.txt','%s');
[filename6] = textread('SAT2_Beh_NoMed_E.txt','%s');
filename = [filename3 ; filename4];



for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_')
    filename{file}

    SRT(find(SRT(:,1) < 150),1) = NaN;
    getTrials_SAT
    
    %Gaussian fits
    [solution minval AIC BIC] = fitModel(SRT(slow_all,1),nanmean(SRT(slow_all,1)),nanstd(SRT(slow_all,1)),'norm');
    params.slow_gaussian(file,1:2) = solution;
    AICs.slow_gaussian(file,1) = AIC;
    BICs.slow_gaussian(file,1) = BIC;
    LL.slow_gaussian(file,1) = minval;
    disp('1')
    
    [solution minval AIC BIC] = fitModel(SRT(fast_all_withCleared,1),nanmean(SRT(fast_all_withCleared,1)),nanstd(SRT(fast_all_withCleared,1)),'norm');
    params.fast_gaussian(file,1:2) = solution;
    AICs.fast_gaussian(file,1) = AIC;
    BICs.fast_gaussian(file,1) = BIC;
    LL.fast_gaussian(file,1) = minval;
    disp('2')
    
    %Ex-Gauss fits
    [solution minval AIC BIC] = fitModel(SRT(slow_all,1),nanmean(SRT(slow_all,1)),nanstd(SRT(slow_all,1)),nanstd(SRT(slow_all,1)),'exGauss');
    params.slow_exgaussian(file,1:3) = solution;
    AICs.slow_exgaussian(file,1) = AIC;
    BICs.slow_exgaussian(file,1) = BIC;
    LL.slow_exgaussian(file,1) = minval;
    disp('3')
    
    [solution minval AIC BIC] = fitModel(SRT(fast_all_withCleared,1),nanmean(SRT(fast_all_withCleared,1)),nanstd(SRT(fast_all_withCleared,1)),nanstd(SRT(fast_all_withCleared,1)),'exGauss');
    params.fast_exgaussian(file,1:3) = solution;
    AICs.fast_exgaussian(file,1) = AIC;
    BICs.fast_exgaussian(file,1) = BIC;
    LL.fast_exgaussian(file,1) = minval;
    disp('4')
    
    file_list{file,1} = filename;
    
    keep filename file params AICs BICs LL file_list
    
end
