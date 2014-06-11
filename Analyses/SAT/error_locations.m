% Partial response error analysis
% Where to eyes tend to go to when an error occurs?
%
% RPH


cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
%[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
[filename3] = textread('SAT_Beh_Med_S.txt','%s');
[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename3 ; filename4];


for file = 1:length(filename)
    
    load(filename{file},'EyeX_','EyeY_','Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_','saccLoc')
    filename{file}
    
    getTrials_SAT
    
    file_list{file,1} = filename;
    
    
    
    
    posmat = [Target_(:,2) saccLoc];
    posmat = sort(posmat,2,'descend');
    posdiff = posmat(:,1) - posmat(:,2);
    posdiff(find(posdiff <= 4)) = mod(posdiff(find(posdiff <= 4)),8);
    posdiff(find(posdiff > 4)) = mod(-posdiff(find(posdiff > 4)),8);
    
    
    %=======
    % SLOW
    
    
    % MUST DIVIDE BY 2 TO ACCOUNT FOR THE FACT THAT POSITION 4 IS ONLY ONE LOCATION (THE OTHERS HAVE 2)
    all_posdiff.slow_errors_made_dead(file,1) = length(find(posdiff(slow_errors_made_dead) == 0)) / length(slow_errors_made_dead);
    all_posdiff.slow_errors_made_dead(file,2) = (length(find(posdiff(slow_errors_made_dead) == 1)) / length(slow_errors_made_dead)) / 2;
    all_posdiff.slow_errors_made_dead(file,3) = (length(find(posdiff(slow_errors_made_dead) == 2)) / length(slow_errors_made_dead)) / 2;
    all_posdiff.slow_errors_made_dead(file,4) = (length(find(posdiff(slow_errors_made_dead) == 3)) / length(slow_errors_made_dead)) / 2;
    all_posdiff.slow_errors_made_dead(file,5) = length(find(posdiff(slow_errors_made_dead) == 4)) / length(slow_errors_made_dead);
    
    
    all_RTs.slow_errors_made_dead(file,1) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 0)),1);
    all_RTs.slow_errors_made_dead(file,2) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 1)),1);
    all_RTs.slow_errors_made_dead(file,3) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 2)),1);
    all_RTs.slow_errors_made_dead(file,4) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 3)),1);
    all_RTs.slow_errors_made_dead(file,5) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 4)),1);
    
    
    all_acc.slow_made_dead_binSLOW(file,1) = length(slow_errors_made_dead_binSLOW) / (length(slow_errors_made_dead_binSLOW) + length(slow_correct_made_dead_binSLOW));
    all_acc.slow_made_dead_binMED(file,1) = length(slow_errors_made_dead_binMED) / (length(slow_errors_made_dead_binMED) + length(slow_correct_made_dead_binMED));
    all_acc.slow_made_dead_binFAST(file,1) = length(slow_errors_made_dead_binFAST) / (length(slow_errors_made_dead_binFAST) + length(slow_correct_made_dead_binFAST));
    
    all_acc.med_binSLOW(file,1) = length(med_errors_binSLOW) / (length(med_errors_binSLOW) + length(med_correct_binSLOW));
    all_acc.med_binMED(file,1) = length(med_errors_binMED) / (length(med_errors_binMED) + length(med_correct_binMED));
    all_acc.med_binFAST(file,1) = length(med_errors_binFAST) / (length(med_errors_binFAST) + length(med_correct_binFAST));
    
    all_acc.fast_made_dead_binSLOW(file,1) = length(fast_errors_made_dead_withCleared_binSLOW) / (length(fast_errors_made_dead_withCleared_binSLOW) + length(fast_correct_made_dead_withCleared_binSLOW));
    all_acc.fast_made_dead_binMED(file,1) = length(fast_errors_made_dead_withCleared_binMED) / (length(fast_errors_made_dead_withCleared_binMED) + length(fast_correct_made_dead_withCleared_binMED));
    all_acc.fast_made_dead_binFAST(file,1) = length(fast_errors_made_dead_withCleared_binFAST) / (length(fast_errors_made_dead_withCleared_binFAST) + length(fast_correct_made_dead_withCleared_binFAST));
    
    all_acc.fast_missed_dead_binSLOW(file,1) = length(fast_errors_missed_dead_withCleared_binSLOW) / (length(fast_errors_missed_dead_withCleared_binSLOW) + length(fast_correct_missed_dead_withCleared_binSLOW));
    all_acc.fast_missed_dead_binMED(file,1) = length(fast_errors_missed_dead_withCleared_binMED) / (length(fast_errors_missed_dead_withCleared_binMED) + length(fast_correct_missed_dead_withCleared_binMED));
    all_acc.fast_missed_dead_binFAST(file,1) = length(fast_errors_missed_dead_withCleared_binFAST) / (length(fast_errors_missed_dead_withCleared_binFAST) + length(fast_correct_missed_dead_withCleared_binFAST));
    
    all_posdiff.slow_errors_made_dead_binSLOW(file,1) = length(find(posdiff(slow_errors_made_dead_binSLOW) == 0)) / length(slow_errors_made_dead_binSLOW);
    all_posdiff.slow_errors_made_dead_binSLOW(file,2) = (length(find(posdiff(slow_errors_made_dead_binSLOW) == 1)) / length(slow_errors_made_dead_binSLOW)) / 2;
    all_posdiff.slow_errors_made_dead_binSLOW(file,3) = (length(find(posdiff(slow_errors_made_dead_binSLOW) == 2)) / length(slow_errors_made_dead_binSLOW)) / 2;
    all_posdiff.slow_errors_made_dead_binSLOW(file,4) = (length(find(posdiff(slow_errors_made_dead_binSLOW) == 3)) / length(slow_errors_made_dead_binSLOW)) / 2;
    all_posdiff.slow_errors_made_dead_binSLOW(file,5) = length(find(posdiff(slow_errors_made_dead_binSLOW) == 4)) / length(slow_errors_made_dead_binSLOW);
    
    all_posdiff.slow_errors_made_dead_binMED(file,1) = length(find(posdiff(slow_errors_made_dead_binMED) == 0)) / length(slow_errors_made_dead_binMED);
    all_posdiff.slow_errors_made_dead_binMED(file,2) = (length(find(posdiff(slow_errors_made_dead_binMED) == 1)) / length(slow_errors_made_dead_binMED)) / 2;
    all_posdiff.slow_errors_made_dead_binMED(file,3) = (length(find(posdiff(slow_errors_made_dead_binMED) == 2)) / length(slow_errors_made_dead_binMED)) / 2;
    all_posdiff.slow_errors_made_dead_binMED(file,4) = (length(find(posdiff(slow_errors_made_dead_binMED) == 3)) / length(slow_errors_made_dead_binMED)) / 2;
    all_posdiff.slow_errors_made_dead_binMED(file,5) = length(find(posdiff(slow_errors_made_dead_binMED) == 4)) / length(slow_errors_made_dead_binMED);
    
    all_posdiff.slow_errors_made_dead_binFAST(file,1) = length(find(posdiff(slow_errors_made_dead_binFAST) == 0)) / length(slow_errors_made_dead_binFAST);
    all_posdiff.slow_errors_made_dead_binFAST(file,2) = (length(find(posdiff(slow_errors_made_dead_binFAST) == 1)) / length(slow_errors_made_dead_binFAST)) / 2;
    all_posdiff.slow_errors_made_dead_binFAST(file,3) = (length(find(posdiff(slow_errors_made_dead_binFAST) == 2)) / length(slow_errors_made_dead_binFAST)) / 2;
    all_posdiff.slow_errors_made_dead_binFAST(file,4) = (length(find(posdiff(slow_errors_made_dead_binFAST) == 3)) / length(slow_errors_made_dead_binFAST)) / 2;
    all_posdiff.slow_errors_made_dead_binFAST(file,5) = length(find(posdiff(slow_errors_made_dead_binFAST) == 4)) / length(slow_errors_made_dead_binFAST);
    
    
    %============
    % NEUTRAL/MED
    all_posdiff.med_errors(file,1) = length(find(posdiff(med_errors) == 0)) / length(med_errors);
    all_posdiff.med_errors(file,2) = (length(find(posdiff(med_errors) == 1)) / length(med_errors)) / 2;
    all_posdiff.med_errors(file,3) = (length(find(posdiff(med_errors) == 2)) / length(med_errors)) / 2;
    all_posdiff.med_errors(file,4) = (length(find(posdiff(med_errors) == 3)) / length(med_errors)) / 2;
    all_posdiff.med_errors(file,5) = length(find(posdiff(med_errors) == 4)) / length(med_errors);
    
    all_RTs.med_errors(file,1) = nanmean(SRT(find(posdiff(med_errors) == 0)),1);
    all_RTs.med_errors(file,2) = nanmean(SRT(find(posdiff(med_errors) == 1)),1);
    all_RTs.med_errors(file,3) = nanmean(SRT(find(posdiff(med_errors) == 2)),1);
    all_RTs.med_errors(file,4) = nanmean(SRT(find(posdiff(med_errors) == 3)),1);
    all_RTs.med_errors(file,5) = nanmean(SRT(find(posdiff(med_errors) == 4)),1);
    
    
    all_posdiff.med_errors_binSLOW(file,1) = length(find(posdiff(med_errors_binSLOW) == 0)) / length(med_errors_binSLOW);
    all_posdiff.med_errors_binSLOW(file,2) = (length(find(posdiff(med_errors_binSLOW) == 1)) / length(med_errors_binSLOW)) / 2;
    all_posdiff.med_errors_binSLOW(file,3) = (length(find(posdiff(med_errors_binSLOW) == 2)) / length(med_errors_binSLOW)) / 2;
    all_posdiff.med_errors_binSLOW(file,4) = (length(find(posdiff(med_errors_binSLOW) == 3)) / length(med_errors_binSLOW)) / 2;
    all_posdiff.med_errors_binSLOW(file,5) = length(find(posdiff(med_errors_binSLOW) == 4)) / length(med_errors_binSLOW);
    
    all_posdiff.med_errors_binMED(file,1) = length(find(posdiff(med_errors_binMED) == 0)) / length(med_errors_binMED);
    all_posdiff.med_errors_binMED(file,2) = (length(find(posdiff(med_errors_binMED) == 1)) / length(med_errors_binMED)) / 2;
    all_posdiff.med_errors_binMED(file,3) = (length(find(posdiff(med_errors_binMED) == 2)) / length(med_errors_binMED)) / 2;
    all_posdiff.med_errors_binMED(file,4) = (length(find(posdiff(med_errors_binMED) == 3)) / length(med_errors_binMED)) / 2;
    all_posdiff.med_errors_binMED(file,5) = length(find(posdiff(med_errors_binMED) == 4)) / length(med_errors_binMED);
    
    all_posdiff.med_errors_binFAST(file,1) = length(find(posdiff(med_errors_binFAST) == 0)) / length(med_errors_binFAST);
    all_posdiff.med_errors_binFAST(file,2) = (length(find(posdiff(med_errors_binFAST) == 1)) / length(med_errors_binFAST)) / 2;
    all_posdiff.med_errors_binFAST(file,3) = (length(find(posdiff(med_errors_binFAST) == 2)) / length(med_errors_binFAST)) / 2;
    all_posdiff.med_errors_binFAST(file,4) = (length(find(posdiff(med_errors_binFAST) == 3)) / length(med_errors_binFAST)) / 2;
    all_posdiff.med_errors_binFAST(file,5) = length(find(posdiff(med_errors_binFAST) == 4)) / length(med_errors_binFAST);
    
    
    %========
    % FAST
    all_posdiff.fast_errors_made_dead_withCleared(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared) == 0)) / length(fast_errors_made_dead_withCleared);
    all_posdiff.fast_errors_made_dead_withCleared(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared) == 1)) / length(fast_errors_made_dead_withCleared)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared) == 2)) / length(fast_errors_made_dead_withCleared)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared) == 3)) / length(fast_errors_made_dead_withCleared)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared) == 4)) / length(fast_errors_made_dead_withCleared);
    
    all_RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 0)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,2) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 1)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,3) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 2)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,4) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 3)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,5) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 4)),1);
    
    
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 0)) / length(fast_errors_made_dead_withCleared_binSLOW);
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 1)) / length(fast_errors_made_dead_withCleared_binSLOW)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 2)) / length(fast_errors_made_dead_withCleared_binSLOW)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 3)) / length(fast_errors_made_dead_withCleared_binSLOW)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 4)) / length(fast_errors_made_dead_withCleared_binSLOW);
    
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 0)) / length(fast_errors_made_dead_withCleared_binMED);
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 1)) / length(fast_errors_made_dead_withCleared_binMED)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 2)) / length(fast_errors_made_dead_withCleared_binMED)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 3)) / length(fast_errors_made_dead_withCleared_binMED)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 4)) / length(fast_errors_made_dead_withCleared_binMED);
    
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 0)) / length(fast_errors_made_dead_withCleared_binFAST);
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 1)) / length(fast_errors_made_dead_withCleared_binFAST)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 2)) / length(fast_errors_made_dead_withCleared_binFAST)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 3)) / length(fast_errors_made_dead_withCleared_binFAST)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 4)) / length(fast_errors_made_dead_withCleared_binFAST);
    
    
    
    
    
    %
    %
    %     %angle of saccade trajectories
    %     if ~exist('traj')
    %         [~,~,traj] = getVec(EyeX_,EyeY_,SRT);
    %     end
    %
    %     %get difference in angles
    %     %First find the actual mean angle produced for each position on correct trials
    %     correct_ang.pos0 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 0))));
    %     correct_ang.pos1 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 1))));
    %     correct_ang.pos2 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 2))));
    %     correct_ang.pos3 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 3))));
    %     correct_ang.pos4 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 4))));
    %     correct_ang.pos5 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 5))));
    %     correct_ang.pos6 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 6))));
    %     correct_ang.pos7 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 7))));
    %
    %
    %     %normalize all error trajectories by subtracting the correct trial trajectories
    %     angs = rad2deg(traj);
    %     ang_diff = angs;
    %     ang_diff(find(saccLoc == 0)) = ang_diff(find(saccLoc == 0)) - correct_ang.pos0;
    %     ang_diff(find(saccLoc == 1)) = ang_diff(find(saccLoc == 1)) - correct_ang.pos1;
    %     ang_diff(find(saccLoc == 2)) = ang_diff(find(saccLoc == 2)) - correct_ang.pos2;
    %     ang_diff(find(saccLoc == 3)) = ang_diff(find(saccLoc == 3)) - correct_ang.pos3;
    %     ang_diff(find(saccLoc == 4)) = ang_diff(find(saccLoc == 4)) - correct_ang.pos4;
    %     ang_diff(find(saccLoc == 5)) = ang_diff(find(saccLoc == 5)) - correct_ang.pos5;
    %     ang_diff(find(saccLoc == 6)) = ang_diff(find(saccLoc == 6)) - correct_ang.pos6;
    %     ang_diff(find(saccLoc == 7)) = ang_diff(find(saccLoc == 7)) - correct_ang.pos7;
    %
    %     %alter any very large angles to negative angles
    %     ang_diff(find(abs(ang_diff) >= 300)) = -1*mod(360,ang_diff(find(abs(ang_diff) >= 300)));
    %
    %     %convert back to radians for circular stats toolbox
    %     rad_diff = deg2rad(ang_diff);
    %
    %     all_rad_diff.slow_errors_made_dead(file,1) = circ_mean(rad_diff(slow_errors_made_dead));
    %
    %
    keep filename file file_list all_posdiff all_RTs all_acc
    
