%calculate Fano factor across SAT databases

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%    [filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
%    [filename2 unit2] = textread('SAT_Vis_Med_Q.txt','%s %s');
%     [filename3 unit3] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
%     [filename4 unit4] = textread('SAT_VisMove_Med_Q.txt','%s %s');
   [filename5 unit5] = textread('SAT_Vis_NoMed_S.txt','%s %s');
   [filename6 unit6] = textread('SAT_Vis_Med_S.txt','%s %s');
   [filename7 unit7] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
   [filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
%     [filename9 unit9] = textread('SAT_Move_Med_Q.txt','%s %s');
%     [filename10 unit10] = textread('SAT_Move_NoMed_Q.txt','%s %s');
%     [filename11 unit11] = textread('SAT_Move_Med_S.txt','%s %s');
%     [filename12 unit12] = textread('SAT_Move_NoMed_S.txt','%s %s');
    
% [filename unit] = textread('SAT_vis_visMove_Med_NoMed_NoBaseEffect.txt','%s %s');

  filename = [filename5 ; filename6 ; filename7 ; filename8];
   unit = [unit5 ; unit6 ; unit7 ; unit8];

% filename = filename1;
% unit = unit1;

totalCell = 1;
for file = 1:length(filename)
    cd /volumes/Dump/Search_Data_SAT/
    load(filename{file},unit{file},'saccLoc')
    
    cd /volumes/Dump/Search_Data_SAT_longBase/
    
    load(filename{file},unit{file},'Correct_','Target_','EyeX_','SRT','SAT_','Errors_','RFs','newfile','TrialStart_')
    
    filename{file}
    
    sig = eval(unit{file});
    
    %Convert to counts
    sig = times2counts(sig);
    
    
    
    RF = RFs.(unit{file});
    
    antiRF = mod((RF+4),8);
    
    %Plot_Time = [-500 1000];
    
    %SDF = sSDF(sig,Target_(:,1),[Plot_Time(1) Plot_Time(2)]);
    
    
    
    %============
    % FIND TRIALS
    %============
    
    getTrials_SAT
    
    if length(slow_all) < 5 || length(fast_all_withCleared) < 5
        disp('skip')
        continue
    end
    
    %downsample trial #'s to equate (stupid way to do this)
    if length(slow_all) > length(fast_all_withCleared)
        slow_all = slow_all(randperm(length(slow_all),length(fast_all_withCleared)));
    elseif length(slow_all < length(fast_all_withCleared))
        fast_all_withCleared = fast_all_withCleared(randperm(length(fast_all_withCleared),length(slow_all)));
    end

    times_baseline = Target_(1,1)-500:Target_(1,1);
    times_vis = Target_(1,1):Target_(1,1)+500;
    
    DATA_baseline(totalCell).spikes = logical([sig(slow_all,times_baseline) sig(fast_all_withCleared,times_baseline)]);
    DATA_vis(totalCell).spikes = logical([sig(slow_all,times_vis) sig(fast_all_withCleared,times_vis)]);
    
    DATA(totalCell).spikes = logical(sig(slow_all,:));
    DATA(totalCell+1).spikes = logical(sig(fast_all_withCleared,:));
    
       
    condMat([totalCell totalCell+1]) = 1:2;
%     inTrls = find(ismember(Target_(:,2),RF));
%     outTrls = find(ismember(Target_(:,2),antiRF));
%     
%     in.slow.correct = intersect(slow_correct_made_dead,inTrls);
%     %in.med.correct = intersect(med_correct,inTrls);
%     in.fast.correct = intersect(fast_correct_made_dead_withCleared,inTrls);
%     
%     out.slow.correct = intersect(slow_correct_made_dead,outTrls);
%     %out.med.correct = intersect(med_correct,outTrls);
%     out.fast.correct = intersect(fast_correct_made_dead_withCleared,outTrls);
%     
%     in.slow.error = intersect(slow_errors_made_dead,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
%     %in.med.error = intersect(med_errors,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
%     in.fast.error = intersect(fast_errors_made_dead_withCleared,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
%     
%     out.slow.error = intersect(slow_errors_made_dead,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
%     %out.med.error = intersect(med_errors,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
%     out.fast.error = intersect(fast_errors_made_dead_withCleared,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
%     
%     
%     if length(in.slow.correct)<5 | length(in.fast.correct)<5 | length(out.slow.correct)<5 | length(out.fast.correct)<5 ...
%             | length(in.slow.error)<5 | length(in.fast.error)<5 | length(out.slow.error)<5 | length(out.fast.error)<5
%         keep filename unit file DATA totalCell condMat
%         disp('skip')
%         continue
%     end
%     
%     
%     DATA(totalCell).spikes = logical(sig(in.slow.correct,:));
%     %DATA(totalCell+1) = sig(in.med.correct,:);
%     DATA(totalCell+1).spikes = logical(sig(in.fast.correct,:));
%     
%     DATA(totalCell+2).spikes = logical(sig(out.slow.correct,:));
%     %DATA(totalCell+1) = sig(out.med.correct,:);
%     DATA(totalCell+3).spikes = logical(sig(out.fast.correct,:));
%     
%     DATA(totalCell+4).spikes = logical(sig(in.slow.error,:));
%     %DATA(totalCell+1) = sig(in.med.error,:);
%     DATA(totalCell+5).spikes = logical(sig(in.fast.error,:));
%     
%     DATA(totalCell+6).spikes = logical(sig(out.slow.error,:));
%     %DATA(totalCell+1) = sig(out.med.error,:);
%     DATA(totalCell+7).spikes = logical(sig(out.fast.error,:));
%     
%     condMat([totalCell totalCell+1 totalCell+2 totalCell+3 totalCell+4 ...
%         totalCell+5 totalCell+6 totalCell+7]) = 1:8;
%     
     %totalCell = totalCell + 8;
     %totalCell = totalCell + 2;
     %totalCell = totalCell + 1;
     
     
    keep filename unit file DATA* totalCell condMat
end
clear file totalCell

% in_slow_correct = find(condMat == 1);
% in_fast_correct = find(condMat == 2);
% out_slow_correct = find(condMat == 3);
% out_fast_correct = find(condMat == 4);
% in_slow_error = find(condMat == 5);
% in_fast_error = find(condMat == 6);
% out_slow_error = find(condMat == 7);
% out_fast_error = find(condMat == 8);

% slow_all = find(condMat == 1);
% fast_all = find(condMat == 2);

PARAMS.alignTime = 3500;
PARAMS.matchReps = 10;
PARAMS.boxWidth = 50;
PARAMS.binSpacing = 1;

plot_time_baseline = -500:10:0;
plot_time_vis = 0:10:500;

%TIMES = (plot_time_baseline) + PARAMS.alignTime;
TIMES = 51:10:900;

% 
% x = DATA(slow_all).spikes;
% y = DATA(fast_all).spikes;
% 
% if size(x,1) > size(y,1)
%     subs = randperm(size(x,1),size(y,1));
%     x = x(subs,:);
% elseif size(x,1) < size(y,1)
%     subs = randperm(size(y,1),size(x,1));
%     y = y(subs,:);
% end
%  
% %catted.spikes = [x y];
% catted.spikes = x;
% Fano = VarVsMean(catted,TIMES,PARAMS);

% x = DATA(slow_all);
% y = DATA(fast_all);
% z = [x y];

F = VarVsMean(DATA_baseline,TIMES,PARAMS);
F2 = VarVsMean(DATA_vis,TIMES,PARAMS);
%Fano.all = VarVsMean([DATA(slow_all) DATA(fast_all)],TIMES,PARAMS);

% Fano.slow_all = VarVsMean(DATA(slow_all),TIMES,PARAMS);
% Fano.fast_all = VarVsMean(DATA(fast_all),TIMES,PARAMS);

figure
plot(plot_time,Fano.slow_all.FanoFactorAll,'r',plot_time,Fano.fast_all.FanoFactorAll,'g');

figure
plot(plot_time,Fano.slow_all.FanoFactorAll,'r',plot_time,Fano.fast_all.FanoFactorAll,'g', ...
    plot_time,Fano.slow_all.FanoAll_95CIs,'--r',plot_time,Fano.fast_all.FanoAll_95CIs,'--g')
 

% Fano.in_slow_correct = VarVsMean(DATA(in_slow_correct),TIMES,PARAMS);
% Fano.in_fast_correct = VarVsMean(DATA(in_fast_correct),TIMES,PARAMS);
% Fano.in_slow_error = VarVsMean(DATA(in_slow_error),TIMES,PARAMS);
% Fano.in_fast_error = VarVsMean(DATA(in_fast_error),TIMES,PARAMS);

% figure
% plot(plot_time,Fano.in_slow_correct.FanoFactorAll,'r',plot_time,Fano.in_fast_correct.FanoFactorAll,'g')
% 
% figure
% plot(plot_time,Fano.in_slow_correct.FanoFactorAll,'r',plot_time,Fano.in_fast_correct.FanoFactorAll,'g', ...
%     plot_time,Fano.in_slow_correct.FanoAll_95CIs,'--r',plot_time,Fano.in_fast_correct.FanoAll_95CIs,'--g')
% 
