%Displays summary statistics for SEARCH or MEMORY GUIDED session
%2/29/08 Richard P. Heitz
%  Vanderbilt University

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP OPTIONS


wavesFlag = 0;


%plot n total waveforms.  Based on this, figure out what "every xth
%waveform" needs to be to amount to n total waveforms.
waveform_decimation = 200; %how many total waveforms?

if exist('fileID')
    if ~isempty(strfind(fileID,'S'))
        monkey = 'S';
        ScullPos = {'Oz','T6','T5','C4','C3','F6','F5','LFP Left','LFP Right'};
        ASL_Delay = 1;
    else
        monkey = 'Q';
        ScullPos = {'T6','T5','LFP left','LFP right'};
        ASL_Delay = 0;
    end
else
    monkey = 'Q';
    ScullPos = {'T6','T5','LFP left','LFP right'};
    ASL_Delay = 0;
end


if exist('SRT') == 0
    [SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay);
end

getCellnames
fixErrors
CorrectTrials = correct
[ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);


%determine number of units to plot T_in vs. T_out for each cell
%if variabls 'RFs' exists, leave out cells with no defined RF
numUnits = 0;
if exist('RFs') == 0
    numUnits = length(CellNames);
else
    for x = 1:length(RFs)
        if ~isempty(RFs{x})
            numUnits = numUnits + 1;
        end
    end
end
%determine total number of channels with units so we can plot spikes
%superimposed for each channel
index = 1;
for c = 1:length(CellNames)
    for u = 2:32
        if ~isempty(strfind(mat2str(cell2mat(CellNames(c))),mat2str(u)))
            chanID(index) = u;
            index = index + 1;
        end
    end
end

numChannels = unique(chanID);

clear index c u chanID



%figure out how many cells we need to plot one T_in vs T_out for each
%neuron
% if numUnits <= 2
%     T_Dcells = [2 1];
% elseif numUnits > 2 & numUnits <= 4
%     T_Dcells = [2 2];
% elseif numUnits > 4 & numUnits <= 6
%     T_Dcells = [3 2];
% elseif numUnits > 6 & numUnits <= 9
%     T_Dcells = [3 3];
% else
%     disp('More neurons than script can account for...')
%     T_Dcells = [4 4];
% end

%break screen locations to plot both target and saccade aligned SDFs
if numUnits <= 1
    T_Dcells = [2 1];
elseif numUnits == 2
    T_Dcells = [2 2];
elseif numUnits == 3
    T_Dcells = [3 2];
elseif numUnits == 4
    T_Dcells = [2 4];
elseif numUnits == 5 | numUnits == 6
    T_Dcells = [3 4];
elseif numUnits == 7 | numUnits == 8
    T_Dcells = [4 4];
else
    disp('More neurons than script can account for...')
    T_Dcells = [5 5];
end


numAD = length(strmatch('AD',who));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN CALCULATIONS

%mean acc and rt x screen location
for loc = 0:7
    loc_acc(loc+1) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,2) == loc),2));
    loc_rt(loc+1) = mean(SRT(ValidTrials(find(Target_(ValidTrials,2) == loc)),1));
end

%mean acc and rt x set size
sz_acc(1) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,5) == 2),2));
sz_acc(2) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,5) == 4),2));
sz_acc(3) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,5) == 8),2));

sz_rt(1) = mean(SRT(Target_(ValidTrials,2) ~= 255 & Target_(ValidTrials,5) == 2,1));
sz_rt(2) = mean(SRT(Target_(ValidTrials,2) ~= 255 & Target_(ValidTrials,5) == 4,1));
sz_rt(3) = mean(SRT(Target_(ValidTrials,2) ~= 255 & Target_(ValidTrials,5) == 8,1));

%multidimensional array to store all data: trial x location x set size x
%homo/hetero

acc_array(1:10000,1:8,1:3,1:2) = NaN;
rt_array(1:10000,1:8,1:3,1:2) = NaN;

