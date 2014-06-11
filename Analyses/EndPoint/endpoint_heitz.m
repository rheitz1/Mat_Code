%sub for various uses; iterates through all search files

cd '/volumes/Dump/Search_Data/'
%cd /Search_Data/

batch_list = dir('Q*SEARCH.mat');

for sess = 1:length(batch_list)
    sess
    
%     %one Q file enters into a continuous loop in circ_median.  Just
%     %skipping file for now.  2nd file, saccade trajectories are strange...
%     if sess == 46 | sess == 116
%         disp('Skipping')
%         continue
%     end
    
    batch_list(sess).name
    
    load(batch_list(sess).name,'Errors_','Correct_','Target_','EyeX_','EyeY_','SRT','newfile')
    
    file_list{sess,1} = batch_list(sess).name;
    
    if size(Correct_,1) < 500
        disp('too few trials.  skipping...')
        continue
    end
    
    %load('S012308001-RH_SEARCH')
    fixErrors
    
    %get Saccade Locations
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
    
    
    %CORRECT
    pos0_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos0_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos0_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos1_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos2_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos3_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos4_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos5_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 5 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 5 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 5 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos6_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos7_ss2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7_ss4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7_ss8.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    
    %ERRORS
    pos0_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 0 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos0_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 0 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos0_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 0 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos1_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 1 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 1 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 1 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos2_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 2 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 2 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 2 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos3_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 3 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 3 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 3 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos4_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 4 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 4 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 4 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos5_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 5 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 5 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 5 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos6_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 6 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 6 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 6 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos7_ss2.errors = find(Errors_(:,5) == 1 & saccLoc == 7 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7_ss4.errors = find(Errors_(:,5) == 1 & saccLoc == 7 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7_ss8.errors = find(Errors_(:,5) == 1 & saccLoc == 7 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    %if fewer than 5 trials in a condition, stats will be very biased.  Set
    %any trial list with less than 5 observation to empty
    if length(pos0_ss2.correct) < 5; pos0_ss2.correct = []; end;
    if length(pos1_ss2.correct) < 5; pos1_ss2.correct = []; end;
    if length(pos2_ss2.correct) < 5; pos2_ss2.correct = []; end;
    if length(pos3_ss2.correct) < 5; pos3_ss2.correct = []; end;
    if length(pos4_ss2.correct) < 5; pos4_ss2.correct = []; end;
    if length(pos5_ss2.correct) < 5; pos5_ss2.correct = []; end;
    if length(pos6_ss2.correct) < 5; pos6_ss2.correct = []; end;
    if length(pos7_ss2.correct) < 5; pos7_ss2.correct = []; end;
    if length(pos0_ss4.correct) < 5; pos0_ss4.correct = []; end;
    if length(pos1_ss4.correct) < 5; pos1_ss4.correct = []; end;
    if length(pos2_ss4.correct) < 5; pos2_ss4.correct = []; end;
    if length(pos3_ss4.correct) < 5; pos3_ss4.correct = []; end;
    if length(pos4_ss4.correct) < 5; pos4_ss4.correct = []; end;
    if length(pos5_ss4.correct) < 5; pos5_ss4.correct = []; end;
    if length(pos6_ss4.correct) < 5; pos6_ss4.correct = []; end;
    if length(pos7_ss4.correct) < 5; pos7_ss4.correct = []; end;
    if length(pos0_ss8.correct) < 5; pos0_ss8.correct = []; end;
    if length(pos1_ss8.correct) < 5; pos1_ss8.correct = []; end;
    if length(pos2_ss8.correct) < 5; pos2_ss8.correct = []; end;
    if length(pos3_ss8.correct) < 5; pos3_ss8.correct = []; end;
    if length(pos4_ss8.correct) < 5; pos4_ss8.correct = []; end;
    if length(pos5_ss8.correct) < 5; pos5_ss8.correct = []; end;
    if length(pos6_ss8.correct) < 5; pos6_ss8.correct = []; end;
    if length(pos7_ss8.correct) < 5; pos7_ss8.correct = []; end;
    
    if length(pos0_ss2.errors) < 5; pos0_ss2.errors = []; end;
    if length(pos1_ss2.errors) < 5; pos1_ss2.errors = []; end;
    if length(pos2_ss2.errors) < 5; pos2_ss2.errors = []; end;
    if length(pos3_ss2.errors) < 5; pos3_ss2.errors = []; end;
    if length(pos4_ss2.errors) < 5; pos4_ss2.errors = []; end;
    if length(pos5_ss2.errors) < 5; pos5_ss2.errors = []; end;
    if length(pos6_ss2.errors) < 5; pos6_ss2.errors = []; end;
    if length(pos7_ss2.errors) < 5; pos7_ss2.errors = []; end;
    if length(pos0_ss4.errors) < 5; pos0_ss4.errors = []; end;
    if length(pos1_ss4.errors) < 5; pos1_ss4.errors = []; end;
    if length(pos2_ss4.errors) < 5; pos2_ss4.errors = []; end;
    if length(pos3_ss4.errors) < 5; pos3_ss4.errors = []; end;
    if length(pos4_ss4.errors) < 5; pos4_ss4.errors = []; end;
    if length(pos5_ss4.errors) < 5; pos5_ss4.errors = []; end;
    if length(pos6_ss4.errors) < 5; pos6_ss4.errors = []; end;
    if length(pos7_ss4.errors) < 5; pos7_ss4.errors = []; end;
    if length(pos0_ss8.errors) < 5; pos0_ss8.errors = []; end;
    if length(pos1_ss8.errors) < 5; pos1_ss8.errors = []; end;
    if length(pos2_ss8.errors) < 5; pos2_ss8.errors = []; end;
    if length(pos3_ss8.errors) < 5; pos3_ss8.errors = []; end;
    if length(pos4_ss8.errors) < 5; pos4_ss8.errors = []; end;
    if length(pos5_ss8.errors) < 5; pos5_ss8.errors = []; end;
    if length(pos6_ss8.errors) < 5; pos6_ss8.errors = []; end;
    if length(pos7_ss8.errors) < 5; pos7_ss8.errors = []; end;
    
    
    %check trial lengths.  If any condition < 5 trials; skip
    %     if findMin(length(pos0_ss2),length(pos0_ss4),length(pos0_ss8), ...
    %             length(pos1_ss2),length(pos1_ss4),length(pos1_ss8), ...
    %             length(pos2_ss2),length(pos2_ss4),length(pos2_ss8), ...
    %             length(pos3_ss2),length(pos3_ss4),length(pos3_ss8), ...
    %             length(pos4_ss2),length(pos4_ss4),length(pos4_ss8), ...
    %             length(pos5_ss2),length(pos5_ss4),length(pos5_ss8), ...
    %             length(pos6_ss2),length(pos6_ss4),length(pos6_ss8), ...
    %             length(pos7_ss2),length(pos7_ss4),length(pos7_ss8)) < 5
    %         disp('At least one condition has too few trials. Skipping...')
    %         continue
    %     end
    
    %CORRECT
    [stats.ss2.correct pos.ss2.correct alpha.ss2.correct] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss2.correct, ...
        pos1_ss2.correct,pos2_ss2.correct,pos3_ss2.correct,pos4_ss2.correct, ...
        pos5_ss2.correct,pos6_ss2.correct,pos7_ss2.correct);
    
    [stats.ss4.correct pos.ss4.correct alpha.ss4.correct] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss4.correct, ...
        pos1_ss4.correct,pos2_ss4.correct,pos3_ss4.correct,pos4_ss4.correct, ...
        pos5_ss4.correct,pos6_ss4.correct,pos7_ss4.correct);
    
    [stats.ss8.correct pos.ss8.correct alpha.ss8.correct] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss8.correct, ...
        pos1_ss8.correct,pos2_ss8.correct,pos3_ss8.correct,pos4_ss8.correct, ...
        pos5_ss8.correct,pos6_ss8.correct,pos7_ss8.correct);
    
    
    %correct missing RTs from 0 to NaN
    pos.ss2.correct.RT(find(pos.ss2.correct.RT == 0)) = NaN;
    pos.ss4.correct.RT(find(pos.ss4.correct.RT == 0)) = NaN;
    pos.ss8.correct.RT(find(pos.ss8.correct.RT == 0)) = NaN;
    
    
    %store angles
    allalpha.ss2.correct(1:size(alpha.ss2.correct,1),1:8,sess) = alpha.ss2.correct;
    allalpha.ss4.correct(1:size(alpha.ss4.correct,1),1:8,sess) = alpha.ss4.correct;
    allalpha.ss8.correct(1:size(alpha.ss8.correct,1),1:8,sess) = alpha.ss8.correct;
    
    %take mean deviations across screen locations
    allpos.ss2.correct.deltaX(1:size(pos.ss2.correct.deltaX,1),1:8,sess) = pos.ss2.correct.deltaX;
    allpos.ss2.correct.deltaY(1:size(pos.ss2.correct.deltaY,1),1:8,sess) = pos.ss2.correct.deltaY;
    allpos.ss2.correct.degX(1:size(pos.ss2.correct.degX,1),1:8,sess) = pos.ss2.correct.degX;
    allpos.ss2.correct.degY(1:size(pos.ss2.correct.degY,1),1:8,sess) = pos.ss2.correct.degY;
    allRT.ss2.correct(1:size(pos.ss2.correct.RT,1),1:8,sess) = pos.ss2.correct.RT;
    
    allpos.ss4.correct.deltaX(1:size(pos.ss4.correct.deltaX,1),1:8,sess) = pos.ss4.correct.deltaX;
    allpos.ss4.correct.deltaY(1:size(pos.ss4.correct.deltaY,1),1:8,sess) = pos.ss4.correct.deltaY;
    allpos.ss4.correct.degX(1:size(pos.ss4.correct.degX,1),1:8,sess) = pos.ss4.correct.degX;
    allpos.ss4.correct.degY(1:size(pos.ss4.correct.degY,1),1:8,sess) = pos.ss4.correct.degY;
    allRT.ss4.correct(1:size(pos.ss4.correct.RT,1),1:8,sess) = pos.ss4.correct.RT;
    
    allpos.ss8.correct.deltaX(1:size(pos.ss8.correct.deltaX,1),1:8,sess) = pos.ss8.correct.deltaX;
    allpos.ss8.correct.deltaY(1:size(pos.ss8.correct.deltaY,1),1:8,sess) = pos.ss8.correct.deltaY;
    allpos.ss8.correct.degX(1:size(pos.ss8.correct.degX,1),1:8,sess) = pos.ss8.correct.degX;
    allpos.ss8.correct.degY(1:size(pos.ss8.correct.degY,1),1:8,sess) = pos.ss8.correct.degY;
    allRT.ss8.correct(1:size(pos.ss8.correct.RT,1),1:8,sess) = pos.ss8.correct.RT;
    
    
    
    %allvar.ss2(sess,1) = nanmean(stats.ss2.var);
    allstd.ss2.correct(sess,1,1:8) = stats.ss2.correct.std;
    allr.ss2.correct(sess,1,1:8) = stats.ss2.correct.r;
    
    %allvar.ss4(sess,1) = nanmean(stats.ss4.var);
    allstd.ss4.correct(sess,1,1:8) = stats.ss4.correct.std;
    allr.ss4.correct(sess,1,1:8) = stats.ss4.correct.r;
    
    %allvar.ss8(sess,1) = nanmean(stats.ss8.var);
    allstd.ss8.correct(sess,1,1:8) = stats.ss8.correct.std;
    allr.ss8.correct(sess,1,1:8) = stats.ss8.correct.r;
    
    
    
    
    
    %ERRORS
    [stats.ss2.errors pos.ss2.errors alpha.ss2.errors] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss2.errors, ...
        pos1_ss2.errors,pos2_ss2.errors,pos3_ss2.errors,pos4_ss2.errors, ...
        pos5_ss2.errors,pos6_ss2.errors,pos7_ss2.errors);
    
    [stats.ss4.errors pos.ss4.errors alpha.ss4.errors] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss4.errors, ...
        pos1_ss4.errors,pos2_ss4.errors,pos3_ss4.errors,pos4_ss4.errors, ...
        pos5_ss4.errors,pos6_ss4.errors,pos7_ss4.errors);
    
    [stats.ss8.errors pos.ss8.errors alpha.ss8.errors] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss8.errors, ...
        pos1_ss8.errors,pos2_ss8.errors,pos3_ss8.errors,pos4_ss8.errors, ...
        pos5_ss8.errors,pos6_ss8.errors,pos7_ss8.errors);
    
    
    %correct missing RTs from 0 to NaN
    pos.ss2.errors.RT(find(pos.ss2.errors.RT == 0)) = NaN;
    pos.ss4.errors.RT(find(pos.ss4.errors.RT == 0)) = NaN;
    pos.ss8.errors.RT(find(pos.ss8.errors.RT == 0)) = NaN;
    
    
    %store angles
    allalpha.ss2.errors(1:size(alpha.ss2.errors,1),1:8,sess) = alpha.ss2.errors;
    allalpha.ss4.errors(1:size(alpha.ss4.errors,1),1:8,sess) = alpha.ss4.errors;
    allalpha.ss8.errors(1:size(alpha.ss8.errors,1),1:8,sess) = alpha.ss8.errors;
    
    %take deviations across screen locations
    allpos.ss2.errors.deltaX(1:size(pos.ss2.errors.deltaX,1),1:8,sess) = pos.ss2.errors.deltaX;
    allpos.ss2.errors.deltaY(1:size(pos.ss2.errors.deltaY,1),1:8,sess) = pos.ss2.errors.deltaY;
    allpos.ss2.errors.degX(1:size(pos.ss2.errors.degX,1),1:8,sess) = pos.ss2.errors.degX;
    allpos.ss2.errors.degY(1:size(pos.ss2.errors.degY,1),1:8,sess) = pos.ss2.errors.degY;
    allRT.ss2.errors(1:size(pos.ss2.errors.RT,1),1:8,sess) = pos.ss2.errors.RT;
    
    allpos.ss4.errors.deltaX(1:size(pos.ss4.errors.deltaX,1),1:8,sess) = pos.ss4.errors.deltaX;
    allpos.ss4.errors.deltaY(1:size(pos.ss4.errors.deltaY,1),1:8,sess) = pos.ss4.errors.deltaY;
    allpos.ss4.errors.degX(1:size(pos.ss4.errors.degX,1),1:8,sess) = pos.ss4.errors.degX;
    allpos.ss4.errors.degY(1:size(pos.ss4.errors.degY,1),1:8,sess) = pos.ss4.errors.degY;
    allRT.ss4.errors(1:size(pos.ss4.errors.RT,1),1:8,sess) = pos.ss4.errors.RT;
    
    allpos.ss8.errors.deltaX(1:size(pos.ss8.errors.deltaX,1),1:8,sess) = pos.ss8.errors.deltaX;
    allpos.ss8.errors.deltaY(1:size(pos.ss8.errors.deltaY,1),1:8,sess) = pos.ss8.errors.deltaY;
    allpos.ss8.errors.degX(1:size(pos.ss8.errors.degX,1),1:8,sess) = pos.ss8.errors.degX;
    allpos.ss8.errors.degY(1:size(pos.ss8.errors.degY,1),1:8,sess) = pos.ss8.errors.degY;
    allRT.ss8.errors(1:size(pos.ss8.errors.RT,1),1:8,sess) = pos.ss8.errors.RT;
    
    
    
    %allvar.ss2(sess,1) = nanmean(stats.ss2.var);
    allstd.ss2.errors(sess,1,1:8) = stats.ss2.errors.std;
    allr.ss2.errors(sess,1,1:8) = stats.ss2.errors.r;
    
    %allvar.ss4(sess,1) = nanmean(stats.ss4.var);
    allstd.ss4.errors(sess,1,1:8) = stats.ss4.errors.std;
    allr.ss4.errors(sess,1,1:8) = stats.ss4.errors.r;
    
    %allvar.ss8(sess,1) = nanmean(stats.ss8.var);
    allstd.ss8.errors(sess,1,1:8) = stats.ss8.errors.std;
    allr.ss8.errors(sess,1,1:8) = stats.ss8.errors.r;
    
    keep batch_list file_list sess allstd allpos allalpha allRT allr
    
