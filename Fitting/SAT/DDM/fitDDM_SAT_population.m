%Returns summed BIC values across a population for a given DDM model
cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
%[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
[filename3] = textread('SAT_Beh_Med_S.txt','%s');
%[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename3];


%Starting Values
% a = .16; %boundary separation
% Ter = .1; %mean non-decisional component time
% eta = .08; %standard deviation of normal drift distribution
% z = a/2; %mean starting point
% sZ = .04; %spread of starting point distribution
% st = .04; %spread of non-decisional component time distribution
% v = .2; %mean drift rate


fx = 1;
fr = 3;

plotFlag = 0;

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
    
    
    Models_1con = ones(nchoosek(7,1),7);
    Models_2con = ones(nchoosek(7,2),7);
    Models_3con = ones(nchoosek(7,3),7);
    Models_4con = ones(nchoosek(7,4),7);
    Models_5con = ones(nchoosek(7,5),7);
    Models_6con = ones(nchoosek(7,6),7);
    
    
    %Set constraints
    %ALL FREE (0 CONSTRAINTS)
    Models_0con(1:7) = fr;
    
    %ONE CONSTRAINT
    con = nchoosek(1:7,1);
    for m = 1:nchoosek(7,1)
        Models_1con(m,con(m)) = fr;
    end
    
    %TWO CONSTRAINTS
    con = nchoosek(1:7,2);
    for m = 1:nchoosek(7,2)
        Models_2con(m,con(m,1:2)) = fr;
    end
    
    %THREE CONSTRAINTS
    con = nchoosek(1:7,3);
    for m = 1:nchoosek(7,3)
        Models_3con(m,con(m,1:3)) = fr;
    end
    
    %FOUR CONSTRAINTS
    con = nchoosek(1:7,4);
    for m = 1:nchoosek(7,4)
        Models_4con(m,con(m,1:4)) = fr;
    end
    
    %FIVE CONSTRAINTS
    con = nchoosek(1:7,5);
    for m = 1:nchoosek(7,5)
        Models_5con(m,con(m,1:5)) = fr;
    end
    
    %SIX CONSTRAINTS
    con = nchoosek(1:7,6);
    for m = 1:nchoosek(7,6)
        Models_6con(m,con(m,1:6)) = fr;
    end
    
    %ALL FIXED
    Models_7con = ones(1,7);
    
    
    MODEL_MAT = [Models_0con ; Models_1con ; Models_2con ; Models_3con ; ...
        Models_4con ; Models_5con ; Models_6con ; Models_7con];
    
    
    for cur_mod = 1:size(MODEL_MAT,1)
        tic
        [sol fitSt] = fitDDM_SAT(MODEL_MAT(cur_mod,:),plotFlag);
        freeParams = find(MODEL_MAT(cur_mod,:) > 1);
        
        str = [];
        if ismember(freeParams,1); str = '.fix_a_'; end
        if ismember(freeParams,2); str = [str '.fix_Ter_']; end
        if ismember(freeParams,3); str = [str '.fix_eta_']; end
        if ismember(freeParams,4); str = [str '.fix_z_']; end
        if ismember(freeParams,5); str = [str '.fix_sZ_']; end
        if ismember(freeParams,6); str = [str '.fix_st_']; end
        if ismember(freeParams,7); str = [str '.fix_v_']; end
        if length(freeParams) == 7; str = '.ALL_FREE'; end
        if isempty(freeParams) str = '.ALL_FIXED'; end
        
        eval(['solution' str ' = sol;'])
        eval(['fitStat' str ' = fitSt;'])
        
        clear str
        toc
    end
    
    
    
end


if fit_individual_sessions
    % individual session fits
    for file = 1:length(filename)
        
        load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
        filename{file}
        
        Models_1con = ones(nchoosek(7,1),7);
        Models_2con = ones(nchoosek(7,2),7);
        Models_3con = ones(nchoosek(7,3),7);
        Models_4con = ones(nchoosek(7,4),7);
        Models_5con = ones(nchoosek(7,5),7);
        Models_6con = ones(nchoosek(7,6),7);
        
        
        %Set constraints
        %ALL FREE (0 CONSTRAINTS)
        Models_0con(1:7) = fr;
        
        %ONE CONSTRAINT
        con = nchoosek(1:7,1);
        for m = 1:nchoosek(7,1)
            Models_1con(m,con(m)) = fr;
        end
        
        %TWO CONSTRAINTS
        con = nchoosek(1:7,2);
        for m = 1:nchoosek(7,2)
            Models_2con(m,con(m,1:2)) = fr;
        end
        
        %THREE CONSTRAINTS
        con = nchoosek(1:7,3);
        for m = 1:nchoosek(7,3)
            Models_3con(m,con(m,1:3)) = fr;
        end
        
        %FOUR CONSTRAINTS
        con = nchoosek(1:7,4);
        for m = 1:nchoosek(7,4)
            Models_4con(m,con(m,1:4)) = fr;
        end
        
        %FIVE CONSTRAINTS
        con = nchoosek(1:7,5);
        for m = 1:nchoosek(7,5)
            Models_5con(m,con(m,1:5)) = fr;
        end
        
        %SIX CONSTRAINTS
        con = nchoosek(1:7,6);
        for m = 1:nchoosek(7,6)
            Models_6con(m,con(m,1:6)) = fr;
        end
        
        %ALL FIXED
        Models_7con = ones(1,7);
        
        
        MODEL_MAT = [Models_0con ; Models_1con ; Models_2con ; Models_3con ; ...
            Models_4con ; Models_5con ; Models_6con ; Models_7con];
        
        
        for cur_mod = 1:size(MODEL_MAT,1)
            tic
            [sol fitSt] = fitDDM_SAT(MODEL_MAT(cur_mod,:),plotFlag);
            freeParams = find(MODEL_MAT(cur_mod,:) > 1);
            
            str = [];
            if ismember(freeParams,1); str = '.fix_a_'; end
            if ismember(freeParams,2); str = [str '.fix_Ter_']; end
            if ismember(freeParams,3); str = [str '.fix_eta_']; end
            if ismember(freeParams,4); str = [str '.fix_z_']; end
            if ismember(freeParams,5); str = [str '.fix_sZ']; end
            if ismember(freeParams,6); str = [str '.fix_st']; end
            if ismember(freeParams,7); str = [str '.fix_v']; end
            if length(freeParams) == 7; str = '.ALL_FREE'; end
            if isempty(freeParams) str = '.ALL_FIXED'; end
            
            eval(['solution' str '(file,:) = sol;'])
            eval(['fitStat' str '(file,:) = fitSt;'])
            
            clear str
            toc
        end
        %for given session, what are all the BIC values (useful for comparing models)
        %         allBIC(file,:) = [BIC.fixNONE(file) BIC.fixA(file) BIC.fixb(file) BIC.fixv(file) BIC.fixT0(file) ...
        %             BIC.fixAb(file) BIC.fixAv(file) BIC.fixAT0(file) BIC.fixbv(file) BIC.fixbT0(file) BIC.fixvT0(file) ...
        %             BIC.fixAbv(file) BIC.fixAbT0(file) BIC.fixAvT0(file) BIC.fixbvT0(file) BIC.fixALL(file)];
        %
        %         %re-arrange to matrix for easier viewing
        %         allBIC2 = cell2mat(struct2cell(BIC));
        %
        %         allAIC(file,:) = [AIC.fixNONE(file) AIC.fixA(file) AIC.fixb(file) AIC.fixv(file) AIC.fixT0(file) ...
        %             AIC.fixAb(file) AIC.fixAv(file) AIC.fixAT0(file) AIC.fixbv(file) AIC.fixbT0(file) AIC.fixvT0(file) ...
        %             AIC.fixAbv(file) AIC.fixAbT0(file) AIC.fixAvT0(file) AIC.fixbvT0(file) AIC.fixALL(file)];
        %
        %         %re-arrange to matrix for easier viewing
        %         allAIC2 = cell2mat(struct2cell(AIC));
        %
        %keep filename file Model solution LL BIC all* fx fr
        keep filename file MODEL_MAT solution fitStat
    end
end