for loc = 0:7
    dimension = 1;
    for sz = [2 4 8]

        for homo = 0:1
            acctemp = Correct_(find(Target_(:,2) == loc & Target_(:,5) == sz & Target_(:,11) == homo),2);
            rttemp = SRT(ValidTrials(find(Target_(ValidTrials,2) == loc & Target_(ValidTrials,5) == sz & Target_(ValidTrials,11) == homo)),1);

            acc_array(1:length(acctemp),loc+1,dimension,homo+1) = acctemp;
            rt_array(1:length(rttemp),loc+1,dimension,homo+1) = rttemp;

            acctemp = [];
            rttemp = [];
        end
        dimension = dimension + 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTTING
%
%
%
%
% 0) SET UP SUBSUBPLOT
figure
set(gcf,'color','white')

%set up subsubplot
summaryPlot.sp = [1 3];

summaryPlot.c(1).sp = [2 1];
summaryPlot.c(1).c(1).sp = [2 1];
summaryPlot.c(1).c(2).sp = [3 3];
summaryPlot.c(2).sp = [2 1];
summaryPlot.c(2).c(1).sp = T_Dcells;
summaryPlot.c(2).c(2).sp = [length(numChannels) 1];
summaryPlot.c(3).sp = [numAD+1 1];

%if you want to see layout first...
%subsubplot_showlayout(summaryPlot);

handles = subsubplot(summaryPlot);

%turn off subsubplot's annoying dividers
axis(handles(1:length(handles)),'off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%.5 PRINT SOME TEXT REGARDING FEATURES OF SESSION
text(0,.7,['File: ' fileID '   Generated: ' date],'FontWeight','b','fontsize',12)
text(0,.55,['Total Number of Trials: ' mat2str(size(Target_,1))],'fontsize',12)
text(0,.4,['Target Hold Errors: ' mat2str(nansum(Errors_(:,4))) ' (' mat2str(round(nansum(Errors_(:,4)) / size(Target_,1) * 100)) '%)'],'fontsize',12)
text(0,.25,['# SRT Estimation Errors (Correct Trials - #Valid Trials): ' mat2str(length(CorrectTrials) - length(ValidTrials)) ' (' mat2str(round((length(CorrectTrials) - length(ValidTrials)) / length(CorrectTrials) * 100)) '%)'],'fontsize',12)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1) PLOT ACC BY SET SIZE / HOMO/HETEROGENOUS

%should not use series of "nanmean" because will be averaging
%averages...will not be quite as accurate
set2_homo = (nansum(nansum(acc_array(:,:,1,1)))) / length(find(~isnan(acc_array(:,:,1,1))));
set4_homo = (nansum(nansum(acc_array(:,:,2,1)))) / length(find(~isnan(acc_array(:,:,2,1))));
set8_homo = (nansum(nansum(acc_array(:,:,3,1)))) / length(find(~isnan(acc_array(:,:,3,1))));

set2_hete = (nansum(nansum(acc_array(:,:,1,2)))) / length(find(~isnan(acc_array(:,:,1,2))));
set4_hete = (nansum(nansum(acc_array(:,:,2,2)))) / length(find(~isnan(acc_array(:,:,2,2))));
set8_hete = (nansum(nansum(acc_array(:,:,3,2)))) / length(find(~isnan(acc_array(:,:,3,2))));

set2_mean = (nansum(nansum(nansum(acc_array(:,:,1,:))))) / length(find(~isnan(acc_array(:,:,1,:))));
set4_mean = (nansum(nansum(nansum(acc_array(:,:,2,:))))) / length(find(~isnan(acc_array(:,:,2,:))));
set8_mean = (nansum(nansum(nansum(acc_array(:,:,3,:))))) / length(find(~isnan(acc_array(:,:,3,:))));


plot(handles(1),[1 2 3],[set2_homo set2_hete set2_mean; set4_homo set4_hete set4_mean; set8_homo set8_hete set8_mean],'-o','LineWidth',2)
set(handles(1),'Xtick',1:1:3)
set(handles(1),'XTickLabel',[2 4 8])
set(handles(1),'outerposition',[-.065 .72 .4 .3])

xlim(handles(1),[.8 3.2])
ylim(handles(1),[0 1])%[.5 1])
legend(handles(1),'Homogeous','Heterogeneous','Mean','Location','SouthWest')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2) PLOT RTD'S BY SET SIZE


