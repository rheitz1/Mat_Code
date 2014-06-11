function [] = getACC_RT_screenloc(SRT,Correct_,Errors_,Target_,ValidTrials,filename,areCells,plot_time,SDFPlot_Time,CellNames,SDF_loc_collapse,SDF_sz_collapse)

%get acc & srt mean by location
%To maintain correct acc rates, remember never to take means of means.
%Take a mean only 1 time.  The below holds accs and RTs for each screen
%location, collapsing over set size
for loc = 0:7
    loc_acc(loc+1) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,2) == loc),2));
    loc_rt(loc+1) = mean(SRT(ValidTrials(find(Target_(ValidTrials,2) == loc)),1));
end

%get acc mean by set size
%Again, take a mean only once.  The below hold accuracy rates for each set
%size, collapsing over location.  (I do not plot mean RT for set size,
%irrespective of location, so that is not coded below.
sz_acc_mean(1) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,5) == 2),2));
sz_acc_mean(2) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,5) == 4),2));
sz_acc_mean(3) = mean(Correct_(find(Target_(:,2) ~= 255 & Target_(:,5) == 8),2));

%get acc array by set size and location
dex = 1;

%We must initialize this variable to NaN's because otherwise, MatLab will
%fill in empty cells with 0's.  That's bad for calculating accuracy.  Huge
%matrix created for cases of huge numbers of trials.
loc_sz_acc(1:10000,1:8,1:3) = NaN;
for loc = 0:7
    dimension = 1;
    for sz = [2 4 8]
        temp = Correct_(find(Target_(:,2) ~= 255 & Target_(:,2) == loc & Target_(:,5) == sz),2);
        loc_sz_acc(1:length(temp),loc+1,dimension) = temp;
        dimension = dimension + 1;
    end
end

%get SRT array by set size and location
dex = 1;
for loc = 0:7
    dimension = 1;
    for sz = [2 4 8]
        temp = SRT(ValidTrials(find(Target_(ValidTrials,5) == sz & Target_(ValidTrials,2) == loc)),1);
        temp_total = SRT(ValidTrials(find(Target_(ValidTrials,2) == loc)),1);

        loc_sz_rt(1:length(temp),loc+1,dimension) = temp;

        [RTs,bins] = hist(temp,100);
        [RTs_total,bins_total] = hist(temp_total,100);

        RT_cdf(1:100,loc+1,dimension) = (cumsum(RTs))/length(temp) * 100;
        RT_cdf_total(1:100,loc+1) = (cumsum(RTs_total))/length(temp_total) * 100;

        RT_bins(1:100,loc+1,dimension) = bins;
        RT_bins_total(1:100,loc+1) = bins_total;

        temp = [];
        dimension = dimension + 1;
    end
end


%get SRT matrix by screen location
figure
set(gcf,'Color','white')
%title(['File: ' filename '  Date Generated' date]);

