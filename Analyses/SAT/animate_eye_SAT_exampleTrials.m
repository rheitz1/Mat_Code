% Run Animate_eye_SAT on good set of trials
cd /volumes/Dump/Search_Data_SAT_longBase/
qload_SAT

slow = find(SAT_(:,1) == 1 & Target_(:,2) ~= 2 & Target_(:,2) ~= 6 & saccLoc ~= 2 & saccLoc ~= 6);
med = find(SAT_(:,1) == 2 & Target_(:,2) ~= 2 & Target_(:,2) ~= 6 & saccLoc ~= 2 & saccLoc ~= 6);
fast = find(SAT_(:,1) == 3 & Target_(:,2) ~= 2 & Target_(:,2) ~= 6 & saccLoc ~= 2 & saccLoc ~= 6);

fast = fast(100:200); %first few fast trials are very inaccurate

%cherry-picked trials
% triallist_slow = [slow(12) ; slow(13) ; slow(14) ; slow(15) ; slow(17)];
triallist_slow = [slow(12) ; slow(13) ; slow(14)];
triallist_med = [med(1) ; med(8) ; med(3)];
triallist_fast = [fast(14) ; fast(16) ; fast(20)];

%triallist = [triallist_med ; triallist_slow ; triallist_fast];

triallist = triallist_med(3);

F = animate_eye_SAT_longBase_blackBack(triallist);