[set2_homo_rt,bins2_homo] = hist(SRT(Target_(CorrectTrials,5) == 2 & Target_(CorrectTrials,11) == 0,1),100);
[set4_homo_rt,bins4_homo] = hist(SRT(Target_(CorrectTrials,5) == 4 & Target_(CorrectTrials,11) == 0,1),100);
[set8_homo_rt,bins8_homo] = hist(SRT(Target_(CorrectTrials,5) == 8 & Target_(CorrectTrials,11) == 0,1),100);

[set2_hete_rt,bins2_hete] = hist(SRT(Target_(CorrectTrials,5) == 2 & Target_(CorrectTrials,11) == 1,1),100);
[set4_hete_rt,bins4_hete] = hist(SRT(Target_(CorrectTrials,5) == 4 & Target_(CorrectTrials,11) == 1,1),100);
[set8_hete_rt,bins8_hete] = hist(SRT(Target_(CorrectTrials,5) == 8 & Target_(CorrectTrials,11) == 1,1),100);

[set2_mean_rt,bins2_mean] = hist(SRT(Target_(CorrectTrials,5) == 2,1),100);
[set4_mean_rt,bins4_mean] = hist(SRT(Target_(CorrectTrials,5) == 4,1),100);
[set8_mean_rt,bins8_mean] = hist(SRT(Target_(CorrectTrials,5) == 8,1),100);

cdf_2_homo = cumsum(set2_homo_rt) ./ length(SRT(Target_(CorrectTrials,5) == 2 & Target_(CorrectTrials,11) == 0,1));
cdf_4_homo = cumsum(set4_homo_rt) ./ length(SRT(Target_(CorrectTrials,5) == 4 & Target_(CorrectTrials,11) == 0,1));
cdf_8_homo = cumsum(set8_homo_rt) ./ length(SRT(Target_(CorrectTrials,5) == 8 & Target_(CorrectTrials,11) == 0,1));

cdf_2_hete = cumsum(set2_hete_rt) ./ length(SRT(Target_(CorrectTrials,5) == 2 & Target_(CorrectTrials,11) == 1,1));
cdf_4_hete = cumsum(set4_hete_rt) ./ length(SRT(Target_(CorrectTrials,5) == 4 & Target_(CorrectTrials,11) == 1,1));
cdf_8_hete = cumsum(set8_hete_rt) ./ length(SRT(Target_(CorrectTrials,5) == 8 & Target_(CorrectTrials,11) == 1,1));

cdf_2_mean = cumsum(set2_mean_rt) ./ length(SRT(Target_(CorrectTrials,5) == 2,1));
cdf_4_mean = cumsum(set4_mean_rt) ./ length(SRT(Target_(CorrectTrials,5) == 4,1));
cdf_8_mean = cumsum(set8_mean_rt) ./ length(SRT(Target_(CorrectTrials,5) == 8,1));

[rt_mean,bins_mean] = hist(SRT(Target_(CorrectTrials,2) ~= 255,1),100);
cdf_mean = cumsum(rt_mean) ./ length(SRT(CorrectTrials,1));


plot(handles(2),bins2_mean,cdf_2_mean,bins4_mean,cdf_4_mean,bins8_mean,cdf_8_mean)
legend(handles(2),'Set Size 2', 'Set Size 4','Set Size 8','Location','SouthEast')
hold(handles(2));
plot(handles(2),bins_mean,cdf_mean,'--k','linewidth',2)
if ~isempty(regexp(newfile,'_MG')) %signals MG data - need larger window
    xlim(handles(2),[500 1500])
elseif ~isempty(regexp(newfile,'_SEARCH')) %signals SEARCH data - smaller window
    xlim(handles(2),[100 800])
end

set(handles(2),'outerposition',[-.065 .475 .4 .3])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3 PLOT ACC AND RTS BY SCREEN LOCATION AND SET SIZE

%find minimum accuracy rate to use for setting YLim
lowest_acc = 1;
for loc = 0:7
    for dim = 1:3
        for homo = 1:2
            if nanmean(acc_array(:,loc+1,dim,homo)) < lowest_acc
                lowest_acc = nanmean(acc_array(:,loc+1,dim,homo));
            end
        end
    end
end


