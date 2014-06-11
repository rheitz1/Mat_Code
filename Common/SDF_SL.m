% Plots SDFs, rasters, and SRT CDFs by screen location
% align = alignment even (s = stimulus / r = response)
% trials = trials you want to use (e.g., error trials, T_in, etc.);
% Defaults to all correct trials
% rasterFlag controls whether or not rasters are plotted for each screen
% location and center position for all trials (can be time consuming)

% Stand-alone for SDF_screenloc_raster
% RPH 3/28/09

function [] = SDF_SL(Spike,align,Plot_Time,trials,rasterFlag)

Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
TrialStart_ = evalin('caller','TrialStart_');
Errors_ = evalin('caller','Errors_');
Correct_ = evalin('caller','Correct_');

fixErrors

if nargin < 5; rasterFlag = 0; end
if nargin < 4; trials = find(Correct_(:,2) == 1); end

if nargin < 3
    if align == 's'
        Plot_Time = [-200 800];
    elseif align == 'r'
        Plot_Time = [-400 200];
    end

    trials = correct;
    rasterFlag = 0;
end

if nargin < 2
    align = 's';
    Plot_Time = [-100 500];
    trials = correct;
    rasterFlag = 0;
end


% set alignment
if align == 'r'
    Align_Time = SRT(:,1) + Target_(1,1);
elseif align == 's'
    Align_Time = Target_(:,1);
end


%Preallocate
SDF(1:length(Plot_Time(1):Plot_Time(2)),1:8) = NaN;
RT_CDF(1:31,1:8) = NaN; %number of bins used hard-coded to 30 (31 w/ left-padded 0)
RT_bins(1:31,1:8) = NaN;

%===========================
% Calulate SDFs by screen location
for j = 0:7
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


    [SDF(1:length(Plot_Time(1):Plot_Time(2)),j+1)] = spikedensityfunct(Spike, Align_Time, Plot_Time, trials(find(Target_(trials,2) == j)), TrialStart_);
    %[RT_bins(1:30,j+1) RT_CDF(1:30,j+1)] = getCDF(SRT(  trials(find(Target_(trials,2) == j)),1   ),30);
end
%===========================



%=======================
% Plot SDFs
fig

maxFire = max(max(SDF));


for j = 0:7
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


    subplot(3,3,screenloc)

    plot(Plot_Time(1):Plot_Time(2),SDF(:,j+1),'r','LineWidth',.5)
    numticks = round(maxFire/5);
    set(gca,'YTick',0:numticks:maxFire); %control number of tick marks for visual clarity
    if maxFire == 0
        ylim([0 1])
    else
        ylim([0 maxFire])
    end

    xlim(Plot_Time);
    %=======================




    %=============================================
    % Sort trials by SRT and plot rasters
    if rasterFlag == 1

        spikeset = Spike(trials(find(Target_(trials,2) == j)),:);
        trial_SRTs = SRT(trials(find(Target_(trials,2) == j)),1);

        trl = (maxFire/size(spikeset,1))/3;
        stepsz = trl;

        %sort trials.  If target aligned, sort shortest to longest. If
        %response aligned, sort longeset to shortest
        if align == 's'
            [s_RT,s_index] = sort(trial_SRTs,'ascend');
        elseif align == 'r'
            [s_RT,s_index] = sort(trial_SRTs,'descend');
        end

        s_RT = s_RT + Target_(1,1);

        hold on


        if align == 's'
            for t = 1:size(s_index)
                if ~isempty(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-Target_(1,1) <= Plot_Time(2) & spikeset(s_index(t),:)-Target_(1,1) >= Plot_Time(1)))))
                    plot(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-Target_(1,1) <= Plot_Time(2) & spikeset(s_index(t),:)-Target_(1,1) >= Plot_Time(1))))-Target_(1,1),trl,'k')
                end
                trl = trl + stepsz;
            end


        elseif align == 'r'
            for t = 1:size(s_index)
                plot(s_RT(t)*-1+Target_(1,1),trl,'.b','MarkerSize',5)
                if ~isempty(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-s_RT(s_index(t),1) <= Plot_Time(2) & spikeset(s_index(t),:)-s_RT(s_index(t),1) >= Plot_Time(1)))))
                    plot(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-s_RT(s_index(t),1) <= Plot_Time(2) & spikeset(s_index(t),:)-s_RT(s_index(t),1) >= Plot_Time(1))))-s_RT(s_index(t),1),trl,'k')
                end
                trl = trl + stepsz;
            end
        end


    end

    %================================================


    %=============================================
    % Plot RT CDFs if target aligned


%     if align == 's'
%         vline(0,'b')%draw line at 0 to indicate response-locked
% 
%         % hold on
%         ax1 = gca;
%         ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
%         hold on
%         plot(RT_bins(:,j+1),RT_CDF(:,j+1),'Parent',ax2,'color','b')
%         xlim(get(ax1,'xlim'))
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%         %hold off
%     elseif align == 'r' %draw line at 0 to indicate response-locked
%         vline(0,'b')
%     end
%     %=============================================
% 
%     %title each subplot with number of observations
%     title(strcat('nRT =  ',mat2str(length(s_RT)),'   nSDF =  ',mat2str(size(nonzeros(spikeset(:,1)),1))),'FontWeight','bold')


end


%==========================================
%draw FULL raster in center position
subplot(3,3,5)
ylim([0 size(Spike,1)])

if align == 's'
    Full_Raster_Plot_Time = [-200 800];
elseif align == 'r'
    Full_Raster_Plot_Time = [-1000 1000];
end

xlim(Full_Raster_Plot_Time)
a = ylim;
trl = a(2)/size(Spike,1);
stepsz = a(2)/size(Spike,1);
hold on

if rasterFlag == 1
    if align == 's'
        for t = 1:size(Spike,1)
            if ~isempty(nonzeros(Spike(t,find(Spike(t,:)-Target_(1,1) <= Full_Raster_Plot_Time(2) & Spike(t,:)-Target_(1,1) >= Full_Raster_Plot_Time(1)))))
                plot(nonzeros(Spike(t,find(Spike(t,:)-Target_(1,1) <= Full_Raster_Plot_Time(2) & Spike(t,:)-Target_(1,1) >= Full_Raster_Plot_Time(1))))-Target_(1,1),trl,'k')
            end
            trl = trl + stepsz;
        end
    elseif align == 'r'
        for t = 1:size(Spike,1)
            if ~isempty(nonzeros(Spike(t,find(Spike(t,:)-Align_Time(t) <= Full_Raster_Plot_Time(2) & Spike(t,:)-Align_Time(t) >= Full_Raster_Plot_Time(1)))))
                plot(nonzeros(Spike(t,find(Spike(t,:)-Align_Time(t) <= Full_Raster_Plot_Time(2) & Spike(t,:)-Align_Time(t) >= Full_Raster_Plot_Time(1))))-Align_Time(t),trl,'k')
            end
            trl = trl + stepsz;
        end
    end
end


title(['N =  ' mat2str(size(nonzeros(Spike(:,1)),1)) ')'],'FontWeight','bold')
ylabel('Trial Number')

if align == 's'
    [ax,h1] = suplabel('Time from Target (ms)');
elseif align == 'r'
    [ax,h1] = suplabel('Time from Saccade (ms)');
end
%=====================================


set(h1,'FontSize',15)
[ax,h2] = suplabel('spikes/sec','y');
set(h2,'FontSize',15)
end