%sub for various uses; iterates through all search files

%batch_list = dir('C:\Documents and Settings\Schall Lab\My Documents\Saccade End Point\Search Data\Seymour\*.mat');
batch_list = dir('/volumes/Dump/Search_Data/Q*SEARCH.mat');
q='''';
c=',';
qcq=[q c q];
file_path_correct = '/volumes/Dump/Search_Data/';
%file_path_correct = 'C:\Documents and Settings\Schall Lab\My Documents\Saccade End Point\Search Data\Seymour\';

totalSpikes.targ = 0;
totalSpikes.resp = 0;

for sess = 1:length(batch_list)
    sess
    
    %     %one Q file enters into a continuous loop in circ_median.  Just
    %     %skipping file for now.  2nd file, saccade trajectories are strange...
    %     if sess == 46 | sess == 116
    %         disp('Skipping')
    %         continue
    %     end
    
    batch_list(sess).name
    
    % if strcmp(batch_list(sess).name,'S110609001-BP_SEARCH') == 1
    %    continue
    %end
    
    eval(['load(',q,file_path_correct,batch_list(sess).name,qcq,'RFs',qcq,'MFs',qcq,'Errors_',qcq,'Correct_',qcq,'Target_',qcq,'EyeX_',qcq,'EyeY_',qcq,'SRT',qcq,'TrialStart_',qcq,'newfile',q,')'])
    
    %get spike channels
    ChanStruct = loadChan(batch_list(sess).name,'DSP');
    
    try
        decodeChanStruct
        clear ChanStruct
    catch
        disp('error loading channels...moving on')
        continue
    end
    
    
    
    
    file_list{sess,1} = batch_list(sess).name;
    
    if size(Correct_,1) < 500
        disp('too few trials.  skipping...')
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
    end
    
    if strcmp(batch_list(sess).name,'S110609001-BP_SEARCH.mat') == 1
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
    elseif strcmp(batch_list(sess).name,'Q051806002-JC_SEARCH.mat') == 1 % Set Size 8 Only
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'Q052106001-JC_SEARCH.mat') == 1 % Set Size 8 Only
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'Q052106002-JC_SEARCH.mat') == 1 % Set Size 8 Only
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'Q052206002-JC_SEARCH.mat') == 1 % Set Size 8 Only
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'S012508001-RH_SEARCH.mat') == 1 % Blocking
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'S012709002-RH_SEARCH.mat') == 1 % Set Size 4 Only
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'S051608001-RH_SEARCH.mat') == 1 % Less than 5 trials in several conditions
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'S110907001-RH_SEARCH.mat') == 1 % getVec won't run
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
        elseif strcmp(batch_list(sess).name,'S111207001-RH_SEARCH.mat') == 1 % getVec won't run
        keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
        continue
    end
    
    %load('S012308001-RH_SEARCH')
    fixErrors
    
    %get Saccade Locations
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
    
    
    
    %CORRECT
    pos0_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos0_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos0_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos1_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos2_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos3_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos4_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos5_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 5 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 5 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5_ss8.correct.all= find(Correct_(:,2) == 1 & Target_(:,2) == 5 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos6_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    pos7_ss2.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7_ss4.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7_ss8.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    
    
    
    %if fewer than 5 trials in a condition, stats will be very biased.  Set
    %any trial list with less than 5 observation to empty
    if length(pos0_ss2.correct.all) < 5; pos0_ss2.correct = []; end;
    if length(pos1_ss2.correct.all) < 5; pos1_ss2.correct = []; end;
    if length(pos2_ss2.correct.all) < 5; pos2_ss2.correct = []; end;
    if length(pos3_ss2.correct.all) < 5; pos3_ss2.correct = []; end;
    if length(pos4_ss2.correct.all) < 5; pos4_ss2.correct = []; end;
    if length(pos5_ss2.correct.all) < 5; pos5_ss2.correct = []; end;
    if length(pos6_ss2.correct.all) < 5; pos6_ss2.correct = []; end;
    if length(pos7_ss2.correct.all) < 5; pos7_ss2.correct = []; end;
    if length(pos0_ss4.correct.all) < 5; pos0_ss4.correct = []; end;
    if length(pos1_ss4.correct.all) < 5; pos1_ss4.correct = []; end;
    if length(pos2_ss4.correct.all) < 5; pos2_ss4.correct = []; end;
    if length(pos3_ss4.correct.all) < 5; pos3_ss4.correct = []; end;
    if length(pos4_ss4.correct.all) < 5; pos4_ss4.correct = []; end;
    if length(pos5_ss4.correct.all) < 5; pos5_ss4.correct = []; end;
    if length(pos6_ss4.correct.all) < 5; pos6_ss4.correct = []; end;
    if length(pos7_ss4.correct.all) < 5; pos7_ss4.correct = []; end;
    if length(pos0_ss8.correct.all) < 5; pos0_ss8.correct = []; end;
    if length(pos1_ss8.correct.all) < 5; pos1_ss8.correct = []; end;
    if length(pos2_ss8.correct.all) < 5; pos2_ss8.correct = []; end;
    if length(pos3_ss8.correct.all) < 5; pos3_ss8.correct = []; end;
    if length(pos4_ss8.correct.all) < 5; pos4_ss8.correct = []; end;
    if length(pos5_ss8.correct.all) < 5; pos5_ss8.correct = []; end;
    if length(pos6_ss8.correct.all) < 5; pos6_ss8.correct = []; end;
    if length(pos7_ss8.correct.all) < 5; pos7_ss8.correct = []; end;
    
    
    
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
    [stats.ss2.correct pos.ss2.correct alpha.ss2.correct] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss2.correct.all, ...
        pos1_ss2.correct.all,pos2_ss2.correct.all,pos3_ss2.correct.all,pos4_ss2.correct.all, ...
        pos5_ss2.correct.all,pos6_ss2.correct.all,pos7_ss2.correct.all);
    
    [stats.ss4.correct pos.ss4.correct alpha.ss4.correct] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss4.correct.all, ...
        pos1_ss4.correct.all,pos2_ss4.correct.all,pos3_ss4.correct.all,pos4_ss4.correct.all, ...
        pos5_ss4.correct.all,pos6_ss4.correct.all,pos7_ss4.correct.all);
    
    [stats.ss8.correct pos.ss8.correct alpha.ss8.correct] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss8.correct.all, ...
        pos1_ss8.correct.all,pos2_ss8.correct.all,pos3_ss8.correct.all,pos4_ss8.correct.all, ...
        pos5_ss8.correct.all,pos6_ss8.correct.all,pos7_ss8.correct.all);
    
    %CORRECT by individual Target Locations
    [pos.ss2.correct.loc0] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss2.correct.all);
    [pos.ss2.correct.loc1] = getVec(EyeX_,EyeY_,SRT,0,1,pos1_ss2.correct.all);
    [pos.ss2.correct.loc2] = getVec(EyeX_,EyeY_,SRT,0,1,pos2_ss2.correct.all);
    [pos.ss2.correct.loc3] = getVec(EyeX_,EyeY_,SRT,0,1,pos3_ss2.correct.all);
    [pos.ss2.correct.loc4] = getVec(EyeX_,EyeY_,SRT,0,1,pos4_ss2.correct.all);
    [pos.ss2.correct.loc5] = getVec(EyeX_,EyeY_,SRT,0,1,pos5_ss2.correct.all);
    [pos.ss2.correct.loc6] = getVec(EyeX_,EyeY_,SRT,0,1,pos6_ss2.correct.all);
    [pos.ss2.correct.loc7] = getVec(EyeX_,EyeY_,SRT,0,1,pos7_ss2.correct.all);
    
    [pos.ss4.correct.loc0] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss2.correct.all);
    [pos.ss4.correct.loc1] = getVec(EyeX_,EyeY_,SRT,0,1,pos1_ss2.correct.all);
    [pos.ss4.correct.loc2] = getVec(EyeX_,EyeY_,SRT,0,1,pos2_ss2.correct.all);
    [pos.ss4.correct.loc3] = getVec(EyeX_,EyeY_,SRT,0,1,pos3_ss2.correct.all);
    [pos.ss4.correct.loc4] = getVec(EyeX_,EyeY_,SRT,0,1,pos4_ss2.correct.all);
    [pos.ss4.correct.loc5] = getVec(EyeX_,EyeY_,SRT,0,1,pos5_ss2.correct.all);
    [pos.ss4.correct.loc6] = getVec(EyeX_,EyeY_,SRT,0,1,pos6_ss2.correct.all);
    [pos.ss4.correct.loc7] = getVec(EyeX_,EyeY_,SRT,0,1,pos7_ss2.correct.all);
    
    [pos.ss8.correct.loc0] = getVec(EyeX_,EyeY_,SRT,0,1,pos0_ss2.correct.all);
    [pos.ss8.correct.loc1] = getVec(EyeX_,EyeY_,SRT,0,1,pos1_ss2.correct.all);
    [pos.ss8.correct.loc2] = getVec(EyeX_,EyeY_,SRT,0,1,pos2_ss2.correct.all);
    [pos.ss8.correct.loc3] = getVec(EyeX_,EyeY_,SRT,0,1,pos3_ss2.correct.all);
    [pos.ss8.correct.loc4] = getVec(EyeX_,EyeY_,SRT,0,1,pos4_ss2.correct.all);
    [pos.ss8.correct.loc5] = getVec(EyeX_,EyeY_,SRT,0,1,pos5_ss2.correct.all);
    [pos.ss8.correct.loc6] = getVec(EyeX_,EyeY_,SRT,0,1,pos6_ss2.correct.all);
    [pos.ss8.correct.loc7] = getVec(EyeX_,EyeY_,SRT,0,1,pos7_ss2.correct.all);
    
    % Find Median Split
    % Position 0 SS2
    accurate_x = find(pos.ss2.correct.degX(:,1)<prctile(pos.ss2.correct.degX(:,1),75) & pos.ss2.correct.degX(:,1)>prctile(pos.ss2.correct.degX(:,1),25));
    accurate_y = find(pos.ss2.correct.degY(:,1)<prctile(pos.ss2.correct.degY(:,1),75) & pos.ss2.correct.degY(:,1)>prctile(pos.ss2.correct.degY(:,1),25));
    sloppy_x = find(pos.ss2.correct.degX(:,1)>prctile(pos.ss2.correct.degX(:,1),75) | pos.ss2.correct.degX(:,1)<prctile(pos.ss2.correct.degX(:,1),25));
    sloppy_y = find(pos.ss2.correct.degY(:,1)>prctile(pos.ss2.correct.degY(:,1),75) | pos.ss2.correct.degY(:,1)<prctile(pos.ss2.correct.degY(:,1),25));
    pos0_ss2.correct.accurate.x = pos0_ss2.correct.all(accurate_x);
    pos0_ss2.correct.accurate.y = pos0_ss2.correct.all(accurate_y);
    pos0_ss2.correct.sloppy.x = pos0_ss2.correct.all(sloppy_x);
    pos0_ss2.correct.sloppy.y = pos0_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 0 SS4
    accurate_x = find(pos.ss4.correct.degX(:,1)<prctile(pos.ss4.correct.degX(:,1),75) & pos.ss4.correct.degX(:,1)>prctile(pos.ss4.correct.degX(:,1),25));
    accurate_y = find(pos.ss4.correct.degY(:,1)<prctile(pos.ss4.correct.degY(:,1),75) & pos.ss4.correct.degY(:,1)>prctile(pos.ss4.correct.degY(:,1),25));
    sloppy_x = find(pos.ss4.correct.degX(:,1)>prctile(pos.ss4.correct.degX(:,1),75) | pos.ss4.correct.degX(:,1)<prctile(pos.ss4.correct.degX(:,1),25));
    sloppy_y = find(pos.ss4.correct.degY(:,1)>prctile(pos.ss4.correct.degY(:,1),75) | pos.ss4.correct.degY(:,1)<prctile(pos.ss4.correct.degY(:,1),25));
    pos0_ss4.correct.accurate.x = pos0_ss4.correct.all(accurate_x);
    pos0_ss4.correct.accurate.y = pos0_ss4.correct.all(accurate_y);
    pos0_ss4.correct.sloppy.x = pos0_ss4.correct.all(sloppy_x);
    pos0_ss4.correct.sloppy.y = pos0_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 0 SS8
    accurate_x = find(pos.ss8.correct.degX(:,1)<prctile(pos.ss8.correct.degX(:,1),75) & pos.ss8.correct.degX(:,1)>prctile(pos.ss8.correct.degX(:,1),25));
    accurate_y = find(pos.ss8.correct.degY(:,1)<prctile(pos.ss8.correct.degY(:,1),75) & pos.ss8.correct.degY(:,1)>prctile(pos.ss8.correct.degY(:,1),25));
    sloppy_x = find(pos.ss8.correct.degX(:,1)>prctile(pos.ss8.correct.degX(:,1),75) | pos.ss8.correct.degX(:,1)<prctile(pos.ss8.correct.degX(:,1),25));
    sloppy_y = find(pos.ss8.correct.degY(:,1)>prctile(pos.ss8.correct.degY(:,1),75) | pos.ss8.correct.degY(:,1)<prctile(pos.ss8.correct.degY(:,1),25));
    pos0_ss8.correct.accurate.x = pos0_ss8.correct.all(accurate_x);
    pos0_ss8.correct.accurate.y = pos0_ss8.correct.all(accurate_y);
    pos0_ss8.correct.sloppy.x = pos0_ss8.correct.all(sloppy_x);
    pos0_ss8.correct.sloppy.y = pos0_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    % Position 1 SS2
    accurate_x = find(pos.ss2.correct.degX(:,2)<prctile(pos.ss2.correct.degX(:,2),75) & pos.ss2.correct.degX(:,2)>prctile(pos.ss2.correct.degX(:,2),25));
    accurate_y = find(pos.ss2.correct.degY(:,2)<prctile(pos.ss2.correct.degY(:,2),75) & pos.ss2.correct.degY(:,2)>prctile(pos.ss2.correct.degY(:,2),25));
    sloppy_x = find(pos.ss2.correct.degX(:,2)>prctile(pos.ss2.correct.degX(:,2),75) | pos.ss2.correct.degX(:,2)<prctile(pos.ss2.correct.degX(:,2),25));
    sloppy_y = find(pos.ss2.correct.degY(:,2)>prctile(pos.ss2.correct.degY(:,2),75) | pos.ss2.correct.degY(:,2)<prctile(pos.ss2.correct.degY(:,2),25));
    pos1_ss2.correct.accurate.x = pos1_ss2.correct.all(accurate_x);
    pos1_ss2.correct.accurate.y = pos1_ss2.correct.all(accurate_y);
    pos1_ss2.correct.sloppy.x = pos1_ss2.correct.all(sloppy_x);
    pos1_ss2.correct.sloppy.y = pos1_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 1 SS4
    accurate_x = find(pos.ss4.correct.degX(:,2)<prctile(pos.ss4.correct.degX(:,2),75) & pos.ss4.correct.degX(:,2)>prctile(pos.ss4.correct.degX(:,2),25));
    accurate_y = find(pos.ss4.correct.degY(:,2)<prctile(pos.ss4.correct.degY(:,2),75) & pos.ss4.correct.degY(:,2)>prctile(pos.ss4.correct.degY(:,2),25));
    sloppy_x = find(pos.ss4.correct.degX(:,2)>prctile(pos.ss4.correct.degX(:,2),75) | pos.ss4.correct.degX(:,2)<prctile(pos.ss4.correct.degX(:,2),25));
    sloppy_y = find(pos.ss4.correct.degY(:,2)>prctile(pos.ss4.correct.degY(:,2),75) | pos.ss4.correct.degY(:,2)<prctile(pos.ss4.correct.degY(:,2),25));
    pos1_ss4.correct.accurate.x = pos1_ss4.correct.all(accurate_x);
    pos1_ss4.correct.accurate.y = pos1_ss4.correct.all(accurate_y);
    pos1_ss4.correct.sloppy.x = pos1_ss4.correct.all(sloppy_x);
    pos1_ss4.correct.sloppy.y = pos1_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 1 SS8
    accurate_x = find(pos.ss8.correct.degX(:,2)<prctile(pos.ss8.correct.degX(:,2),75) & pos.ss8.correct.degX(:,2)>prctile(pos.ss8.correct.degX(:,2),25));
    accurate_y = find(pos.ss8.correct.degY(:,2)<prctile(pos.ss8.correct.degY(:,2),75) & pos.ss8.correct.degY(:,2)>prctile(pos.ss8.correct.degY(:,2),25));
    sloppy_x = find(pos.ss8.correct.degX(:,2)>prctile(pos.ss8.correct.degX(:,2),75) | pos.ss8.correct.degX(:,2)<prctile(pos.ss8.correct.degX(:,2),25));
    sloppy_y = find(pos.ss8.correct.degY(:,2)>prctile(pos.ss8.correct.degY(:,2),75) | pos.ss8.correct.degY(:,2)<prctile(pos.ss8.correct.degY(:,2),25));
    pos1_ss8.correct.accurate.x = pos1_ss8.correct.all(accurate_x);
    pos1_ss8.correct.accurate.y = pos1_ss8.correct.all(accurate_y);
    pos1_ss8.correct.sloppy.x = pos1_ss8.correct.all(sloppy_x);
    pos1_ss8.correct.sloppy.y = pos1_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    % Position 2 SS2
    accurate_x = find(pos.ss2.correct.degX(:,3)<prctile(pos.ss2.correct.degX(:,3),75) & pos.ss2.correct.degX(:,3)>prctile(pos.ss2.correct.degX(:,3),25));
    accurate_y = find(pos.ss2.correct.degY(:,3)<prctile(pos.ss2.correct.degY(:,3),75) & pos.ss2.correct.degY(:,3)>prctile(pos.ss2.correct.degY(:,3),25));
    sloppy_x = find(pos.ss2.correct.degX(:,3)>prctile(pos.ss2.correct.degX(:,3),75) | pos.ss2.correct.degX(:,3)<prctile(pos.ss2.correct.degX(:,3),25));
    sloppy_y = find(pos.ss2.correct.degY(:,3)>prctile(pos.ss2.correct.degY(:,3),75) | pos.ss2.correct.degY(:,3)<prctile(pos.ss2.correct.degY(:,3),25));
    pos2_ss2.correct.accurate.x = pos2_ss2.correct.all(accurate_x);
    pos2_ss2.correct.accurate.y = pos2_ss2.correct.all(accurate_y);
    pos2_ss2.correct.sloppy.x = pos2_ss2.correct.all(sloppy_x);
    pos2_ss2.correct.sloppy.y = pos2_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 2 SS4
    accurate_x = find(pos.ss4.correct.degX(:,3)<prctile(pos.ss4.correct.degX(:,3),75) & pos.ss4.correct.degX(:,3)>prctile(pos.ss4.correct.degX(:,3),25));
    accurate_y = find(pos.ss4.correct.degY(:,3)<prctile(pos.ss4.correct.degY(:,3),75) & pos.ss4.correct.degY(:,3)>prctile(pos.ss4.correct.degY(:,3),25));
    sloppy_x = find(pos.ss4.correct.degX(:,3)>prctile(pos.ss4.correct.degX(:,3),75) | pos.ss4.correct.degX(:,3)<prctile(pos.ss4.correct.degX(:,3),25));
    sloppy_y = find(pos.ss4.correct.degY(:,3)>prctile(pos.ss4.correct.degY(:,3),75) | pos.ss4.correct.degY(:,3)<prctile(pos.ss4.correct.degY(:,3),25));
    pos2_ss4.correct.accurate.x = pos2_ss4.correct.all(accurate_x);
    pos2_ss4.correct.accurate.y = pos2_ss4.correct.all(accurate_y);
    pos2_ss4.correct.sloppy.x = pos2_ss4.correct.all(sloppy_x);
    pos2_ss4.correct.sloppy.y = pos2_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 2 SS8
    accurate_x = find(pos.ss8.correct.degX(:,3)<prctile(pos.ss8.correct.degX(:,3),75) & pos.ss8.correct.degX(:,3)>prctile(pos.ss8.correct.degX(:,3),25));
    accurate_y = find(pos.ss8.correct.degY(:,3)<prctile(pos.ss8.correct.degY(:,3),75) & pos.ss8.correct.degY(:,3)>prctile(pos.ss8.correct.degY(:,3),25));
    sloppy_x = find(pos.ss8.correct.degX(:,3)>prctile(pos.ss8.correct.degX(:,3),75) | pos.ss8.correct.degX(:,3)<prctile(pos.ss8.correct.degX(:,3),25));
    sloppy_y = find(pos.ss8.correct.degY(:,3)>prctile(pos.ss8.correct.degY(:,3),75) | pos.ss8.correct.degY(:,3)<prctile(pos.ss8.correct.degY(:,3),25));
    pos2_ss8.correct.accurate.x = pos2_ss8.correct.all(accurate_x);
    pos2_ss8.correct.accurate.y = pos2_ss8.correct.all(accurate_y);
    pos2_ss8.correct.sloppy.x = pos2_ss8.correct.all(sloppy_x);
    pos2_ss8.correct.sloppy.y = pos2_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    % Position 3 SS2
    accurate_x = find(pos.ss2.correct.degX(:,4)<prctile(pos.ss2.correct.degX(:,4),75) & pos.ss2.correct.degX(:,4)>prctile(pos.ss2.correct.degX(:,4),25));
    accurate_y = find(pos.ss2.correct.degY(:,4)<prctile(pos.ss2.correct.degY(:,4),75) & pos.ss2.correct.degY(:,4)>prctile(pos.ss2.correct.degY(:,4),25));
    sloppy_x = find(pos.ss2.correct.degX(:,4)>prctile(pos.ss2.correct.degX(:,4),75) | pos.ss2.correct.degX(:,4)<prctile(pos.ss2.correct.degX(:,4),25));
    sloppy_y = find(pos.ss2.correct.degY(:,4)>prctile(pos.ss2.correct.degY(:,4),75) | pos.ss2.correct.degY(:,4)<prctile(pos.ss2.correct.degY(:,4),25));
    pos3_ss2.correct.accurate.x = pos3_ss2.correct.all(accurate_x);
    pos3_ss2.correct.accurate.y = pos3_ss2.correct.all(accurate_y);
    pos3_ss2.correct.sloppy.x = pos3_ss2.correct.all(sloppy_x);
    pos3_ss2.correct.sloppy.y = pos3_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 3 SS4
    accurate_x = find(pos.ss4.correct.degX(:,4)<prctile(pos.ss4.correct.degX(:,4),75) & pos.ss4.correct.degX(:,4)>prctile(pos.ss4.correct.degX(:,4),25));
    accurate_y = find(pos.ss4.correct.degY(:,4)<prctile(pos.ss4.correct.degY(:,4),75) & pos.ss4.correct.degY(:,4)>prctile(pos.ss4.correct.degY(:,4),25));
    sloppy_x = find(pos.ss4.correct.degX(:,4)>prctile(pos.ss4.correct.degX(:,4),75) | pos.ss4.correct.degX(:,4)<prctile(pos.ss4.correct.degX(:,4),25));
    sloppy_y = find(pos.ss4.correct.degY(:,4)>prctile(pos.ss4.correct.degY(:,4),75) | pos.ss4.correct.degY(:,4)<prctile(pos.ss4.correct.degY(:,4),25));
    pos3_ss4.correct.accurate.x = pos3_ss4.correct.all(accurate_x);
    pos3_ss4.correct.accurate.y = pos3_ss4.correct.all(accurate_y);
    pos3_ss4.correct.sloppy.x = pos3_ss4.correct.all(sloppy_x);
    pos3_ss4.correct.sloppy.y = pos3_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 3 SS8
    accurate_x = find(pos.ss8.correct.degX(:,4)<prctile(pos.ss8.correct.degX(:,4),75) & pos.ss8.correct.degX(:,4)>prctile(pos.ss8.correct.degX(:,4),25));
    accurate_y = find(pos.ss8.correct.degY(:,4)<prctile(pos.ss8.correct.degY(:,4),75) & pos.ss8.correct.degY(:,4)>prctile(pos.ss8.correct.degY(:,4),25));
    sloppy_x = find(pos.ss8.correct.degX(:,4)>prctile(pos.ss8.correct.degX(:,4),75) | pos.ss8.correct.degX(:,4)<prctile(pos.ss8.correct.degX(:,4),25));
    sloppy_y = find(pos.ss8.correct.degY(:,4)>prctile(pos.ss8.correct.degY(:,4),75) | pos.ss8.correct.degY(:,4)<prctile(pos.ss8.correct.degY(:,4),25));
    pos3_ss8.correct.accurate.x = pos3_ss8.correct.all(accurate_x);
    pos3_ss8.correct.accurate.y = pos3_ss8.correct.all(accurate_y);
    pos3_ss8.correct.sloppy.x = pos3_ss8.correct.all(sloppy_x);
    pos3_ss8.correct.sloppy.y = pos3_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    % Position 4 SS2
    accurate_x = find(pos.ss2.correct.degX(:,5)<prctile(pos.ss2.correct.degX(:,5),75) & pos.ss2.correct.degX(:,5)>prctile(pos.ss2.correct.degX(:,5),25));
    accurate_y = find(pos.ss2.correct.degY(:,5)<prctile(pos.ss2.correct.degY(:,5),75) & pos.ss2.correct.degY(:,5)>prctile(pos.ss2.correct.degY(:,5),25));
    sloppy_x = find(pos.ss2.correct.degX(:,5)>prctile(pos.ss2.correct.degX(:,5),75) | pos.ss2.correct.degX(:,5)<prctile(pos.ss2.correct.degX(:,5),25));
    sloppy_y = find(pos.ss2.correct.degY(:,5)>prctile(pos.ss2.correct.degY(:,5),75) | pos.ss2.correct.degY(:,5)<prctile(pos.ss2.correct.degY(:,5),25));
    pos4_ss2.correct.accurate.x = pos4_ss2.correct.all(accurate_x);
    pos4_ss2.correct.accurate.y = pos4_ss2.correct.all(accurate_y);
    pos4_ss2.correct.sloppy.x = pos4_ss2.correct.all(sloppy_x);
    pos4_ss2.correct.sloppy.y = pos4_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 4 SS4
    accurate_x = find(pos.ss4.correct.degX(:,5)<prctile(pos.ss4.correct.degX(:,5),75) & pos.ss4.correct.degX(:,5)>prctile(pos.ss4.correct.degX(:,5),25));
    accurate_y = find(pos.ss4.correct.degY(:,5)<prctile(pos.ss4.correct.degY(:,5),75) & pos.ss4.correct.degY(:,5)>prctile(pos.ss4.correct.degY(:,5),25));
    sloppy_x = find(pos.ss4.correct.degX(:,5)>prctile(pos.ss4.correct.degX(:,5),75) | pos.ss4.correct.degX(:,5)<prctile(pos.ss4.correct.degX(:,5),25));
    sloppy_y = find(pos.ss4.correct.degY(:,5)>prctile(pos.ss4.correct.degY(:,5),75) | pos.ss4.correct.degY(:,5)<prctile(pos.ss4.correct.degY(:,5),25));
    pos4_ss4.correct.accurate.x = pos4_ss4.correct.all(accurate_x);
    pos4_ss4.correct.accurate.y = pos4_ss4.correct.all(accurate_y);
    pos4_ss4.correct.sloppy.x = pos4_ss4.correct.all(sloppy_x);
    pos4_ss4.correct.sloppy.y = pos4_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 4 SS8
    accurate_x = find(pos.ss8.correct.degX(:,5)<prctile(pos.ss8.correct.degX(:,5),75) & pos.ss8.correct.degX(:,5)>prctile(pos.ss8.correct.degX(:,5),25));
    accurate_y = find(pos.ss8.correct.degY(:,5)<prctile(pos.ss8.correct.degY(:,5),75) & pos.ss8.correct.degY(:,5)>prctile(pos.ss8.correct.degY(:,5),25));
    sloppy_x = find(pos.ss8.correct.degX(:,5)>prctile(pos.ss8.correct.degX(:,5),75) | pos.ss8.correct.degX(:,5)<prctile(pos.ss8.correct.degX(:,5),25));
    sloppy_y = find(pos.ss8.correct.degY(:,5)>prctile(pos.ss8.correct.degY(:,5),75) | pos.ss8.correct.degY(:,5)<prctile(pos.ss8.correct.degY(:,5),25));
    pos4_ss8.correct.accurate.x = pos4_ss8.correct.all(accurate_x);
    pos4_ss8.correct.accurate.y = pos4_ss8.correct.all(accurate_y);
    pos4_ss8.correct.sloppy.x = pos4_ss8.correct.all(sloppy_x);
    pos4_ss8.correct.sloppy.y = pos4_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    % Position 5 SS2
    accurate_x = find(pos.ss2.correct.degX(:,6)<prctile(pos.ss2.correct.degX(:,6),75) & pos.ss2.correct.degX(:,6)>prctile(pos.ss2.correct.degX(:,6),25));
    accurate_y = find(pos.ss2.correct.degY(:,6)<prctile(pos.ss2.correct.degY(:,6),75) & pos.ss2.correct.degY(:,6)>prctile(pos.ss2.correct.degY(:,6),25));
    sloppy_x = find(pos.ss2.correct.degX(:,6)>prctile(pos.ss2.correct.degX(:,6),75) | pos.ss2.correct.degX(:,6)<prctile(pos.ss2.correct.degX(:,6),25));
    sloppy_y = find(pos.ss2.correct.degY(:,6)>prctile(pos.ss2.correct.degY(:,6),75) | pos.ss2.correct.degY(:,6)<prctile(pos.ss2.correct.degY(:,6),25));
    pos5_ss2.correct.accurate.x = pos5_ss2.correct.all(accurate_x);
    pos5_ss2.correct.accurate.y = pos5_ss2.correct.all(accurate_y);
    pos5_ss2.correct.sloppy.x = pos5_ss2.correct.all(sloppy_x);
    pos5_ss2.correct.sloppy.y = pos5_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 5 SS4
    accurate_x = find(pos.ss4.correct.degX(:,6)<prctile(pos.ss4.correct.degX(:,6),75) & pos.ss4.correct.degX(:,6)>prctile(pos.ss4.correct.degX(:,6),25));
    accurate_y = find(pos.ss4.correct.degY(:,6)<prctile(pos.ss4.correct.degY(:,6),75) & pos.ss4.correct.degY(:,6)>prctile(pos.ss4.correct.degY(:,6),25));
    sloppy_x = find(pos.ss4.correct.degX(:,6)>prctile(pos.ss4.correct.degX(:,6),75) | pos.ss4.correct.degX(:,6)<prctile(pos.ss4.correct.degX(:,6),25));
    sloppy_y = find(pos.ss4.correct.degY(:,6)>prctile(pos.ss4.correct.degY(:,6),75) | pos.ss4.correct.degY(:,6)<prctile(pos.ss4.correct.degY(:,6),25));
    pos5_ss4.correct.accurate.x = pos5_ss4.correct.all(accurate_x);
    pos5_ss4.correct.accurate.y = pos5_ss4.correct.all(accurate_y);
    pos5_ss4.correct.sloppy.x = pos5_ss4.correct.all(sloppy_x);
    pos5_ss4.correct.sloppy.y = pos5_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 5 SS8
    accurate_x = find(pos.ss8.correct.degX(:,6)<prctile(pos.ss8.correct.degX(:,6),75) & pos.ss8.correct.degX(:,6)>prctile(pos.ss8.correct.degX(:,6),25));
    accurate_y = find(pos.ss8.correct.degY(:,6)<prctile(pos.ss8.correct.degY(:,6),75) & pos.ss8.correct.degY(:,6)>prctile(pos.ss8.correct.degY(:,6),25));
    sloppy_x = find(pos.ss8.correct.degX(:,6)>prctile(pos.ss8.correct.degX(:,6),75) | pos.ss8.correct.degX(:,6)<prctile(pos.ss8.correct.degX(:,6),25));
    sloppy_y = find(pos.ss8.correct.degY(:,6)>prctile(pos.ss8.correct.degY(:,6),75) | pos.ss8.correct.degY(:,6)<prctile(pos.ss8.correct.degY(:,6),25));
    pos5_ss8.correct.accurate.x = pos5_ss8.correct.all(accurate_x);
    pos5_ss8.correct.accurate.y = pos5_ss8.correct.all(accurate_y);
    pos5_ss8.correct.sloppy.x = pos5_ss8.correct.all(sloppy_x);
    pos5_ss8.correct.sloppy.y = pos5_ss8.correct.all(sloppy_y);
    
    % Position 6 SS2
    accurate_x = find(pos.ss2.correct.degX(:,7)<prctile(pos.ss2.correct.degX(:,7),75) & pos.ss2.correct.degX(:,7)>prctile(pos.ss2.correct.degX(:,7),25));
    accurate_y = find(pos.ss2.correct.degY(:,7)<prctile(pos.ss2.correct.degY(:,7),75) & pos.ss2.correct.degY(:,7)>prctile(pos.ss2.correct.degY(:,7),25));
    sloppy_x = find(pos.ss2.correct.degX(:,7)>prctile(pos.ss2.correct.degX(:,7),75) | pos.ss2.correct.degX(:,7)<prctile(pos.ss2.correct.degX(:,7),25));
    sloppy_y = find(pos.ss2.correct.degY(:,7)>prctile(pos.ss2.correct.degY(:,7),75) | pos.ss2.correct.degY(:,7)<prctile(pos.ss2.correct.degY(:,7),25));
    pos6_ss2.correct.accurate.x = pos6_ss2.correct.all(accurate_x);
    pos6_ss2.correct.accurate.y = pos6_ss2.correct.all(accurate_y);
    pos6_ss2.correct.sloppy.x = pos6_ss2.correct.all(sloppy_x);
    pos6_ss2.correct.sloppy.y = pos6_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 6 SS4
    accurate_x = find(pos.ss4.correct.degX(:,7)<prctile(pos.ss4.correct.degX(:,7),75) & pos.ss4.correct.degX(:,7)>prctile(pos.ss4.correct.degX(:,7),25));
    accurate_y = find(pos.ss4.correct.degY(:,7)<prctile(pos.ss4.correct.degY(:,7),75) & pos.ss4.correct.degY(:,7)>prctile(pos.ss4.correct.degY(:,7),25));
    sloppy_x = find(pos.ss4.correct.degX(:,7)>prctile(pos.ss4.correct.degX(:,7),75) | pos.ss4.correct.degX(:,7)<prctile(pos.ss4.correct.degX(:,7),25));
    sloppy_y = find(pos.ss4.correct.degY(:,7)>prctile(pos.ss4.correct.degY(:,7),75) | pos.ss4.correct.degY(:,7)<prctile(pos.ss4.correct.degY(:,7),25));
    pos6_ss4.correct.accurate.x = pos6_ss4.correct.all(accurate_x);
    pos6_ss4.correct.accurate.y = pos6_ss4.correct.all(accurate_y);
    pos6_ss4.correct.sloppy.x = pos6_ss4.correct.all(sloppy_x);
    pos6_ss4.correct.sloppy.y = pos6_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 6 SS8
    accurate_x = find(pos.ss8.correct.degX(:,7)<prctile(pos.ss8.correct.degX(:,7),75) & pos.ss8.correct.degX(:,7)>prctile(pos.ss8.correct.degX(:,7),25));
    accurate_y = find(pos.ss8.correct.degY(:,7)<prctile(pos.ss8.correct.degY(:,7),75) & pos.ss8.correct.degY(:,7)>prctile(pos.ss8.correct.degY(:,7),25));
    sloppy_x = find(pos.ss8.correct.degX(:,7)>prctile(pos.ss8.correct.degX(:,7),75) | pos.ss8.correct.degX(:,7)<prctile(pos.ss8.correct.degX(:,7),25));
    sloppy_y = find(pos.ss8.correct.degY(:,7)>prctile(pos.ss8.correct.degY(:,7),75) | pos.ss8.correct.degY(:,7)<prctile(pos.ss8.correct.degY(:,7),25));
    pos6_ss8.correct.accurate.x = pos6_ss8.correct.all(accurate_x);
    pos6_ss8.correct.accurate.y = pos6_ss8.correct.all(accurate_y);
    pos6_ss8.correct.sloppy.x = pos6_ss8.correct.all(sloppy_x);
    pos6_ss8.correct.sloppy.y = pos6_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    % Position 7 SS2
    accurate_x = find(pos.ss2.correct.degX(:,8)<prctile(pos.ss2.correct.degX(:,8),75) & pos.ss2.correct.degX(:,8)>prctile(pos.ss2.correct.degX(:,8),25));
    accurate_y = find(pos.ss2.correct.degY(:,8)<prctile(pos.ss2.correct.degY(:,8),75) & pos.ss2.correct.degY(:,8)>prctile(pos.ss2.correct.degY(:,8),25));
    sloppy_x = find(pos.ss2.correct.degX(:,8)>prctile(pos.ss2.correct.degX(:,8),75) | pos.ss2.correct.degX(:,8)<prctile(pos.ss2.correct.degX(:,8),25));
    sloppy_y = find(pos.ss2.correct.degY(:,8)>prctile(pos.ss2.correct.degY(:,8),75) | pos.ss2.correct.degY(:,8)<prctile(pos.ss2.correct.degY(:,8),25));
    pos7_ss2.correct.accurate.x = pos7_ss2.correct.all(accurate_x);
    pos7_ss2.correct.accurate.y = pos7_ss2.correct.all(accurate_y);
    pos7_ss2.correct.sloppy.x = pos7_ss2.correct.all(sloppy_x);
    pos7_ss2.correct.sloppy.y = pos7_ss2.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 7 SS4
    accurate_x = find(pos.ss4.correct.degX(:,8)<prctile(pos.ss4.correct.degX(:,8),75) & pos.ss4.correct.degX(:,8)>prctile(pos.ss4.correct.degX(:,8),25));
    accurate_y = find(pos.ss4.correct.degY(:,8)<prctile(pos.ss4.correct.degY(:,8),75) & pos.ss4.correct.degY(:,8)>prctile(pos.ss4.correct.degY(:,8),25));
    sloppy_x = find(pos.ss4.correct.degX(:,8)>prctile(pos.ss4.correct.degX(:,8),75) | pos.ss4.correct.degX(:,8)<prctile(pos.ss4.correct.degX(:,8),25));
    sloppy_y = find(pos.ss4.correct.degY(:,8)>prctile(pos.ss4.correct.degY(:,8),75) | pos.ss4.correct.degY(:,8)<prctile(pos.ss4.correct.degY(:,8),25));
    pos7_ss4.correct.accurate.x = pos7_ss4.correct.all(accurate_x);
    pos7_ss4.correct.accurate.y = pos7_ss4.correct.all(accurate_y);
    pos7_ss4.correct.sloppy.x = pos7_ss4.correct.all(sloppy_x);
    pos7_ss4.correct.sloppy.y = pos7_ss4.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    % Position 7 SS8
    accurate_x = find(pos.ss8.correct.degX(:,8)<prctile(pos.ss8.correct.degX(:,8),75) & pos.ss8.correct.degX(:,8)>prctile(pos.ss8.correct.degX(:,8),25));
    accurate_y = find(pos.ss8.correct.degY(:,8)<prctile(pos.ss8.correct.degY(:,8),75) & pos.ss8.correct.degY(:,8)>prctile(pos.ss8.correct.degY(:,8),25));
    sloppy_x = find(pos.ss8.correct.degX(:,8)>prctile(pos.ss8.correct.degX(:,8),75) | pos.ss8.correct.degX(:,8)<prctile(pos.ss8.correct.degX(:,8),25));
    sloppy_y = find(pos.ss8.correct.degY(:,8)>prctile(pos.ss8.correct.degY(:,8),75) | pos.ss8.correct.degY(:,8)<prctile(pos.ss8.correct.degY(:,8),25));
    pos7_ss8.correct.accurate.x = pos7_ss8.correct.all(accurate_x);
    pos7_ss8.correct.accurate.y = pos7_ss8.correct.all(accurate_y);
    pos7_ss8.correct.sloppy.x = pos7_ss8.correct.all(sloppy_x);
    pos7_ss8.correct.sloppy.y = pos7_ss8.correct.all(sloppy_y);
    clear accurate_x accurate_y sloppy_x sloppy_y
    
    
    
    
    
    
    %correct missing RTs from 0 to NaN
   % pos.ss2.correct.RT(find(pos.ss2.correct.RT == 0)) = NaN;
   % pos.ss4.correct.RT(find(pos.ss4.correct.RT == 0)) = NaN;
    %pos.ss8.correct.RT(find(pos.ss8.correct.RT == 0)) = NaN;
    
    
    %store angles
    %allalpha.ss2.correct(1:size(alpha.ss2.correct,1),1:8,sess) = alpha.ss2.correct;
    %allalpha.ss4.correct(1:size(alpha.ss4.correct,1),1:8,sess) = alpha.ss4.correct;
    %allalpha.ss8.correct(1:size(alpha.ss8.correct,1),1:8,sess) = alpha.ss8.correct;
    
    %take mean deviations across screen locations
    %allpos.ss2.correct.deltaX(1:size(pos.ss2.correct.deltaX,1),1:8,sess) = pos.ss2.correct.deltaX;
    %allpos.ss2.correct.deltaY(1:size(pos.ss2.correct.deltaY,1),1:8,sess) = pos.ss2.correct.deltaY;
    %allpos.ss2.correct.degX(1:size(pos.ss2.correct.degX,1),1:8,sess) = pos.ss2.correct.degX;
    %allpos.ss2.correct.degY(1:size(pos.ss2.correct.degY,1),1:8,sess) = pos.ss2.correct.degY;
    %allRT.ss2.correct(1:size(pos.ss2.correct.RT,1),1:8,sess) = pos.ss2.correct.RT;
    
    %allpos.ss4.correct.deltaX(1:size(pos.ss4.correct.deltaX,1),1:8,sess) = pos.ss4.correct.deltaX;
    %allpos.ss4.correct.deltaY(1:size(pos.ss4.correct.deltaY,1),1:8,sess) = pos.ss4.correct.deltaY;
    %allpos.ss4.correct.degX(1:size(pos.ss4.correct.degX,1),1:8,sess) = pos.ss4.correct.degX;
    %allpos.ss4.correct.degY(1:size(pos.ss4.correct.degY,1),1:8,sess) = pos.ss4.correct.degY;
    %allRT.ss4.correct(1:size(pos.ss4.correct.RT,1),1:8,sess) = pos.ss4.correct.RT;
    
    %allpos.ss8.correct.deltaX(1:size(pos.ss8.correct.deltaX,1),1:8,sess) = pos.ss8.correct.deltaX;
    %allpos.ss8.correct.deltaY(1:size(pos.ss8.correct.deltaY,1),1:8,sess) = pos.ss8.correct.deltaY;
    %allpos.ss8.correct.degX(1:size(pos.ss8.correct.degX,1),1:8,sess) = pos.ss8.correct.degX;
    %allpos.ss8.correct.degY(1:size(pos.ss8.correct.degY,1),1:8,sess) = pos.ss8.correct.degY;
    %allRT.ss8.correct(1:size(pos.ss8.correct.RT,1),1:8,sess) = pos.ss8.correct.RT;
    
    
    
    %allvar.ss2(sess,1) = nanmean(stats.ss2.var);
    %allstd.ss2.correct(sess,1,1:8) = stats.ss2.correct.std;
    %allr.ss2.correct(sess,1,1:8) = stats.ss2.correct.r;
    
    %allvar.ss4(sess,1) = nanmean(stats.ss4.var);
    %allstd.ss4.correct(sess,1,1:8) = stats.ss4.correct.std;
    %allr.ss4.correct(sess,1,1:8) = stats.ss4.correct.r;
    
    %allvar.ss8(sess,1) = nanmean(stats.ss8.var);
    %allstd.ss8.correct(sess,1,1:8) = stats.ss8.correct.std;
    %allr.ss8.correct(sess,1,1:8) = stats.ss8.correct.r;
    
    
    
    
    %DO SLOPPY/ACCURATE COMPARISON FOR SPIKES, TARGET ALIGNED IF RF
    NeuronList = fields(RFs);
    for neuron = 1:length(NeuronList)
        if ~isempty(RFs.(NeuronList{neuron}))
            totalSpikes.targ = totalSpikes.targ + 1;
            
            spike = eval(NeuronList{neuron});
            RF = RFs.(NeuronList{neuron});
            in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
            out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),mod((RF+4),8)));
            
            
            %compile all x and y accurate saccades, then find intersection
            %w/ RF location
            allaccurate_ss2 = [pos0_ss2.correct.accurate.x;pos1_ss2.correct.accurate.x; ...
                pos2_ss2.correct.accurate.x; pos3_ss2.correct.accurate.x; ...
                pos4_ss2.correct.accurate.x; pos5_ss2.correct.accurate.x; ...
                pos6_ss2.correct.accurate.x; pos7_ss2.correct.accurate.x; ...
                pos0_ss2.correct.accurate.y; pos1_ss2.correct.accurate.y; ...
                pos2_ss2.correct.accurate.y; pos3_ss2.correct.accurate.y; ...
                pos4_ss2.correct.accurate.y; pos5_ss2.correct.accurate.y; ...
                pos6_ss2.correct.accurate.y; pos7_ss2.correct.accurate.y];
            
            allsloppy_ss2 = [pos0_ss2.correct.sloppy.x;pos1_ss2.correct.sloppy.x; ...
                pos2_ss2.correct.sloppy.x; pos3_ss2.correct.sloppy.x; ...
                pos4_ss2.correct.sloppy.x; pos5_ss2.correct.sloppy.x; ...
                pos6_ss2.correct.sloppy.x; pos7_ss2.correct.sloppy.x; ...
                pos0_ss2.correct.sloppy.y; pos1_ss2.correct.sloppy.y; ...
                pos2_ss2.correct.sloppy.y; pos3_ss2.correct.sloppy.y; ...
                pos4_ss2.correct.sloppy.y; pos5_ss2.correct.sloppy.y; ...
                pos6_ss2.correct.sloppy.y; pos7_ss2.correct.sloppy.y];
            
            
            allaccurate_ss4 = [pos0_ss4.correct.accurate.x;pos1_ss4.correct.accurate.x; ...
                pos2_ss4.correct.accurate.x; pos3_ss4.correct.accurate.x; ...
                pos4_ss4.correct.accurate.x; pos5_ss4.correct.accurate.x; ...
                pos6_ss4.correct.accurate.x; pos7_ss4.correct.accurate.x; ...
                pos0_ss4.correct.accurate.y; pos1_ss4.correct.accurate.y; ...
                pos2_ss4.correct.accurate.y; pos3_ss4.correct.accurate.y; ...
                pos4_ss4.correct.accurate.y; pos5_ss4.correct.accurate.y; ...
                pos6_ss4.correct.accurate.y; pos7_ss4.correct.accurate.y];
            
            allsloppy_ss4 = [pos0_ss4.correct.sloppy.x;pos1_ss4.correct.sloppy.x; ...
                pos2_ss4.correct.sloppy.x; pos3_ss4.correct.sloppy.x; ...
                pos4_ss4.correct.sloppy.x; pos5_ss4.correct.sloppy.x; ...
                pos6_ss4.correct.sloppy.x; pos7_ss4.correct.sloppy.x; ...
                pos0_ss4.correct.sloppy.y; pos1_ss4.correct.sloppy.y; ...
                pos2_ss4.correct.sloppy.y; pos3_ss4.correct.sloppy.y; ...
                pos4_ss4.correct.sloppy.y; pos5_ss4.correct.sloppy.y; ...
                pos6_ss4.correct.sloppy.y; pos7_ss4.correct.sloppy.y];
            
            
            allaccurate_ss8 = [pos0_ss8.correct.accurate.x;pos1_ss8.correct.accurate.x; ...
                pos2_ss8.correct.accurate.x; pos3_ss8.correct.accurate.x; ...
                pos4_ss8.correct.accurate.x; pos5_ss8.correct.accurate.x; ...
                pos6_ss8.correct.accurate.x; pos7_ss8.correct.accurate.x; ...
                pos0_ss8.correct.accurate.y; pos1_ss8.correct.accurate.y; ...
                pos2_ss8.correct.accurate.y; pos3_ss8.correct.accurate.y; ...
                pos4_ss8.correct.accurate.y; pos5_ss8.correct.accurate.y; ...
                pos6_ss8.correct.accurate.y; pos7_ss8.correct.accurate.y];
            
            allsloppy_ss8 = [pos0_ss8.correct.sloppy.x;pos1_ss8.correct.sloppy.x; ...
                pos2_ss8.correct.sloppy.x; pos3_ss8.correct.sloppy.x; ...
                pos4_ss8.correct.sloppy.x; pos5_ss8.correct.sloppy.x; ...
                pos6_ss8.correct.sloppy.x; pos7_ss8.correct.sloppy.x; ...
                pos0_ss8.correct.sloppy.y; pos1_ss8.correct.sloppy.y; ...
                pos2_ss8.correct.sloppy.y; pos3_ss8.correct.sloppy.y; ...
                pos4_ss8.correct.sloppy.y; pos5_ss8.correct.sloppy.y; ...
                pos6_ss8.correct.sloppy.y; pos7_ss8.correct.sloppy.y];
            
            
            accurate.in.ss2 = intersect(allaccurate_ss2,in);
            accurate.in.ss4 = intersect(allaccurate_ss4,in);
            accurate.in.ss8 = intersect(allaccurate_ss8,in);
            sloppy.in.ss2 = intersect(allsloppy_ss2,in);
            sloppy.in.ss4 = intersect(allsloppy_ss4,in);
            sloppy.in.ss8 = intersect(allsloppy_ss8,in);
            
            
            accurate.out.ss2 = intersect(allaccurate_ss2,out);
            accurate.out.ss4 = intersect(allaccurate_ss4,out);
            accurate.out.ss8 = intersect(allaccurate_ss8,out);
            sloppy.out.ss2 = intersect(allsloppy_ss2,out);
            sloppy.out.ss4 = intersect(allsloppy_ss4,out);
            sloppy.out.ss8 = intersect(allsloppy_ss8,out);
            
            SDF_in.targ.accurate.ss2(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],accurate.in.ss2,TrialStart_);
            SDF_in.targ.accurate.ss4(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],accurate.in.ss4,TrialStart_);
            SDF_in.targ.accurate.ss8(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],accurate.in.ss8,TrialStart_);
            SDF_in.targ.sloppy.ss2(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],sloppy.in.ss2,TrialStart_);
            SDF_in.targ.sloppy.ss4(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],sloppy.in.ss4,TrialStart_);
            SDF_in.targ.sloppy.ss8(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],sloppy.in.ss8,TrialStart_);
            
            SDF_out.targ.accurate.ss2(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],accurate.out.ss2,TrialStart_);
            SDF_out.targ.accurate.ss4(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],accurate.out.ss4,TrialStart_);
            SDF_out.targ.accurate.ss8(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],accurate.out.ss8,TrialStart_);
            SDF_out.targ.sloppy.ss2(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],sloppy.out.ss2,TrialStart_);
            SDF_out.targ.sloppy.ss4(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],sloppy.out.ss4,TrialStart_);
            SDF_out.targ.sloppy.ss8(totalSpikes.targ,1:601) = spikedensityfunct(spike,Target_(:,1),[-100 500],sloppy.out.ss8,TrialStart_);
            
        end
    end
    
    
    
    
    %NOW MOVEMENT ALIGNED IF MF
    for neuron = 1:length(NeuronList)
        if ~isempty(MFs.(NeuronList{neuron}))
            totalSpikes.resp = totalSpikes.resp + 1;
            
            spike = eval(NeuronList{neuron});
            RF = MFs.(NeuronList{neuron});
            in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
            out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),mod((RF+4),8)));
            
            
            %compile all x and y accurate saccades, then find intersection
            %w/ RF location
            allaccurate_ss2 = [pos0_ss2.correct.accurate.x;pos1_ss2.correct.accurate.x; ...
                pos2_ss2.correct.accurate.x; pos3_ss2.correct.accurate.x; ...
                pos4_ss2.correct.accurate.x; pos5_ss2.correct.accurate.x; ...
                pos6_ss2.correct.accurate.x; pos7_ss2.correct.accurate.x; ...
                pos0_ss2.correct.accurate.y; pos1_ss2.correct.accurate.y; ...
                pos2_ss2.correct.accurate.y; pos3_ss2.correct.accurate.y; ...
                pos4_ss2.correct.accurate.y; pos5_ss2.correct.accurate.y; ...
                pos6_ss2.correct.accurate.y; pos7_ss2.correct.accurate.y];
            
            allsloppy_ss2 = [pos0_ss2.correct.sloppy.x;pos1_ss2.correct.sloppy.x; ...
                pos2_ss2.correct.sloppy.x; pos3_ss2.correct.sloppy.x; ...
                pos4_ss2.correct.sloppy.x; pos5_ss2.correct.sloppy.x; ...
                pos6_ss2.correct.sloppy.x; pos7_ss2.correct.sloppy.x; ...
                pos0_ss2.correct.sloppy.y; pos1_ss2.correct.sloppy.y; ...
                pos2_ss2.correct.sloppy.y; pos3_ss2.correct.sloppy.y; ...
                pos4_ss2.correct.sloppy.y; pos5_ss2.correct.sloppy.y; ...
                pos6_ss2.correct.sloppy.y; pos7_ss2.correct.sloppy.y];
            
            
            allaccurate_ss4 = [pos0_ss4.correct.accurate.x;pos1_ss4.correct.accurate.x; ...
                pos2_ss4.correct.accurate.x; pos3_ss4.correct.accurate.x; ...
                pos4_ss4.correct.accurate.x; pos5_ss4.correct.accurate.x; ...
                pos6_ss4.correct.accurate.x; pos7_ss4.correct.accurate.x; ...
                pos0_ss4.correct.accurate.y; pos1_ss4.correct.accurate.y; ...
                pos2_ss4.correct.accurate.y; pos3_ss4.correct.accurate.y; ...
                pos4_ss4.correct.accurate.y; pos5_ss4.correct.accurate.y; ...
                pos6_ss4.correct.accurate.y; pos7_ss4.correct.accurate.y];
            
            allsloppy_ss4 = [pos0_ss4.correct.sloppy.x;pos1_ss4.correct.sloppy.x; ...
                pos2_ss4.correct.sloppy.x; pos3_ss4.correct.sloppy.x; ...
                pos4_ss4.correct.sloppy.x; pos5_ss4.correct.sloppy.x; ...
                pos6_ss4.correct.sloppy.x; pos7_ss4.correct.sloppy.x; ...
                pos0_ss4.correct.sloppy.y; pos1_ss4.correct.sloppy.y; ...
                pos2_ss4.correct.sloppy.y; pos3_ss4.correct.sloppy.y; ...
                pos4_ss4.correct.sloppy.y; pos5_ss4.correct.sloppy.y; ...
                pos6_ss4.correct.sloppy.y; pos7_ss4.correct.sloppy.y];
            
            
            allaccurate_ss8 = [pos0_ss8.correct.accurate.x;pos1_ss8.correct.accurate.x; ...
                pos2_ss8.correct.accurate.x; pos3_ss8.correct.accurate.x; ...
                pos4_ss8.correct.accurate.x; pos5_ss8.correct.accurate.x; ...
                pos6_ss8.correct.accurate.x; pos7_ss8.correct.accurate.x; ...
                pos0_ss8.correct.accurate.y; pos1_ss8.correct.accurate.y; ...
                pos2_ss8.correct.accurate.y; pos3_ss8.correct.accurate.y; ...
                pos4_ss8.correct.accurate.y; pos5_ss8.correct.accurate.y; ...
                pos6_ss8.correct.accurate.y; pos7_ss8.correct.accurate.y];
            
            allsloppy_ss8 = [pos0_ss8.correct.sloppy.x;pos1_ss8.correct.sloppy.x; ...
                pos2_ss8.correct.sloppy.x; pos3_ss8.correct.sloppy.x; ...
                pos4_ss8.correct.sloppy.x; pos5_ss8.correct.sloppy.x; ...
                pos6_ss8.correct.sloppy.x; pos7_ss8.correct.sloppy.x; ...
                pos0_ss8.correct.sloppy.y; pos1_ss8.correct.sloppy.y; ...
                pos2_ss8.correct.sloppy.y; pos3_ss8.correct.sloppy.y; ...
                pos4_ss8.correct.sloppy.y; pos5_ss8.correct.sloppy.y; ...
                pos6_ss8.correct.sloppy.y; pos7_ss8.correct.sloppy.y];
            
            
            accurate.in.ss2 = intersect(allaccurate_ss2,in);
            accurate.in.ss4 = intersect(allaccurate_ss4,in);
            accurate.in.ss8 = intersect(allaccurate_ss8,in);
            sloppy.in.ss2 = intersect(allsloppy_ss2,in);
            sloppy.in.ss4 = intersect(allsloppy_ss4,in);
            sloppy.in.ss8 = intersect(allsloppy_ss8,in);
            
            
            accurate.out.ss2 = intersect(allaccurate_ss2,out);
            accurate.out.ss4 = intersect(allaccurate_ss4,out);
            accurate.out.ss8 = intersect(allaccurate_ss8,out);
            sloppy.out.ss2 = intersect(allsloppy_ss2,out);
            sloppy.out.ss4 = intersect(allsloppy_ss4,out);
            sloppy.out.ss8 = intersect(allsloppy_ss8,out);
            
            SDF_in.resp.accurate.ss2(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],accurate.in.ss2,TrialStart_);
            SDF_in.resp.accurate.ss4(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],accurate.in.ss4,TrialStart_);
            SDF_in.resp.accurate.ss8(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],accurate.in.ss8,TrialStart_);
            SDF_in.resp.sloppy.ss2(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],sloppy.in.ss2,TrialStart_);
            SDF_in.resp.sloppy.ss4(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],sloppy.in.ss4,TrialStart_);
            SDF_in.resp.sloppy.ss8(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],sloppy.in.ss8,TrialStart_);
            
            SDF_out.resp.accurate.ss2(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],accurate.out.ss2,TrialStart_);
            SDF_out.resp.accurate.ss4(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],accurate.out.ss4,TrialStart_);
            SDF_out.resp.accurate.ss8(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],accurate.out.ss8,TrialStart_);
            SDF_out.resp.sloppy.ss2(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],sloppy.out.ss2,TrialStart_);
            SDF_out.resp.sloppy.ss4(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],sloppy.out.ss4,TrialStart_);
            SDF_out.resp.sloppy.ss8(totalSpikes.resp,1:601) = spikedensityfunct(spike,SRT(:,1)+500,[-400 200],sloppy.out.ss8,TrialStart_);
            
        end
    end
    keep SDF_in SDF_out totalSpikes batch_list file_list sess allstd allpos allalpha allRT allr q qcq file_path_correct
    
end

keep SDF_in SDF_out totalSpikes file_list allstd allpos allRT allr allalpha



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



