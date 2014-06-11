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
eval(['load(' q file qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);

%rename LFP channels for consistency
clear ADlist
varlist = who;
chanlist = varlist(strmatch('AD',varlist));
clear varlist

plottime = (-50:400);
plottime_saccade = (-400:50);


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
    correct_left = find(ismember(Target_(:,2),[3 4 5]) & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    correct_right = find(ismember(Target_(:,2),[7 0 1]) & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    %    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);


    %generate matrices, limit size of channels
    %truncate on saccade so we eliminate artifactual correlation due to
    %saccade
    sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
    sig1_correct_left(1:length(correct_left),1:451) = NaN;
    sig1_correct_right(1:length(correct_right),1:451) = NaN;
    sig2_correct_left(1:length(correct_left),1:451) = NaN;
    sig2_correct_right(1:length(correct_right),1:451) = NaN;


    %truncate correct trial signals at SRT (and then shift back another 20
    %ms to help account for any pre-movement buildup
    %also, start at 450 (actually a 50 ms pre-target baseline)
    for trl = 1:length(correct_left)
        if ~isnan(SRT(correct_left(trl),1)) && ceil(SRT(correct_left(trl),1)) + 50 < 450
            sig1_correct_left(trl,1:ceil(SRT(correct_left(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(correct_left(trl),1)) + 500 - 20);
            sig2_correct_left(trl,1:ceil(SRT(correct_left(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(correct_left(trl),1)) + 500 - 20);
        else
            sig1_correct_left(trl,1:451) = sig1(correct_left(trl),450:900);
            sig2_correct_left(trl,1:451) = sig2(correct_left(trl),450:900);
        end
    end

    for trl = 1:length(correct_right)
        if ~isnan(SRT(correct_right(trl),1)) && ceil(SRT(correct_right(trl),1)) + 50 < 450
            sig1_correct_right(trl,1:ceil(SRT(correct_right(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(correct_right(trl),1)) + 500 - 20);
            sig2_correct_right(trl,1:ceil(SRT(correct_right(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(correct_right(trl),1)) + 500 - 20);
        else
            sig1_correct_right(trl,1:451) = sig1(correct_right(trl),450:900);
            sig2_correct_right(trl,1:451) = sig2(correct_right(trl),450:900);
        end
    end


    %NOTE: BASELINE CORRECTION
    %baseline correct to eliminate large jumpts in absolute voltage
    sig1_correct_left = sig1_correct_left - repmat(sig1_correct_left(:,1),1,451);
    sig1_correct_right = sig1_correct_right - repmat(sig1_correct_right(:,1),1,451);

    sig2_correct_left = sig2_correct_left - repmat(sig2_correct_left(:,1),1,451);
    sig2_correct_right = sig2_correct_right - repmat(sig2_correct_right(:,1),1,451);



    %==========================================================================

    clear sig1 sig2 correct_left correct_right


    %=========================================================
    % Keep track of average waveforms

    %sig1-target aligned
    wf_sig1_correct_left = nanmean(sig1_correct_left,1);
    wf_sig1_correct_right = nanmean(sig1_correct_right,1);
    %wf_sig1_errors = nanmean(sig1_errors,1);

    %sig2-target aligned
    wf_sig2_correct_left = nanmean(sig2_correct_left,1);
    wf_sig2_correct_right = nanmean(sig2_correct_right,1);
    %wf_sig2_errors = nanmean(sig2_errors,1);



    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise

    %sig1-target aligned
    [freq FFT_correct_1] = getFFT(wf_sig1_correct_left);

    %[freq FFT_errors_1] = getFFT(wf_sig1_errors);

    %sig2-target aligned
    [freq FFT_correct_2] = getFFT(wf_sig2_correct_left);

    % [freq FFT_errors_2] = getFFT(wf_sig2_errors);


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
    cor_correct_left(1:size(sig1_correct_left,1),1:401) = NaN;
    cor_correct_right(1:size(sig1_correct_right,1),1:401) = NaN;
    % cor_errors(1:size(sig1_errors,1),1:401) = NaN;

    lags = -200:200;

    %Correlogram for correct trials
    %Need to correct for truncated signals.
    %Find NOT NAN trials - will be the same for both sig1 and sig2, so can
    %just check one of them.
    for trl = 1:size(sig1_correct_left,1)
        EndDat = length(find(~isnan(sig1_correct_left(trl,:))));
        cor_correct_left(trl,1:401) = xcorr(sig2_correct_left(trl,1:EndDat),sig1_correct_left(trl,1:EndDat),200,'coeff');
    end

    for trl = 1:size(sig1_correct_right,1)
        EndDat = length(find(~isnan(sig1_correct_right(trl,:))));
        cor_correct_right(trl,1:401) = xcorr(sig2_correct_right(trl,1:EndDat),sig1_correct_right(trl,1:EndDat),200,'coeff');
    end

    %Correlogram for error trials
    %     for trl = 1:size(sig1_errors,1)
    %         EndDat = length(find(~isnan(sig1_errors(trl,:))));
    %         cor_errors(trl,1:401) = xcorr(sig2_errors(trl,1:EndDat),sig1_errors(trl,1:EndDat),200,'coeff');
    %     end
    clear EndDat

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % JPSTC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %===================================
    %Pre-allocate space
    JPSTC_correct_left(1:451,1:451) = NaN;
    JPSTC_correct_right(1:451,1:451) = NaN;
    %JPSTC_errors(1:451,1:451) = NaN;
    %shift_predictor(1:451,1:451) = NaN;
    %====================================


    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials Target Left]')

    for time1 = 1:size(sig1_correct_left,2)
        for time2 = 1:size(sig2_correct_left,2)
            %eliminate trials with saturation or abnormally large
            %increases/decreases in voltage: discard > or < 2std of mean voltage
            %across trials at given time point
            ub_1 = nanmean(sig1_correct_left(:,time1)) + 2*nanstd(sig1_correct_left(:,time1));
            ub_2 = nanmean(sig2_correct_left(:,time2)) + 2*nanstd(sig2_correct_left(:,time2));

            lb_1 = nanmean(sig1_correct_left(:,time1)) - nanstd(sig1_correct_left(:,time1));
            lb_2 = nanmean(sig2_correct_left(:,time2)) - nanstd(sig2_correct_left(:,time2));


            a = find(~isnan(sig1_correct_left(:,time1)) & sig1_correct_left(:,time1) < ub_1 & sig1_correct_left(:,time1) > lb_1);
            b = find(~isnan(sig2_correct_left(:,time2)) & sig2_correct_left(:,time2) < ub_2 & sig2_correct_left(:,time2) > lb_2);
            noNANlist = intersect(a,b);
            if ~isempty(noNANlist)
                JPSTC_correct_left(time1,time2) = corr(sig1_correct_left(noNANlist,time1),sig2_correct_left(noNANlist,time2));
            else
                JPSTC_correct_left(time1,time2) = NaN;
            end
        end
    end
    n_correct_left = size(sig1_correct_left,1);

    disp('Running... [Correct Trials Target Right]')

    for time1 = 1:size(sig1_correct_right,2)
        for time2 = 1:size(sig2_correct_right,2)
            %eliminate trials with saturation or abnormally large
            %increases/decreases in voltage: discard > or < 2std of mean voltage
            %across trials at given time point
            ub_1 = nanmean(sig1_correct_right(:,time1)) + 2*nanstd(sig1_correct_right(:,time1));
            ub_2 = nanmean(sig2_correct_right(:,time2)) + 2*nanstd(sig2_correct_right(:,time2));

            lb_1 = nanmean(sig1_correct_right(:,time1)) - 2*nanstd(sig1_correct_right(:,time1));
            lb_2 = nanmean(sig2_correct_right(:,time2)) - 2*nanstd(sig2_correct_right(:,time2));


            a = find(~isnan(sig1_correct_right(:,time1)) & sig1_correct_right(:,time1) < ub_1 & sig1_correct_right(:,time1) > lb_1);
            b = find(~isnan(sig2_correct_right(:,time2)) & sig2_correct_right(:,time2) < ub_2 & sig2_correct_right(:,time2) > lb_2);
            noNANlist = intersect(a,b);
            if ~isempty(noNANlist)
                JPSTC_correct_right(time1,time2) = corr(sig1_correct_right(noNANlist,time1),sig2_correct_right(noNANlist,time2));
            else
                JPSTC_correct_right(time1,time2) = NaN;
            end
        end
    end
    n_correct_right = size(sig1_correct_right,1);


    clear sig1_correct_left sig1_correct_right ...
        sig2_correct_left sig2_correct_right



    %     % 2) Error TRIALS
    %     %    use times -50 to 400 (or until saccade)
    %     if error_skip ~= 1
    %         disp('Running... [Error Trials]')
    %
    %         for time1 = 1:size(sig1_errors,2)
    %             for time2 = 1:size(sig2_errors,2)
    %                 a = find(~isnan(sig1_errors(:,time1)));
    %                 b = find(~isnan(sig2_errors(:,time2)));
    %                 noNANlist = intersect(a,b);
    %                 if ~isempty(noNANlist)
    %                     JPSTC_errors(time1,time2) = corr(sig1_errors(noNANlist,time1),sig2_errors(noNANlist,time2));
    %                 else
    %                     JPSTC_errors(time1,time2) = NaN;
    %                 end
    %                 clear a b noNANlist
    %             end
    %         end
    %         clear time1 time2
    %         n_errors = size(sig1_errors,1);
    %         clear sig1_errors sig2_errors
    %
    %     else
    %         disp('No Errors found...skipping')
    %     end



    %     ======================================================================
    %     =====================End Main Loops===================================



    %======================================================================
    % Calculate Main and Off-Diagonal Averages
    %     [t_vector,above_furthest_correct,above_far_correct,above_close_correct,main_correct,below_close_correct,below_far_correct,below_furthest_correct,thickdiagonal_correct] = OffDiagonalAverage_vampire2(JPSTC_correct);
    %     [t_vector,above_furthest_errors,above_far_errors,above_close_errors,main_errors,below_close_errors,below_far_errors,below_furthest_errors,thickdiagonal_errors] = OffDiagonalAverage_vampire2(JPSTC_errors);

    %======================================================================


    %======================================
    % Save Variables
    %     if saveFlag == 1
    %save(['~/desktop/test/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg_target_truncated_filtering.mat'],'SRT','plottime','lags','JPSTC_correct_left','JPSTC_correct_right','cor_correct_left','cor_correct_right','wf_sig1_correct_left','wf_sig1_correct_right','wf_sig2_correct_left','wf_sig2_correct_right','-mat')
    save(['//scratch/heitzrp/Output/correct_nosaturation_hemi/Matrices/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg_target_truncated_nosaturation_hemi.mat'],'SRT','plottime','lags','JPSTC_correct_left','JPSTC_correct_right','cor_correct_left','cor_correct_right','wf_sig1_correct_left','wf_sig1_correct_right','wf_sig2_correct_left','wf_sig2_correct_right','-mat')
    %     end

    %======================================


    if plotFlag == 1
        %find color limits
        minCorrect_left = min(min(JPSTC_correct_left));
        minCorrect_right = min(min(JPSTC_correct_right));

        maxCorrect_left = max(max(JPSTC_correct_left));
        maxCorrect_right = max(max(JPSTC_correct_right));

        clim = [min(minCorrect_left,minCorrect_right) max(maxCorrect_left,maxCorrect_right)];
        %============================================
        %Figure 1: Correct trials no filtering, 60Hz notch filter,
        % and 55-80Hz band-stop
        figure
        orient landscape
        set(gcf,'renderer','painters')
        set(gcf,'Color','white')

        %Plot JPSTC
        subplot(4,8,[1:4 9:12])
        surface(JPSTC_correct_left,'edgecolor','none')
        xlim([0 450])
        ylim([0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        set(gca,'Clim',clim)

        %Plot lines marking target onset time
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)

        %Plot boxes around areas to average

        %above, furthest
        %         line([52 64],[130 118],'color','g')
        %         line([52 302],[130 380],'color','g')
        %         line([302 314],[380 368],'color','g')
        %         line([64 314],[118 368],'color','g')
        %
        %         %above, far
        %         line([65 77],[117 105],'color','r')
        %         line([65 315],[117 367],'color','r')
        %         line([315 327],[367 355],'color','r')
        %         line([77 327],[105 355],'color','r')
        %
        %         %above, close
        %         line([78 90],[104 92],'color','b')
        %         line([78 328],[104 354],'color','b')
        %         line([328 340],[354 342],'color','b')
        %         line([90 340],[92 342],'color','b')
        %
        %         %below, close
        %         line([92 104],[90 78],'color','b','linestyle','--')
        %         line([92 342],[90 340],'color','b','linestyle','--')
        %         line([342 354],[340 328],'color','b','linestyle','--')
        %         line([104 354],[78 328],'color','b','linestyle','--')
        %
        %         %below, far
        %         line([105 117],[77 65],'color','r','linestyle','--')
        %         line([105 355],[77 327],'color','r','linestyle','--')
        %         line([355 367],[327 315],'color','r','linestyle','--')
        %         line([117 367],[65 315],'color','r','linestyle','--')
        %
        %         %below, furthest
        %         line([118 130],[64 52],'color','g','linestyle','--')
        %         line([118 368],[64 314],'color','g','linestyle','--')
        %         line([368 380],[314 302],'color','g','linestyle','--')
        %         line([130 380],[52 302],'color','g','linestyle','--')
        %
        %         %thickdiagonal
        %         line([52 130],[128 49],'color','k','linewidth',2)
        %         line([52 302],[128 383],'color','k','linewidth',2)
        %         line([302 383],[381 304],'color','k','linewidth',2)
        %         line([130 381],[49 304],'color','k','linewidth',2)

        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' Target Left'],'fontweight','bold')
        ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

        %Plot Shift-Predictor (shifted Sig1 by 1 trial)
        subplot(4,8,[5:8 13:16])
        surface(JPSTC_correct_right,'edgecolor','none')
        xlim([0 450])
        ylim([0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        set(gca,'Clim',clim)
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)
        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' Target Right'],'fontweight','bold')

        %Plot sig1 vs sig2

        %         subplot(4,8,17:20)
        %         plot(plottime,wf_sig1_correct,'linewidth',2)
        %         ylim([min(wf_sig1_correct) max(wf_sig1_correct)])
        %         xlim([-50 400])
        %         set(gca,'ytick',[])
        %         ylabel('mV','fontweight','bold')
        %         legend(cell2mat(chanlist(pairings(pair,1))))
        %
        %         ax1 = gca;
        %         ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        %         hold
        %         plot(plottime,wf_sig2_correct,'r','linewidth',2)
        %         ylim([min(wf_sig2_correct) max(wf_sig2_correct)])
        %         xlim([-50 400])
        %         set(gca,'ytick',[])
        %         legend(cell2mat(chanlist(pairings(pair,2))),'location','southeast')
        %         title('Mean Signals','fontweight','bold')
        %
        %
        %         %Plot FFTs
        %         subplot(4,8,25:26)
        %         plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
        %         xlim([10 80])
        %         ylabel('Power','fontweight','bold')
        %         xlabel('Time','fontweight','bold')
        %         set(gca,'ytick',[])
        %         ax1 = gca;
        %         ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        %         hold;
        %         plot(freq(5:end),FFT_correct_2(5:end),'r','linewidth',1)
        %         xlim([10 80])
        %         set(gca,'xtick',[])
        %         set(gca,'ytick',[])
        %         hold off
        %         title('FFT (All Correct Trials)','fontweight','bold')


        %Plot Correlogram
        subplot(4,8,21:24)
        plot(lags,mean(cor_correct_left),'b',lags,mean(cor_correct_right),'r','linewidth',2)
        xlabel('Lag','fontweight','bold')
        set(gca,'YAxisLocation','right')
        ylabel('Correlation','fontweight','bold')
        title('Correlogram','fontweight','bold')
        legend('TargL','TargR')


        %Plot Off-diagonal averages
        %
        %         %find global min and max so can compare across plots
        %         minvals(1) = min(above_close_correct);      maxvals(1) = max(above_close_correct);
        %         minvals(2) = min(above_far_correct);        maxvals(2) = max(above_far_correct);
        %         minvals(3) = min(above_furthest_correct);   maxvals(3) = max(above_furthest_correct);
        %         minvals(4) = min(below_close_correct);      maxvals(4) = max(below_close_correct);
        %         minvals(5) = min(below_far_correct);        maxvals(5) = max(below_far_correct);
        %         minvals(6) = min(below_furthest_correct);   maxvals(6) = max(below_furthest_correct);
        %         minvals(7) = min(main_correct);             maxvals(7) = max(main_correct);
        %         minval = min(minvals);
        %         maxval = max(maxvals);
        %
        %
        %         %close
        %         subplot(4,8,27:28)
        %         plot(t_vector,above_close_correct,'b',t_vector,below_close_correct,'--b',t_vector,main_correct,'k','linewidth',2)
        %         %legend('Above','Below','Main','location','southeast')
        %         ylim([minval maxval])
        %         xlim([t_vector(1) t_vector(end)])
        %         title('Close','fontweight','bold')
        %         %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])
        %
        %         %far
        %         subplot(4,8,29:30)
        %         plot(t_vector,above_far_correct,'r',t_vector,below_far_correct,'--r',t_vector,main_correct,'k','linewidth',2)
        %         % legend('Above','Below','Main','location','southeast')
        %         ylim([minval maxval])
        %         xlim([t_vector(1) t_vector(end)])
        %         title('Far','fontweight','bold')
        %
        %         %furthest
        %         subplot(4,8,31:32)
        %         plot(t_vector,above_furthest_correct,'g',t_vector,below_furthest_correct,'--g',t_vector,main_correct,'k','linewidth',2)
        %         legend('Above','Below','Main','location','southeast')
        %         ylim([minval maxval])
        %         xlim([t_vector(1) t_vector(end)])
        %         title('Furthest','fontweight','bold')


        [ax,h2] = suplabel(['nCorrect Left = ' mat2str(n_correct_left) ' nCorrect Right = ' mat2str(n_correct_right)],'y');
        set(h2,'FontSize',12,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'FontSize',12,'FontWeight','bold')



        if pdfFlag == 1
            %Print PDF
            %      eval(['print -dpdf ',q,'//scratch/heitzrp/Output/set_size/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_targ_reg.pdf',q])
            %Print JPG w/ 0% compression
            %eval(['print -djpeg100 ',q,'~/desktop/test/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_targ_reg.jpg',q])
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/correct_nosaturation_hemi/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_reg_target_truncated_nosaturation_hemi.jpg',q])
        end

        close all
    end



end %for current pair

%clean up variables that will change between comparisons for safety
clear JPSTC_correct_left JPSTC_correct_right ...
    cor_correct_left cor_correct_right wf_sig1_correct_left ...
    wf_sig1_correct_right wf_sig2_correct_left wf_sig2_correct_right ...
    n_correct_left n_correct_right ...
    freq FFT_correct_1 FFT_correct_2 ...



disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes

end %for current session