for j = 0:7
    %Will be plotting with subplot, but need to specify where each
    %screen location will fall in subplot coordinates
    switch j
        case 0
            screenloc = 8;
        case 1
            screenloc = 5;
        case 2
            screenloc = 4;
        case 3
            screenloc = 3;
        case 4
            screenloc = 6;
        case 5
            screenloc = 9;
        case 6
            screenloc = 10;
        case 7
            screenloc = 11;
    end



    tempacc_2_homo = nansum(acc_array(:,j+1,1,1)) / length(find(~isnan(acc_array(:,j+1,1,1))));
    tempacc_4_homo = nansum(acc_array(:,j+1,2,1)) / length(find(~isnan(acc_array(:,j+1,2,1))));
    tempacc_8_homo = nansum(acc_array(:,j+1,3,1)) / length(find(~isnan(acc_array(:,j+1,3,1))));

    tempacc_2_hete = nansum(acc_array(:,j+1,1,2)) / length(find(~isnan(acc_array(:,j+1,1,2))));
    tempacc_4_hete = nansum(acc_array(:,j+1,2,2)) / length(find(~isnan(acc_array(:,j+1,2,2))));
    tempacc_8_hete = nansum(acc_array(:,j+1,3,2)) / length(find(~isnan(acc_array(:,j+1,3,2))));

    tempacc_2_mean = nansum(nansum(acc_array(:,j+1,1,:))) / length(find(~isnan(acc_array(:,j+1,1,:))));
    tempacc_4_mean = nansum(nansum(acc_array(:,j+1,2,:))) / length(find(~isnan(acc_array(:,j+1,2,:))));
    tempacc_8_mean = nansum(nansum(acc_array(:,j+1,3,:))) / length(find(~isnan(acc_array(:,j+1,3,:))));

    [set2_mean_rt,bins2_mean] = hist(SRT(Target_(CorrectTrials,5) == 2 & Target_(CorrectTrials,2) == j,1),100);
    [set4_mean_rt,bins4_mean] = hist(SRT(Target_(CorrectTrials,5) == 4 & Target_(CorrectTrials,2) == j,1),100);
    [set8_mean_rt,bins8_mean] = hist(SRT(Target_(CorrectTrials,5) == 8 & Target_(CorrectTrials,2) == j,1),100);

    cdf_2_mean = cumsum(set2_mean_rt) ./ length(SRT(Target_(CorrectTrials,5) == 2 & Target_(CorrectTrials,2) == j,1));
    cdf_4_mean = cumsum(set4_mean_rt) ./ length(SRT(Target_(CorrectTrials,5) == 4 & Target_(CorrectTrials,2) == j,1));
    cdf_8_mean = cumsum(set8_mean_rt) ./ length(SRT(Target_(CorrectTrials,5) == 8 & Target_(CorrectTrials,2) == j,1));


    plot(handles(screenloc),[1 2 3],[tempacc_2_homo tempacc_2_hete tempacc_2_mean; tempacc_4_homo tempacc_4_hete tempacc_4_mean; tempacc_8_homo tempacc_8_hete tempacc_8_mean],'-o','linewidth',2)

    set(handles(screenloc),'Xtick',[])
    if screenloc == 6
        set(handles(screenloc),'ytick',[0:.1:1])
        ax1 = handles(screenloc);
        ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','xtick',[],'ytick',[]);
        text(.95,.05,'0','fontweight','b','fontsize',10,'units','data')
        text(.95,.95,'1','fontweight','b','fontsize',10,'units','data')
        text(.95,.5,'.5','fontweight','b','fontsize',10,'units','data')
    else
        set(handles(screenloc),'ytick',[])
        set(handles(screenloc),'xtick',[])
    end
    xlim(handles(screenloc),[.8 3.2])
    ylim(handles(screenloc),[0 1])%[.5 1])

    %conditional formatting
    %     if j == 3
    %         set(handles(screenloc),'outerposition',[-.02 .32 .13 .21])
    %     elseif j == 4
    %         set(handles(screenloc),'outerposition',[-.02 .12 .13 .21])
    %     elseif j == 5
    %         set(handles(screenloc),'outerposition',[-.02 -.05 .13 .21])
    %     end
    %

    ax1 = handles(screenloc);
    ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','xtick',[],'ytick',[]);
    line(bins2_mean,cdf_2_mean,'Parent',ax2,'Color','b','linewidth',2)
    line(bins4_mean,cdf_4_mean,'Parent',ax2,'Color','g','linewidth',2)
    line(bins8_mean,cdf_8_mean,'Parent',ax2,'Color','r','linewidth',2)
    text(.60,.05,['Hold Errs: ' mat2str(nansum(Errors_(find(Target_(:,2) == j),4)))],'units','normalized','FontWeight','b')

    clear j tempacc_2_homo tempacc_4_homo tempacc_8_homo tempacc_2_hete tempacc_4_hete tempacc_8_hete ...
        set2_mean_rt bins2_mean set4_mean_rt bins4_mean set8_mean_rt bins8_mean clear cdf_2_mean cdf_4_mean cdf_8_mean
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4 PLOT T_IN VS D_IN FOR NEURONS WITH RF's DEFINED
if exist('RFs') == 1

    Align_Time_s(1:length(Correct_),1) = 500;
    Align_Time_r = SRT(:,1);
    %account for 500 ms baseline
    Align_Time_r = Align_Time_r + 500;

    for c = 1:length(RFs)
        if ~isempty(RFs{c})
            RF = RFs{c};
            anti_RF = getAntiRF(RF);
            Spike = eval(cell2mat(CellNames(c)));

            if ~isempty(regexp(newfile,'_MG')) %signals MG data - need larger window
                SDFPlot_Time_s = [-100 1500];
                SDFPlot_Time_r = [-400 100];
            elseif ~isempty(regexp(newfile,'_SEARCH')) %signals SEARCH data - smaller window
                SDFPlot_Time_s = [-100 400];
                SDFPlot_Time_r = [-400 100];
            end



            triallist_in = ValidTrials(ismember(Target_(ValidTrials,2),RF));
            triallist_out = ValidTrials(ismember(Target_(ValidTrials,2),anti_RF));

            SDF_in_s = spikedensityfunct(Spike, Align_Time_s, SDFPlot_Time_s, triallist_in, TrialStart_);
            SDF_in_r = spikedensityfunct(Spike, Align_Time_r, SDFPlot_Time_r, triallist_in, TrialStart_);
            SDF_out_s = spikedensityfunct(Spike, Align_Time_s, SDFPlot_Time_s, triallist_out, TrialStart_);
            SDF_out_r = spikedensityfunct(Spike, Align_Time_r, SDFPlot_Time_r, triallist_out, TrialStart_);

            screenloc = screenloc + 1;
            plot(handles(screenloc),SDFPlot_Time_s(1):SDFPlot_Time_s(2),SDF_in_s,'b',SDFPlot_Time_s(1):SDFPlot_Time_s(2),SDF_out_s,'r')
            set(handles(screenloc),'YTickLabel',[])
            set(handles(screenloc),'XTickLabel',[])
            xlim(handles(screenloc),SDFPlot_Time_s)
            ax1 = handles(screenloc);
            ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','xtick',[],'ytick',[]);
            text(.05,.95,mat2str(cell2mat(CellNames(c))),'fontweight','b','fontsize',10,'units','normalized')
            text(.05,.05,mat2str(SDFPlot_Time_s(1)),'fontweight','b','fontsize',10,'units','data')
            text(.85,.05,mat2str(SDFPlot_Time_s(2)),'fontweight','b','fontsize',10,'units','data')
            text(.05,.10,mat2str(round(min(min(SDF_in_s,SDF_out_s)))),'fontweight','b','fontsize',10,'units','data')
            text(.05,.85,mat2str(round(max(max(SDF_in_s,SDF_out_s)))),'fontweight','b','fontsize',10,'units','data')

            %             if screenloc == 12
            %                 legend(handles(screenloc),'Target in','Target out','NorthEast')
            %             end

            screenloc = screenloc + 1;
            plot(handles(screenloc),SDFPlot_Time_r(1):SDFPlot_Time_r(2),SDF_in_r,'b',SDFPlot_Time_r(1):SDFPlot_Time_r(2),SDF_out_r,'r')
            xlim(handles(screenloc),SDFPlot_Time_r)
            set(handles(screenloc),'YTickLabel',[])
            set(handles(screenloc),'XTickLabel',[])
            ax1 = handles(screenloc);
            ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','xtick',[],'ytick',[]);
            text(.05,.95,['RFs: ' mat2str(RF)],'fontweight','b','fontsize',10,'units','normalized')
            text(.05,.05,mat2str(SDFPlot_Time_r(1)),'fontweight','b','fontsize',10,'units','data')
            text(.85,.05,mat2str(SDFPlot_Time_r(2)),'fontweight','b','fontsize',10,'units','data')
            text(.05,.10,mat2str(round(min(min(SDF_in_r,SDF_out_r)))),'fontweight','b','fontsize',10,'units','data')
            text(.05,.85,mat2str(round(max(max(SDF_in_r,SDF_out_r)))),'fontweight','b','fontsize',10,'units','data')
           
        else
            c = c + 1;
        end
    end