end

keep file_list allstd allpos allRT allr allalpha



%change all 0's to NaN because each session had different numbers of
%observations

%CORRECT
allRT.ss2.correct(find(allRT.ss2.correct == 0)) = NaN;
allRT.ss4.correct(find(allRT.ss4.correct == 0)) = NaN;
allRT.ss8.correct(find(allRT.ss8.correct == 0)) = NaN;

allalpha.ss2.correct(find(allalpha.ss2.correct == 0)) = NaN;
allalpha.ss4.correct(find(allalpha.ss4.correct == 0)) = NaN;
allalpha.ss8.correct(find(allalpha.ss8.correct == 0)) = NaN;


allpos.ss2.correct.deltaX(find(allpos.ss2.correct.deltaX == 0)) = NaN;
allpos.ss4.correct.deltaX(find(allpos.ss4.correct.deltaX == 0)) = NaN;
allpos.ss8.correct.deltaX(find(allpos.ss8.correct.deltaX == 0)) = NaN;

allpos.ss2.correct.deltaY(find(allpos.ss2.correct.deltaY == 0)) = NaN;
allpos.ss4.correct.deltaY(find(allpos.ss4.correct.deltaY == 0)) = NaN;
allpos.ss8.correct.deltaY(find(allpos.ss8.correct.deltaY == 0)) = NaN;

