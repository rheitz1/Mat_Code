% Get BEHavior
% 

% BEH: 2-dimensional matrix of means
%           RT correct:  correct /   x    / ss2 / ss4 / ss8 / homo / hete
%           RT errors:      x    / errors / ss2 / ss4 / ss8 / homo / hete
%           ACC:         overall /   x    / ss2 / ss4 / ss8 / homo / hete

% BEH_CDF_correct: 3-dimension matrix of correct CDFs
%               correct / NaN / ss2 / ss4 / ss8 / homo / hete
%   dimension 1 holds cumprob
%   dimension 2 holds bin centers

% BEH_CDF_errors: 3-dimension matrix of errant CDFs
%               NaN / errors / ss2 / ss4 / ss8 / homo / hete
%   dimension 1 holds cumprob
%   dimension 2 holds bin centers

% RPH

fixErrors

valid_correct = find(Correct_(:,2) == 1 & Target_(:,2) ~=255 & SRT(:,1) > 50 & SRT(:,1) < 2000);
valid_errors = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & SRT(:,1) > 50 & SRT(:,1) < 2000);
correct_ss2 = find(Correct_(:,2) == 1 & Target_(:,2) ~=255 & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) < 2000);
correct_ss4 = find(Correct_(:,2) == 1 & Target_(:,2) ~=255 & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) < 2000);
correct_ss8 = find(Correct_(:,2) == 1 & Target_(:,2) ~=255 & Target_(:,5) == 8 & SRT(:,1) > 50 & SRT(:,1) < 2000);
correct_homo = find(Correct_(:,2) == 1 & Target_(:,2) ~=255 & Target_(:,11) == 0 & SRT(:,1) > 50 & SRT(:,1) < 2000);
correct_hete = find(Correct_(:,2) == 1 & Target_(:,2) ~=255 & Target_(:,11) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000);

errors_ss2 = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) < 2000);
errors_ss4 = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) < 2000);
errors_ss8 = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & Target_(:,5) == 8 & SRT(:,1) > 50 & SRT(:,1) < 2000);
errors_homo = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & Target_(:,11) == 0 & SRT(:,1) > 50 & SRT(:,1) < 2000);
errors_hete = find(Errors_(:,5) == 1 & Target_(:,2) ~=255 & Target_(:,11) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000);


%exclude files that are too small or missing ss2, 4, 8
if size(Target_,1) < 400
    disp('Fewer than 500 trials...skipping')
    BEH(1:3,1:7) = NaN;
    BEH_CDF_correct(1:30,1:7,1:2) = NaN;
    BEH_CDF_errors(1:30,1:7,1:2) = NaN;
    return
end

if isempty(correct_ss2) | isempty(correct_ss4) | isempty(correct_ss8)
    disp('Missing data...Skipping')
    BEH(1:3,1:7) = NaN;
    BEH_CDF_correct(1:30,1:7,1:2) = NaN;
    BEH_CDF_errors(1:30,1:7,1:2) = NaN;
    return
end

%accuracy rate caclulations - proportions of # of trials from above
ACC = length(valid_correct) / length(find(Target_(:,2) ~=255 & SRT(:,1) > 50 & SRT(:,1) < 2000));
ACC_ss2 = length(correct_ss2) / length(find(Target_(:,2) ~=255 & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) < 2000));
ACC_ss4 = length(correct_ss4) / length(find(Target_(:,2) ~=255 & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) < 2000));
ACC_ss8 = length(correct_ss8) / length(find(Target_(:,2) ~=255 & Target_(:,5) == 8 & SRT(:,1) > 50 & SRT(:,1) < 2000));
ACC_homo = length(correct_homo) / length(find(Target_(:,2) ~=255 & Target_(:,11) == 0 & SRT(:,1) > 50 & SRT(:,1) < 2000));
ACC_hete = length(correct_hete) / length(find(Target_(:,2) ~=255 & Target_(:,11) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000));

BEH(1,1:7) = [nanmean(SRT(valid_correct,1)) NaN nanmean(SRT(correct_ss2,1)) nanmean(SRT(correct_ss4,1)) nanmean(SRT(correct_ss8,1)) nanmean(SRT(correct_homo,1)) nanmean(SRT(correct_hete,1))];
BEH(2,1:7) = [NaN nanmean(SRT(valid_errors,1)) nanmean(SRT(errors_ss2,1)) nanmean(SRT(errors_ss4,1)) nanmean(SRT(errors_ss8,1)) nanmean(SRT(errors_homo,1)) nanmean(SRT(errors_hete,1))];
BEH(3,1:7) = [ACC NaN ACC_ss2 ACC_ss4 ACC_ss8 ACC_homo ACC_hete];

%CDFs
[correct_CDF correct_bins] = getCDF(SRT(valid_correct,1),30);

