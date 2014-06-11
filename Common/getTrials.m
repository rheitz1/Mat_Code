% Script to quickly find all trials of various conditions

% create 3 nTiles separately for correct and error trials based on RT.

%calculate n RT bins
fixErrors
numBins = 3;
divideby = 100/numBins;


if length(find(~isnan(MStim_(:,1)))) > 0
    disp('Warning... uStim data detected!')
end

trials.correct.all = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.errors.all = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & SRT(:,1) < 2000 & SRT(:,1) > 50);

j = 1;
for i = divideby:divideby:100
    percentile_array.correct(j) = prctile(SRT(trials.correct.all,1),i);
    percentile_array.errors(j) = prctile(SRT(trials.errors.all,1),i);
    
    j = j + 1;
end

trials.correct.fast = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > 50 & SRT(:,1) <= percentile_array.correct(1));
trials.correct.med = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > percentile_array.correct(1) & SRT(:,1) <= percentile_array.correct(2));
trials.correct.slow = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > percentile_array.correct(2) & SRT(:,1) < 2000);

trials.errors.fast = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > 50 & SRT(:,1) <= percentile_array.errors(1));
trials.errors.med = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > percentile_array.errors(1) & SRT(:,1) <= percentile_array.errors(2));
trials.errors.slow = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > percentile_array.errors(2) & SRT(:,1) < 2000);

trials.correct.catch = find(Correct_(:,2) == 1 & Target_(:,2) == 255);
trials.errors.catch = find(Errors_(:,5) == 1 & Target_(:,2) == 255);

trials.pos0.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 0 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos1.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos2.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos3.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 3 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos4.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos5.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 5 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos6.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 6 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos7.correct = find(Correct_(:,2) == 1 & Target_(:,2) == 7 & SRT(:,1) < 2000 & SRT(:,1) > 50);

trials.pos0.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 0 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos1.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos2.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos3.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 3 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos4.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos5.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 5 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos6.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 6 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.pos7.errors = find(Errors_(:,5) == 1 & Target_(:,2) == 7 & SRT(:,1) < 2000 & SRT(:,1) > 50);

trials.correct.ss2 = find(Correct_(:,2) == 1 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.correct.ss4 = find(Correct_(:,2) == 1 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.correct.ss8 = find(Correct_(:,2) == 1 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);

trials.errors.ss2 = find(Errors_(:,5) == 1 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.errors.ss4 = find(Errors_(:,5) == 1 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
trials.errors.ss8 = find(Errors_(:,5) == 1 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
