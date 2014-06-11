%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SEARCH DATA ANALYSIS
%
%   Runs on newer search files - older
%   search files do not immediately run
%   (e.g. 'fecfef_m.157')
%
%   Script will plot:
%       Eye Movements
%       Saccad latency measurements
%       ERPs
%       Accuracy rate by set size and screen location
%       RT by set size and screen location
%
%   Calls:
%       getSRT
%       getACC_RT_screenloc
%
%   9/27/2007
%   Richard P. Heitz
%   Vanderbilt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%OPEN FILE (if one not already loaded)
if exist('Decide_') == 0
    file_path = 'D:\Data\RawData\';
    [filename,file_path] = uigetfile([file_path,],'Choose MATLAB File to Process');
    load([file_path filename],'-mat');
else
    filename = '';
end

%CHECK FOR MEMORY GUIDED FILE
if max(Target_(:,2) > 1)
    disp('MEMORY GUIDED FILE DETECTED...ABORTING')
    %clear all
    return
end

%PLOT OPTIONS
eyeplotOption = 1;
AccRTPlotOption = 1;
saveOption = 0;


close all;
Align_Time = 500;


%Filter for errors & catch trials.
%If variable "ERRORS_" does not exist (older files), then just use the
%Correct_ variable.

if exist('Errors_') == 1
    CorrectTrials = find(Target_(:,2) ~= 255 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & Errors_(:,5) ~= 1 & Errors_(:,6) ~= 1);
else
    Errors_(1:length(Correct_),1:6) = 0;
    Errors_(:,6) = logical(Correct_(:,2) == 0);
    CorrectTrials = find(Correct_(:,2) == 1);
end
    


plot_time = (1:length(EyeX_))*4 - 3;


%CALL FUNCTION - GETSRT
[SRT] = getSRT(EyeX_,EyeY_,CorrectTrials);


if AccRTPlotOption == 1
    %CALL FUNCTION - GETACC_RT_SCREENLOC
    getACC_RT_screenloc(SRT,Errors_,Target_,CorrectTrials,filename);
end

varlist = who;
ADlist = varlist(find(strmatch('AD0',varlist)));

figure;
set(gcf,'Color','white');



%ERPs will be averages; Eye traces will be trial-by-trial;
%Plot ERPs
for ADchan = 1:length(ADlist)
    currAD = eval(cell2mat(ADlist(ADchan)));
    currMean = nanmean(currAD(CorrectTrials,:));
    subplot(4,3,ADchan + 3)
    plot(plot_time,currMean) 
    xlim([400 1500]);
    title(ADlist(ADchan));
    set(gca,'Xtick',400:100:1500);
    set(gca,'XTickLabel',-100:100:1000)
end

%Plot Eyes on each trial
if eyeplotOption == 1
    for nTrial = 1:size(CorrectTrials)
        text(2200,2,['Trial: ' mat2str(CorrectTrials(nTrial))],'FontWeight','bold')
        subplot(4,3,[1:3])
        plot(plot_time,EyeX_(CorrectTrials(nTrial),:),'Color','r')
        title(['File: ' mat2str(filename) '   Date Generated: ' date]);
        hold on
        plot(plot_time,EyeY_(CorrectTrials(nTrial),:),'Color','b')
        xlim([400 2500]);
        ylim([-3.2 3.2]);
        set(gca,'Xtick',400:50:2500)
        set(gca,'XTickLabel',-100:50:2000)

        %draw target onset time
        line([Align_Time Align_Time],[-2 2],'Color','g')

        %draw Tempo estimated saccade latency
        line([Decide_(CorrectTrials(nTrial),1) + 500 Decide_(CorrectTrials(nTrial),1) + 500], [-2 2],'Color','k')

        %draw Saccade onset estimated by "getSRT" function
        %SRT(CorrectTrials(nTrial))
        trialSacc = nonzeros(SRT(nTrial,:));
        for nSacc = 1:length(trialSacc)
            line([SRT(nTrial,nSacc) + 500 SRT(nTrial,nSacc)+500],[-2 2],'Color','b')
        end
        pause
        cla
    end
end

 