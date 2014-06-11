%==============================================
%   MEMORY GUIDED ANALYSIS
%
%   Plots SDFs by screen location aligned on 
%   target onset and on saccade onset
%
%
%
%   10/12/2007
%   Richard P. Heitz
%   Vanderbilt
%===============================================

%OPEN FILE (if one not already loaded)
if exist('Decide_') == 0
    file_path = 'D:\Data\RawData\';
    [filename,file_path] = uigetfile([file_path,],'Choose MATLAB File to Process');
    load([file_path filename],'-mat');
else
    filename = '';
end

%CHECK FOR MEMORY GUIDED FILE AND FILES WHERE TASK IS NOT CLEAR
if isempty(find(Target_(:,9) == 2))
    disp('MEMORY GUIDED OR UNCLEAR TASK TYPE DETECTED....ABORTING')
    %clear all
  %  return
end

%============PLOT OPTIONS==========
%
eyeplotOption = 1;
SDFplotOption = 1;
Acc_CDF_SDF_Option = 1;
saveOption = 0;
SDF_raster_Option = 0;
%
%==================================


close all;
Align_Time(1:length(Correct_),1) = 500;
SDFPlot_Time = [-500 2000];
plot_time = (1:length(EyeX_))*4 - 3;

%Filter for errors & catch trials.
%If variable "ERRORS_" does not exist (older files), then just use the
%Correct_ variable.
%Newer files might also have the Errors_ variable because the translation
%code puts it there, even though it has no meaning.  check

if exist('Errors_') == 1
    if isempty(find(~isnan(Errors_(:,:))))
        Errors_(1:length(Correct_),1:6) = NaN;
        Errors_(find(Correct_(:,2) == 0),6) = 0;
        CorrectTrials = find(Correct_(:,2) == 1);
    else
        CorrectTrials = find(Target_(:,2) ~= 255 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & Errors_(:,5) ~= 1 & Errors_(:,6) ~= 1);
    end
else
    Errors_(1:length(Correct_),1:6) = NaN;
    Errors_(find(Correct_(:,2) == 0),6) = 1;
    CorrectTrials = find(Correct_(:,2) == 1);
end


%======================================================
%
% Function call - "getSRT"
%   -estimates saccadic RT based on X and Y eye traces
%
%======================================================

[SRT] = getSRT(EyeX_,EyeY_,CorrectTrials);


%Find DSP channels
varlist = who;

%find indices of cell names
Cells = varlist(strmatch('DSP',varlist));

%is there neural data?
if isempty(Cells) || SDFplotOption == 0
    areCells = 0;
else
    areCells = 1;
end

%remove hash cells (end with "i")
if areCells == 1
    m = 1;
    for j = 1:length(Cells)
        if isempty(strfind(cell2mat(Cells(j)),'i') > 0)
            CellNames(m,1) = Cells(j);
            m = m + 1;
        end
    end

    
%==========================================================================
% 
% Function call - "getSDF"
%   -dimensions are: SDF(time[rows], screen location[columns],set size,cell
%
%==========================================================================

%Form a multidimensional array containing ALL spike data from all neurons
    %CALL FUNCTION - GETSDF
    for cell_num = 1:length(CellNames)
        %[SDF(:,:,:,cell_num), SDF_loc_collapse(:,:,cell_num),SDF_sz_collapse(:,:,cell_num),SDF_all_Collapse(:,cell_num)] =  getSDF(eval(cell2mat(CellNames(cell_num))),Errors_,Target_,CorrectTrials,Align_Time,SDFPlot_Time,TrialStart_);
        [SDF(:,:,:,cell_num), SDF_loc_collapse(:,:,cell_num)] =  getSDF(eval(cell2mat(CellNames(cell_num))),Errors_,Target_,CorrectTrials,Align_Time,SDFPlot_Time,TrialStart_);
    end
end


%==============================================
%
% Function call - "SDF_raster"
%   -plots SDFs and rasters by screen location
%
%==============================================

if SDF_raster_Option == 1
    for cell_num = 1:length(CellNames)
        SDF_raster(SDF,eval(cell2mat(CellNames(cell_num))),CellNames(cell_num),CorrectTrials,Target_,SDFPlot_Time,cell_num)
    end
end

%===========================================
%
% Function call getACC_RT_screenloc
%   -plots:
%       -accuracy rates by set size
%       -CDFs by set size
%       -SDFs by screen location and cell
%       -everything by screen location
%
%============================================
if Acc_CDF_SDF_Option == 1
    %CALL FUNCTION - GETACC_RT_SCREENLOC
    if areCells == 1
        getACC_RT_screenloc(SRT,Errors_,Target_,CorrectTrials,filename,areCells,plot_time,SDFPlot_Time,CellNames,SDF);
    else
        getACC_RT_screenloc(SRT,Errors_,Target_,CorrectTrials,filename,areCells);
    end
end

varlist = who;
ADlist = varlist(find(strmatch('AD0',varlist)));


%====================================================
%
% Trial-by-trial plotting of eye traces as well as
% average ERPs
%
%====================================================
if eyeplotOption == 1
    h = figure;
    set(gcf,'Color','white');
    
    
    %Plot Average ERPs
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

    for nTrial = 1:size(CorrectTrials)
        figure(h)
        text(2200,2,['Trial: ' mat2str(CorrectTrials(nTrial))],'FontWeight','bold')
        subplot(4,3,[1:3])
        plot(plot_time,EyeX_(CorrectTrials(nTrial),:),'Color','r')
        title(['File: ' mat2str(filename) '   Date Generated: ' date]);
        hold on
        plot(plot_time,EyeY_(CorrectTrials(nTrial),:),'Color','b')
        xlim([400 2500]);
        ylim([-3.2 3.2]);
        set(gca,'Xtick',400:100:2500)
        set(gca,'XTickLabel',-100:100:2000)
        set(gca,'FontSize',8)

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

