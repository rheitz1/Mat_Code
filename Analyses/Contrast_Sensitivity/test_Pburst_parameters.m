%function [] = Contrast_2008(file_path, fileID)
%CONTRAST SENSITIVITY
%Richard P. Heitz
% 3/5/08

%Note: Script written to include all trials
%We are looking primarily at visual responses, which should
%obtain for correct and error trials


saveFlag = 1;

outdir = 'C:\Documents and Settings\Administrator\Desktop\Mat_Code\Analyses\Contrast Sensitivity\PDF\test_PBurst_Parameters\';


%load appropriate file
f_path = 'C:\Data\Search_Data\';
[file_name cell_name] = textread('vis-vismove_MG_temp.txt', '%s %s');


Align_ = 's';
extension = 'all';

for file = 1:size(file_name,1)
    load([f_path cell2mat(file_name(file))])

    Align_Time(1:size(Target_,1),1) = 500;
    Plot_Time = [-50 300];


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


    fixErrors


    %find 'valid' Correct trials
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);

    %=============================
    %run scripts
    getCellnames
    %fixErrors


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


    TotalSpikes = eval(cell2mat(cell_name(file)));
    inTrials = find(ismember(Target_(:,2),RF));
    %outTrials = find(ismember(Target_(:,2),anti_RF));


    Spikes = TotalSpikes(inTrials,:);





    figure
    orient landscape
    hold
    [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',cell2mat(cell_name(file)),'   Generated: ',date),'t');
    set(h3,'FontSize',12)

    
    for sig = [.05 .01]
        plotPos = 1;
        for minSpks = 2:5
            for anchor = 0:50:200

                subplot(4,5,plotPos)

                if ~isempty(Spikes)
                    %Get bursts for current cell
                    [BurstBegin,BurstEnd,BurstSurprise,BurstStartTimes] = getBurst_testparams(Spikes,minSpks,anchor,sig);
                    %rename variable coincident with current cell in use

                    med = nanmedian(BurstBegin(:,1));
                    clear med
                end

                %========================================================================



                %===================================================================
                % HIGH, MED, LOW analyses
                %===================================================================

                %For this analysis, I (mostly) disregard gunned luminance values and focus
                %instead on finding the lower bound of stimuli that *I* could visibly see
                %when dark adapted.  Then, I used the previous gunned luminance values to
                %find natural groupings.  Appears that low contrast can be between 0 and
                %.32, medium up to 2, and high thereafter.  This has the advantage of
                %including more data, while grouping your 170's and 173s together in the
                %same category.
                %Also, no correction is made for eccentricity, as this may not actually
                %matter.  This will also help to include more data, particularly those
                %files that had the eccentricity changed mid-session.


                %first set all values to NaN
                Target_(:,13) = NaN;


                %================ S E T   L U M I N A N C E   V A L U E S ========
                %=================================================================

                %set critical values in each of three groups to categorical numbers
                %includes CLUT of 140, which was ungunnable but clearly visible
                %when dark adapted.  Low-range files will lose approx. half of its
                %data, beginning at 101 and up to 137, which are not included by
                %the below criterias
                Target_(find(Target_(:,3) >= 140 & Target_(:,3) < 160),13) = 1;
                Target_(find(Target_(:,3) >= 160 & Target_(:,3) < 190),13) = 2;
                Target_(find(Target_(:,3) >= 190),13) = 3;




                lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);
                cut1 = 1.5;
                cut2 = 2.5;
                lum(1) = min(Target_(find(Target_(:,3) > 1),3));
                lum(2) = max(Target_(find(Target_(:,3) > 1),3));

                Lows = find(ismember(Target_(:,2),RF) & Target_(:,13) < cut1);
                Mids = find(ismember(Target_(:,2),RF) & Target_(:,13) >= cut1 & Target_(:,13) < cut2);
                Highs = find(ismember(Target_(:,2),RF) & Target_(:,13) >= cut2);

                SDF_low = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,Lows, TrialStart_);
                SDF_mid = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,Mids, TrialStart_);
                SDF_high = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,Highs, TrialStart_);

                %Get Burst onset times for low, med, and high
                temp = BurstStartTimes;



                %====================
                %%% BURSTS, 3 GRP %%%
                Burst_low = nanmedian(temp(ismember(inTrials,Lows)));
                Burst_mid = nanmedian(temp(ismember(inTrials,Mids)));
                Burst_high = nanmedian(temp(ismember(inTrials,Highs)));

                BurstArray = [Burst_low Burst_mid Burst_high];

                set(gcf,'Color','white')

                %% Plot SDFs, 3 grp
                plot(Plot_Time(1):Plot_Time(2),SDF_low,'r',Plot_Time(1):Plot_Time(2),SDF_mid,'b',Plot_Time(1):Plot_Time(2),SDF_high,'k','LineWidth',2)
                line([Burst_low Burst_low],[0 SDF_low(ceil(Burst_low + abs(Plot_Time(1))))],'Color','r','LineWidth',2)
                line([Burst_mid Burst_mid],[0 SDF_mid(ceil(Burst_mid + abs(Plot_Time(1))))],'Color','b','LineWidth',2)
                line([Burst_high Burst_high],[0 SDF_high(ceil(Burst_high + abs(Plot_Time(1))))],'Color','k','LineWidth',2)
                %legend('Low','Med','High','Location','NorthWest')
                ylim([min(min([SDF_low SDF_mid SDF_high])) max(max([SDF_low SDF_mid SDF_high]))])
                xlim(Plot_Time)
                title(mat2str(BurstArray))

                plotPos = plotPos + 1;
                maximize


            end
        end

        if saveFlag == 1
            eval(['print -dpdf ',mat2str(outdir),cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'-',round(mat2str(sig)),'.pdf']);
        end
        close all
    end
end

keep file extension Align_ f_path file_name cell_name saveFlag outdir
% clear Align_Time Plot_Time Lows Mids Highs cut1 cut2 lum lum_spacing SDF_in ...
%     TotalSpikes Spikes x k DrawSDFs BurstFlag BurstSaveFlag med temp lumarray ...
%     lum_onset inTrials