end

renvar all_acc S_all_acc
renvar all_posdiff S_all_posdiff
renvar all_RTs S_all_RTs



cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
% [filename3] = textread('SAT_Beh_Med_S.txt','%s');
% [filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename2];


for file = 1:length(filename)
    
    load(filename{file},'EyeX_','EyeY_','Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_','saccLoc')
    filename{file}
    
    getTrials_SAT
    
    file_list{file,1} = filename;
    
    
    
    
    posmat = [Target_(:,2) saccLoc];
    posmat = sort(posmat,2,'descend');
    posdiff = posmat(:,1) - posmat(:,2);
    posdiff(find(posdiff <= 4)) = mod(posdiff(find(posdiff <= 4)),8);
    posdiff(find(posdiff > 4)) = mod(-posdiff(find(posdiff > 4)),8);
    
    
    %=======
    % SLOW
    all_posdiff.slow_errors_made_dead(file,1) = length(find(posdiff(slow_errors_made_dead) == 0)) / length(slow_errors_made_dead);
    all_posdiff.slow_errors_made_dead(file,2) = (length(find(posdiff(slow_errors_made_dead) == 1)) / length(slow_errors_made_dead)) / 2;
    all_posdiff.slow_errors_made_dead(file,3) = (length(find(posdiff(slow_errors_made_dead) == 2)) / length(slow_errors_made_dead)) / 2;
    all_posdiff.slow_errors_made_dead(file,4) = (length(find(posdiff(slow_errors_made_dead) == 3)) / length(slow_errors_made_dead)) / 2;
    all_posdiff.slow_errors_made_dead(file,5) = length(find(posdiff(slow_errors_made_dead) == 4)) / length(slow_errors_made_dead);
    
    all_RTs.slow_errors_made_dead(file,1) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 0)),1);
    all_RTs.slow_errors_made_dead(file,2) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 1)),1);
    all_RTs.slow_errors_made_dead(file,3) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 2)),1);
    all_RTs.slow_errors_made_dead(file,4) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 3)),1);
    all_RTs.slow_errors_made_dead(file,5) = nanmean(SRT(find(posdiff(slow_errors_made_dead) == 4)),1);
    
    
    all_acc.slow_made_dead_binSLOW(file,1) = length(slow_errors_made_dead_binSLOW) / (length(slow_errors_made_dead_binSLOW) + length(slow_correct_made_dead_binSLOW));
    all_acc.slow_made_dead_binMED(file,1) = length(slow_errors_made_dead_binMED) / (length(slow_errors_made_dead_binMED) + length(slow_correct_made_dead_binMED));
    all_acc.slow_made_dead_binFAST(file,1) = length(slow_errors_made_dead_binFAST) / (length(slow_errors_made_dead_binFAST) + length(slow_correct_made_dead_binFAST));
    
    all_acc.med_binSLOW(file,1) = length(med_errors_binSLOW) / (length(med_errors_binSLOW) + length(med_correct_binSLOW));
    all_acc.med_binMED(file,1) = length(med_errors_binMED) / (length(med_errors_binMED) + length(med_correct_binMED));
    all_acc.med_binFAST(file,1) = length(med_errors_binFAST) / (length(med_errors_binFAST) + length(med_correct_binFAST));
    
    all_acc.fast_made_dead_binSLOW(file,1) = length(fast_errors_made_dead_withCleared_binSLOW) / (length(fast_errors_made_dead_withCleared_binSLOW) + length(fast_correct_made_dead_withCleared_binSLOW));
    all_acc.fast_made_dead_binMED(file,1) = length(fast_errors_made_dead_withCleared_binMED) / (length(fast_errors_made_dead_withCleared_binMED) + length(fast_correct_made_dead_withCleared_binMED));
    all_acc.fast_made_dead_binFAST(file,1) = length(fast_errors_made_dead_withCleared_binFAST) / (length(fast_errors_made_dead_withCleared_binFAST) + length(fast_correct_made_dead_withCleared_binFAST));
    
    all_acc.fast_missed_dead_binSLOW(file,1) = length(fast_errors_missed_dead_withCleared_binSLOW) / (length(fast_errors_missed_dead_withCleared_binSLOW) + length(fast_correct_missed_dead_withCleared_binSLOW));
    all_acc.fast_missed_dead_binMED(file,1) = length(fast_errors_missed_dead_withCleared_binMED) / (length(fast_errors_missed_dead_withCleared_binMED) + length(fast_correct_missed_dead_withCleared_binMED));
    all_acc.fast_missed_dead_binFAST(file,1) = length(fast_errors_missed_dead_withCleared_binFAST) / (length(fast_errors_missed_dead_withCleared_binFAST) + length(fast_correct_missed_dead_withCleared_binFAST));
    
    all_posdiff.slow_errors_made_dead_binSLOW(file,1) = length(find(posdiff(slow_errors_made_dead_binSLOW) == 0)) / length(slow_errors_made_dead_binSLOW);
    all_posdiff.slow_errors_made_dead_binSLOW(file,2) = (length(find(posdiff(slow_errors_made_dead_binSLOW) == 1)) / length(slow_errors_made_dead_binSLOW)) / 2;
    all_posdiff.slow_errors_made_dead_binSLOW(file,3) = (length(find(posdiff(slow_errors_made_dead_binSLOW) == 2)) / length(slow_errors_made_dead_binSLOW)) / 2;
    all_posdiff.slow_errors_made_dead_binSLOW(file,4) = (length(find(posdiff(slow_errors_made_dead_binSLOW) == 3)) / length(slow_errors_made_dead_binSLOW)) / 2;
    all_posdiff.slow_errors_made_dead_binSLOW(file,5) = length(find(posdiff(slow_errors_made_dead_binSLOW) == 4)) / length(slow_errors_made_dead_binSLOW);
    
    all_posdiff.slow_errors_made_dead_binMED(file,1) = length(find(posdiff(slow_errors_made_dead_binMED) == 0)) / length(slow_errors_made_dead_binMED);
    all_posdiff.slow_errors_made_dead_binMED(file,2) = (length(find(posdiff(slow_errors_made_dead_binMED) == 1)) / length(slow_errors_made_dead_binMED)) / 2;
    all_posdiff.slow_errors_made_dead_binMED(file,3) = (length(find(posdiff(slow_errors_made_dead_binMED) == 2)) / length(slow_errors_made_dead_binMED)) / 2;
    all_posdiff.slow_errors_made_dead_binMED(file,4) = (length(find(posdiff(slow_errors_made_dead_binMED) == 3)) / length(slow_errors_made_dead_binMED)) / 2;
    all_posdiff.slow_errors_made_dead_binMED(file,5) = length(find(posdiff(slow_errors_made_dead_binMED) == 4)) / length(slow_errors_made_dead_binMED);
    
    all_posdiff.slow_errors_made_dead_binFAST(file,1) = length(find(posdiff(slow_errors_made_dead_binFAST) == 0)) / length(slow_errors_made_dead_binFAST);
    all_posdiff.slow_errors_made_dead_binFAST(file,2) = (length(find(posdiff(slow_errors_made_dead_binFAST) == 1)) / length(slow_errors_made_dead_binFAST)) / 2;
    all_posdiff.slow_errors_made_dead_binFAST(file,3) = (length(find(posdiff(slow_errors_made_dead_binFAST) == 2)) / length(slow_errors_made_dead_binFAST)) / 2;
    all_posdiff.slow_errors_made_dead_binFAST(file,4) = (length(find(posdiff(slow_errors_made_dead_binFAST) == 3)) / length(slow_errors_made_dead_binFAST)) / 2;
    all_posdiff.slow_errors_made_dead_binFAST(file,5) = length(find(posdiff(slow_errors_made_dead_binFAST) == 4)) / length(slow_errors_made_dead_binFAST);
    
    
    %============
    % NEUTRAL/MED
    all_posdiff.med_errors(file,1) = length(find(posdiff(med_errors) == 0)) / length(med_errors);
    all_posdiff.med_errors(file,2) = (length(find(posdiff(med_errors) == 1)) / length(med_errors)) / 2;
    all_posdiff.med_errors(file,3) = (length(find(posdiff(med_errors) == 2)) / length(med_errors)) / 2;
    all_posdiff.med_errors(file,4) = (length(find(posdiff(med_errors) == 3)) / length(med_errors)) / 2;
    all_posdiff.med_errors(file,5) = length(find(posdiff(med_errors) == 4)) / length(med_errors);
    
    all_RTs.med_errors(file,1) = nanmean(SRT(find(posdiff(med_errors) == 0)),1);
    all_RTs.med_errors(file,2) = nanmean(SRT(find(posdiff(med_errors) == 1)),1);
    all_RTs.med_errors(file,3) = nanmean(SRT(find(posdiff(med_errors) == 2)),1);
    all_RTs.med_errors(file,4) = nanmean(SRT(find(posdiff(med_errors) == 3)),1);
    all_RTs.med_errors(file,5) = nanmean(SRT(find(posdiff(med_errors) == 4)),1);
    
    
    
    all_posdiff.med_errors_binSLOW(file,1) = length(find(posdiff(med_errors_binSLOW) == 0)) / length(med_errors_binSLOW);
    all_posdiff.med_errors_binSLOW(file,2) = (length(find(posdiff(med_errors_binSLOW) == 1)) / length(med_errors_binSLOW)) / 2;
    all_posdiff.med_errors_binSLOW(file,3) = (length(find(posdiff(med_errors_binSLOW) == 2)) / length(med_errors_binSLOW)) / 2;
    all_posdiff.med_errors_binSLOW(file,4) = (length(find(posdiff(med_errors_binSLOW) == 3)) / length(med_errors_binSLOW)) / 2;
    all_posdiff.med_errors_binSLOW(file,5) = length(find(posdiff(med_errors_binSLOW) == 4)) / length(med_errors_binSLOW);
    
    all_posdiff.med_errors_binMED(file,1) = length(find(posdiff(med_errors_binMED) == 0)) / length(med_errors_binMED);
    all_posdiff.med_errors_binMED(file,2) = (length(find(posdiff(med_errors_binMED) == 1)) / length(med_errors_binMED)) / 2;
    all_posdiff.med_errors_binMED(file,3) = (length(find(posdiff(med_errors_binMED) == 2)) / length(med_errors_binMED)) / 2;
    all_posdiff.med_errors_binMED(file,4) = (length(find(posdiff(med_errors_binMED) == 3)) / length(med_errors_binMED)) / 2;
    all_posdiff.med_errors_binMED(file,5) = length(find(posdiff(med_errors_binMED) == 4)) / length(med_errors_binMED);
    
    all_posdiff.med_errors_binFAST(file,1) = length(find(posdiff(med_errors_binFAST) == 0)) / length(med_errors_binFAST);
    all_posdiff.med_errors_binFAST(file,2) = (length(find(posdiff(med_errors_binFAST) == 1)) / length(med_errors_binFAST)) / 2;
    all_posdiff.med_errors_binFAST(file,3) = (length(find(posdiff(med_errors_binFAST) == 2)) / length(med_errors_binFAST)) / 2;
    all_posdiff.med_errors_binFAST(file,4) = (length(find(posdiff(med_errors_binFAST) == 3)) / length(med_errors_binFAST)) / 2;
    all_posdiff.med_errors_binFAST(file,5) = length(find(posdiff(med_errors_binFAST) == 4)) / length(med_errors_binFAST);
    
    
    %========
    % FAST
    all_posdiff.fast_errors_made_dead_withCleared(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared) == 0)) / length(fast_errors_made_dead_withCleared);
    all_posdiff.fast_errors_made_dead_withCleared(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared) == 1)) / length(fast_errors_made_dead_withCleared)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared) == 2)) / length(fast_errors_made_dead_withCleared)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared) == 3)) / length(fast_errors_made_dead_withCleared)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared) == 4)) / length(fast_errors_made_dead_withCleared);
    
    all_RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 0)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,2) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 1)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,3) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 2)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,4) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 3)),1);
    all_RTs.fast_errors_made_dead_withCleared(file,5) = nanmean(SRT(find(posdiff(fast_errors_made_dead_withCleared) == 4)),1);
    
    
    
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 0)) / length(fast_errors_made_dead_withCleared_binSLOW);
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 1)) / length(fast_errors_made_dead_withCleared_binSLOW)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 2)) / length(fast_errors_made_dead_withCleared_binSLOW)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 3)) / length(fast_errors_made_dead_withCleared_binSLOW)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binSLOW(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared_binSLOW) == 4)) / length(fast_errors_made_dead_withCleared_binSLOW);
    
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 0)) / length(fast_errors_made_dead_withCleared_binMED);
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 1)) / length(fast_errors_made_dead_withCleared_binMED)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 2)) / length(fast_errors_made_dead_withCleared_binMED)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 3)) / length(fast_errors_made_dead_withCleared_binMED)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binMED(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared_binMED) == 4)) / length(fast_errors_made_dead_withCleared_binMED);
    
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,1) = length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 0)) / length(fast_errors_made_dead_withCleared_binFAST);
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,2) = (length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 1)) / length(fast_errors_made_dead_withCleared_binFAST)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,3) = (length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 2)) / length(fast_errors_made_dead_withCleared_binFAST)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,4) = (length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 3)) / length(fast_errors_made_dead_withCleared_binFAST)) / 2;
    all_posdiff.fast_errors_made_dead_withCleared_binFAST(file,5) = length(find(posdiff(fast_errors_made_dead_withCleared_binFAST) == 4)) / length(fast_errors_made_dead_withCleared_binFAST);
    
    
    
    
    
    %
    %
    %     %angle of saccade trajectories
    %     if ~exist('traj')
    %         [~,~,traj] = getVec(EyeX_,EyeY_,SRT);
    %     end
    %
    %     %get difference in angles
    %     %First find the actual mean angle produced for each position on correct trials
    %     correct_ang.pos0 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 0))));
    %     correct_ang.pos1 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 1))));
    %     correct_ang.pos2 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 2))));
    %     correct_ang.pos3 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 3))));
    %     correct_ang.pos4 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 4))));
    %     correct_ang.pos5 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 5))));
    %     correct_ang.pos6 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 6))));
    %     correct_ang.pos7 = rad2deg(circ_mean(traj(find(Correct_(:,2) == 1 & Target_(:,2) == 7))));
    %
    %
    %     %normalize all error trajectories by subtracting the correct trial trajectories
    %     angs = rad2deg(traj);
    %     ang_diff = angs;
    %     ang_diff(find(saccLoc == 0)) = ang_diff(find(saccLoc == 0)) - correct_ang.pos0;
    %     ang_diff(find(saccLoc == 1)) = ang_diff(find(saccLoc == 1)) - correct_ang.pos1;
    %     ang_diff(find(saccLoc == 2)) = ang_diff(find(saccLoc == 2)) - correct_ang.pos2;
    %     ang_diff(find(saccLoc == 3)) = ang_diff(find(saccLoc == 3)) - correct_ang.pos3;
    %     ang_diff(find(saccLoc == 4)) = ang_diff(find(saccLoc == 4)) - correct_ang.pos4;
    %     ang_diff(find(saccLoc == 5)) = ang_diff(find(saccLoc == 5)) - correct_ang.pos5;
    %     ang_diff(find(saccLoc == 6)) = ang_diff(find(saccLoc == 6)) - correct_ang.pos6;
    %     ang_diff(find(saccLoc == 7)) = ang_diff(find(saccLoc == 7)) - correct_ang.pos7;
    %
    %     %alter any very large angles to negative angles
    %     ang_diff(find(abs(ang_diff) >= 300)) = -1*mod(360,ang_diff(find(abs(ang_diff) >= 300)));
    %
    %     %convert back to radians for circular stats toolbox
    %     rad_diff = deg2rad(ang_diff);
    %
    %     all_rad_diff.slow_errors_made_dead(file,1) = circ_mean(rad_diff(slow_errors_made_dead));
    %
    %
    keep filename file file_list *all_posdiff *all_RTs *all_acc
    
