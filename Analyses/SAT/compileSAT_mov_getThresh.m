cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%      [filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
%      [filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
%    [filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%    [filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
    [filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
    [filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
      [filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
      [filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename5 ; filename6 ; filename7 ; filename8];
unit = [unit5 ; unit6 ; unit7 ; unit8];



for file = 1:length(filename)
    cd /volumes/Dump/Search_Data_SAT/
    load(filename{file},unit{file},'saccLoc')
    
    cd /volumes/Dump/Search_Data_SAT_longBase/
    
    load(filename{file},unit{file},'Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile','TrialStart_')
    
    filename{file}
    
    sig = eval(unit{file});
    
    MF = MFs.(unit{file});
    
    antiMF = mod((MF+4),8);
    
    %normalizeSDF = 1;
    
    nBins = 7;
    
    RF = MF;
    
    trunc_RT = 2000;
    plotBaselineBlocks = 0;
    separate_cleared_nocleared = 0;
    within_condition_RT_bins = 1; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
    match_variability = 0;
    plot_integrals = 0;
    basewin = [400 500]; %baseline correction window for AD channels
    
    %============
    % FIND TRIALS
    %===================================================================
    
    getTrials_SAT
    
%     SDF = sSDF(sig,Target_(:,1),[-400 800]);
%     SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[-2500 200]);
%     
%     if normalizeSDF == 1
%         SDF = normalize_SP(SDF);
%         SDF_r = normalize_SP(SDF_r);
%     end
    
    inMF = find(ismember(Target_(:,2),MF));
    outMF = find(ismember(Target_(:,2),antiMF));
    inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
    outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
    
    
    %======================
    % Movement-Aligned MF
    %==============
    % CORRECT
    %made dead only
    in.slow_correct_made_dead_MF = intersect(inMF,slow_correct_made_dead);
    in.fast_correct_made_dead_withCleared_MF = intersect(inMF,fast_correct_made_dead_withCleared);
    in.med_correct_MF = intersect(inMF,med_correct);
    
    [thresh.fast(file,:),~,~,~,labels.fast(file,:)] = getThresh(sig,RF,MF,in.fast_correct_made_dead_withCleared_MF,nBins,0);
    [thresh.slow(file,:),~,~,~,labels.slow(file,:)] = getThresh(sig,RF,MF,in.slow_correct_made_dead_MF,nBins,0);
    
    [m.fast(file,1) b.fast(file,1) r.fast(file,1)] = linreg(thresh.fast(file,:)',labels.fast(file,:)');
    [m.slow(file,1) b.slow(file,1) r.slow(file,1)] = linreg(thresh.slow(file,:)',labels.slow(file,:)');
    

    keep filename unit file thresh labels m b r nBins
    
end


%FAST vs SLOW MADE DEADLINES
fig1
plot(1:nBins,thresh.fast,'g',1:nBins,thresh.slow,'r')

fig2

sems.fast = sem(thresh.fast);
sems.slow = sem(thresh.slow);

errorbar(1:nBins,nanmean(thresh.fast),sems.fast,'g')
hold on
errorbar(1:nBins,nanmean(thresh.slow),sems.slow,'r')


[w x y z] = ttest(m.fast,m.slow)


