%examines correlation between binomial probability of making errors given
%base rate of error commission and exent of selectivity using ROC

window = 300;
fixErrors
srt

prob = getBinomialErrors(Correct_,Errors_,window);


Spike = DSP09a;
RF = RFs.DSP09a;
antiRF = mod((RF+4),8);

in_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);


SDF = sSDF(Spike,Target_(:,1),[-100 500]);


%calculate selectivity for each point in the binomial probability
%calculation
run = 1;
for seq = 1:window:size(Errors_,1)-window
    disp([mat2str(round(run / (floor(size(Errors_,1) /window))*100)) '%'])
    in_correct = find(Correct_(seq:seq+window-1,2) == 1 & ismember(Target_(seq:seq+window-1,2),RF) & SRT(seq:seq+window-1,1) < 2000 & SRT(seq:seq+window-1,1) > 50);
    out_correct = find(Correct_(seq:seq+window-1,2) == 1 & ismember(Target_(seq:seq+window-1,2),antiRF) & SRT(seq:seq+window-1,1) < 2000 & SRT(seq:seq+window-1,1) > 50);
    in_errors = find(Errors_(seq:seq+window-1,5) == 1 & ismember(Target_(seq:seq+window-1,2),antiRF) & ismember(saccLoc,RF) & SRT(seq:seq+window-1,1) < 2000 & SRT(seq:seq+window-1,1) > 50);
    out_errors = find(Errors_(seq:seq+window-1,5) == 1 & ismember(Target_(seq:seq+window-1,2),RF) & ismember(saccLoc,RF) & SRT(seq:seq+window-1,1) < 2000 & SRT(seq:seq+window-1,1) > 50);
    
    wf.in_correct(run,1:601) = nanmean(SDF(in_correct,:));
    wf.out_correct(run,1:601) = nanmean(SDF(out_correct,:));
    wf.in_errors(run,1:601) = nanmean(SDF(
    
    ROC.correct(run,1:601) = getROC(SDF,in_correct,out_correct);
    
    run = run + 1;
    
    clear in_correct out_correct
end