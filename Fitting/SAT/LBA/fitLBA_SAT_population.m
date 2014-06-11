%Returns summed BIC values across a population for a given LBA model
cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
%[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
%[filename3] = textread('SAT_Beh_Med_S.txt','%s');
%[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');

[filename1] = textread('SAT2_Beh_NoMed_D.txt','%s');
%[filename2] = textread('SAT2_Beh_NoMed_E.txt','%s');
filename = [filename1 ];

% NOTE:  DO NOT DO POPULATION FITS ON MED & NOMED CONDITIONS TOGETHER; THIS IS NOT APPROPRIATE AND THE
% FITS WILL NOT BE AS GOOD

fx = 1;
fr = 2;

fit_individual_sessions = 0;
fit_population = 1;

if fit_individual_sessions && fit_population; error('Do not run both sessions and population simultaneously'); end

if fit_population
    % For population, compile all data into one huge dataset
    allTarget_ = [];
    allCorrect_ = [];
    allSRT = [];
    allSAT_ = [];
    allErrors_ = [];
    
    filenum = [];
    allFile_ = [];
    allMonk_ = [];
    
    for file = 1:length(filename)
        load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
        filename{file}
        
        filenum(1:size(Target_,1),1) = file;
        if file < 26
            monk(1:size(Target_,1),1) = 1;
        else
            monk(1:size(Target_,1),1) = 2;
        end
        
        allTarget_ = [allTarget_ ; Target_];
        allCorrect_ = [allCorrect_ ; Correct_];
        allSRT = [allSRT ; SRT(:,1)];
        allSAT_ = [allSAT_ ; SAT_];
        allErrors_ = [allErrors_ ; Errors_];
        allFile_ = [allFile_ ; filenum];
        allMonk_ = [allMonk_ ; monk];
        
        clear Correct_ Target_ SRT SAT_ Errors_ filenum monk
    end
    
    %rename files back to what scripts want
    Target_ = allTarget_;
    Correct_ = allCorrect_;
    SRT = allSRT;
    SAT_ = allSAT_;
    Errors_ = allErrors_;
    
    clear all*
    
    %MODEL 1
    %ALL FREE
    disp('Running ALL FREE')
    Model = [fr fr fr fr];
    [solution.fixNONE LL.fixNONE AIC.fixNONE BIC.fixNONE CDF] = fitLBA_SAT(Model,1); %only need to get CDF once for population
    
    
    % ONE CONSTRAINT
    %MODEL 2
    %Fix A
    disp('Running FIX A')
    Model = [fx fr fr fr];
    [solution.fixA LL.fixA AIC.fixA BIC.fixA CDF] = fitLBA_SAT(Model,0);
    G2.fixA = 2 * (LL.fixNONE - LL.fixA);
    p.fixA = 1 - chi2cdf(G2.fixA,1);
    
    %MODEL 3
    %Fix b
    disp('Running FIX b')
    Model = [fr fx fr fr];
    [solution.fixb LL.fixb AIC.fixb BIC.fixb] = fitLBA_SAT(Model,0);
    G2.fixb = 2 * (LL.fixNONE - LL.fixb);
    p.fixb = 1 - chi2cdf(G2.fixb,1);
    
    %MODEL 4
    %Fix v
    disp('Running FIX v')
    Model = [fr fr fx fr];
    [solution.fixv LL.fixv AIC.fixv BIC.fixv] = fitLBA_SAT(Model,0);
    G2.fixv = 2 * (LL.fixNONE - LL.fixv);
    p.fixv = 1 - chi2cdf(G2.fixv,1);
    
    %MODEL 5
    %Fix T0
    disp('Running FIX T0')
    Model = [fr fr fr fx];
    [solution.fixT0 LL.fixT0 AIC.fixT0 BIC.fixT0] = fitLBA_SAT(Model,0);
    G2.fixT0 = 2 * (LL.fixNONE - LL.fixT0);
    p.fixT0 = 1 - chi2cdf(G2.fixT0,1);
    
    
    % TWO CONSTRAINTS
    %MODEL 6
    %Fix A,b
    disp('Running FIX A,b')
    Model = [fx fx fr fr];
    [solution.fixAb LL.fixAb AIC.fixAb BIC.fixAb] = fitLBA_SAT(Model,0);
    G2.fixAb = 2 * (LL.fixNONE - LL.fixAb);
    p.fixAb = 1 - chi2cdf(G2.fixAb,2);
    
    %MODEL 7
    %Fix A,v
    disp('Running FIX A,v')
    Model = [fx fr fx fr];
    [solution.fixAv LL.fixAv AIC.fixAv BIC.fixAv] = fitLBA_SAT(Model,0);
    G2.fixAv = 2 * (LL.fixNONE - LL.fixAv);
    p.fixAv = 1 - chi2cdf(G2.fixAv,2);
    
    %MODEL 8
    %Fix A,T0
    disp('Running FIX A,T0')
    Model = [fx fr fr fx];
    [solution.fixAT0 LL.fixAT0 AIC.fixAT0 BIC.fixAT0] = fitLBA_SAT(Model,0);
    G2.fixAT0 = 2 * (LL.fixNONE - LL.fixAT0);
    p.fixAT0 = 1 - chi2cdf(G2.fixAT0,2);
    
    %MODEL 9
    %Fix b,v
    disp('Running FIX b,v')
    Model = [fr fx fx fr];
    [solution.fixbv LL.fixbv AIC.fixbv BIC.fixbv] = fitLBA_SAT(Model,0);
    G2.fixbv = 2 * (LL.fixNONE - LL.fixbv);
    p.fixbv = 1 - chi2cdf(G2.fixbv,2);
    
    %MODEL 10
    %Fix b,T0
    disp('Running FIX b,T0')
    Model = [fr fx fr fx];
    [solution.fixbT0 LL.fixbT0 AIC.fixbT0 BIC.fixbT0] = fitLBA_SAT(Model,0);
    G2.fixbT0 = 2 * (LL.fixNONE - LL.fixbT0);
    p.fixbT0 = 1 - chi2cdf(G2.fixbT0,2);
    
    %MODEL 11
    %Fix v,T0
    disp('Running FIX v,T0')
    Model = [fr fr fx fx];
    [solution.fixvT0 LL.fixvT0 AIC.fixvT0 BIC.fixvT0] = fitLBA_SAT(Model,0);
    G2.fixvT0 = 2 * (LL.fixNONE - LL.fixvT0);
    p.fixvT0 = 1 - chi2cdf(G2.fixvT0,2);
    
    % THREE CONSTRAINTS
    %MODEL 12
    %Fix A,b,v
    disp('Running FIX A,b,v')
    Model = [fx fx fx fr];
    [solution.fixAbv LL.fixAbv AIC.fixAbv BIC.fixAbv] = fitLBA_SAT(Model,0);
    G2.fixAbv = 2 * (LL.fixNONE - LL.fixAbv);
    p.fixAbv = 1 - chi2cdf(G2.fixAbv,3);
    
    %MODEL 13
    %Fix A,b,T0
    disp('Running FIX A,b,T0')
    Model = [fx fx fr fx];
    [solution.fixAbT0 LL.fixAbT0 AIC.fixAbT0 BIC.fixAbT0] = fitLBA_SAT(Model,0);
    G2.fixAbT0 = 2 * (LL.fixNONE - LL.fixAbT0);
    p.fixAbT0 = 1 - chi2cdf(G2.fixAbT0,3);
    
    %MODEL 14
    %Fix A,v,T0
    disp('Running FIX A,v,T0')
    Model = [fx fr fx fx];
    [solution.fixAvT0 LL.fixAvT0 AIC.fixAvT0 BIC.fixAvT0] = fitLBA_SAT(Model,0);
    G2.fixAvT0 = 2 * (LL.fixNONE - LL.fixAvT0);
    p.fixAvT0 = 1 - chi2cdf(G2.fixAvT0,3);
    
    %MODEL 15
    %Fix b,v,T0
    disp('Running FIX b,v,T0')
    Model = [fr fx fx fx];
    [solution.fixbvT0 LL.fixbvT0 AIC.fixbvT0 BIC.fixbvT0] = fitLBA_SAT(Model,0);
    G2.fixbvT0 = 2 * (LL.fixNONE - LL.fixbvT0);
    p.fixbvT0 = 1 - chi2cdf(G2.fixbvT0,3);
    
    % ALL FIXED
    %MODEL 16
    disp('Running FIX ALL')
    Model = [fx fx fx fx];
    [solution.fixALL LL.fixALL AIC.fixALL BIC.fixALL] = fitLBA_SAT(Model,0);
    G2.fixALL = 2 * (LL.fixNONE - LL.fixALL);
    p.fixALL = 1 - chi2cdf(G2.fixALL,3);
end


if fit_individual_sessions
    % individual session fits
    for file = 1:length(filename)
        
        load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
        filename{file}
        
        %MODEL 1
        %ALL FREE
        disp('Running ALL FREE')
        Model = [fr fr fr fr];
        [solution.fixNONE(file,:) LL.fixNONE(file,1) AIC.fixNONE(file,1) BIC.fixNONE(file,1) CDF] = fitLBA_SAT(Model,0);
        
        %only need to get CDFs once for current file.
        allCDF.slow.correct(:,1:2,file) = CDF.slow.correct;
        allCDF.slow.err(:,1:2,file) = CDF.slow.err;
        allCDF.med.correct(:,1:2,file) = CDF.med.correct;
        allCDF.med.err(:,1:2,file) = CDF.med.err;
        allCDF.fast.correct(:,1:2,file) = CDF.fast.correct;
        allCDF.fast.err(:,1:2,file) = CDF.fast.err;
        
        clear CDF
        
        % ONE CONSTRAINT
        %MODEL 2
        %Fix A
        disp('Running FIX A')
        Model = [fx fr fr fr];
        [solution.fixA(file,:) LL.fixA(file,1) AIC.fixA(file,1) BIC.fixA(file,1)] = fitLBA_SAT(Model,0);
        
        
        %MODEL 3
        %Fix b
        disp('Running FIX b')
        Model = [fr fx fr fr];
        [solution.fixb(file,:) LL.fixb(file,1) AIC.fixb(file,1) BIC.fixb(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 4
        %Fix v
        disp('Running FIX v')
        Model = [fr fr fx fr];
        [solution.fixv(file,:) LL.fixv(file,1) AIC.fixv(file,1) BIC.fixv(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 5
        %Fix T0
        disp('Running FIX T0')
        Model = [fr fr fr fx];
        [solution.fixT0(file,:) LL.fixT0(file,1) AIC.fixT0(file,1) BIC.fixT0(file,1)] = fitLBA_SAT(Model,0);
        
        
        % TWO CONSTRAINTS
        %MODEL 6
        %Fix A,b
        disp('Running FIX A,b')
        Model = [fx fx fr fr];
        [solution.fixAb(file,:) LL.fixAb(file,1) AIC.fixAb(file,1) BIC.fixAb(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 7
        %Fix A,v
        disp('Running FIX A,v')
        Model = [fx fr fx fr];
        [solution.fixAv(file,:) LL.fixAv(file,1) AIC.fixAv(file,1) BIC.fixAv(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 8
        %Fix A,T0
        disp('Running FIX A,T0')
        Model = [fx fr fr fx];
        [solution.fixAT0(file,:) LL.fixAT0(file,1) AIC.fixAT0(file,1) BIC.fixAT0(file,1)] = fitLBA_SAT(Model,0);
        
        
        %MODEL 9
        %Fix b,v
        disp('Running FIX b,v')
        Model = [fr fx fx fr];
        [solution.fixbv(file,:) LL.fixbv(file,1) AIC.fixbv(file,1) BIC.fixbv(file,1)] = fitLBA_SAT(Model,0);
        
        
        %MODEL 10
        %Fix b,T0
        disp('Running FIX b,T0')
        Model = [fr fx fr fx];
        [solution.fixbT0(file,:) LL.fixbT0(file,1) AIC.fixbT0(file,1) BIC.fixbT0(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 11
        %Fix v,T0
        disp('Running FIX v,T0')
        Model = [fr fr fx fx];
        [solution.fixvT0(file,:) LL.fixvT0(file,1) AIC.fixvT0(file,1) BIC.fixvT0(file,1)] = fitLBA_SAT(Model,0);
        
        
        % THREE CONSTRAINTS
        %MODEL 12
        %Fix A,b,v
        disp('Running FIX A,b,v')
        Model = [fx fx fx fr];
        [solution.fixAbv(file,:) LL.fixAbv(file,1) AIC.fixAbv(file,1) BIC.fixAbv(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 13
        %Fix A,b,T0
        disp('Running FIX A,b,T0')
        Model = [fx fx fr fx];
        [solution.fixAbT0(file,:) LL.fixAbT0(file,1) AIC.fixAbT0(file,1) BIC.fixAbT0(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 14
        %Fix A,v,T0
        disp('Running FIX A,v,T0')
        Model = [fx fr fx fx];
        [solution.fixAvT0(file,:) LL.fixAvT0(file,1) AIC.fixAvT0(file,1) BIC.fixAvT0(file,1)] = fitLBA_SAT(Model,0);
        
        %MODEL 15
        %Fix b,v,T0
        disp('Running FIX b,v,T0')
        Model = [fr fx fx fx];
        [solution.fixbvT0(file,:) LL.fixbvT0(file,1) AIC.fixbvT0(file,1) BIC.fixbvT0(file,1)] = fitLBA_SAT(Model,0);
        
        
        % ALL FIXED
        %MODEL 16
        disp('Running FIX ALL')
        Model = [fx fx fx fx];
        [solution.fixALL(file,:) LL.fixALL(file,1) AIC.fixALL(file,1) BIC.fixALL(file,1)] = fitLBA_SAT(Model,0);
        
        %for given session, what are all the BIC values (useful for comparing models)
        allBIC(file,:) = [BIC.fixNONE(file) BIC.fixA(file) BIC.fixb(file) BIC.fixv(file) BIC.fixT0(file) ...
            BIC.fixAb(file) BIC.fixAv(file) BIC.fixAT0(file) BIC.fixbv(file) BIC.fixbT0(file) BIC.fixvT0(file) ...
            BIC.fixAbv(file) BIC.fixAbT0(file) BIC.fixAvT0(file) BIC.fixbvT0(file) BIC.fixALL(file)];
        
        %re-arrange to matrix for easier viewing
        allBIC2 = cell2mat(struct2cell(BIC));
        
        allAIC(file,:) = [AIC.fixNONE(file) AIC.fixA(file) AIC.fixb(file) AIC.fixv(file) AIC.fixT0(file) ...
            AIC.fixAb(file) AIC.fixAv(file) AIC.fixAT0(file) AIC.fixbv(file) AIC.fixbT0(file) AIC.fixvT0(file) ...
            AIC.fixAbv(file) AIC.fixAbT0(file) AIC.fixAvT0(file) AIC.fixbvT0(file) AIC.fixALL(file)];
        
        %re-arrange to matrix for easier viewing
        allAIC2 = cell2mat(struct2cell(AIC));
        
        keep filename file Model solution LL BIC all* fx fr
    end
end
