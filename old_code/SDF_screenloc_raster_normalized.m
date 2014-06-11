%Richard P. Heitz
%6/20/07
% %Plot SDFs by screen location
% %Use to find cell's RF
%
%maxspike = 0;
%create a list of all variables in workspace
clear all
close all
cd 'D:\Data\RawData\'
file_path = 'D:\Data\RawData\';
q = ''''; c = ','; qcq = [q c q];
% if isempty(who)
%     [filename,file_path] = uigetfile('Choose File')
% else
%     filename = 'dat030_m.706001-01_1'
%     file_path = 'D:\Data\RawData\'
%     eval(load(q,file_path,filename,qcq,-mat,q))
% end
%
%
batch_list = dir('D:\Data\RawData\*_1*.*');

for i = 1:length(batch_list)
    eval(['load(',q,file_path,batch_list(i).name,qcq,'-mat',q,')'])
    batch_list(i).name
    %Contrast flag to optionally run contrast sensitivity analysis
    ContrastFlag = 1;
    %Print Flag
    printflag = 0;
    %Save PDF flag
    saveflag = 0;


    CellName = [];

    varlist = who;

    %find indexes of cell names
    CellMarker = strmatch('DSP',varlist);

    %create a list of target cells to analyze
    for a = 1:length(CellMarker)
        CellName_temp(a,1) = varlist(CellMarker(a));
    end

    %remove hash cells (end with "i")
    m = 1;
    for j = 1:length(CellName_temp)
        if isempty(strfind(cell2mat(CellName_temp(j)),'i') > 0)
            CellNames(m,1) = CellName_temp(j);
            m = m + 1;
        end
    end

    %Set SDF parameters
    Align_Time_=Target_(:,1);
    %Align_Time_ = SaccBegin(:,1) + 500
    Plot_Time=[-500 2000];


    %find correct trials
    %goodtrials = Target_(find(Correct_(:,2) == 1),:);

    for k = 1:length(CellNames)
        figure;
        orient landscape;
        set(gcf,'Color','white')
        CellName = eval(cell2mat(CellNames(k)));


        %draw SDFs

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

            SDF=[];
            SDF_max=0;
            %dynamically set "triallist" - should be equal to the # of trials for
            %each screen location
            %Last component Target_(:,3) > 1 ensures that we are using only
            %MG trials (which will have a luminance greater than 1.  All
            %others have a 1
            triallist = 1:length(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1));
            [SDF] = spikedensityfunct_contrast(CellName(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1),:), Align_Time_, Plot_Time, triallist, TrialStart_);
            
            %Normalization
            if max(SDF) > SDF_max
                SDF_max = max(SDF);
            end


            subplot(3,3,screenloc)
            plot(Plot_Time(1):Plot_Time(2),SDF,'r','LineWidth',.5)
            set(gca,'YTick',0:20:100);
            line([mean(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1))) mean(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1)))],[-10 10],'color','g')
            %title(CellNames(i))
            %     if max(SDF) > maxspike
            %         maxspike = max(SDF);
            %     end
            %         %set axis limits based on max SDF
            %         if j == 7
            %             ymax = max(SDF);
            %         end
            ylim([0 100]);
            xlim(Plot_Time);
            %     for i = 1:length(CellName(find(goodtrials(:,2) == j)))
            %         for n = 1:(length(CellName(i,:)))
            %         line([CellName(i,n) CellName(i,n)], [i-1 i+1])
            %         end
            %     end
            %RFs = input('Enter matrix of locations thought to be within cell RF, separated by spaces ')

            %Plot Raster

            %Find set of spikes corresponding to correct trials at current screen
            %location
            spikeset = CellName(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1),:);
            spikeset = spikeset - Align_Time_(1,1);
            %sort the SRTs held in "Decide_" and record row numbers
            %[SRTs,loc] = sort(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j),1));
            for t = 1:length(spikeset(:,1))
                for r = 1:length(spikeset(t,:))
                    %while spikeset(t,r) >= Plot_Time(1) && spikeset(t,r) <= Plot_Time(2)
                    %    line([spikeset(t,r) spikeset(t,r)],[t t],'color','k');
                    %end
                end
            end

            %Plot CDF
            hold on
            [RTs,bins] = hist(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1),1),100);
            RT_cdf = (cumsum(RTs))/length(Decide_(find(Correct_(:,2) == 1 & Target_(:,2) == j & Target_(:,3) > 1),1)) * 100;
            plot(bins,RT_cdf,'color','b')
            hold off
            %title each subplot with number of observations
            title(strcat('N =  ',mat2str(sum(RTs))),'FontWeight','bold')
        end
        [ax,h1] = suplabel('Time from Target (ms)');
        set(h1,'FontSize',15)
        [ax,h2] = suplabel('spikes/sec','y');
        set(h2,'FontSize',15)
        [ax,h3] = suplabel(strcat('File:   ',batch_list(i).name,'                 Cell: ',mat2str(cell2mat(CellNames(k)))),'t');
        set(h3,'FontSize',12)

        %PRINT AND SAVING
        if saveflag == 1
            eval(['print -dpdf ',batch_list(i).name,'_',str2mat(CellNames(k)),'_1.pdf'])
        end
        if printflag == 1
            gcf
            print
        end

        
    %LFP analysis
    %Find AD channels
%    ADCH = strmatch('AD',varlist);
   %Call to function to get LFP
if ~isempty(findstr('04',cell2mat(CellNames(k))))
    AD_CH = 'AD04';
elseif ~isempty(findstr('05',cell2mat(CellNames(k))))
    AD_CH = 'AD05';
elseif ~isempty(findstr('09',cell2mat(CellNames(k))))
    AD_CH = 'AD09';
elseif ~isempty(findstr('10',cell2mat(CellNames(k))))
    AD_CH = 'AD10';
elseif ~isempty(findstr('11',cell2mat(CellNames(k))))
    AD_CH = 'AD11';
elseif ~isempty(findstr('12',cell2mat(CellNames(k))))
    AD_CH = 'AD12';
end

disp(AD_CH)
[ADchan_low,ADchan_mid,ADchan_high] = plotAD(eval(AD_CH),Target_,Correct_);
        
        
        
        %Optional Contrast_Sensitivity Flag
        if ContrastFlag == 1
            TotalSpikes = eval(cell2mat(CellNames(k)));
            %             saveflag = input('Do you want to save RFs?  [1 = yes 0 = no] ');
            Contrast_Sensitivity(batch_list(i).name,CellNames(k),TotalSpikes,Target_,Decide_,Correct_,TrialStart_,ADchan_low,ADchan_mid,ADchan_high);
        end
    end
    CellNames = {};
    CellName_temp = {};



%         figure
%         hold on
%         plot(AD_plot_time,ADchan_low,'r',AD_plot_time,ADchan_mid,'b',AD_plot_time,ADchan_high,'k')
%         %plot(ADchan_mid,'b')
%         %plot(ADchan_high,'k')
%         title(cell2mat(varlist(ADCH(AD_count))));
%         set(gcf,'Color','white');
%         legend('low contrast','medium contrast','high contrast');
%     end

    keep batch_list file_path q c qcq 

end