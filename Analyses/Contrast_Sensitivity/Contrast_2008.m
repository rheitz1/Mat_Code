%function [] = Contrast_2008(file_path, fileID)
%CONTRAST SENSITIVITY
%Richard P. Heitz
% 3/5/08

%Note: Script written to include all trials
%We are looking primarily at visual responses, which should
%obtain for correct and error trials

Plot_Time = [-50 300];
LFP_Plot_Time = [-500 2500];
%===============
%Set Options
PDFflag = 1;
DrawSDFs = 1;
BurstFlag = 1;
BurstSaveFlag = 0;
%===============

%initialize some variables
maxFire_all = [];
Burst_Record = {};
lum_onset = [];

%read in files and neurons
f_path = 'C:\Data\Search_Data\';
%[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
%[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
[file_name cell_name] = textread('new.txt', '%s %s');


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
    disp([file_name(file) cell_name(file)])

    load([f_path cell2mat(file_name(file))])
    Align_Time(1:size(Target_,1),1) = 500;

    %Get all cells in file
    getCellnames

    %find relevant RFs
    for cl = 1:length(CellNames)
        if strmatch(cell_name(file),CellNames(cl)) == 1
            RF = RFs{cl};
            cel = cl;
        end
    end




    if isempty(RF)
        disp('RFs for cell not found!  Aborting...')
        return
    end

    %clear irrelevant variables
    eval(['keep ' cell2mat(CellNames(cel)) ' lum_onset Burst_Record maxFire_all LFP_Plot_Time PDFflag Align_Time BurstFlag BurstSaveFlag Correct_ Decide_ Errors_ Plot_Time RF SRT Target_ TrialStart_ cell_name cl f_path file fileID file_name newfile' ])

    %get anti_RF for plotting T_in vs D_in
    anti_RF = getAntiRF(RF);

    inTrials = find(ismember(Target_(:,2),RF));
    outTrials = find(ismember(Target_(:,2),anti_RF));

    %get CellNames again (should only have one left after clearing all rest
    getCellnames

    TotalSpikes = [];
    %correct Cell name will always be 1st one as long as only one in
    %workspace
    TotalSpikes = eval(cell2mat(CellNames(1)));
    Spikes = TotalSpikes(inTrials,:);

    if ~isempty(Spikes)
        SDF_in = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,inTrials, TrialStart_);
        SDF_out = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,outTrials, TrialStart_);
    end



    %
    %         %=================================
    %         if DrawSDFs == 1;
    %             %Call Script
    %             SDF_screenloc_raster_allTrials
    %         end
    %         %================================
    %
    %
    %         %=========================================================================
    %         %%% SET OPTIONS %%%
    %
    if BurstFlag == 1
        %check for spikes
        if ~isempty(Spikes)
            %Get bursts for current cell
            [BurstBegin,BurstEnd,BurstSurprise,BurstStartTimes] = getBurst(Spikes);
            %rename variable coincident with current cell in use
            eval(['BurstStart_' cell2mat(cell_name(file)) ' = BurstBegin;' ]);
            eval(['BurstEnd_' cell2mat(cell_name(file)) ' = BurstEnd;' ]);
            eval(['BurstSurprise_' cell2mat(cell_name(file)) ' = BurstSurprise;' ]);
            eval(['BurstStartTimes_' cell2mat(cell_name(file)) ' = BurstStartTimes;' ]);

            clear BurstBegin BurstEnd BurstSurprise BurstStartTimes
            % plot(Plot_Time(1):Plot_Time(2),SDF_in)
            eval(['temp = BurstStartTimes_' cell2mat(cell_name(file)) ';']);
            med = nanmedian(temp(:,1));
            %  line([med med],[0 SDF_in(ceil(med + abs(Plot_Time(1))))],'Color','r','LineWidth',2)
            % title(['Onset Time = ' mat2str(med) '  Cell: ' mat2str(cell2mat(CellNames(k)))])

            clear temp med
        end
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

    %     %Get Burst onset times for low, med, and high
    eval(['temp = BurstStartTimes_' cell2mat(cell_name(file)) ';']);
    temp = temp(:,1);


    %====================
    %%% BURSTS, 3 GRP %%%
    Burst_low = nanmedian(temp(ismember(inTrials,Lows)));
    Burst_mid = nanmedian(temp(ismember(inTrials,Mids)));
    Burst_high = nanmedian(temp(ismember(inTrials,Highs)));

    if isnan(Burst_low) == 1
        Burst_low = 0;
    end
    if isnan(Burst_mid) == 1
        Burst_mid = 0;
    end
    if isnan(Burst_high) == 1
        Burst_high = 0;
    end

    %Keep record of Burst onsets
    Burst_Record(file,1) = file_name(file);
    Burst_Record(file,2) = cell_name(file);
    Burst_Record(file,3) = mat2cell(Burst_low);
    Burst_Record(file,4) = mat2cell(Burst_mid);
    Burst_Record(file,5) = mat2cell(Burst_high);



    %=======================
    %%% BURSTS, ARRAY  %%%
    lumarray = unique(Target_(:,3));
    lumarray = lumarray(find(lumarray > 3));

    for x = 1:length(lumarray)
        lum_onset(file,x) = nanmedian(temp(ismember(Target_(inTrials,3),lumarray(x))));
    end

    if BurstSaveFlag == 1
        save([f_path 'Burst_Record'],'Burst_Record','-mat')
        save([f_path 'lum_onset'],'lum_onset','-mat')
    end


    %%%% SAVE BURSTS %%%%
    if BurstSaveFlag == 1

    end


    %=================================
    %%%% GET SLOPE OF BURST LINES %%%%




    %============================
    %%%% PEAK AMPLITUDE, 3 GRP %%%%
    maxFire_Low = max(SDF_low);
    maxFire_Mid = max(SDF_mid);
    maxFire_High = max(SDF_high);

    maxFire_all(file,1) = maxFire_Low;
    maxFire_all(file,2) = maxFire_Mid;
    maxFire_all(file,3) = maxFire_High;
    %==============================
    %%%% PEAK AMPLITUDE, ARRAY %%%%
    for x = 1:length(lumarray)
        SDF = [];
        SDF = spikedensityfunct(TotalSpikes,Align_Time,Plot_Time,inTrials(Target_(inTrials,3) == lumarray(x)), TrialStart_);
        lum_SDF(1:length(SDF),x) = SDF;
        lum_max(x) = max(SDF);
    end


    %============================
    %%%% GET SLOPE OF AMPLITUDES %%%%




    %         %===================
    %         %%%% SPIKE WIDTH %%%%
    %         %Spike interpolation:
    %         %   used 800 micro-s waveform length
    %         %   sampling at 40 kHz, gives us 32 points/waveform
    %         %   to obtain 1-ms resolution, must interpolate with spline
    %         %   yielding 800 points
    %
    %         %get mean spike waveform
    %         eval(['mean_wave = nanmean(waves_' cell2mat(CellNames(k)) ');'])
    %
    %         x = 1:length(mean_wave);
    %         %generate interpolant points
    %         xx = linspace(0,32,800);
    %         yy = spline(x,mean_wave,xx);
    %
    %         %find max and min points
    %         [ma, max_index] = max(yy);
    %         [mi, min_index] = min(yy);
    %
    %         spike_width = xx(max_index) - xx(min_index);
    %         clear mean_wave x xx yy ma mi max_index min_index
    %
    %         %====================
    %         %%%% CV / LV %%%%
    %         [Cv,Lv] = getCVLV(TotalSpikes,TrialStart_);


    %=============================
    %%% ACC RATES %%%
    % Note: low acc rates may be an indication
    % that stimuli could not be seen.  Accuracy is typically
    % very high for MG task.

    Acc_Low = nanmean(Correct_(Lows,2));
    Acc_Mid = nanmean(Correct_(Mids,2));
    Acc_High = nanmean(Correct_(Highs,2));
    Acc = [Acc_Low Acc_Mid Acc_High];

    %=================================================
    %%% LFPs %%%

    cl = cell_name{file};
    ADname = ['AD' cl(end-2:end-1)];
    load([f_path cell2mat(file_name(file))],ADname)
    ADchan = eval(ADname);


    %inclue all screen locations for LFP analyses until we have hemisphere
    %coded for all files using only DSP04a (could be left or right
    %hemisphere)
    LFP_l = find(Target_(:,13) < cut1);
    LFP_m = find(Target_(:,13) >= cut1 & Target_(:,13) < cut2);
    LFP_h = find(Target_(:,13) >= cut2);

    LFP_lows = nanmean(ADchan(LFP_l,:));
    LFP_mids = nanmean(ADchan(LFP_m,:));
    LFP_highs = nanmean(ADchan(LFP_h,:));

    %for LFPs, code by hemifield, leaving upper and lower out of
    %analyses NOTE then that "left_hemi_Lows" actually includes
    %trials in which the target appeared in the RIGHT hemifield
    %             right_hemi_Lows = find(ismember(Target_(:,2),[7 0 1]) & Target_(:,13) < cut1);
    %             right_hemi_Mids = find(ismember(Target_(:,2),[7 0 1]) & Target_(:,13) >= cut1 & Target_(:,13) < cut2);
    %             right_hemi_Highs = find(ismember(Target_(:,2),[7 0 1]) & Target_(:,13) >= cut2);
    %
    %             left_hemi_Lows = find(ismember(Target_(:,2),[3 4 5]) & Target_(:,13) < cut1);
    %             left_hemi_Mids = find(ismember(Target_(:,2),[3 4 5]) & Target_(:,13) >= cut1 & Target_(:,13) < cut2);
    %             left_hemi_Highs = find(ismember(Target_(:,2),[3 4 5]) & Target_(:,13) >= cut2);
    %


    %         tempname = mat2str(cell2mat(CellNames(k)));
    %         tempname1 = tempname(end-3:end-2);
    %         LFP = strcat('AD',tempname1);
    %         LFP = eval(LFP);
    %
    %         %check left vs. right LFP.  Assume that odd numbered LFP
    %         %channels are left and even are right
    %         if mod(str2num(tempname1),2) == 1
    %             hemi = 'left';
    %         elseif mod(str2num(tempname1),2) == 0
    %             hemi = 'right';
    %         end
    %
    %         %For LFPs, group by hemifield, leaving upper and lower out of
    %         %all analyses
    %




    %================================================
    %================================================
    %%%% PLOTTING %%%%

    f = figure;
    orient landscape
    set(gcf,'Color','white')
    %     subplot(6,4,1)

    subplot(2,3,1)
    % Plot SDFs, 3 grp
    plot(Plot_Time(1):Plot_Time(2),SDF_low,'r',Plot_Time(1):Plot_Time(2),SDF_mid,'b',Plot_Time(1):Plot_Time(2),SDF_high,'k','LineWidth',2)
    line([Burst_low Burst_low],[0 SDF_low(ceil(Burst_low + abs(Plot_Time(1))))],'Color','r','LineWidth',2)
    line([Burst_mid Burst_mid],[0 SDF_mid(ceil(Burst_mid + abs(Plot_Time(1))))],'Color','b','LineWidth',2)
    line([Burst_high Burst_high],[0 SDF_high(ceil(Burst_high + abs(Plot_Time(1))))],'Color','k','LineWidth',2)
    legend('Low','Med','High','Location','NorthWest')
    ylim([min(min([SDF_low SDF_mid SDF_high])) max(max([SDF_low SDF_mid SDF_high]))])
    xlim(Plot_Time)
    title([cell2mat(file_name(file)) '  ' cell2mat(cell_name(file)) '  ' date])
    %    title(['Cell: ' mat2str(cell2mat(CellNames(k))) ' RFs = ' mat2str(RF)])

    % Plot all SDFs
    subplot(2,3,6)
    hold on
    %plot(Plot_Time(1):Plot_Time(2),lum_SDF(:,1),'Color',[.95 .95 .95],Plot_Time(1):Plot_Time(2),lum_SDF(:,2),'Color',[.9 .9 .9],Plot_Time(1):Plot_Time(2),lum_SDF(:,3),'Color',[.8 .8 .8],Plot_Time(1):Plot_Time(2),lum_SDF(:,4),'Color',[.7 .7 .7],Plot_Time(1):Plot_Time(2),lum_SDF(:,5),'Color',[.6 .6 .6],Plot_Time(1):Plot_Time(2),lum_SDF(:,6),'Color',[.5 .5 .5],Plot_Time(1):Plot_Time(2),lum_SDF(:,7),'Color',[.4 .4 .4],Plot_Time(1):Plot_Time(2),lum_SDF(:,8),'Color',[.3 .3 .3],Plot_Time(1):Plot_Time(2),lum_SDF(:,9),'Color',[.2 .2 .2],Plot_Time(1):Plot_Time(2),lum_SDF(:,10),'Color',[.1 .1 .1],Plot_Time(1):Plot_Time(2),lum_SDF(:,11),'Color',[0 0 0])
    for x = 1:11
        plot(Plot_Time(1):Plot_Time(2),lum_SDF(:,x),'Color',[((length(lumarray)+1)-x)/length(lumarray) ((length(lumarray)+1)-x)/length(lumarray) ((length(lumarray)+1)-x)/length(lumarray)])
    end


    ylim([min(min(lum_SDF)) max(max(lum_SDF))])
    xlim(Plot_Time)
    set(gca,'FontSize',6)
    %legend(mat2str(lumarray(1)),mat2str(lumarray(2)),mat2str(lumarray(3)),mat2str(lumarray(4)),mat2str(lumarray(5)),mat2str(lumarray(6)),mat2str(lumarray(7)),mat2str(lumarray(8)),mat2str(lumarray(9)),mat2str(lumarray(10)),mat2str(lumarray(11)),'Location','NorthWest')

    %
    %         %Plot Burst onset times, 3 grps
    subplot(2,3,2)
    plot([Burst_low Burst_mid Burst_high],'-or','LineWidth',1.5,'MarkerFaceColor','r','MarkerSize',5)
    set(gca,'XTick',1:1:3)
    set(gca,'XTickLabel',[' Low';' Med';'High'])
    ylabel('Burst onset (ms)')
    xlim([.5 3.5])
    ylim([min([Burst_high Burst_mid Burst_low] - 10) max([Burst_high Burst_mid Burst_low] + 10)])

    %
    %Plot Bust onset times, all
    subplot(6,4,13)
    plot(lum_onset(1:end),'-or','LineWidth',1.5,'MarkerFaceColor','r','MarkerSize',5)
    ylim([min(lum_onset) - 10 max(lum_onset) + 10])
    xlim([0 12])
    xlabel('CLUT value')
    ylabel('Burst onset (ms)')
    set(gca,'XTickLabel',[lumarray(1);lumarray(2);lumarray(3);lumarray(4);lumarray(5);lumarray(6);lumarray(7);lumarray(8);lumarray(9);lumarray(10);lumarray(11)])

    %
    %         %Plot SDF amplitudes, 3 grps
    subplot(2,3,3)
    plot([maxFire_Low maxFire_Mid maxFire_High],'-or','LineWidth',1.5,'MarkerFaceColor','r','MarkerSize',5)
    set(gca,'XTick',1:1:3)
    set(gca,'XTickLabel',[' Low';' Med';'High'])
    ylabel('Peak Firing rate (sp/s)')
    xlim([.5 3.5])
    ylim([min([maxFire_Low maxFire_Mid maxFire_High] - 10) max([maxFire_Low maxFire_Mid maxFire_High] + 10)])


    %Plot LFPs
    subplot(2,3,4)
    plot(LFP_Plot_Time(1):LFP_Plot_Time(2),LFP_lows,'r',LFP_Plot_Time(1):LFP_Plot_Time(2),LFP_mids,'b',LFP_Plot_Time(1):LFP_Plot_Time(2),LFP_highs,'k')
    xlim(Plot_Time)

    %Plot Acc rates and luminance range
    subplot(2,3,5)
    bar(Acc,.5)
    ylim([0 1])
    ylabel('Proportion Correct','FontWeight','bold');
    set(gca,'XTickLabel',{'Low';'Medium';'High'},'FontWeight','bold')
    set(gcf,'Color','white')
    title(['nLow = ' mat2str(length(Lows)) ' nMid = ' mat2str(length(Mids)) ' nHigh = ' mat2str(length(Highs))])
    %Plot contrast range on secondary axis
    ax1 = gca;
    ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
    hold on
    ylim([0 1])
    xlim([90 250])
    %xlabel('CLUT index [higher = brighter]','FontWeight','bold')
    set(gca,'ytick',[])

    line([lum(1) lum(2)],[1 1],'marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','LineWidth',3,'Color','r')




    %Plot SDF amplitudes, all
    subplot(6,4,21)
    plot(lum_max(1:end),'-or','LineWidth',1.5,'MarkerFaceColor','r','MarkerSize',5)
    ylim([min(lum_max) - 10 max(lum_max) + 10])
    xlim([0 12])
    xlabel('CLUT value')
    ylabel('Peak Firing rate (sp/s)')
    set(gca,'XTickLabel',[lumarray(1);lumarray(2);lumarray(3);lumarray(4);lumarray(5);lumarray(6);lumarray(7);lumarray(8);lumarray(9);lumarray(10);lumarray(11)])

    %Plot left hemisphere LFPs, 3 grps, if it exists
    if exist('LFP_left_low') == 1
        %left hemisphere LFP data exists

        subplot(6,4,2)
        plot(-500:2500,LFP_left_low,'r',-500:2500,LFP_left_mid,'b',-500:2500,LFP_left_high,'k')
        ylim([min([LFP_left_low LFP_left_mid LFP_left_high]) max([LFP_left_low LFP_left_mid LFP_left_high])])
        xlim([Plot_Time(1) Plot_Time(2)])
        title(['Left LFP'])
        ylabel(['Amplitude mV'])
    end


    if exist('LFP_right_low') == 1
        %right hemisphere LFP data exists
        subplot(6,4,3)
        plot(-500:2500,LFP_right_low,'r',-500:2500,LFP_right_mid,'b',-500:2500,LFP_right_high,'k')
        ylim([min([LFP_right_low LFP_right_mid LFP_right_high]) max([LFP_right_low LFP_right_mid LFP_right_high])])
        xlim([Plot_Time(1) Plot_Time(2)])
        title(['Right LFP'],'FontWeight','b')
        ylabel(['Amplitude mV'])
    end
end
maximize
outdir = 'C:\Data\Analyses\Contrast Sensitivity 2008\PDF\';

if PDFflag == 1
    outdir = 'C:\Data\Analyses\Contrast_2008\SDF_LFP_Burst\';
    eval(['print -dpdf ',outdir,cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'_SDF_LFP.pdf']);
end

close(f)
keep lum_onset Burst_Record maxFire_all LFP_Plot_Time PDFflag BurstFlag BurstSaveFlag Plot_Time cell_name f_path file file_name