allpos.ss2.correct.degX(find(allpos.ss2.correct.degX == 0)) = NaN;
allpos.ss4.correct.degX(find(allpos.ss4.correct.degX == 0)) = NaN;
allpos.ss8.correct.degX(find(allpos.ss8.correct.degX == 0)) = NaN;

allpos.ss2.correct.degY(find(allpos.ss2.correct.degY == 0)) = NaN;
allpos.ss4.correct.degY(find(allpos.ss4.correct.degY == 0)) = NaN;
allpos.ss8.correct.degY(find(allpos.ss8.correct.degY == 0)) = NaN;

allstd.ss2.correct(find(allstd.ss2.correct == 0)) = NaN;
allstd.ss4.correct(find(allstd.ss4.correct == 0)) = NaN;
allstd.ss8.correct(find(allstd.ss8.correct == 0)) = NaN;

allr.ss2.correct(find(allr.ss2.correct == 0)) = NaN;
allr.ss4.correct(find(allr.ss4.correct == 0)) = NaN;
allr.ss8.correct(find(allr.ss8.correct == 0)) = NaN;



%ERRORS
allRT.ss2.errors(find(allRT.ss2.errors == 0)) = NaN;
allRT.ss4.errors(find(allRT.ss4.errors == 0)) = NaN;
allRT.ss8.errors(find(allRT.ss8.errors == 0)) = NaN;
 
