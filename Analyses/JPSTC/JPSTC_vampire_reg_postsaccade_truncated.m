% Joint Peri-stimulus time correlogram
% time-based correlation analysis for EEG-EEG, LFP-FLP, and LFP-EEG
% comparisons.

% (c) Richard P. Heitz, Vanderbilt 2008
% All rights reserved.

function [] = JPSTC_vampire(file)
tic
% path(path,'/home/heitzrp/Mat_Code/Common')
% path(path,'/home/heitzrp/Mat_Code/JPSTC')
% path(path,'/home/heitzrp/Data')
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')

plotFlag = 1;
pdfFlag = 1;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist)));
%DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist


for chanNum = 1:size(ADlist,1)
    ADchan = ADlist(chanNum,:);
    eval(['load(' q file qcq ADchan qcq '-mat' q ')'])
    disp(['load(' q file qcq ADchan qcq '-mat' q ')'])
    clear ADchan
end

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'Errors_' qcq 'SRT' qcq 'EyeX_' qcq 'EyeY_' qcq 'newfile' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);

%rename LFP channels for consistency
clear ADlist
varlist = who;
chanlist = varlist(strmatch('AD',varlist));
clear varlist

plottime = (-50:400);
plottime_saccade = (-50:400);


%Find all possible pairings of LFP channels
pairings = nchoosek(1:length(chanlist),2);


