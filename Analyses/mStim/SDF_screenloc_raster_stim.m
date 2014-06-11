%Richard P. Heitz
%Vanderbilt
%Draws SDFs and Rasters by screen location
%Runs on open file
%10/18/2007
%
%edited 3/5/2008 RPH

tic
%Do you want to save?
saveflag = 0;
printflag = 0;
maximizeflag = 1;
plotRaster = 'n';
Align_ = 's';

%Determine monkey (legacy code
getMonk

%================================================
%Get SRT from Eye Traces
if exist('SRT') == 0
    [SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
end
%================================================
%=====================================================
%Call scripts
fixErrors
%[ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,correct);
%=====================================================
ValidTrials_all = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
ValidTrials_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & ~isnan(MStim_(:,1)));
ValidTrials_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)));

%align differently for MG and search
if Align_ == 's' && ~isempty(regexp(newfile,'_MG'))
    Align_Time(1:length(Correct_),1) = 500;
    SDFPlot_Time = [-200 1500];
    Full_Raster_Plot_Time = [-200 2000];
elseif Align_ == 's' && ~isempty(regexp(newfile,'_SEARCH'))
    Align_Time(1:length(Correct_),1) = 500;
    SDFPlot_Time = [-200 800];
    Full_Raster_Plot_Time = [-200 2000];
elseif Align_ == 'r'
    Align_Time = SRT(:,1);
    SDFPlot_Time = [-400 200];
    %When Saccade aligned, still have 500 ms baseline + SRT.
    Align_Time = Align_Time + 500;
    Full_Raster_Plot_Time = [-1000 1000];
end


%=================================================
%CALL SCRIPT getCellnames
%script because passed variables changes every file
eval('getCellnames')
%=================================================




