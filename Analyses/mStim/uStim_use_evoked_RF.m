cd ~/desktop/Mat_Code/Analyses/mStim/
[filename] = textread('uStim_evoked_RF.txt','%s');


for file = 1:length(filename)
    load(filename{file},'Target_','MStim_','Correct_','evokedRF','evokedRF_all','SRT')
    
    RF = evokedRF;
    antiRF = mod((RF+4),8);
    
    trls.in.all = find(ismember(Target_(:,2),RF));
    trls.in.correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
    trls.out.all = find(ismember(Target_(:,2),antiRF));
    trls.out.correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
    trls.stim = find(~isnan(MStim_(:,1)));
    trls.nostim = find(isnan(MStim_(:,1)));
    
    acc.stim.in(file,1) = length(intersect(trls.in.correct,trls.stim)) / length(intersect(trls.in.all,trls.stim));
    acc.nostim.in(file,1) = length(intersect(trls.in.correct,trls.nostim)) / length(intersect(trls.in.all,trls.nostim));
    acc.stim.out(file,1) = length(intersect(trls.out.correct,trls.stim)) / length(intersect(trls.out.all,trls.stim));
    acc.nostim.out(file,1) = length(intersect(trls.out.correct,trls.nostim)) / length(intersect(trls.out.all,trls.nostim));
    
    rt.stim.in(file,1) = nanmean(SRT(intersect(trls.in.correct,trls.stim),1));
    rt.stim.out(file,1) = nanmean(SRT(intersect(trls.out.correct,trls.stim),1));
    rt.nostim.in(file,1) = nanmean(SRT(intersect(trls.in.correct,trls.nostim),1));
    rt.nostim.out(file,1) = nanmean(SRT(intersect(trls.out.correct,trls.nostim),1));
    
    keep acc rt file filename
end
    