cd /Users/richardheitz/Desktop/Mat_Code/Analyses/Move_Onset_Vis_ROC/
 [filename unitMove unitVis] = textread('Move_Onset_Vis_ROC.txt','%s %s %s');


 
 numBins = 3;
 ROCwindow = 10;
 
for file = 1:length(filename)
    
    load(filename{file},unitMove{file},unitVis{file},'MStim_','Correct_','Target_','SRT','SAT_','Errors_','RFs','MFs','newfile','TrialStart_')
    filename{file}
    
    sigMove = eval(unitMove{file});
    sigVis = eval(unitVis{file});
    
    MF_Move = MFs.(unitMove{file});
    RF_Vis = RFs.(unitVis{file});
    
    antiMF_Move = mod((MF_Move+4),8);
    antiRF_Vis = mod((RF_Vis+4),8);
    
    
    %getTrials_SAT

    %was this a uStim session? if so, have to remember to ditch those trials
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF_Vis) & isnan(MStim_(:,1)));
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF_Vis) & isnan(MStim_(:,1)));
    
    ntiles = prctile(SRT(:,1),[33 66]);
    q1 = find(SRT(:,1) < ntiles(1));
    q2 = find(SRT(:,1) >=ntiles(1) & SRT(:,1) < ntiles(2));
    q3 = find(SRT(:,1) >=ntiles(2));
    
    q1_in = intersect(q1,in);
    q2_in = intersect(q2,in);
    q3_in = intersect(q3,in);
        
    q1_out = intersect(q1,out);
    q2_out = intersect(q2,out);
    q3_out = intersect(q3,out);
    
    SDF = sSDF(sigVis,Target_(:,1),[-100 800]);
    ROC.q1(file,:) = getROC(SDF,q1_in,q1_out,ROCwindow);
    ROC.q2(file,:) = getROC(SDF,q2_in,q2_out,ROCwindow);
    ROC.q3(file,:) = getROC(SDF,q3_in,q3_out,ROCwindow);
    
    [thresh(file,1:numBins),baseline(file,1:numBins),onset(file,1:numBins),rate(file,1:numBins),labels(file,1:numBins)] = getThresh(sigMove,MF_Move,MF_Move,1:size(sigMove,1),numBins,0);
   
    
    keep ROC* numBins thresh baseline onset rate labels file filename unit*
end