end

renvar all_acc Q_all_acc
renvar all_posdiff Q_all_posdiff
renvar all_RTs Q_all_RTs



% Get SEMs for plotting
S_ACC_sems.slow_errors_made_dead = sem(S_all_posdiff.slow_errors_made_dead);
S_ACC_sems.slow_errors_made_dead_binSLOW = sem(S_all_posdiff.slow_errors_made_dead_binSLOW);
S_ACC_sems.slow_errors_made_dead_binMED = sem(S_all_posdiff.slow_errors_made_dead_binMED);
S_ACC_sems.slow_errors_made_dead_binFAST = sem(S_all_posdiff.slow_errors_made_dead_binFAST);

S_ACC_sems.med_errors = sem(S_all_posdiff.med_errors);
S_ACC_sems.med_errors_binSLOW = sem(S_all_posdiff.med_errors_binSLOW);
S_ACC_sems.med_errors_binMED = sem(S_all_posdiff.med_errors_binMED);
S_ACC_sems.med_errors_binFAST = sem(S_all_posdiff.med_errors_binFAST);

S_ACC_sems.fast_errors_made_dead_withCleared = sem(S_all_posdiff.fast_errors_made_dead_withCleared);
S_ACC_sems.fast_errors_made_dead_withCleared_binSLOW = sem(S_all_posdiff.fast_errors_made_dead_withCleared_binSLOW);
S_ACC_sems.fast_errors_made_dead_withCleared_binMED = sem(S_all_posdiff.fast_errors_made_dead_withCleared_binMED);
S_ACC_sems.fast_errors_made_dead_withCleared_binFAST = sem(S_all_posdiff.fast_errors_made_dead_withCleared_binFAST);