for j = 0:7
    %Will be plotting with subplot, but need to specify where each
    %screen location will fall in subplot coordinates
    switch j
        case 0
            screenloc = 6;
        case 1
            screenloc = 3;
        case 2
            screenloc = 2;
        case 3
            screenloc = 1;
        case 4
            screenloc = 4;
        case 5
            screenloc = 7;
        case 6
            screenloc = 8;
        case 7
            screenloc = 9;
    end

    %find minimum accuracy rate to use for setting YLim
    lowest_acc = 1;
    for dim = 1:3
        for loc = 0:7
            if nanmean(loc_sz_acc(:,loc+1,dim)) < lowest_acc
                lowest_acc = nanmean(loc_sz_acc(:,loc+1,dim));
            end
        end
    end

    %Find # of Target Hold Errors for this screen location
    %NOTE: TYPICALLY, when there are calibration problems with the eye
    %tracker, they will manifest in an elevated target hold error.  That
    %is, a saccade will be to the correct location but because of loss of
    %calibration, the saccade will fall out of the target window.  Such
    %problems will also lead to DirectionErrors, but not as frequently.
    %This will at least be enough to diagnose problems with specific screen
    %locations

    curr_TargHoldErr = nansum(Errors_(find(Target_(:,2) == j & Target_(:,2) ~= 255),4));

    if lowest_acc < .5
        low_y = lowest_acc;
    else
        low_y = .5;
    end

    subplot(3,3,screenloc)

    for i = 1:3
        tempACCarray(i) = nanmean(loc_sz_acc(:,j+1,i));
    end

    plot(tempACCarray,'-o','LineWidth',2,'MarkerFaceColor','b','MarkerEdgeColor','b')
    hold on
    plot(.5,loc_acc(j+1),'s','MarkerFaceColor','b')
    set(gca,'Xtick',1:1:3)
    set(gca,'XTickLabel',[2 4 8])
    set(gca,'Ytick',((floor(low_y*10))/10):.1:1)
    axis([.5 3.5 ((floor(low_y*10))/10) 1])

    %keep track of current axis settings so can superimpose
    ax1 = gca;
    ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none');
    line(RT_bins(:,j+1,1),RT_cdf(:,j+1,1),'Parent',ax2,'Color','r')
    line(RT_bins(:,j+1,2),RT_cdf(:,j+1,2),'Parent',ax2,'Color','g')
    line(RT_bins(:,j+1,3),RT_cdf(:,j+1,3),'Parent',ax2,'Color','b')
    line(RT_bins_total(:,j+1),RT_cdf_total(:,j+1),'Parent',ax2,'Color','k','LineWidth',2)
    hold on
    plot(loc_rt(j+1),100,'s','Color','r','MarkerFaceColor','r')
    title(strcat('nRT =  ','   TargHoldErrors = ',mat2str(curr_TargHoldErr)),'FontWeight','bold')


    %Plot SDFs in this screen location
    %COLLAPSE OVER SET SIZES
    %3rd dimension now only = 1.
    if areCells == 1 && ~isempty(CellNames)
        hold all
        for cellnum = 1:length(CellNames)
            %plot SDF, but normalize by dividing by maximum firing rate, then
            %multiple by 100 to put on same scale as other plots
            %plot(0:2000,SDF_sz_collapse(500:2500,j+1,cellnum),'Parent',ax2,'LineWidth',1)
            plot(SDFPlot_Time,SDF_sz_collapse(1:2501,j+1,cellnum),'Parent',ax2,'LineWidth',1)
        end
    end

    xlim([0 500])
    set(gca,'FontSize',10)

    set(gca,'ytick',[])


    if areCells == 1
        ylabel(['CDF Cumulative % / Firing Rate'])
    end
end


%Get overall CDFs by set size
dex = 1;
for sz = [2 4 8]
    temp = SRT(ValidTrials(find(Target_(ValidTrials,5) == sz)),1);
    temp_total = SRT(ValidTrials(:,1));


    [RTs,bins] = hist(temp,100);
    [RTs_total,bins_total] = hist(temp_total,100);

    RT_cdf(1:100,dex) = (cumsum(RTs))/length(temp) * 100;
    RT_cdf_total = (cumsum(RTs_total))/length(temp_total)*100;

    RT_bins(1:100,dex) = bins;
    RT_bins_total = bins_total;

    temp = [];
    dex = dex + 1;
end


%plot final position
subplot(3,3,5)
plot(sz_acc_mean,'-o','LineWidth',2,'MarkerFaceColor','b','MarkerEdgeColor','b')
set(gca,'Xtick',1:1:3)
set(gca,'XTickLabel',[2 4 8])
%draw Yticks from nearest .1 to 1 (multiply fraction by 1, round,
%then convert back
set(gca,'Ytick',((floor(low_y*10))/10):.1:1)
axis([.5 3.5 ((floor(low_y*10))/10) 1])

%plot overall accuracy rate
hold on
plot(.5,nanmean(Correct_(find(Target_(:,2) ~= 255),2)),'s','Color','b','MarkerFaceColor','b')

ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none');
line(RT_bins(:,1),RT_cdf(:,1),'Color','r')
line(RT_bins(:,2),RT_cdf(:,2),'Color','g')
line(RT_bins(:,3),RT_cdf(:,3),'Color','b')
line(RT_bins_total,RT_cdf_total,'Color','k','LineWidth',2)


axis([0 2000 0 100])
xlabel('SRT: OVERALL')
set(gca,'ytick',[])

%plot overall SRTs
hold on
plot(nanmean(SRT(ValidTrials,1)),100,'s','Color','r','MarkerFaceColor','r')

[ax,h1] = suplabel('Set Size');
set(h1,'FontSize',15)
[ax,h2] = suplabel('% Correct','y');
set(h2,'FontSize',15)
[ax,h3] = suplabel(strcat('Filename:       ',filename,'Generated: ',date),'t');
set(h3,'FontSize',8)


end