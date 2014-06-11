%calculate Fano factor across SAT databases

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%[filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
%[filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename4 unit4] = textread('SAT_Move_Med_Q.txt','%s %s');
%[filename5 unit5] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%[filename6 unit6] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename3 ; filename4 ; filename7 ; filename8];
unit = [unit3 ; unit4 ; unit7 ; unit8];

for file = 1:length(filename)
    cd /volumes/Dump/Search_Data_SAT/
    load(filename{file},unit{file},'saccLoc')
    
    cd /volumes/Dump/Search_Data_SAT_longBase/
    
    load(filename{file},unit{file},'Correct_','Target_','SRT','SAT_','Errors_','MFs','newfile','TrialStart_')
    
    filename{file}
    
    sig = eval(unit{file});
    
    RF = MFs.(unit{file});
    
    antiRF = mod((RF+4),8);
    
    Plot_Time = [-800 400];
    
    SDF = sSDF(sig,SRT(:,1)+Target_(1,1),[Plot_Time(1) Plot_Time(2)]);
    
    
    
    %============
    % FIND TRIALS
    %============
    
    getTrials_SAT
    
    inTrls = find(ismember(Target_(:,2),RF));
    outTrls = find(ismember(Target_(:,2),antiRF));
    
    in.slow.correct = intersect(slow_correct_made_dead,inTrls);
    in.med.correct = intersect(med_correct,inTrls);
    in.fast.correct = intersect(fast_correct_made_dead_withCleared,inTrls);
    
    out.slow.correct = intersect(slow_correct_made_dead,outTrls);
    out.med.correct = intersect(med_correct,outTrls);
    out.fast.correct = intersect(fast_correct_made_dead_withCleared,outTrls);
    
    in.slow.error = intersect(slow_errors_made_dead,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
    in.med.error = intersect(med_errors,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
    in.fast.error = intersect(fast_errors_made_dead_withCleared,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
    
    out.slow.error = intersect(slow_errors_made_dead,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
    out.med.error = intersect(med_errors,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
    out.fast.error = intersect(fast_errors_made_dead_withCleared,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
    
    
    %============
    % CALC FANO
    %============
    
    %calculate real_time only on the first instance because of a problem file. Don't want to remove the
    %problem file from the main file list for reproduction purposes...
    
    if file == 1
        [Fano.in.slow.correct real_time] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.slow.correct);
    else
        [Fano.in.slow.correct] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.slow.correct);
    end
    
    [Fano.in.med.correct] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.med.correct);
    [Fano.in.fast.correct] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.fast.correct);
    
    [Fano.out.slow.correct] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],out.slow.correct);
    [Fano.out.med.correct] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],out.med.correct);
    [Fano.out.fast.correct] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],out.fast.correct);
    
    [Fano.in.slow.error] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.slow.error);
    [Fano.in.med.error] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.med.error);
    [Fano.in.fast.error] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],in.fast.error);
    
    [Fano.out.slow.error] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],out.slow.error);
    [Fano.out.med.error] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],out.med.error);
    [Fano.out.fast.error] = getFano_resp(sig,50,10,[Plot_Time(1) Plot_Time(2)],out.fast.error);
    
    
    %===================
    % KEEP RECORD OF SDF
    %===================
    
    allSDF.in.slow.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.slow.correct,:));
    allSDF.in.med.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.med.correct,:));
    allSDF.in.fast.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.fast.correct,:));
    
    allSDF.out.slow.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.slow.correct,:));
    allSDF.out.med.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.med.correct,:));
    allSDF.out.fast.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.fast.correct,:));
    
    allSDF.in.slow.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.slow.error,:));
    allSDF.in.med.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.med.error,:));
    allSDF.in.fast.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.fast.error,:));
    
    allSDF.out.slow.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.slow.error,:));
    allSDF.out.med.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.med.error,:));
    allSDF.out.fast.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.fast.error,:));
    
    %===============================
    % KEEP RECORD OF ALL FANO FACTOR
    %===============================
    
    allFano.in.slow.correct(file,1:length(real_time)) = Fano.in.slow.correct;
    allFano.in.med.correct(file,1:length(real_time)) = Fano.in.med.correct;
    allFano.in.fast.correct(file,1:length(real_time)) = Fano.in.fast.correct;
    
    allFano.out.slow.correct(file,1:length(real_time)) = Fano.out.slow.correct;
    allFano.out.med.correct(file,1:length(real_time)) = Fano.out.med.correct;
    allFano.out.fast.correct(file,1:length(real_time)) = Fano.out.fast.correct;
    
    allFano.in.slow.error(file,1:length(real_time)) = Fano.in.slow.error;
    allFano.in.med.error(file,1:length(real_time)) = Fano.in.med.error;
    allFano.in.fast.error(file,1:length(real_time)) = Fano.in.fast.error;
    
    allFano.out.slow.error(file,1:length(real_time)) = Fano.out.slow.error;
    allFano.out.med.error(file,1:length(real_time)) = Fano.out.med.error;
    allFano.out.fast.error(file,1:length(real_time)) = Fano.out.fast.error;
    
    
    %==============================================================
    % KEEP RT QUANTILES FOR VINCENTIZING LATER
    % NOTE: THERE WILL BE REPEATS FOR SESSIONS WITH MULTIPLE CELLS!
    %==============================================================
    
    allVincent.in.slow.correct(file,1:11) = getCDF(SRT(in.slow.correct,1));
    allVincent.in.med.correct(file,1:11) = getCDF(SRT(in.med.correct,1));
    allVincent.in.fast.correct(file,1:11) = getCDF(SRT(in.fast.correct,1));
    
    allVincent.out.slow.correct(file,1:11) = getCDF(SRT(out.slow.correct,1));
    allVincent.out.med.correct(file,1:11) = getCDF(SRT(out.med.correct,1));
    allVincent.out.fast.correct(file,1:11) = getCDF(SRT(out.fast.correct,1));
    
    allVincent.in.slow.error(file,1:11) = getCDF(SRT(in.slow.error,1));
    allVincent.in.med.error(file,1:11) = getCDF(SRT(in.med.error,1));
    allVincent.in.fast.error(file,1:11) = getCDF(SRT(in.fast.error,1));
    
    allVincent.out.slow.error(file,1:11) = getCDF(SRT(out.slow.error,1));
    allVincent.out.med.error(file,1:11) = getCDF(SRT(out.med.error,1));
    allVincent.out.fast.error(file,1:11) = getCDF(SRT(out.fast.error,1));
    
    keep filename unit file all* real_time
end