Q_ACC_sems.slow_errors_made_dead = sem(Q_all_posdiff.slow_errors_made_dead);
Q_ACC_sems.slow_errors_made_dead_binSLOW = sem(Q_all_posdiff.slow_errors_made_dead_binSLOW);
Q_ACC_sems.slow_errors_made_dead_binMED = sem(Q_all_posdiff.slow_errors_made_dead_binMED);
Q_ACC_sems.slow_errors_made_dead_binFAST = sem(Q_all_posdiff.slow_errors_made_dead_binFAST);

Q_ACC_sems.med_errors = sem(Q_all_posdiff.med_errors);
Q_ACC_sems.med_errors_binSLOW = sem(Q_all_posdiff.med_errors_binSLOW);
Q_ACC_sems.med_errors_binMED = sem(Q_all_posdiff.med_errors_binMED);
Q_ACC_sems.med_errors_binFAST = sem(Q_all_posdiff.med_errors_binFAST);

Q_ACC_sems.fast_errors_made_dead_withCleared = sem(Q_all_posdiff.fast_errors_made_dead_withCleared);
Q_ACC_sems.fast_errors_made_dead_withCleared_binSLOW = sem(Q_all_posdiff.fast_errors_made_dead_withCleared_binSLOW);
Q_ACC_sems.fast_errors_made_dead_withCleared_binMED = sem(Q_all_posdiff.fast_errors_made_dead_withCleared_binMED);
Q_ACC_sems.fast_errors_made_dead_withCleared_binFAST = sem(Q_all_posdiff.fast_errors_made_dead_withCleared_binFAST);