end
clear ax1 ax2 c RF anti_RF SDFPlot_Time SDFPlot_Time_r SDFPlot_Time_s SDF_in_r SDF_in_s ...
    SDF_out_r SDF_out_s Spike




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%5 PLOT SPIKE WAVEFORMS

varlist = who;

wavelist = varlist(strmatch('waves_',varlist));

% for dex = 1:length(wavelist);
%
%
% for k = 1:numChannels
colors = ['r','g','b','c','m','y','k'];
color_index = 1;

for k = 1:length(numChannels)
    screenloc = 11 + (T_Dcells(1)*T_Dcells(2)) + k;
    hold(handles(screenloc));
    for c = 1:length(CellNames)
        %if current wave unit a member of current channel
        if ~isempty(strfind(mat2str(cell2mat(CellNames(c))),mat2str(numChannels(k))))
            temp = eval(['waves_' cell2mat(CellNames(c))]);
            %for j = 1:waveform_decimation:size(temp,1)
            for j = 1: floor(size(temp,1) / waveform_decimation) :size(temp,1)
                if wavesFlag == 1
                    %use option here because we need the counter variable 'k'
                    %below
                    eval(['plot(handles(screenloc),temp(j,:),' mat2str(colors(color_index)) ')'])
                end
            end
            plot(handles(screenloc),mean(temp),'k','linewidth',4)
            color_index = color_index + 1;
        end
    end
    color_index = 1;
    ax1 = handles(screenloc);
    ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','xtick',[],'ytick',[]);
    text(.05,.85,['Channel: ' mat2str(numChannels(k))],'fontweight','b','fontsize',13,'units','normalized')
    text(.05,.80,['Waveform Decimation = ' mat2str(waveform_decimation)],'fontweight','b','fontsize',13,'units','normalized')