%Compute comparisons backwards so we get LFP correlations out first
for pair = size(pairings,1):-1:1
    disp(['Comparing... ' cell2mat(chanlist(pairings(pair,1))) ' vs ' cell2mat(chanlist(pairings(pair,2))) ' ... ' mat2str(length(pairings) - pair + 1) ' of ' mat2str(size(pairings,1))])

    fixErrors
    error_skip = 0;
    set_size_skip = 0;
    homog_skip = 0;

    %====================================================
    % SET UP DATA
    %find relevant trials, exclude catch trials (255)
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);

    sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2 = eval(cell2mat(chanlist(pairings(pair,2))));

    %make sure we have data for all conditions
    if isempty(errors) == 1
        error_skip = 1;
    end

    %Get saccade-aligned traces

    %initialize variables
    sig1_correct_saccade(1:length(correct),1:451) = NaN;
    sig2_correct_saccade(1:length(correct),1:451) = NaN;
    sig1_errors_saccade(1:length(errors),1:451) = NaN;
    sig2_errors_saccade(1:length(errors),1:451) = NaN;

    %find time of second saccade, if there is one
    getMonk
    SecondSaccRT_temp = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
    SecondSaccRT = SecondSaccRT_temp(:,2) - SRT(:,1);
    clear SecondSaccRT_temp ASL_Delay monkey

    for trl = 1:length(correct)
        sig1_correct_saccade(trl,1:451) = sig1(correct(trl),ceil(SRT(correct(trl),1)+450:ceil(SRT(correct(trl),1)+900)));
        sig2_correct_saccade(trl,1:451) = sig2(correct(trl),ceil(SRT(correct(trl),1)+450:ceil(SRT(correct(trl),1)+900)));
    end


    if error_skip ~= 1
        for trl = 1:length(errors)
            %             sig1_errors_saccade(trl,1:451) = sig1(errors(trl),ceil(SRT(errors(trl),1)+450:ceil(SRT(errors(trl),1)+900)));
            %             sig2_errors_saccade(trl,1:451) = sig2(errors(trl),ceil(SRT(errors(trl),1)+450:ceil(SRT(errors(trl),1)+900)));

            %compute error signal, but truncate at 2nd saccade, if it
            %exists, is less than 400 ms (extent of signal we are analyzing,
            %& is greater than 100 ms (to make sure second saccade
            %is feasible rather than a single drifting saccade)
            if ~isnan(SecondSaccRT(errors(trl))) == 1 & SecondSaccRT(errors(trl)) < 400 & SecondSaccRT(errors(trl)) > 100
                sig1_errors_saccade(trl,1:SecondSaccRT(errors(trl)) + 1) = sig1(errors(trl),ceil(SRT(errors(trl),1)+450):ceil(SRT(errors(trl),1)) + 450 + SecondSaccRT(errors(trl)));
                sig2_errors_saccade(trl,1:SecondSaccRT(errors(trl)) + 1) = sig2(errors(trl),ceil(SRT(errors(trl),1)+450):ceil(SRT(errors(trl),1)) + 450 + SecondSaccRT(errors(trl)));
            else
                sig1_errors_saccade(trl,1:451) = sig1(errors(trl),ceil(SRT(errors(trl),1)+450:ceil(SRT(errors(trl),1) + 900)));
                sig2_errors_saccade(trl,1:451) = sig2(errors(trl),ceil(SRT(errors(trl),1)+450:ceil(SRT(errors(trl),1) + 900)));
            end
        end
    end

    %==========================================================================

    clear sig1 sig2 correct errors


    %=========================================================
    % Keep track of average waveforms


    %sig1-saccade aligned
    wf_sig1_correct_saccade = nanmean(sig1_correct_saccade,1);
    wf_sig1_errors_saccade = nanmean(sig1_errors_saccade,1);

    %sig2-saccade aligned
    wf_sig2_correct_saccade = nanmean(sig2_correct_saccade,1);
    wf_sig2_errors_saccade = nanmean(sig2_errors_saccade,1);

    %===========================================================


    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise

    %sig1-saccade aligned
    [freq FFT_correct_1_saccade] = getFFT(wf_sig1_correct_saccade);
    [freq FFT_errors_1_saccade] = getFFT(wf_sig1_errors_saccade);

    %sig2-saccade aligned
    [freq FFT_correct_2_saccade] = getFFT(wf_sig2_correct_saccade);
    [freq FFT_errors_2_saccade] = getFFT(wf_sig2_errors_saccade);

    %========================================================



    %
    % ========================================
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % % Time-averaged Correlograms
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Take a given lag and for each trial, calculate
    %   the correlation between the two signals over time (i.e., time-
    %   averaged).  Do for all lags


    % preallocate space
    cor_correct_saccade(1:size(sig1_correct_saccade,1),1:401) = NaN;
    cor_errors_saccade(1:size(sig1_errors_saccade,1),1:401) = NaN;

    lags = -200:200;

    %Correlogram for correct trials
    for trl = 1:size(sig1_correct_saccade,1)
        cor_correct_saccade(trl,1:401) = xcorr(sig2_correct_saccade(trl,:),sig1_correct_saccade(trl,:),200,'coeff');
    end

    %Correlogram for error trials
    for trl = 1:size(sig1_errors_saccade,1)
        cor_errors_saccade(trl,1:401) = xcorr(sig2_errors_saccade(trl,:),sig1_errors_saccade(trl,:),200,'coeff');
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % JPSTC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %===================================
    %Pre-allocate space
    JPSTC_correct_saccade(1:451,1:451) = NaN;
    JPSTC_errors_saccade(1:451,1:451) = NaN;

    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials Targ-align & Sacc-align, Shift-Predictor]')
    JPSTC_correct_saccade = corr(sig1_correct_saccade,sig2_correct_saccade);

    n_correct = size(sig1_correct_saccade,1);
    clear sig1_correct sig2_correct sig1_correct_saccade sig2_correct_saccade


    % 2) Error TRIALS
    if error_skip ~= 1
        disp('Running... [Error Trials]')

        for time1 = 1:size(sig1_errors_saccade,2)
            for time2 = 1:size(sig2_errors_saccade,2)
                a = find(~isnan(sig1_errors_saccade(:,time1)));
                b = find(~isnan(sig2_errors_saccade(:,time2)));
                noNANlist = intersect(a,b);
                JPSTC_errors_saccade(time1,time2) = corr(sig1_errors_saccade(noNANlist,time1),sig2_errors_saccade(noNANlist,time2));
                clear a b noNANlist
            end
        end
        clear time1 time2
        n_errors = size(sig1_errors_saccade,1);
        clear sig1_errors sig2_errors sig1_errors_saccade sig2_errors_saccade

    else
        disp('No Errors found...skipping')
    end

    %     ======================================================================
    %     =====================End Main Loops===================================



    %======================================================================
    % Calculate Main and Off-Diagonal Averages
    [t_vector,above_furthest_correct_saccade,above_far_correct_saccade,above_close_correct_saccade,main_correct_saccade,below_close_correct_saccade,below_far_correct_saccade,below_furthest_correct_saccade,thickdiagonal_correct_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_saccade);
    %
    [t_vector,above_furthest_errors_saccade,above_far_errors_saccade,above_close_errors_saccade,main_errors_saccade,below_close_errors_saccade,below_far_errors_saccade,below_furthest_errors_saccade,thickdiagonal_errors_saccade] = OffDiagonalAverage_vampire2(JPSTC_errors_saccade);
    %
    %     %set t_vector for saccades:
    t_vector_saccade = t_vector + -50;
    %======================================================================


    %======================================
    % Save Variables
    if saveFlag == 1
        save(['//scratch/heitzrp/Output/JPSTC_matrices/reg/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg_postsaccade_truncated.mat'],'SRT','RFs','MFs','BestRF','BestMF','plottime','plottime_saccade','lags','JPSTC_correct_saccade','JPSTC_errors_saccade','cor_correct_saccade','cor_errors_saccade','wf_sig1_correct_saccade','wf_sig1_errors_saccade','wf_sig2_correct_saccade','wf_sig2_errors_saccade','t_vector','above_furthest_correct_saccade','above_far_correct_saccade','above_close_correct_saccade','main_correct_saccade','below_close_correct_saccade','below_far_correct_saccade','below_furthest_correct_saccade','thickdiagonal_correct_saccade','above_furthest_errors_saccade','above_far_errors_saccade','above_close_errors_saccade','main_errors_saccade','below_close_errors_saccade','below_far_errors_saccade','below_furthest_errors_saccade','thickdiagonal_errors_saccade','-mat')
    end

    %======================================


    if plotFlag == 1



        %==================================================================
        %==================================================================
        %Figure 4: Correct vs errors, saccade-aligned
        if error_skip ~= 1
            figure
            orient landscape
            %use 'painters' renderer so that lines will show up
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %Plot JPSTC
            subplot(4,8,[1:4 9:12])
            surface(JPSTC_correct_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:450)
            set(gca,'YTickLabel',[])


            %Plot lines marking target onset time
            line([50 50],[0 450],'color','k','linewidth',2)
            line([0 450],[50 50],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Correct'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

            %Plot error JPSTC
            subplot(4,8,[5:8 13:16])
            surface(JPSTC_errors_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])
            line([50 50],[0 450],'color','k','linewidth',2)
            line([0 450],[50 50],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Errors'],'fontweight','bold')


            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime_saccade,wf_sig1_correct_saccade,'b',plottime_saccade,wf_sig1_errors_saccade,'--b','linewidth',2)
            ylim([min(min(wf_sig1_correct_saccade),min(wf_sig1_errors_saccade)) max(max(wf_sig1_correct_saccade),max(wf_sig1_errors_saccade))])
            xlim([-50 400])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' Correct'],[cell2mat(chanlist(pairings(pair,1))) ' Errors'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime_saccade,wf_sig2_correct_saccade,'r',plottime_saccade,wf_sig2_errors_saccade,'--r','linewidth',2)
            ylim([min(min(wf_sig2_correct_saccade),min(wf_sig2_errors_saccade)) max(max(wf_sig2_correct_saccade),max(wf_sig2_errors_saccade))])
            xlim([-50 400])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' Correct'],[cell2mat(chanlist(pairings(pair,2))) ' Errors'],'location','southeast')
            title('Mean Signals','fontweight','bold')


            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for error trials
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1_saccade(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2_saccade(5:end),'r','linewidth',1)
            xlim([10 80])
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials, saccade-aligned)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct_saccade),'b',lags,mean(cor_errors_saccade),'r','linewidth',2)
            legend('Correct','Errors')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')

            %Plot Off-diagonal averages

            %find global min and max so can compare across plots
            minvals(1) = min(above_close_correct_saccade);      maxvals(1) = max(above_close_correct_saccade);
            minvals(2) = min(above_far_correct_saccade);        maxvals(2) = max(above_far_correct_saccade);
            minvals(3) = min(above_furthest_correct_saccade);   maxvals(3) = max(above_furthest_correct_saccade);
            minvals(4) = min(below_close_correct_saccade);      maxvals(4) = max(below_close_correct_saccade);
            minvals(5) = min(below_far_correct_saccade);        maxvals(5) = max(below_far_correct_saccade);
            minvals(6) = min(below_furthest_correct_saccade);   maxvals(6) = max(below_furthest_correct_saccade);
            minvals(7) = min(above_close_errors_saccade);       maxvals(7) = max(above_close_errors_saccade);
            minvals(8) = min(above_far_errors_saccade);         maxvals(8) = max(above_far_errors_saccade);
            minvals(9) = min(above_furthest_errors_saccade);    maxvals(9) = max(above_furthest_errors_saccade);
            minvals(10) = min(below_close_errors_saccade);      maxvals(10) = max(below_close_errors_saccade);
            minvals(11) = min(below_far_errors_saccade);        maxvals(11) = max(below_far_errors_saccade);
            minvals(12) = min(below_furthest_errors_saccade);   maxvals(12) = max(below_furthest_errors_saccade);
            minvals(13) = min(main_errors_saccade);             maxvals(13) = max(main_errors_saccade);

            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector,above_close_correct_saccade,'b',t_vector,below_close_correct_saccade,'r',t_vector,above_close_errors_saccade,'--b',t_vector,below_close_errors_saccade,'--r','linewidth',2)
            %legend('Above-corr','Below-corr','Above-err','Below-err','location','southwest')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector,above_far_correct_saccade,'b',t_vector,below_far_correct_saccade,'r',t_vector,above_far_errors_saccade,'--b',t_vector,below_far_errors_saccade,'--r','linewidth',2)
            %legend('Above-corr','Below-corr','Above-err','Below-err','location','southwest')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector,above_furthest_correct_saccade,'b',t_vector,below_furthest_correct_saccade,'r',t_vector,above_furthest_errors_saccade,'--b',t_vector,below_furthest_errors_saccade,'--r','linewidth',2)
            legend('Above-corr','Below-corr','Above-err','Below-err','location','southwest')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Furthest','fontweight','bold')

            [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct) ' nErrors = ' mat2str(n_errors)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')

            if pdfFlag == 1
                %Print PDF
                %eval(['print -dpdf ',q,'//scratch/heitzrp/Output/correct_vs_errors_saccade/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors_sacc_reg_bigwindow.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/correct_vs_errors_saccade/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors_sacc_reg_postsaccade_truncated.jpg',q])
            end

            close all
        end


        close all
    end

    %for current pair

    %clean up variables that will change between comparisons for safety
    clear JPSTC_correct_saccade   JPSTC_errors_saccade ...
        cor_correct_saccade cor_errors_saccade ...
        wf_sig1_correct_saccade wf_sig1_errors_saccade ...
        wf_sig2_correct_saccade  wf_sig2_errors_saccade ...
        n_correct n_errors FFT_correct_1_saccade FFT_correct_2_saccade ...
        FFT_errors_1_saccade FFT_errors_2_saccade ...

end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes
end