S_RTs_sems.slow_errors_made_dead = sem(S_all_RTs.slow_errors_made_dead);
S_RTs_sems.med_errors = sem(S_all_RTs.med_errors);
S_RTs_sems.fast_errors_made_dead_withCleared = sem(S_all_RTs.fast_errors_made_dead_withCleared);
 
Q_RTs_sems.slow_errors_made_dead = sem(Q_all_RTs.slow_errors_made_dead);
Q_RTs_sems.med_errors = sem(Q_all_RTs.med_errors);
Q_RTs_sems.fast_errors_made_dead_withCleared = sem(Q_all_RTs.fast_errors_made_dead_withCleared);
 




figure
subplot(221)
errorbar([nanmean(Q_all_posdiff.slow_errors_made_dead)' nanmean(S_all_posdiff.slow_errors_made_dead)' ; ...
    nanmean(Q_all_posdiff.med_errors)' nanmean(S_all_posdiff.med_errors)' ; ...
    nanmean(Q_all_posdiff.fast_errors_made_dead_withCleared)' nanmean(S_all_posdiff.fast_errors_made_dead_withCleared)'], ...
    [Q_ACC_sems.slow_errors_made_dead' S_ACC_sems.slow_errors_made_dead' ; ...
    Q_ACC_sems.med_errors' S_ACC_sems.med_errors' ; ...
    Q_ACC_sems.fast_errors_made_dead_withCleared' S_ACC_sems.fast_errors_made_dead_withCleared'])