[correct_ss2_CDF correct_ss2_bins] = getCDF(SRT(correct_ss2,1),30);
[correct_ss4_CDF correct_ss4_bins] = getCDF(SRT(correct_ss4,1),30);
[correct_ss8_CDF correct_ss8_bins] = getCDF(SRT(correct_ss8,1),30);

%use try/catch in case there are no homo or hete trials
try
    [correct_homo_CDF correct_homo_bins] = getCDF(SRT(correct_homo,1),30);
catch
    correct_homo_CDF(1:30,1) = NaN;
    correct_homo_bins(1:30,1) = NaN;
end
try
    [correct_hete_CDF correct_hete_bins] = getCDF(SRT(correct_hete,1),30);
catch
    correct_hete_CDF(1:30,1) = NaN;
    correct_hete_bins(1:30,1) = NaN;
end

[errors_CDF errors_bins] = getCDF(SRT(valid_errors,1),30);
[errors_ss2_CDF errors_ss2_bins] = getCDF(SRT(errors_ss2,1),30);
[errors_ss4_CDF errors_ss4_bins] = getCDF(SRT(errors_ss4,1),30);
[errors_ss8_CDF errors_ss8_bins] = getCDF(SRT(errors_ss8,1),30);

try
    [errors_homo_CDF errors_homo_bins] = getCDF(SRT(errors_homo,1),30);
catch
    errors_homo_CDF(1:30,1) = NaN;
    errors_homo_bins(1:30,1) = NaN;
end

try
    [errors_hete_CDF errors_hete_bins] = getCDF(SRT(errors_hete,1),30);
catch
    errors_hete_CDF(1:30,1) = NaN;
    errors_hete_bins(1:30,1) = NaN;
end

nBins = length(correct_bins);
%CORRECT; dimension 1 = cumulative probabilities
BEH_CDF_correct(1:nBins,1,1) = correct_bins;
BEH_CDF_correct(1:nBins,2,1) = NaN;
BEH_CDF_correct(1:nBins,3,1) = correct_ss2_bins;
BEH_CDF_correct(1:nBins,4,1) = correct_ss4_bins;
BEH_CDF_correct(1:nBins,5,1) = correct_ss8_bins;
BEH_CDF_correct(1:nBins,6,1) = correct_homo_bins;
BEH_CDF_correct(1:nBins,7,1) = correct_hete_bins;

%CORRECT; dimension 2 = bin centers
BEH_CDF_correct(1:nBins,1,2) = correct_CDF;
BEH_CDF_correct(1:nBins,2,2) = NaN;
BEH_CDF_correct(1:nBins,3,2) = correct_ss2_CDF;
BEH_CDF_correct(1:nBins,4,2) = correct_ss4_CDF;
BEH_CDF_correct(1:nBins,5,2) = correct_ss8_CDF;
BEH_CDF_correct(1:nBins,6,2) = correct_homo_CDF;
BEH_CDF_correct(1:nBins,7,2) = correct_hete_CDF;

%ERRORS; dimension 1 = cumulative probabilities
BEH_CDF_errors(1:nBins,1,1) = NaN;
BEH_CDF_errors(1:nBins,2,1) = errors_bins;
BEH_CDF_errors(1:nBins,3,1) = errors_ss2_bins;
BEH_CDF_errors(1:nBins,4,1) = errors_ss4_bins;
BEH_CDF_errors(1:nBins,5,1) = errors_ss8_bins;
BEH_CDF_errors(1:nBins,6,1) = errors_homo_bins;
BEH_CDF_errors(1:nBins,7,1) = errors_hete_bins;

%ERRORS; dimension 2 = bin centers
BEH_CDF_errors(1:nBins,1,2) = NaN;
BEH_CDF_errors(1:nBins,2,2) = errors_CDF;
BEH_CDF_errors(1:nBins,3,2) = errors_ss2_CDF;
BEH_CDF_errors(1:nBins,4,2) = errors_ss4_CDF;
BEH_CDF_errors(1:nBins,5,2) = errors_ss8_CDF;
BEH_CDF_errors(1:nBins,6,2) = errors_homo_CDF;
BEH_CDF_errors(1:nBins,7,2) = errors_hete_CDF;



clear nBins valid_correct valid_errors correct_ss2 correct_ss4 correct_ss8 ...
    correct_homo correct_hete errors_ss2 errors_ss4 errors_ss8 errors_homo ...
    errors_hete ACC ACC_ss2 ACC_ss4 ACC_ss8 ACC_homo ACC_hete correct_CDF correct_bins ...
    correct_ss2_CDF correct_ss2_bins correct_ss4_CDF correct_ss4_bins correct_ss8_CDF ...
    correct_ss8_bins correct_homo_CDF correct_homo_bins correct_hete_CDF ...
    errors_CDF errors_bins correct_hete_bins errors_ss2_CDF errors_ss2_bins ...
    errors_ss4_CDF errors_ss4_bins errors_ss8_CDF ...
    errors_ss8_bins errors_homo_CDF errors_homo_bins errors_hete_CDF errors_hete_bins