%%%%%%%%%%%%%%%%%%%%%%%%%
% 1) SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%

saveFlag = 1;
outdir = 'C:\Data\Analyses\Search_Errors\PDF\';


%load appropriate file
f_path = 'C:\Data\Search_Data\';
[file_name cell_name] = textread('MG_errors_move.txt', '%s %s');
Align_ = 'r';
extension = 'move';

for file = 1:size(file_name,1)
    load([f_path cell2mat(file_name(file))])

    %Determine monkey
    if exist('newfile')
        if strfind(newfile,'Q') == 1
            monkey = 'Q';
            ASL_Delay = 0;
        elseif strfind(newfile,'dat') == 1
            monkey = 'Q';
            ASL_Delay = 0;
        else
            monkey = 'S';
            ASL_Delay = 1;
        end
    end


    if exist('SRT') == 0
        [SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay);
    end

    %set up alignment options for SDF
    if Align_ == 's'
        Align_Time(1:length(Correct_),1) = 500;
        SDFPlot_Time = [-200 800];
    elseif Align_ == 'r'
        Align_Time = SRT(:,1);
        SDFPlot_Time = [-400 200];
        %When Saccade aligned, still have 500 ms baseline + SRT.
        Align_Time = Align_Time + 500;
    end


    %check to make sure RFs exist in file
    if exist('RFs') == 0
        disp('No RFs present in file')
        return
    end

    % NOTE: for vis-move cell S011508001-RH_SEARCH, move response correct-in and
    % incorrect-in were NOT the same; correct-in still a bit higher (but,
    % incorrect-out lowest)
    %


    fixErrors


    %find 'valid' Correct trials
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);

    %find incorrect trials.  Will filter for all other types of errors (latency
    %errors, target hold errors, etc. leaving us only with saccade direction
    %errors.  Have to do this backwards because some files do not have this
    %information)

    %find 'valid' Incorrect Trials (because Tempo's 'Decide_' variable has a
    %'0' for incorrect trials, we will only eliminate SRTs that have
    %exceptionally small or large values)
    %IncorrectTrials = find(Correct_(:,2) == 0 & Errors_(:,1) ~= 1 & Errors_(:,2) ~=1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~=1 & SRT(:,1) < 2000 & SRT(:,1) > 100);
    IncorrectTrials = find(Errors_(:,5) == 1);


    %find index of relevant cell
    varlist = who;
    cells = varlist(strmatch('DSP',varlist));



    %match RF with relevant cell
    %y = strmatch(cell_list{i},varlist_clean);
    y = strmatch(cell_name{file},cells);
    
    if Align_ == 's'
        RF = RFs{y};
    elseif Align_ == 'r'
        RF = MFs{y};
    end
    anti_RF = getAntiRF(RF);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2) overall SDFs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Spike = eval(cell2mat(cell_name(file)));

    in_correct_trials = ValidTrials(find(ismember(Target_(ValidTrials,2),RF)));
    %in_incorrect_trials = IncorrectTrials(find(ismember(saccDir(IncorrectTrials,2),RF)));
    in_incorrect_trials = find(ismember(saccDir,RF) & ismember(Target_(:,2),anti_RF) & Errors_(:,5) == 1);
    out_incorrect_trials = find(ismember(saccDir,anti_RF) & ismember(Target_(:,2),RF) & Errors_(:,5) == 1);

    RTs_in_correct = SRT(in_correct_trials,1);
    RTs_in_incorrect = SRT(in_incorrect_trials,1);

    SDF_in_correct = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, in_correct_trials, TrialStart_);
    SDF_in_incorrect = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, in_incorrect_trials, TrialStart_);
    SDF_out_incorrect = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, out_incorrect_trials, TrialStart_);

    f = figure;
    set(gcf,'Color','white')
    plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF_in_correct,'b',SDFPlot_Time(1):SDFPlot_Time(2),SDF_in_incorrect,'r',SDFPlot_Time(1):SDFPlot_Time(2),SDF_out_incorrect,'g')
    legend('Correct-In','Incorrect-In','Incorrect-out','Location','northwest')
    title(['Correct-in n = ',mat2str(length(in_correct_trials)),'  Incorrect-in n = ',mat2str(length(in_incorrect_trials)),'  Incorrect-out n = ',mat2str(length(out_incorrect_trials)),'      RF = ',mat2str(RF),' antiRF = ',mat2str(anti_RF)],'FontSize',13)
    [ax,h3] = suplabel(strcat('File: ',cell2mat(file_name(file)),'     Cell: ',cell2mat(cell_name(file)),'-',extension,'   Generated: ',date),'t');
    set(h3,'FontSize',14)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %3) Accomplish latency matching between correct and error trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    fast_RTs_in_incorrect = SRT(in_incorrect_trials(find(SRT(in_incorrect_trials,1) < 150),1));

    if saveFlag == 1
        eval(['print -dpdf ',outdir,cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'-',extension]);
    end
    
    close(f);
    keep f_path file_name cell_name file Align_ extension saveFlag outdir
end %cell loop
clear all