hold on
bar([nanmean(Q_all_posdiff.slow_errors_made_dead)' nanmean(S_all_posdiff.slow_errors_made_dead)' ; ...
    nanmean(Q_all_posdiff.med_errors)' nanmean(S_all_posdiff.med_errors)' ; ...
    nanmean(Q_all_posdiff.fast_errors_made_dead_withCleared)' nanmean(S_all_posdiff.fast_errors_made_dead_withCleared)'],'barwidth',1)
set(gca,'xtick',0:16);
set(gca,'xticklabel',[0 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4]);
box off
ylim([0 .7])
xlim([0 16])
set(gca,'yaxislocation','right')

%ADD RT plot above to show that differences in error location propensities are not due to RT. 
% Have to pad with 0's to get them to line up properly
Q_RT.slow = [nanmean(Q_all_RTs.slow_errors_made_dead) NaN(1,11)];
Q_RT.med = [NaN(1,5) nanmean(Q_all_RTs.med_errors) NaN(1,5)];
Q_RT.fast = [NaN(1,10) nanmean(Q_all_RTs.fast_errors_made_dead_withCleared)];

S_RT.slow = [nanmean(S_all_RTs.slow_errors_made_dead) NaN(1,11)];
S_RT.med = [NaN(1,5) nanmean(S_all_RTs.med_errors) NaN(1,5)];
S_RT.fast = [NaN(1,10) nanmean(S_all_RTs.fast_errors_made_dead_withCleared)];

