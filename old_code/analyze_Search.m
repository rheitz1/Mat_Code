%==============================================
%   SEARCH DATA ANALYSIS
%
%   Runs on newer search files - older
%   search files do not immediately run
%   (e.g. 'fecfef_m.157')
%
%   Script will plot:
%       Eye Movements
%       Saccade latency measurements
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
%===============================================


%============PLOT OPTIONS==========
%%Do you want to align on stimulus (s) or response (r) ?
Align_ = 's';
%Do you want to plot eye traces for each trial?
eyeplotOption = 1;
%Do you want to plot SDFs and rasters by screen location?
SDF_raster_Option = 0;
%Behavioral data?
Acc_CDF_SDF_Option = 0;
%Do you want to superimpose SDFs on behavioral data?
SDFplotOption = 0;
%Wanna save?
saveOption = 0;
%
%
%==================================
%Determine monkey
if exist('newfile')
    if strfind(newfile,'S') == 1
        monkey = 'S';
        ASL_Delay = 1;
    else
        monkey = 'Q';
        ASL_Delay = 0;
    end
else
    monkey = 'Q';
    ASL_Delay = 0;
end

close all


%OPEN FILE (if one not already loaded)
if exist('Decide_') == 0
    file_path = 'C:\Data\ToTranslate\Translate_Done';
    [filename,file_path] = uigetfile([file_path,],'Choose MATLAB File to Process');
    load([file_path filename],'-mat');
else
    filename = '';
end

%======================================================
%
% Script call: fixErrors
% will determine if the Errors_ variable exists
%   if it does and it has 1's and 0's in column 6, then
%   it is a newer file
%   if it does and it has all NaN's, its an older file
%   translated using new translation code
%   if it does not, will be added
eval('fixErrors')
%======================================================


%======================================================
%
% Function call - "getSRT"
%   -estimates saccadic RT based on X and Y eye traces
if exist('SRT') == 0
    [SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay);
end
%======================================================

%======================================================
%
% Function call - 'findValid'
%  -finds all valid trials by comparing estimated SRT
%   with Decide_ variable from Tempo
[ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);
%======================================================



%==========OPTIONS=====================================
if Align_ == 's'
    Align_Time(1:length(Correct_),1) = 500;
    SDFPlot_Time = [-200 2000];
    plot_time = (1:2500)*4-3;
elseif Align_ == 'r'
    Align_Time = getSRT(EyeX_,EyeY_);
    Align_Time = Align_Time(:,1);
    SDFPlot_Time = [-400 400];
    plot_time = (1:801)*4-3;
end
%=====================================================





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
%CellNames = [];
if areCells == 1
    m = 1;
    for j = 1:length(Cells)
        if isempty(strfind(cell2mat(Cells(j)),'i') > 0)
            CellNames(m,1) = Cells(j);
            m = m + 1;
        end
    end


    %=====================================================================
    %
    % Function call - "getSDF"
    %

    %Form a multidimensional array of SDFs collapsing on location and on
    %set size
    %CALL FUNCTION - GETSDF
    if ~isempty(Cells)
        for cell_num = 1:length(CellNames)
            %[SDF(:,:,:,cell_num), SDF_loc_collapse(:,:,cell_num),SDF_sz_collapse(:,:,cell_num),SDF_all_Collapse(:,cell_num)] =  getSDF(eval(cell2mat(CellNames(cell_num))),Errors_,Target_,CorrectTrials,Align_Time,SDFPlot_Time,TrialStart_);
            [SDF_loc_collapse(:,:,cell_num), SDF_sz_collapse(:,:,cell_num)] =  getSDF(eval(cell2mat(CellNames(cell_num))),Errors_,Target_,CorrectTrials,Align_Time,SDFPlot_Time,TrialStart_);
        end
    else
        disp('Only hash cells found - unsorted?')
    end
    %====================================================================


end


%==============================================
%
%  call Script- "SDF_screeloc_raster"
%   -plots SDFs and rasters by screen location
%   -I left this as a script so that it can be
%   easily used as a stand-alone program as well
%   as a function
%
if SDF_raster_Option == 1
    if areCells == 0
        eval('SDF_screenloc_raster')
    else
        disp('SDF_screenloc_raster option set to 1, but no neural data found')
    end
end
%==============================================




%===========================================
%
% Function call getACC_RT_screenloc
%   -plots:
%       -accuracy rates by set size
%       -CDFs by set size
%       -SDFs by screen location and cell
%       -everything by screen location
%
if Acc_CDF_SDF_Option == 1
    %CALL FUNCTION - GETACC_RT_SCREENLOC
    if areCells == 1 & ~isempty(CellNames)
        getACC_RT_screenloc(SRT,Correct_,Errors_,Target_,ValidTrials,filename,areCells,plot_time,SDFPlot_Time,CellNames,SDF_loc_collapse,SDF_sz_collapse);
    else
        areCells = 0;
        getACC_RT_screenloc(SRT,Correct_,Errors_,Target_,ValidTrials,filename,areCells);
    end
end
%===========================================


if eyeplotOption == 1

    %build a list of AD channels in current file
    varlist = who;
    ad_list = varlist(strmatch('AD',varlist));

    for i = 1:length(ad_list)
        vars_ad_list(i) = strcat(ad_list(i),',');
    end

    vars_ad_list = cell2mat(vars_ad_list(1:end));
    %remove trailing comma...
    vars_ad_list = vars_ad_list(1:end-1);

    %============CALL FUNCTION plotEyeTraces_ADchan===========================
    %Using eval allows me to build the function arguments dynamically
    %based on the number of AD channels present.
    eval(['plotEyeTraces_ADchan(EyeX_,EyeY_,SRT,CorrectTrials,ValidTrials,Decide_,plot_time,Align_Time,ad_list,' str2mat(vars_ad_list) ')'])
end