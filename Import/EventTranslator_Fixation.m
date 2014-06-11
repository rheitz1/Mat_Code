function [TrialStart_,Strobe_Times] = EventTranslator(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,Strobe_Times,Strobe_Values)

%Translates Events from .plx format and saves them to an output file
%INPUT:
%   file_path: folder where data files are kept and saved to
%   filename: .plx file
%   TrialStart_TimeStamps: Array of Trial Start times from Tempo (measured
%   in seconds)
%
%   outfile:    name of the output file to write to
%
%OUTPUT:
%   Returns TrialStart_ and Strobe_Times
%   Saves:
%
%Originally written by erik.emeric@vanderbilt.edu and
%pierre.pouget@vanderbilt.edu 6-24-2005
%
%NOTE: Strobe_Times and Strobe_Values are a subset of total, a result from
%the variables "Times_to_pass" and "Events_to_pass".  This should help
%avoid out of memory errors.


%edited and commented by richard.p.heitz@vanderbilt.edu 9-6-2007


disp(['Retrieving Events from...', [file_path,filename]])

%Get file infos
%
%CALL:   plx_information
% OpenedFileName    - returns the filename (useful if empty string is passed as filename)
% Version -  version code of the plx file format
% Freq -  timestamp frequency for waveform digitization
% Comment - user-entered comment
% Trodalness - 0,1 = single electrode, 2 = stereotrode, 4 = tetrode
% Number of Points Per Wave - number of samples in a spike waveform
% Pre Threshold Points - the sample where the threshold was crossed
% SpikePeakV - peak voltage in mV of the final spike A/D converter
% SpikeADResBits - resolution of the spike A/D converter (usually 12 bits)
% SlowPeakV - peak voltage of mV of the final analog A/D converter
% SlowADResBits - resolution of the analog A/D converter (usually 12 bits)
% Duration - the duration of the file in seconds
% DateTime - date and time string for the file
[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreThresh, SpikePeakV,...
    SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information([file_path,filename]);

Header_ = DateTime;

nTrials = length(TrialStart_TimeStamps);

%initialize TrialStart_ variable
TrialStart_(1:nTrials,1:2)=NaN;
Errors_(1:nTrials,1:5) = NaN;
Correct_(1:nTrials,1:2) = NaN;      %Was the trial correct
Decide_(1:nTrials,1:2) = NaN;       %Decision latency determined by Tempo
Target_(1:nTrials,1:12) = NaN;       %TARGET PARAMETERS
SaccDir_(1:nTrials,1) = NaN;
Stimuli_(1:nTrials,1:7) = NaN;
%Find all relevant events for current trial
%Relevant events will have time stamps that are >= start time of current
%trial and < time stamp on trial n + 1
%h = waitbar(0,'Sorting Events...');
for i = 1:nTrials
  %  waitbar(i / nTrials,h);

%     if i < nTrials
%         TrialEvents = find(Strobe_Times >= TrialStart_TimeStamps(i) & Strobe_Times < TrialStart_TimeStamps(i+1));
%     elseif i == nTrials
%         TrialEvents = find(Strobe_Times >= TrialStart_TimeStamps(i));
%     end

    if i > 1%nTrials
        TrialEvents = find(Strobe_Times <= TrialStart_TimeStamps(i) & Strobe_Times > TrialStart_TimeStamps(i-1));
    elseif i == 1
        TrialEvents = find(Strobe_Times <= TrialStart_TimeStamps(i));
    end
    
    

    %Store trial-relevenat values and times, respectively, in new variables
    TrialStrobeValues(i,1:length(TrialEvents)) = Strobe_Values(TrialEvents);
    TrialStrobeTimes(i,1:length(TrialEvents)) = Strobe_Times(TrialEvents);

    
    
    %***IMPORTANT NOTE
    %TRIALSTART_ variable will hold **Target** onset times based on
    %EVENT002, so is the correct time stamp for array onset.
    %***This value is multiplied by 1000 to convert seconds into
    %milliseconds (ms), then 500 ms is subtracted so that we will
    %retain a 500 ms baseline.
%     TrialStart_(i,1) = ceil(target_on_Evt2(i)*1000) - 500;
% 
%     %if there is an abort, limit search space up until the abort code
%     if ~isempty(find(TrialStrobeValues(i,:) == 2621))
%         relevant = min(find(TrialStrobeValues(i,:) == 2621));
%     else
%         relevant = min(length(TrialStrobeValues(i,:)));
%     end

    %find Error Codes
    %Types of Errors
    %Column:
    %1 = CatchError
    %2 = HoldError
    %3 = Latency Error
    %4 = Target Hold Error
    %5 = Saccade Direction Error

%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 2622,1))
%         Errors_(i,1) = 1;
%     end
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 2623,1))
%         Errors_(i,2) = 1;
%     end
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 2624,1))
%         Errors_(i,3) = 1;
%     end
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 2625,1))
%         Errors_(i,4) = 1;
%     end
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 2626,1))
%         Errors_(i,5) = 1;
%     end
% 
% 
%     %Correct/Incorrect (1/0)
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3034,1))
%         Correct_(i,2) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3034,1) + 1);
%     end
% 
%     %Tempo calculated saccade latency
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3035,1))
%         Decide_(i,1) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3035,1) + 1);
%     end
% 
%     %Target align time
%     Target_(i,1) = ceil(target_on_Evt2 (i)*1000)-TrialStart_(i);
% 
%     %Target location (255 = catch trial)
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3013,1))
%         Target_(i,2) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3013,1) + 1);
%     end
% 
%     %%%%% TARGET COLOR
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3008,1))
%         Target_(i,3) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3008,1) + 1);
%     end
% 
% 
%     %Min Target Color (CLUT value; higher values = BRIGHTER [more white])
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3009,1))
%         Target_(i,4) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3009,1) + 1);
%     end
% 
%     %Set Size
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3005,1))
%         Target_(i,5) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3005,1) + 1);
%         if Target_(i,5) == 0
%             Target_(i,5) = 2;
%         elseif Target_(i,5) == 1
%             Target_(i,5) = 4;
%         elseif Target_(i,5) == 2
%             Target_(i,5) = 8;
%         end
%     end
% 
% 
%     %SET SIZE CONDITION (0 = 2; 1 = 4; 2 = 8; 3 = random
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3004,1))
%         Target_(i,6) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3004,1) + 1);
%     end
% 
%     % Easy hard  Target type
%     %must index to LAST '3007' to find correct value.  I do not
%     %understand this coding scheme...
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3007,1))
%         Target_(i,7) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3007,1,'last') - 1);
%         Target_(i,8) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3007,1,'last') + 1);
%     end
% 
%     %Task Type  (0 = fixation; 1 = detection; 2 = search/MG??
% 
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3003,1))
%         Target_(i,9) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3003,1) + 1);
%     end
% 
%     %Hold Time (use to determine search or memory guided)
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3021,1))
%         Target_(i,10) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3021,1) + 1);
%     end
% 
%     %Homogeneous/Inhomogeneous
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3032,1))
%         Target_(i,11) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3032,1) + 1);
%     end
% 
%     %Eccentricity
%     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 3001,1))
%         Target_(i,12) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == 3001,1) + 1);
%     end
%     
%     %Actual Saccade Location
%     for pos = 0:7
%         if ~isempty(find(TrialStrobeValues(i,1:relevant) == pos + 7000,1))
%             SaccDir_(i,1) = pos;
%         end
%     end
%     
% %     
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7001,1))
% %         SaccDir_(i,1) = 1;
% %     end
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7002,1))
% %         SaccDir_(i,1) = 2;
% %     end
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7003,1))
% %         SaccDir_(i,1) = 3;
% %     end
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7004,1))
% %         SaccDir_(i,1) = 4;
% %     end
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7005,1))
% %         SaccDir_(i,1) = 5;
% %     end
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7006,1))
% %         SaccDir_(i,1) = 6;
% %     end
% %     if ~isempty(find(TrialStrobeValues(i,1:relevant) == 7007,1))
% %         SaccDir_(i,1) = 7;
% %     end
%     
%     %Actual Stimuli Presented
%     
%     for pos = 0:7
%         if ~isempty(find(TrialStrobeValues(i,1:relevant) == pos + 6000,1))
%             Stimuli_(i,pos + 1) = TrialStrobeValues(i,find(TrialStrobeValues(i,1:relevant) == pos + 6000,1) + 1);
%         end
%     end
% end


%SAVE VARIABLES
% disp('Saving...Errors_, Correct_, Target_, TrialStart_, Decide_ SaccDir, Stimuli_')
% save([file_path,outfile],'TrialStart_','Decide_','SaccDir_','Stimuli_','-mat')
% %close(h)