allalpha.ss2.errors(find(allalpha.ss2.errors == 0)) = NaN;
allalpha.ss4.errors(find(allalpha.ss4.errors == 0)) = NaN;
allalpha.ss8.errors(find(allalpha.ss8.errors == 0)) = NaN;
 
 
allpos.ss2.errors.deltaX(find(allpos.ss2.errors.deltaX == 0)) = NaN;
allpos.ss4.errors.deltaX(find(allpos.ss4.errors.deltaX == 0)) = NaN;
allpos.ss8.errors.deltaX(find(allpos.ss8.errors.deltaX == 0)) = NaN;
 
allpos.ss2.errors.deltaY(find(allpos.ss2.errors.deltaY == 0)) = NaN;
allpos.ss4.errors.deltaY(find(allpos.ss4.errors.deltaY == 0)) = NaN;
allpos.ss8.errors.deltaY(find(allpos.ss8.errors.deltaY == 0)) = NaN;
 
allpos.ss2.errors.degX(find(allpos.ss2.errors.degX == 0)) = NaN;
allpos.ss4.errors.degX(find(allpos.ss4.errors.degX == 0)) = NaN;
allpos.ss8.errors.degX(find(allpos.ss8.errors.degX == 0)) = NaN;
 
allpos.ss2.errors.degY(find(allpos.ss2.errors.degY == 0)) = NaN;
allpos.ss4.errors.degY(find(allpos.ss4.errors.degY == 0)) = NaN;
allpos.ss8.errors.degY(find(allpos.ss8.errors.degY == 0)) = NaN;
 
allstd.ss2.errors(find(allstd.ss2.errors == 0)) = NaN;
allstd.ss4.errors(find(allstd.ss4.errors == 0)) = NaN;
allstd.ss8.errors(find(allstd.ss8.errors == 0)) = NaN;
 
allr.ss2.errors(find(allr.ss2.errors == 0)) = NaN;
allr.ss4.errors(find(allr.ss4.errors == 0)) = NaN;
allr.ss8.errors(find(allr.ss8.errors == 0)) = NaN;
