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

use_all_trials = 0;

plotRaster = 'y';
Align_ = 's';
outdir = '/volumes/Dump/Search_Data_SAT_longBase/New/NewPlots/';
%outdir = '/Search_Data_SAT/PDF/';
%Determine monkey (legacy code
getMonk

%================================================
%Get SRT from Eye Traces
if exist('SRT') == 0
    %[SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
    [SRT] = getSRT(EyeX_,EyeY_);
end
%================================================
%=====================================================
%Call scripts


%do you want to include only correct trials or all trials?
if use_all_trials
    ValidTrials = 1:size(Target_,1);
else
    fixErrors
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,correct);
end



%=====================================================


%align differently for MG and search
if Align_ == 's' && ~isempty(regexp(newfile,'_MG'))
    Align_Time(1:length(Correct_),1) = Target_(1,1);
    SDFPlot_Time = [-200 1500];
    Full_Raster_Plot_Time = [-200 2000];
elseif Align_ == 's' && isempty(regexp(newfile,'_MG'))
    Align_Time(1:length(Correct_),1) = Target_(1,1);
    SDFPlot_Time = [-200 800];
    Full_Raster_Plot_Time = [-200 2000];
elseif Align_ == 'r'
    Align_Time = SRT(:,1);
    SDFPlot_Time = [-600 200];
    %When Saccade aligned, still have 500 ms baseline + SRT.
    Align_Time = Align_Time + Target_(1,1);
    Full_Raster_Plot_Time = [-1000 1000];
end


%=====================w============================
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
        [SDF] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, ValidTrials(find(Target_(ValidTrials,2) == j)), TrialStart_);



        %Find max firing rate (this is an efficient method and should be
        %revised in the future!)

        maxFire = 0;
        for SDF_j = 0:7
            Trls = ValidTrials(find(Target_(ValidTrials,2) == SDF_j));
            %[temp_SDF] = spikedensityfunct_lgn_old(CellName, Align_Time, SDFPlot_Time, Trls, TrialStart_);
            [temp_SDF] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, Trls, TrialStart_);

            if max(temp_SDF) > maxFire
                maxFire = max(temp_SDF);
            end
            clear Trls temp_SDF
        end



        subplot(3,3,screenloc)
        plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF,'r','LineWidth',.5)


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
        spikeset = CellName(ValidTrials(find(Target_(ValidTrials,2) == j)),:);
        trial_SRTs = SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1);

        if Align_ == 's'
            [s_RT,s_index] = sort(trial_SRTs,'ascend');
        elseif Align_ == 'r'
            [s_RT,s_index] = sort(trial_SRTs,'descend');
        end

        s_RT = s_RT + Target_(1,1);

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
                %get spike time matrix with nans outside area of interest (x axis values)
                    plot_spikeset=spikeset(s_index,:)-Target_(1,1);
                    plot_spikeset(plot_spikeset==0)=nan;
                    plot_spikeset(plot_spikeset>SDFPlot_Time(2)-Target_(1,1)&plot_spikeset<SDFPlot_Time(1)-Target_(1,1))=nan;
                %get rows to plot (y axis values)
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(s_index,1)-1)]',1,size(plot_spikeset,2));
                %plot
                    plot(plot_spikeset,plot_rows,'k','linestyle','none','marker','.','markersize',1)




            elseif Align_ == 'r'



                %sort trial SRTs
                    plot_spikeset=spikeset(s_index,:);
                    plot_spikeset(plot_spikeset==0)=nan;
                    plot_spikeset=plot_spikeset-repmat(s_RT(s_index),1,size(plot_spikeset,2));
                %get rows to plot(y axis 
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(s_index,1)-1)]',1,size(plot_spikeset,2));
                %plot
                    plot(plot_spikeset,plot_rows,'k','linestyle','none','marker','.','markersize',1)
                    plot(-s_RT+Target_(1,1),[trl:stepsz:trl+stepsz*(size(s_index,1)-1)],'.b','MarkerSize',5)
            end
        end
        
                            %draw line at 0 to indicate response-locked
                line([0 0],[0 maxFire])
        %Plot CDF
        hold on
        if Align_ == 's'
            [RTs,bins] = hist(SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1),100);
            RT_cdf = (cumsum(RTs))/length(SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1)) * 100;
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold on
            plot(bins,RT_cdf,'Parent',ax2,'color','b')
            xlim(get(ax1,'xlim'))
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
        end

        %title each subplot with number of observations
        title(strcat('nRT =  ',mat2str(length(s_RT)),'   nSDF =  ',mat2str(size(nonzeros(spikeset(:,1)),1))),'FontWeight','bold')
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