Q_RT.slow = [nanmean(Q_all_RTs.slow_errors_made_dead) NaN(1,11)];
Q_RT.med = [NaN(1,5) nanmean(Q_all_RTs.med_errors) NaN(1,5)];
Q_RT.fast = [NaN(1,10) nanmean(Q_all_RTs.fast_errors_made_dead_withCleared)];

S_RT.slow = [nanmean(S_all_RTs.slow_errors_made_dead) NaN(1,11)];
S_RT.med = [NaN(1,5) nanmean(S_all_RTs.med_errors) NaN(1,5)];
S_RT.fast = [NaN(1,10) nanmean(S_all_RTs.fast_errors_made_dead_withCleared)];


Q_RT_sem.slow = [Q_RTs_sems.slow_errors_made_dead NaN(1,11)];
Q_RT_sem.med = [NaN(1,5) Q_RTs_sems.med_errors NaN(1,5)];
Q_RT_sem.fast = [NaN(1,10) Q_RTs_sems.fast_errors_made_dead_withCleared];

S_RT_sem.slow = [S_RTs_sems.slow_errors_made_dead NaN(1,11)];
S_RT_sem.med = [NaN(1,5) S_RTs_sems.med_errors NaN(1,5)];
S_RT_sem.fast = [NaN(1,10) S_RTs_sems.fast_errors_made_dead_withCleared];