for k = 1:length(CellNames)
    f = figure;
        %maximize figure window
    if maximizeflag == 1
        maximize
    end
    orient landscape;
    set(gcf,'Color','white')
    CellName = eval(cell2mat(CellNames(k)));

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

        SDF=[];
        [SDF_stim] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, ValidTrials_stim(find(Target_(ValidTrials_stim,2) == j)), TrialStart_);
        [SDF_nostim] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, ValidTrials_nostim(find(Target_(ValidTrials_nostim,2) == j)), TrialStart_);
        [SDF_all] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, ValidTrials_all(find(Target_(ValidTrials_all,2) == j)), TrialStart_);

        %Find max firing rate (this is an efficient method and should be
        %revised in the future!)

        maxFire = 0;
        for SDF_j = 0:7
            Trls_stim = ValidTrials_stim(find(Target_(ValidTrials_stim,2) == SDF_j));
            Trls_nostim = ValidTrials_nostim(find(Target_(ValidTrials_nostim,2) == SDF_j));
            Trls_all = ValidTrials_all(find(Target_(ValidTrials_all,2) == SDF_j));
            %[temp_SDF] = spikedensityfunct_lgn_old(CellName, Align_Time, SDFPlot_Time, Trls, TrialStart_);
            [temp_SDF_all] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, Trls_all, TrialStart_);
            [temp_SDF_stim] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, Trls_stim, TrialStart_);
            [temp_SDF_nostim] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, Trls_nostim, TrialStart_);
            
            if max(max(max(temp_SDF_stim),max(temp_SDF_nostim)),max(SDF_all)) > maxFire
                maxFire = max(max(max(temp_SDF_stim),max(temp_SDF_nostim)),max(SDF_all));
            end
            clear temp_SDF_stim temp_SDF_nostim Trls_all temp_SDF_all
        end



        subplot(3,3,screenloc)
        plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF_nostim,'b',SDFPlot_Time(1):SDFPlot_Time(2),SDF_stim,'r','LineWidth',.5)
        hold on
        plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF_all,'k')

        numticks = round(maxFire/5);

        set(gca,'YTick',0:numticks:maxFire);


        if maxFire == 0
            ylim([0 1])
        else
            ylim([0 maxFire])
        end

        xlim(SDFPlot_Time);

        %Plot Raster
        %Find set of spikes corresponding to correct trials at current screen
        %location
        spikeset = CellName(ValidTrials_stim(find(Target_(ValidTrials_stim,2) == j)),:);
        trial_SRTs = SRT(ValidTrials_stim(find(Target_(ValidTrials_stim,2) == j)),1);

        if Align_ == 's'
            [s_RT,s_index] = sort(trial_SRTs,'ascend');
        elseif Align_ == 'r'
            [s_RT,s_index] = sort(trial_SRTs,'descend');
        end

        s_RT = s_RT + 500;

        hold on

        
        if plotRaster == 'y'
            %========================RASTER=======================
            %want to fill each location from top to bottom with raster.  To
            %figure out the spacing, take the ylim(2) (here, the variable "a"
            %holds that), then divide by the number of trials, and that's your
            %spacing.
            trl = (maxFire/size(spikeset,1))/3;
            stepsz = (maxFire/size(spikeset,1))/3;

            if Align_ == 's'
                for t = 1:size(s_index)
                    if ~isempty(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-500 <= SDFPlot_Time(2) & spikeset(s_index(t),:)-500 >= SDFPlot_Time(1)))))
                        plot(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-500 <= SDFPlot_Time(2) & spikeset(s_index(t),:)-500 >= SDFPlot_Time(1))))-500,trl,'k')
                    end
                    trl = trl + stepsz;
                end



            elseif Align_ == 'r'


                %sort trial SRTs


                for t = 1:size(s_index)
                    plot(s_RT(t)*-1+500,trl,'.b','MarkerSize',5)

                    if ~isempty(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-s_RT(s_index(t),1) <= SDFPlot_Time(2) & spikeset(s_index(t),:)-s_RT(s_index(t),1) >= SDFPlot_Time(1)))))
                        plot(nonzeros(spikeset(s_index(t),find(spikeset(s_index(t),:)-s_RT(s_index(t),1) <= SDFPlot_Time(2) & spikeset(s_index(t),:)-s_RT(s_index(t),1) >= SDFPlot_Time(1))))-s_RT(s_index(t),1),trl,'k')

                    end
                    trl = trl + stepsz;
                end
            end
        end
        
                            %draw line at 0 to indicate response-locked
                line([0 0],[0 maxFire])
        %Plot CDF
        hold on
        if Align_ == 's'
            [RTs_stim,bins_stim] = hist(SRT(ValidTrials_stim(find(Target_(ValidTrials_stim,2) == j)),1),100);
            RT_cdf_stim = (cumsum(RTs_stim))/length(SRT(ValidTrials_stim(find(Target_(ValidTrials_stim,2) == j)),1)) * 100;
            [RTs_nostim,bins_nostim] = hist(SRT(ValidTrials_nostim(find(Target_(ValidTrials_nostim,2) == j)),1),100);
            RT_cdf_nostim = (cumsum(RTs_nostim))/length(SRT(ValidTrials_nostim(find(Target_(ValidTrials_nostim,2) == j)),1)) * 100;
            
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold on
            plot(bins_nostim,RT_cdf_nostim,'Parent',ax2,'color','b')
            plot(bins_stim,RT_cdf_stim,'Parent',ax2,'color','r')
            xlim(get(ax1,'xlim'))
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
        end

        %title each subplot with number of observations
        title(strcat('nStim =  ',mat2str(length(Trls_stim)),'   nNoStim =  ',mat2str(length(Trls_nostim))),'FontWeight','bold')
    end


    %draw FULL raster in center position
    subplot(3,3,5)
    ylim([0 size(CellName,1)])
    xlim(Full_Raster_Plot_Time)
    a = ylim;
    trl = a(2)/size(CellName,1);
    stepsz = a(2)/size(CellName,1);
    hold on
    
    if plotRaster == 'y'
        if Align_ == 's'
            for t = 1:size(CellName,1)
                if ~isempty(nonzeros(CellName(t,find(CellName(t,:)-500 <= Full_Raster_Plot_Time(2) & CellName(t,:)-500 >= Full_Raster_Plot_Time(1)))))
                    if ~isnan(MStim_(t,1))
                        plot(nonzeros(CellName(t,find(CellName(t,:)-500 <= Full_Raster_Plot_Time(2) & CellName(t,:)-500 >= Full_Raster_Plot_Time(1))))-500,trl,'r')
                    elseif isnan(MStim_(t,1))
                        plot(nonzeros(CellName(t,find(CellName(t,:)-500 <= Full_Raster_Plot_Time(2) & CellName(t,:)-500 >= Full_Raster_Plot_Time(1))))-500,trl,'b')
                    end
                end
                trl = trl + stepsz;
            end
        elseif Align_ == 'r'
            for t = 1:size(CellName,1)
                if ~isempty(nonzeros(CellName(t,find(CellName(t,:)-Align_Time(t) <= Full_Raster_Plot_Time(2) & CellName(t,:)-Align_Time(t) >= Full_Raster_Plot_Time(1)))))
                    if ~isnan(MStim_(t,1))
                        plot(nonzeros(CellName(t,find(CellName(t,:)-Align_Time(t) <= Full_Raster_Plot_Time(2) & CellName(t,:)-Align_Time(t) >= Full_Raster_Plot_Time(1))))-Align_Time(t),trl,'r')
                    elseif isnan(MStim_(t,1))
                        plot(nonzeros(CellName(t,find(CellName(t,:)-Align_Time(t) <= Full_Raster_Plot_Time(2) & CellName(t,:)-Align_Time(t) >= Full_Raster_Plot_Time(1))))-Align_Time(t),trl,'b')
                    end
                end
                trl = trl + stepsz;
            end
        end
   end
    
    title([strcat('N =  ',mat2str(size(nonzeros(CellName(:,1)),1))) '       #Correct - #Valid = ' mat2str(length(correct) - length(ValidTrials_all))],'FontWeight','bold')
    ylabel('Trial Number')

    if Align_ == 's'
        [ax,h1] = suplabel('Time from Target (ms)');
    elseif Align_ == 'r'
        [ax,h1] = suplabel('Time from Saccade (ms)');
    end

    set(h1,'FontSize',15)
    [ax,h2] = suplabel('spikes/sec','y');
    set(h2,'FontSize',15)

    if exist('newfile')
        [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date, '   Red == STIM'),'t');
        set(h3,'FontSize',12)
    elseif exist('batch_list')
        [ax,h3] = suplabel(strcat('File: ',batch_list(i).name,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date, '   Red == STIM'),'t');
        set(h3,'FontSize',12)
    else
        [ax,h3] = suplabel(strcat('Cell: ',mat2str(cell2mat(CellNames(k)))),'t');
        set(h3,'FontSize',12)
    end




    if saveflag == 1
        outdir = '/volumes/dump/Search_Data_uStim/PDF/';
        if exist('newfile') == 1 & Align_ == 's'
            eval(['print -dpdf ',outdir,newfile,'_',cell2mat(CellNames(k)),'_s.pdf']);
        elseif exist('newfile') == 1 & Align_ == 'r'
            eval(['print -dpdf ',outdir,newfile,'_',cell2mat(CellNames(k)),'_r.pdf']);
        elseif exist('batch_list') & Align_ == 's'
            eval(['print -dpdf ',outdir,batch_list(i).name,'_',cell2mat(CellNames(k)),'_s.pdf']);
        elseif exist('batch_list') & Align_ == 'r'
            eval(['print -dpdf ',outdir,batch_list(i).name,'_',cell2mat(CellNames(k)),'_r.pdf']);
        end
        close(f)
    end

    if printflag == 1
        print
        close(f)
    end
    
    
    
end

clear monkey ASL_Delay Align_ Align_Time SDFPlot_Time Full_Raster_Plot_Time ...
    CellName h1 h2 h3 ax ax1 ax2 SDF_stim SDF_nostim maxFire SDF_j screenloc a j k t saveflag outdir ...
    spikeset trial_SRTs_stim trialSRTs_nostim s_RT index trl stepsz bins endvar maximizeflag numticks printflag ...
    s_index 
toc