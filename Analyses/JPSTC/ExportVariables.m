%exports relevant data for JPSTC analyses to new data files
clear all
close all


q = '''';
c = ',';
qcq = [q c q];

export_path = 'C:\data\Analyses\JPSTC\Analysis_files\';

[file_name cell_name] = textread('temp.txt', '%s %s');


%=============================
%run scripts

%fixErrors

% % A L L   T R I A L S correction
% CorrectTrials = [];
% CorrectTrials = (1:size(Target_,1))';
% ValidTrials = CorrectTrials;
% %=============================

for file = 1:size(file_name,1)
    %echo current file and cell
    disp([file_name(file)])

    %find relevant channels in file
    varlist = who('-file',cell2mat(file_name(file)));
    ADlist = cell2mat(varlist(strmatch('AD',varlist)));
    %DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
    clear varlist


    for chanNum = 1:size(ADlist,1)
        ADchan = ADlist(chanNum,:);
        eval(['load(' q cell2mat(file_name(file)) qcq ADchan qcq '-mat' q ')'])
        clear ADchan
    end

    %load Target_ & Correct_ variable
    eval(['load(' q cell2mat(file_name(file)) qcq 'Decide_' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')'])

    %rename LFP channels for consistency
    clear ADlist
    varlist = who;
    chanlist = varlist(strmatch('AD',varlist));
    clear varlist


    %Find all possible pairings of LFP channels
    pairings = nchoosek(1:length(chanlist),2);

    for pair = 1:size(pairings,1)
         sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
         sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
         save([export_path (cell2mat(file_name(file))) '_' cell2mat(chanlist(pairings(pair,1))) '_' cell2mat(chanlist(pairings(pair,2)))],'sig1','sig2','newfile','SRT','Correct_','Decide_','Errors_','Target_','-mat')
    end
    keep c q qcq cell_name file_name file export_path
end
