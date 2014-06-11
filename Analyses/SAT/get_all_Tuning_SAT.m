cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');
% 
% 
filename = [filename5 ; filename6 ; filename7 ; filename8];
unit = [unit5 ; unit6 ; unit7 ; unit8];

for file = 1:length(filename)
    
    load(filename{file},unit{file},'Correct_','Target_','SRT','SAT_','Errors_','MFs','newfile','TrialStart_')
    filename{file}
    
    sig = eval(unit{file});
    
    MF = MFs.(unit{file});
    
    antiMF = mod((MF+4),8);
    %     [~,saccLoc] = getSRT(EyeX_,EyeY_);
    %     clear EyeX_ EyeY_
    
    normalizeSDF = 1;

    getTrials_SAT
    
    
    tun.slow = getTuning_SP_move(sig,slow_correct_made_dead,[-40 40]);
    tun.med = getTuning_SP_move(sig,med_correct,[-40 40]);
    tun.fast = getTuning_SP_move(sig,fast_correct_made_dead_withCleared,[-40 40]);
    
    tuning.slow.mean(file,:) = tun.slow.mean;
    tuning.med.mean(file,:) = tun.med.mean;
    tuning.fast.mean(file,:) = tun.fast.mean;
    
    tuning.slow.minmax(file,:) = tun.slow.minmax;
    tuning.med.minmax(file,:) = tun.med.minmax;
    tuning.fast.minmax(file,:) = tun.fast.minmax;
    
    keep filename unit file tuning
    
end

