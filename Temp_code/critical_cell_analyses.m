%Critical cell analyses

%reads from "cell_list.txt"
tic
close all
clear all

saveFlag = 1;

[file_list cell_list] = textread('temp.txt','%s %s');




for i = 1:size(file_list,1)

    load(file_list{i},'-mat')
    file_list{i}
    %set luminance values
    fixLuminance_with_ungunnable
    spikes = eval(cell_list{i});
    %find relevant RFs
    varlist = who;

    %remove hash cells if they exist
    varlist = who;
    cells = varlist(strmatch('DSP',varlist));
    m = 1;
    for j = 1:length(cells)
        if isempty(strfind(cell2mat(cells(j)),'i') > 0)
            varlist_clean(m) = cells(j);
            m = m + 1;
        end
    end



    y = strmatch(cell_list{i},varlist_clean);
    RF = RFs{y};



    %CV_LV analyses
    [CV_all,LV_all] = getCVLV(spikes,TrialStart_);
    CV(i,1) = nanmedian(CV_all);
    LV(i,1) = nanmedian(LV_all);

    %firing rate analyses
    %take max firing rate within window
    window = [50 200];
    cut1 = 1.5;
    cut2 = 2.5;

    %Set SDF parameters
    Align_Time_=Target_(:,1);
    %Align_Time_ = SaccBegin(:,1) + 500
    Plot_Time=[-200 1000];


    Lows = find(ismember(Target_(:,2),RF) & Target_(:,13) < cut1 & Target_(:,3) > 1);
    Mids = find(ismember(Target_(:,2),RF) & Target_(:,13) >= cut1 & Target_(:,13) < cut2 & Target_(:,3) > 1);
    Highs = find(ismember(Target_(:,2),RF) & Target_(:,13) >= cut2 & Target_(:,3) > 1);

    [SDF_Low] = spikedensityfunct_lgn_old(spikes, Align_Time_, Plot_Time, Lows, TrialStart_);
    [SDF_Mid] = spikedensityfunct_lgn_old(spikes, Align_Time_, Plot_Time, Mids, TrialStart_);
    [SDF_High] = spikedensityfunct_lgn_old(spikes, Align_Time_, Plot_Time, Highs, TrialStart_);


    MaxRate(i,1) = nanmax(SDF_Low(window(1) + 200:window(2) + 200));
    MaxRate(i,2) = nanmax(SDF_Mid(window(1) + 200:window(2) + 200));
    MaxRate(i,3) = nanmax(SDF_High(window(1) + 200:window(2) + 200));


    %Percentage max analyses
    crit = .5*max(SDF_Low);
    start_time_low_percent(i,1) = find(SDF_Low(200:end) > crit,1);
    crit = .5*max(SDF_Mid);
    start_time_mid_percent(i,1) = find(SDF_Mid(200:end) > crit,1);
    crit = .5*max(SDF_High);
    start_time_high_percent(i,1) = find(SDF_High(200:end) > crit,1);



    %Burst Onset analyses, based on SDF
    catvar = [];
    for j = 1:size(Lows)
        catvar = cat(1,catvar,spikes(Lows(j),:)');
    end

    catvar = sort(catvar);
    catvar = nonzeros(catvar);
    %find repeats
    for j = 2:size(catvar)
        if catvar(j) == catvar(j-1)
            catvar(j,2) = 1;
        end
    end


    %remove repeats so ISI distribution does not fail
    catvar = catvar(find(catvar(:,2) == 0),1);
    %------------------


    [BOB,EOB,SOB] = P_BURST(catvar,min(catvar(:,1)),max(catvar(:,1)));

    %link cell references from P_BURST to actual spike times
    start_Times_low = catvar(BOB')-500;
    start_time_low(i,1) = start_Times_low(find(start_Times_low(:,1) > 10,1));



    catvar = [];
    for j = 1:size(Mids)
        catvar = cat(1,catvar,spikes(Mids(j),:)');
    end

    catvar = sort(catvar);
    catvar = nonzeros(catvar);
    %find repeats
    for j = 2:size(catvar)
        if catvar(j) == catvar(j-1)
            catvar(j,2) = 1;
        end
    end


    %remove repeats so ISI distribution does not fail
    catvar = catvar(find(catvar(:,2) == 0),1);
    %------------------


    [BOB,EOB,SOB] = P_BURST(catvar,min(catvar(:,1)),max(catvar(:,1)));

    %link cell references from P_BURST to actual spike times
    start_Times_mid = catvar(BOB')-500;
    start_time_mid(i,1) = start_Times_mid(find(start_Times_mid(:,1) > 10,1));

    catvar = [];
    for j = 1:size(Highs)
        catvar = cat(1,catvar,spikes(Highs(j),:)');
    end

    catvar = sort(catvar);
    catvar = nonzeros(catvar);
    %find repeats
    for j = 2:size(catvar)
        if catvar(j) == catvar(j-1)
            catvar(j,2) = 1;
        end
    end


    %remove repeats so ISI distribution does not fail
    catvar = catvar(find(catvar(:,2) == 0),1);
    %------------------


    [BOB,EOB,SOB] = P_BURST(catvar,min(catvar(:,1)),max(catvar(:,1)));

    %link cell references from P_BURST to actual spike times
    start_Times_high = catvar(BOB')-500;
    start_time_high(i,1) = start_Times_high(find(start_Times_high(:,1) > 10,1));




    figure
    orient landscape
    subplot(1,3,1)
    plot(Plot_Time(1):Plot_Time(2),SDF_Low,'r')
    xlim([-200 500])
    title('Low')
    %mark onset detected by poisson burst
    line([start_time_low(i,1) start_time_low(i,1)],[min(SDF_Low) max(SDF_Low)],'color','g')
    %mark onset detected by 50% of max firing rate
    line([start_time_low_percent(i,1) start_time_low_percent(i,1)],[min(SDF_Low) max(SDF_Low)],'color','m')

    subplot(1,3,2)
    plot(Plot_Time(1):Plot_Time(2),SDF_Mid,'b')
    xlim([-200 500])
    title('Mid')
    %mark onset detected by poisson burst
    line([start_time_mid(i,1) start_time_mid(i,1)],[min(SDF_Mid) max(SDF_Mid)],'color','g')
    %mark onset detected by 50% of max firing rate
    line([start_time_mid_percent(i,1) start_time_mid_percent(i,1)],[min(SDF_Mid) max(SDF_Mid)],'color','m')


    subplot(1,3,3)
    plot(Plot_Time(1):Plot_Time(2),SDF_High,'k')
    xlim([-200 500])
    title('High')
    %mark onset detected by poisson burst
    line([start_time_high(i,1) start_time_high(i,1)],[min(SDF_High) max(SDF_High)],'color','g')
    %mark onset detected by 50% of max firing rate
    line([start_time_high_percent(i,1) start_time_high_percent(i,1)],[min(SDF_High) max(SDF_High)],'color','m')


    if saveFlag == 1
        eval(['print -dpdf ',cell2mat(file_list(i)),'_',cell2mat(cell_list(i)),'_onset.pdf']);
    end


    close all


    keep saveFlag file_list cell_list CV LV MaxRate i start_time_low start_time_mid start_time_high start_time_low_percent start_time_mid_percent start_time_high_percent
end

figure
subplot(2,2,1)
set(gcf,'color','white')
hist(CV)
title('CV')
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.5 .5 .5])
xlim([0 2.5])

subplot(2,2,2)
hist(LV)
title('LV')
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.5 .5 .5])
xlim([0 2.5])
toc