Q_RT_sem_sem.slow = [Q_RTs_sems.slow_errors_made_dead NaN(1,11)];
Q_RT_sem.med = [NaN(1,5) Q_RTs_sems.med_errors NaN(1,5)];
Q_RT_sem.fast = [NaN(1,10) Q_RTs_sems.fast_errors_made_dead_withCleared];

S_RT_sem.slow = [S_RTs_sems.slow_errors_made_dead NaN(1,11)];
S_RT_sem.med = [NaN(1,5) S_RTs_sems.med_errors NaN(1,5)];
S_RT_sem.fast = [NaN(1,10) S_RTs_sems.fast_errors_made_dead_withCleared];



subplot(223)
errorbar(Q_RT.slow,Q_RT_sem.slow,'-or','markerfacecolor','r','markersize',6)
hold on
errorbar(Q_RT.med,Q_RT_sem.med,'-ok','markerfacecolor','k','markersize',6)
errorbar(Q_RT.fast,Q_RT_sem.fast,'-og','markerfacecolor','g','markersize',6)
errorbar(S_RT.slow,S_RT_sem.slow,'-or','markersize',6)
errorbar(S_RT.med,S_RT_sem.med,'-ok','markersize',6)
errorbar(S_RT.fast,S_RT_sem.fast,'-og','markersize',6)
ylim([0 600])
box off
set(gca,'xtick',0:16);
set(gca,'xticklabel',[0 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4]);
xlim([0 16])