%get spike time matrix with nans outside area of interest (x axis values)
                    plot_CellName=CellName;
                    plot_CellName(plot_CellName==0)=nan;
                    plot_CellName=plot_CellName-Target_(1,1);
                    plot_CellName(plot_CellName>Full_Raster_Plot_Time(2)-Target_(1,1)&plot_CellName<Full_Raster_Plot_Time(1)-Target_(1,1))=nan;
                %get rows to plot (y axis values)
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(plot_CellName,1)-1)]',1,size(plot_CellName,2));
                %plot
                    plot(plot_CellName,plot_rows,'k','linestyle','none','marker','.','markersize',1)
                    
        elseif Align_ == 'r'

                    plot_CellName=CellName;
                    plot_CellName(plot_CellName==0)=nan;
                    plot_CellName=plot_CellName-repmat(Align_Time,1,size(plot_CellName,2));
                %get rows to plot(y axis 
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(plot_CellName,1)-1)]',1,size(plot_CellName,2));
                %plot
                    plot(plot_CellName,plot_rows,'k','linestyle','none','marker','.','markersize',1)
                    
                    
%             end
        end
    end
    
    title([strcat('N =  ',mat2str(size(nonzeros(CellName(:,1)),1))) '       #Correct - #Valid = ' mat2str(length(correct) - length(ValidTrials))],'FontWeight','bold')
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
        [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date, '   Correct Trials Only'),'t');
        set(h3,'FontSize',12,'interpreter','none')
    elseif exist('batch_list')
        [ax,h3] = suplabel(strcat('File: ',batch_list(i).name,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date, '   Correct Trials Only'),'t');
        set(h3,'FontSize',12)
    else
        [ax,h3] = suplabel(strcat('Cell: ',mat2str(cell2mat(CellNames(k)))),'t');
        set(h3,'FontSize',12)
    end




    if saveflag == 1
        
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
    CellName h1 h2 h3 ax ax1 ax2 SDF maxFire SDF_j screenloc a j k t  ...
    spikeset trial_SRTs s_RT index trl stepsz bins endvar  numticks  ...
    s_index 
toc



















%Richard P. Heitz
%Vanderbilt
%Draws SDFs and Rasters by screen location
%Runs on open file
%10/18/2007
%
%edited 3/5/2008 RPH

tic
%Do you want to save?
% saveflag = 0;
% printflag = 0;
% maximizeflag = 1;
% 
% use_all_trials = 0;

%plotRaster = 'y';
Align_ = 'r';
%outdir = '/volumes/Dump/Search_Data_SAT_longBase/New/NewPlots/';
%outdir = '/Search_Data_SAT/PDF/';
%Determine monkey (legacy code
getMonk

%================================================
%Get SRT from Eye Traces
if exist('SRT') == 0
    %[SRT,saccDir] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
    [SRT] = getSRT(EyeX_,EyeY_);
end
%================================================
%=====================================================
%Call scripts


%do you want to include only correct trials or all trials?
if use_all_trials
    ValidTrials = 1:size(Target_,1);
else
    fixErrors
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,correct);
end



%=====================================================


%align differently for MG and search
if Align_ == 's' && ~isempty(regexp(newfile,'_MG'))
    Align_Time(1:length(Correct_),1) = Target_(1,1);
    SDFPlot_Time = [-200 1500];
    Full_Raster_Plot_Time = [-200 2000];
elseif Align_ == 's' && isempty(regexp(newfile,'_MG'))
    Align_Time(1:length(Correct_),1) = Target_(1,1);
    SDFPlot_Time = [-200 800];
    Full_Raster_Plot_Time = [-200 2000];
