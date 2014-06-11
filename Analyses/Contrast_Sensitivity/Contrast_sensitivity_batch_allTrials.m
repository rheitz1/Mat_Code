%Richard P. Heitz
%Vanderbilt
%6/20/07
% %Plot SDFs by screen location
% %Use to find cell's RF
%
%maxspike = 0;
%create a list of all variables in workspace
tic
clear all
close all

q = ''''; c = ','; qcq = [q c q];

batch_list = dir('C:\Data\Search_Data\');

    %!!NOTE:: If ContrastFlag == 1, then make sure we are not saving PDFs
    %from SDF_screenloc_raster.  ContrastFlag == 0 will run the wrong
    %fixErrors routine.
    SDF_screenlocFlag = 1;
    ContrastFlag = 1;
    BurstFlag = 0;
    BurstSaveFlag = 0;
    LFPflag = 1;

for i = 1:length(batch_list)
    %     disp('Press key to begin next file...')
    %     pause
    close all
    file_path = 'C:\Data\ToTranslate\';
    cd 'C:\Data\ToTranslate\'

    eval(['load(',q,file_path,batch_list(i).name,qcq,'-mat',q,')'])
    
    %recompute 'file_path' because some files have it saved as something
    %wrong
    file_path = 'C:\Data\ToTranslate\';
    batch_list(i).name

    %Fix Luminance Values
    %fixLuminance;
    %fixLuminance_no_correct_eccentricity
    fixLuminance_visible

    %DRAW RASTER script
    
    if SDF_screenlocFlag == 1
        eval('SDF_screenloc_raster_allTrials')
    else
        %when SDF_screenloc_raster_allTrials is not run, will not have
        %Errors_ or ValidTrials variables. FIX THIS - IT IS NOT ELEGANT
        if exist('ContrastFlag') == 1
            if ContrastFlag == 1
                eval('fixErrors_CONTRAST')
            else
                eval('fixErrors')
            end
        else
            eval('fixErrors')
        end
        
        SRT = getSRT_old(EyeX_,EyeY_,ASL_Delay);
        
        if exist('ValidTrials') == 0
            [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);
        end
    end
    
    
    %========Call Script 'getCellnames'=========
    % Call script getCellnames
      eval('getCellnames')
    %===========================================


    for k = 1:length(CellNames)
%         orient landscape;
%         set(gcf,'Color','white')
        % CellName = eval(cell2mat(CellNames(k)));
        TotalSpikes = eval(cell2mat(CellNames(k)));


        if BurstFlag == 1
            %Get burst onset times from P_BURST
            %=======FUNCTION CALL 'getBurst' ===========================
            %Get bursts for current cell
            [BurstBegin,BurstEnd,BurstSurprise,BurstStartTimes] = getBurst(TotalSpikes);
            %===========================================================

            %rename variable coincident with current cell in use
            eval(['BurstStart_' cell2mat(CellNames(k)) ' = BurstBegin;' ]);
            eval(['BurstEnd_' cell2mat(CellNames(k)) ' = BurstEnd;' ]);
            eval(['BurstSurprise_' cell2mat(CellNames(k)) ' = BurstSurprise;' ]);
            eval(['BurstStartTimes_' cell2mat(CellNames(k)) ' = BurstStartTimes;' ]);
        end

        %Save Bursts if option is selected
        if BurstSaveFlag == 1
            save([file_path batch_list(i).name],eval([q,'BurstStartTimes_' cell2mat(CellNames(k)),q]),'-append','-mat')
        end
            
            
        if ContrastFlag == 1 && BurstFlag == 1
            Contrast_sensitivity_new_allTrials(RFs{k},batch_list(i).name,CellNames(k),TotalSpikes,Target_,Correct_,Errors_,ValidTrials,TrialStart_,BurstStartTimes);
        elseif ContrastFlag == 1 && BurstFlag == 0
            Contrast_sensitivity_new_allTrials(RFs{k},batch_list(i).name,CellNames(k),TotalSpikes,Target_,Correct_,Errors_,ValidTrials,TrialStart_);
        end

        if LFPflag == 1
            %Find appropriate LFP channels
            varlist = who;
            tempname = mat2str(cell2mat(CellNames(k)));
            tempname1 = tempname(end-3:end-2);
            LFPchan = strcat('AD',tempname1);
            LFPchan = eval(LFPchan);

            %%NOTE: variable "BurstBegin" will be the correct one only
            %%because it was just set to the current DSP channel.

            %=======FUNCTION CALL 'LFP_allTrials'==========================
            LFP_allTrials(LFPchan,RFs{k},batch_list(i).name,CellNames(k),TotalSpikes,Target_,Correct_,Errors_,ValidTrials,TrialStart_);

            %==============================================================
        end
    end
    keep batch_list file_path q c qcq SDF_screenlocFlag ContrastFlag BurstFlag BurstSaveFlag LFPflag
end
toc