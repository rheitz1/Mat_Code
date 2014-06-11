cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename1 ; filename2 ; filename3 ; filename4 ; ...
    filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];


allRTs_slow = [];
allRTs_med = [];
allRTs_fast = [];

allThreshold_slow = [];
allThreshold_med = [];
allThreshold_fast = [];


for file = 1:length(filename)
    
    load(filename{file},unit{file},'Target_','SRT','SAT_','RFs','MFs','newfile')
    filename{file}
    
    sig = eval(unit{file});
    
    MF = MFs.(unit{file});
    
    antiMF = mod((MF+4),8);
    
    normalize = 1;
    
    %============
    % FIND TRIALS
    %===================================================================
    
    
    SDF_r = sSDF(sig,SRT(:,1)+500,[-400 200]);
    
    if normalize == 1
        SDF_r = normalize_SP(SDF_r);
    end
    
    
    inMF = find(ismember(Target_(:,2),MF));
    outMF = find(ismember(Target_(:,2),antiMF));
    
    
    %====================================
    %====================================
    % Keep track of infos & waveforms
    %Plot_Time_targ = Plot_Time;
    %Plot_Time_resp = -400:200;
    
    inMF_slow = intersect(inMF,find(SAT_(:,1) == 1));
    inMF_med = intersect(inMF,find(SAT_(:,1) == 2));
    inMF_fast = intersect(inMF,find(SAT_(:,1) == 3));
    
    [RTs_slow ix_slow] = sort(SRT(inMF_slow));
    [RTs_med ix_med] = sort(SRT(inMF_med));
    [RTs_fast ix_fast] = sort(SRT(inMF_fast));
    
    if isempty(RTs_med)
        RTs_med = NaN;
        ix_med = NaN;
    end
    
    indices_slow = ceil((.2:.2:.8) .* length(RTs_slow));
    indices_med = ceil((.2:.2:.8) .* length(RTs_med));
    indices_fast = ceil((.2:.2:.8) .* length(RTs_fast));
    
    bins_slow(file,1:4) = RTs_slow(indices_slow);
    bins_med(file,1:4) = RTs_med(indices_med);
    bins_fast(file,1:4) = RTs_fast(indices_fast);
    
    
    Threshold_slow = nanmean(SDF_r(inMF_slow,380:390),2);
    % Threshold_med = nanmean(SDF_r(inMF_med,380:390),2);
    Threshold_fast = nanmean(SDF_r(inMF_fast,380:390),2);
    
    %sort Thresholds based on RT
    Threshold_slow = Threshold_slow(ix_slow);
    % Threshold_med = Threshold_med(ix_med);
    Threshold_fast = Threshold_fast(ix_fast);
    
    binnedThresh_slow(file,1) = nanmean(Threshold_slow(find(RTs_slow <= bins_slow(file,1))));
    binnedThresh_slow(file,2) = nanmean(Threshold_slow(find(RTs_slow > bins_slow(file,1) & RTs_slow <= bins_slow(file,2))));
    binnedThresh_slow(file,3) = nanmean(Threshold_slow(find(RTs_slow > bins_slow(file,2) & RTs_slow <= bins_slow(file,3))));
    binnedThresh_slow(file,4) = nanmean(Threshold_slow(find(RTs_slow > bins_slow(file,3) & RTs_slow <= bins_slow(file,4))));
        
    
    binnedThresh_fast(file,1) = nanmean(Threshold_fast(find(RTs_fast <= bins_fast(file,1))));
    binnedThresh_fast(file,2) = nanmean(Threshold_fast(find(RTs_fast > bins_fast(file,1) & RTs_fast <= bins_fast(file,2))));
    binnedThresh_fast(file,3) = nanmean(Threshold_fast(find(RTs_fast > bins_fast(file,2) & RTs_fast <= bins_fast(file,3))));
    binnedThresh_fast(file,4) = nanmean(Threshold_fast(find(RTs_fast > bins_fast(file,3) & RTs_fast <= bins_fast(file,4))));
    

    
    
    allRTs_slow = [allRTs_slow ; RTs_slow];
    allRTs_med = [allRTs_med ; RTs_med];
    allRTs_fast = [allRTs_fast ; RTs_fast];
    
    meanRTs_slow(file,1) = nanmean(RTs_slow);
    meanRTs_med(file,1) = nanmean(RTs_med);
    meanRTs_fast(file,1) = nanmean(RTs_fast);
    
    allThreshold_slow = [allThreshold_slow ; Threshold_slow];
    %allThreshold_med = [allThreshold_med ; Threshold_med];
    allThreshold_fast = [allThreshold_fast ; Threshold_fast];
    
    meanThresh_slow(file,1) = nanmean(Threshold_slow);
    %meanThresh_med(file,1) = nanmean(Threshold_med);
    meanThresh_fast(file,1) = nanmean(Threshold_fast);
    
    
    keep filename unit file allRTs* allThreshold* meanThresh* meanRTs* bins_* binned*
    
end

