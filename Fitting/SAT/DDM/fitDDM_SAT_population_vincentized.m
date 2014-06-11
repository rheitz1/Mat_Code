%Returns summed BIC values across a population for a given DDM model
cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
%[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
%[filename3] = textread('SAT_Beh_Med_S.txt','%s');
%[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1];


%Starting Values
% a = .16; %boundary separation
% Ter = .1; %mean non-decisional component time
% eta = .08; %standard deviation of normal drift distribution
% z = a/2; %mean starting point
% sZ = .04; %spread of starting point distribution
% st = .04; %spread of non-decisional component time distribution
% v = .2; %mean drift rate


 fx = 1;
 fr = 2;

plotFlag = 1;
truncate_IQR = 1;
truncval = 1.5;

include_med = 1;

trls.slow_correct_made_dead = [];
trls.slow_errors_made_dead = [];
trls.fast_correct_made_dead_withCleared = [];
trls.fast_errors_made_dead_withCleared = [];

if include_med
    trls.med_correct = [];
    trls.med_errors = [];
    fr = 3;
end

% individual session fits
for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
    filename{file}
    
    getTrials_SAT
    

    if truncate_IQR
        disp(['Truncating ' mat2str(truncval) ' * IQR'])
        highcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
        lowcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
        highcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
        lowcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
        
        
        %All correct trials w/ made deadlines
        slow_correct_made_dead = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_correct_made_dead_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        slow_errors_made_dead = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_errors_made_dead_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        
        %keep track of total N for calculating AIC/BIC for MLE models
        N.all = numel([slow_correct_made_dead ; slow_errors_made_dead ; fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared]);
        if include_med
            highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
            lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
            
            med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
            med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
            
            N.all = N.all + numel([med_correct ; med_errors]);
            
        end
        
    end
    
    srt = SRT ./ 1000;
    
    %keep track of all trials. in the calc_X2 script, this is really only used for counting the N's. This
    %should be changed later
    trls.slow_correct_made_dead = [trls.slow_correct_made_dead ; slow_correct_made_dead];
    trls.slow_errors_made_dead = [trls.slow_errors_made_dead ; slow_errors_made_dead];
    trls.fast_correct_made_dead_withCleared = [trls.fast_correct_made_dead_withCleared ; fast_correct_made_dead_withCleared];
    trls.fast_errors_made_dead_withCleared = [trls.fast_errors_made_dead_withCleared ; fast_errors_made_dead_withCleared];
    
    if include_med
        trls.med_correct = [trls.med_correct ; med_correct];
        trls.med_errors = [trls.med_errors ; med_errors];
    end
    

    nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100];
    ntiles.slow_correct_made_dead(file,:) = prctile(srt(slow_correct_made_dead,1),nts);
    ntiles.slow_errors_made_dead(file,:) = prctile(srt(slow_errors_made_dead,1),nts);
    
    ntiles.fast_correct_made_dead_withCleared(file,:) = prctile(srt(fast_correct_made_dead_withCleared,1),nts);
    ntiles.fast_errors_made_dead_withCleared(file,:) = prctile(srt(fast_errors_made_dead_withCleared,1),nts);
    
    if include_med
        ntiles.med_correct(file,:) = prctile(srt(med_correct,1),nts);
        ntiles.med_errors(file,:) = prctile(srt(med_errors,1),nts);
    end
    
%     clear slow_correct_made_dead slow_errors_made_dead med_correct med_errors ...
%         fast_correct_made_dead_withCleared fast_errors_made_dead_withCleared

    keep filename include_med file ntiles trls truncate_IQR truncval fr fx plotFlag

end

    %VINCENT AVERAGE
    ntiles.slow_correct_made_dead = nanmean(ntiles.slow_correct_made_dead)';
    ntiles.slow_errors_made_dead = nanmean(ntiles.slow_errors_made_dead)';
    ntiles.fast_correct_made_dead_withCleared = nanmean(ntiles.fast_correct_made_dead_withCleared)';
    ntiles.fast_errors_made_dead_withCleared = nanmean(ntiles.fast_errors_made_dead_withCleared)';
    
    if include_med
        ntiles.med_correct = nanmean(ntiles.med_correct)';
        ntiles.med_errors = nanmean(ntiles.med_errors)';
    end
    
    nl = .1 * length(trls.slow_correct_made_dead);
    nh = .2 * length(trls.slow_correct_made_dead);
    obs_freq.slow_correct_made_dead = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.slow_errors_made_dead);
    nh = .2 * length(trls.slow_errors_made_dead);
    obs_freq.slow_errors_made_dead = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.fast_correct_made_dead_withCleared);
    nh = .2 * length(trls.fast_correct_made_dead_withCleared);
    obs_freq.fast_correct_made_dead_withCleared = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.fast_errors_made_dead_withCleared);
    nh = .2 * length(trls.fast_errors_made_dead_withCleared);
    obs_freq.fast_errors_made_dead_withCleared = [nl nh nh nh nh nl];
    clear nl nh
    
    if include_med
        nl = .1 * length(trls.med_correct);
        nh = .2 * length(trls.med_correct);
        obs_freq.med_correct = [nl nh nh nh nh nl];
        clear nl nh
        
        
        nl = .1 * length(trls.med_errors);
        nh = .2 * length(trls.med_errors);
        obs_freq.med_errors = [nl nh nh nh nh nl];
        clear nl nh
    end
    
    
    
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
        [sol fitSt] = fitDDM_SAT_vincentized(MODEL_MAT(cur_mod,:),plotFlag);
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