end
clear temp k c j color_index colors


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%6 PLOT ERP and LFPs
Plot_Time_AD = [-500 2500];


for i = 0:numAD-1
    %note: advance relevant screenloc by T_Dcells(1)*T_Dcells(2) because we
    %may have more grids created than neurons for aesthetic purposes
    screenloc = 12 + (T_Dcells(1)*T_Dcells(2)) + length(numChannels) + i;
    temp = eval(cell2mat(Names_AD(i+1)));
    %use only correct trials
    temp = temp(CorrectTrials,:);
    plot(handles(screenloc),Plot_Time_AD(1):Plot_Time_AD(2),mean(temp))
    xlim(handles(screenloc),[-200 800])
    ylabel(handles(screenloc),mat2str(cell2mat(ScullPos(i+1))),'FontSize',11,'Fontweight','b')
    set(handles(screenloc),'YTickLabel',[])
    if i < numAD-1
        set(handles(screenloc),'XTickLabel',[])
    end
end

%maximize plot
maximize

clear Names_AD screenloc temp Plot_Time_AD i j k set2_hete set2_hete_rt set2_homo set2_homo_rt ...
    set2_mean set4_hete set4_hete_rt set4_homo set4_homo_rt set4_mean set8_hete ...
    set8_hete_rt set8_homo set8_homo_rt set8_mean sz sz_acc sz_rt tempacc_2_mean ...
    tempacc_4_mean tempacc_8_mean varlist waveform_decimation wavelist wavesFlag ...
    summaryPlot T_Dcells acc_array acctemp ax1 ax2 bins2_hete bins2_homo  bins4_homo ...
    bins4_hete bins8_hete bins8_homo bins_mean cdf_2_hete cdf_2_homo cdf_4_hete cdf_4_homo ...
    cdf_8_hete cdf_8_homo cdf_mean dimension endvar handles loc loc_acc loc_rt ...
    homo numAD numChannels numUnits rt_array rt_mean rttemp Align_ ScullPos x dim ...
    lowest_acc ASL_Delay