elseif Align_ == 'r'
    Align_Time = SRT(:,1);
    SDFPlot_Time = [-400 200];
    %When Saccade aligned, still have 500 ms baseline + SRT.
    Align_Time = Align_Time + Target_(1,1);
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
        [SDF] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, ValidTrials(find(Target_(ValidTrials,2) == j)), TrialStart_);



        %Find max firing rate (this is an efficient method and should be
        %revised in the future!)

        maxFire = 0;
        for SDF_j = 0:7
            Trls = ValidTrials(find(Target_(ValidTrials,2) == SDF_j));
            %[temp_SDF] = spikedensityfunct_lgn_old(CellName, Align_Time, SDFPlot_Time, Trls, TrialStart_);
            [temp_SDF] = spikedensityfunct(CellName, Align_Time, SDFPlot_Time, Trls, TrialStart_);

            if max(temp_SDF) > maxFire
                maxFire = max(temp_SDF);
            end
            clear Trls temp_SDF
        end



        subplot(3,3,screenloc)
        plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF,'r','LineWidth',.5)


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
        spikeset = CellName(ValidTrials(find(Target_(ValidTrials,2) == j)),:);
        trial_SRTs = SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1);

        if Align_ == 's'
            [s_RT,s_index] = sort(trial_SRTs,'ascend');
        elseif Align_ == 'r'
            [s_RT,s_index] = sort(trial_SRTs,'descend');
        end

        s_RT = s_RT + Target_(1,1);

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
                %get spike time matrix with nans outside area of interest (x axis values)
                    plot_spikeset=spikeset(s_index,:)-Target_(1,1);
                    plot_spikeset(plot_spikeset==0)=nan;
                    plot_spikeset(plot_spikeset>SDFPlot_Time(2)-Target_(1,1)&plot_spikeset<SDFPlot_Time(1)-Target_(1,1))=nan;
                %get rows to plot (y axis values)
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(s_index,1)-1)]',1,size(plot_spikeset,2));
                %plot
                    plot(plot_spikeset,plot_rows,'k','linestyle','none','marker','.','markersize',1)




            elseif Align_ == 'r'



                %sort trial SRTs
                    plot_spikeset=spikeset(s_index,:);
                    plot_spikeset(plot_spikeset==0)=nan;
                    plot_spikeset=plot_spikeset-repmat(s_RT(s_index),1,size(plot_spikeset,2));
                %get rows to plot(y axis 
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(s_index,1)-1)]',1,size(plot_spikeset,2));
                %plot
                    plot(plot_spikeset,plot_rows,'k','linestyle','none','marker','.','markersize',1)
                    plot(-s_RT+Target_(1,1),[trl:stepsz:trl+stepsz*(size(s_index,1)-1)],'.b','MarkerSize',5)
            end
        end
        
                            %draw line at 0 to indicate response-locked
                line([0 0],[0 maxFire])
        %Plot CDF
        hold on
        if Align_ == 's'
            [RTs,bins] = hist(SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1),100);
            RT_cdf = (cumsum(RTs))/length(SRT(ValidTrials(find(Target_(ValidTrials,2) == j)),1)) * 100;
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold on
            plot(bins,RT_cdf,'Parent',ax2,'color','b')
            xlim(get(ax1,'xlim'))
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
        end

        %title each subplot with number of observations
        title(strcat('nRT =  ',mat2str(length(s_RT)),'   nSDF =  ',mat2str(size(nonzeros(spikeset(:,1)),1))),'FontWeight','bold')
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

%get spike time matrix with nans outside area of interest (x axis values)
                    plot_CellName=CellName;
                    plot_CellName(plot_CellName==0)=nan;
                    plot_CellName=plot_CellName-Target_(1,1);
                    plot_CellName(plot_CellName>Full_Raster_Plot_Time(2)-Target_(1,1)&plot_CellName<Full_Raster_Plot_Time(1)-Target_(1,1))=nan;
                %get rows to plot (y axis values)
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(plot_CellName,1)-1)]',1,size(plot_CellName,2));
                %plot
                    plot(plot_CellName,plot_rows,'k','linestyle','none','marker','.','markersize',1)
                    
        elseif Align_ == 'r'

                    plot_CellName=CellName;
                    plot_CellName(plot_CellName==0)=nan;
                    plot_CellName=plot_CellName-repmat(Align_Time,1,size(plot_CellName,2));
                %get rows to plot(y axis 
                    plot_rows=repmat([trl:stepsz:trl+stepsz*(size(plot_CellName,1)-1)]',1,size(plot_CellName,2));
                %plot
                    plot(plot_CellName,plot_rows,'k','linestyle','none','marker','.','markersize',1)
                    
                    
%             end
        end
    end
    
    title([strcat('N =  ',mat2str(size(nonzeros(CellName(:,1)),1))) '       #Correct - #Valid = ' mat2str(length(correct) - length(ValidTrials))],'FontWeight','bold')
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
        [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date, '   Correct Trials Only'),'t');
        set(h3,'FontSize',12,'interpreter','none')
    elseif exist('batch_list')
        [ax,h3] = suplabel(strcat('File: ',batch_list(i).name,'     Cell: ',mat2str(cell2mat(CellNames(k))),'   Generated: ',date, '   Correct Trials Only'),'t');
        set(h3,'FontSize',12)
    else
        [ax,h3] = suplabel(strcat('Cell: ',mat2str(cell2mat(CellNames(k)))),'t');
        set(h3,'FontSize',12)
    end




    if saveflag == 1
        
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
    CellName h1 h2 h3 ax ax1 ax2 SDF maxFire SDF_j screenloc a j k t saveflag outdir ...
    spikeset trial_SRTs s_RT index trl stepsz bins endvar maximizeflag numticks printflag ...
    s_index 
toc