
%Options
Align_ = 's';
plotOption = 1;
Spike = DSP10b;

%analyze correct trials or errors?
% correct = c, errors = e
TrialType = 'e';

%Fix "Errors_" variable
if exist('ContrastFlag') == 1
    if ContrastFlag == 1
        eval('fixErrors_CONTRAST')
    else
        eval('fixErrors')
    end
else
    eval('fixErrors')
end

%Get SRT from Eye Traces (and saccade directions
[SRT,saccDir] = getSRT_direction(EyeX_,EyeY_,Target_);

%convert saccade direction from degrees into screen locations
saccLoc = dir2loc(EyeX_,EyeY_,saccDir,SRT,Target_);


%Find Valid Trials (SRT >= 100 & difference between SRT & Decide < 45 ms)
[ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);


%TEMPORARILY REMOVE 'VALID TRIAL' FILTERING ..12/18/07
%ValidTrials = CorrectTrials;

if Align_ == 's'
    Align_Time(1:length(Correct_),1) = 500;
    SDFPlot_Time = [-200 2000];
    % plot_time = (1:2500)*4-3;
elseif Align_ == 'r'
    Align_Time = SRT(:,1);
    SDFPlot_Time = [-400 400];

    %When Saccade aligned, still have 500 ms baseline + SRT.
    Align_Time = Align_Time + 500;
    % plot_time = (1:801)*4-3;
end


%build matrix of RF / anti-RFs

anti_index = 1;

if ismember(0,RF)
    RF_out(anti_index) = 4;
    anti_index = anti_index + 1;
end
if ismember(1,RF)
    RF_out(anti_index) = 5;
    anti_index = anti_index + 1;
end
if ismember(2,RF)
    RF_out(anti_index) = 6;
    anti_index = anti_index + 1;
end
if ismember(3,RF)
    RF_out(anti_index) = 7;
    anti_index = anti_index + 1;
end

if ismember(4,RF)
    RF_out(anti_index) = 0;
    anti_index = anti_index + 1;
end
if ismember(5,RF)
    RF_out(anti_index) = 1;
    anti_index = anti_index + 1;
end
if ismember(6,RF)
    RF_out(anti_index) = 2;
    anti_index = anti_index + 1;
end
if ismember(7,RF)
    RF_out(anti_index) = 3;
    anti_index = anti_index + 1;
end


if TrialType == 'c'
    triallist_in = ValidTrials(ismember(Target_(ValidTrials,2),RF));
    triallist_out = ValidTrials(ismember(Target_(ValidTrials,2),RF_out));

    SDF_in = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, triallist_in, TrialStart_);
    SDF_out = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, triallist_out, TrialStart_);

elseif TrialType == 'e'
    IncorrectTrials = find(Correct_(:,2) == 0);
    triallist_in = ValidTrials(ismember(Target_(ValidTrials,2),RF));
    triallist_in_errors = IncorrectTrials(ismember(saccLoc(IncorrectTrials),RF));

    SDF_in = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, triallist_in, TrialStart_);
    SDF_out = spikedensityfunct(Spike, Align_Time, SDFPlot_Time, triallist_in_errors, TrialStart_);

end



if plotOption == 1
    figure
    plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF_in,'r',SDFPlot_Time(1):SDFPlot_Time(2),SDF_out,'b')

    if TrialType == 'c'
        legend('Target in','Target out')
    elseif TrialType == 'e'
        legend('Correct','Error')
    end
end