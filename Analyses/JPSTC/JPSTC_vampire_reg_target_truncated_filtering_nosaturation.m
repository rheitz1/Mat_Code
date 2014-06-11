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
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    
    %make sure we have data for all conditions
    if isempty(errors) == 1
        error_skip = 1;
    end
    
    
    
    %generate matrices, limit size of channels
    %truncate on saccade so we eliminate artifactual correlation due to
    %saccade
    sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
    sig1_correct(1:length(correct),1:451) = NaN;
    sig1_correct_notch(1:length(correct),1:451) = NaN;
    sig1_correct_band(1:length(correct),1:451) = NaN;
    
    sig2_correct(1:length(correct),1:451) = NaN;
    sig2_correct_notch(1:length(correct),1:451) = NaN;
    sig2_correct_band(1:length(correct),1:451) = NaN;
    
    
    %filter signals with either 60Hz notch or 55-80Hz band-stop
    %have to do this before truncating @ saccade because function filtSig
    %cannot handle NaN values.
    sig1_notch = filtSig(sig1',60)';
    sig1_band = filtSig(sig1',[55 80])';
    
    sig2_notch = filtSig(sig2',60)';
    sig2_band = filtSig(sig2',[55 80])';
    
    
    %truncate correct trial signals at SRT (and then shift back another 20
    %ms to help account for any pre-movement buildup
    %also, start at 450 (actually a 50 ms pre-target baseline)
    for trl = 1:length(correct)
        if ~isnan(SRT(correct(trl),1)) && ceil(SRT(correct(trl),1)) + 50 < 450
            sig1_correct(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
            sig1_correct_notch(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig1_notch(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
            sig1_correct_band(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig1_band(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
            
            sig2_correct(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
            sig2_correct_notch(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig2_notch(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
            sig2_correct_band(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig2_band(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
            
        else
            sig1_correct(trl,1:451) = sig1(correct(trl),450:900);
            sig1_correct_notch(trl,1:451) = sig1_notch(correct(trl),450:900);
            sig1_correct_band(trl,1:451) = sig1_band(correct(trl),450:900);
            
            sig2_correct(trl,1:451) = sig2(correct(trl),450:900);
            sig2_correct_notch(trl,1:451) = sig2_notch(correct(trl),450:900);
            sig2_correct_band(trl,1:451) = sig2_band(correct(trl),450:900);
        end
    end
    
    
    %NOTE: BASELINE CORRECTION
    %baseline correct to eliminate large jumpts in absolute voltage
    sig1_correct = sig1_correct - repmat(sig1_correct(:,1),1,451);
    sig1_correct_notch = sig1_correct_notch - repmat(sig1_correct_notch(:,1),1,451);
    sig1_correct_band = sig1_correct_band - repmat(sig1_correct_band(:,1),1,451);
    
    sig2_correct = sig2_correct - repmat(sig2_correct(:,1),1,451);
    sig2_correct_notch = sig2_correct_notch - repmat(sig2_correct_notch(:,1),1,451);
    sig2_correct_band = sig2_correct_band - repmat(sig2_correct_band(:,1),1,451);
    
    
    %==========================================================================
    
    clear sig1 sig2 sig1_notch sig1_band sig2_notch sig2_band correct errors
    
    
    %=========================================================
    % Keep track of average waveforms
    
    %sig1-target aligned
    wf_sig1_correct = nanmean(sig1_correct,1);
    wf_sig1_correct_notch = nanmean(sig1_correct_notch);
    wf_sig1_correct_band = nanmean(sig1_correct_band);
    
    %wf_sig1_errors = nanmean(sig1_errors,1);
    
    %sig2-target aligned
    wf_sig2_correct = nanmean(sig2_correct,1);
    wf_sig2_correct_notch = nanmean(sig2_correct_notch);
    wf_sig2_correct_band = nanmean(sig2_correct_band);
    
    %wf_sig2_errors = nanmean(sig2_errors,1);
    
    
    
    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise
    
    %sig1-target aligned
    [freq FFT_correct_1] = getFFT(wf_sig1_correct);
    [freq FFT_correct_1_notch] = getFFT(wf_sig1_correct_notch);
    [freq FFT_correct_1_band] = getFFT(wf_sig1_correct_band);
    
    %[freq FFT_errors_1] = getFFT(wf_sig1_errors);
    
    %sig2-target aligned
    [freq FFT_correct_2] = getFFT(wf_sig2_correct);
    [freq FFT_correct_2_notch] = getFFT(wf_sig2_correct_notch);
    [freq FFT_correct_2_band] = getFFT(wf_sig2_correct_band);
    
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
    cor_correct(1:size(sig1_correct,1),1:401) = NaN;
    cor_correct_notch(1:size(sig1_correct_notch,1),1:401) = NaN;
    cor_correct_band(1:size(sig1_correct_band,1),1:401) = NaN;
    
   % cor_errors(1:size(sig1_errors,1),1:401) = NaN;
    
    lags = -200:200;
    
    %Correlogram for correct trials
    %Need to correct for truncated signals.
    %Find NOT NAN trials - will be the same for both sig1 and sig2, so can
    %just check one of them.
    for trl = 1:size(sig1_correct,1)
        EndDat = length(find(~isnan(sig1_correct(trl,:))));
        cor_correct(trl,1:401) = xcorr(sig2_correct(trl,1:EndDat),sig1_correct(trl,1:EndDat),200,'coeff');
        cor_correct_notch(trl,1:401) = xcorr(sig2_correct_notch(trl,1:EndDat),sig1_correct_notch(trl,1:EndDat),200,'coeff');
        cor_correct_band(trl,1:401) = xcorr(sig2_correct_band(trl,1:EndDat),sig1_correct_band(trl,1:EndDat),200,'coeff');
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
    JPSTC_correct(1:451,1:451) = NaN;
    JPSTC_correct_notch(1:451,1:451) = NaN;
    JPSTC_correct_band(1:451,1:451) = NaN;
    
    %JPSTC_errors(1:451,1:451) = NaN;
    %shift_predictor(1:451,1:451) = NaN;
    %====================================
    
    
    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials Targ-align & Sacc-align, Shift-Predictor]')
    
    for time1 = 1:size(sig1_correct,2)
        for time2 = 1:size(sig2_correct,2)
            %eliminate trials with saturation or abnormally large
            %increases/decreases in voltage: discard > or < 2std of mean voltage
            %across trials at given time point
            ub_1 = nanmean(sig1_correct(:,time1)) + 2*nanstd(sig1_correct(:,time1));
            ub_2 = nanmean(sig2_correct(:,time2)) + 2*nanstd(sig2_correct(:,time2));
            
            lb_1 = nanmean(sig1_correct(:,time1)) - 2*nanstd(sig1_correct(:,time1));
            lb_2 = nanmean(sig2_correct(:,time2)) - 2*nanstd(sig2_correct(:,time2));
            
            
            a = find(~isnan(sig1_correct(:,time1)) & sig1_correct(:,time1) < ub_1 & sig1_correct(:,time1) > lb_1);
            b = find(~isnan(sig2_correct(:,time2)) & sig2_correct(:,time2) < ub_2 & sig2_correct(:,time2) > lb_2);
            noNANlist = intersect(a,b);
            if ~isempty(noNANlist)
                JPSTC_correct(time1,time2) = corr(sig1_correct(noNANlist,time1),sig2_correct(noNANlist,time2));
                JPSTC_correct_notch(time1,time2) = corr(sig1_correct_notch(noNANlist,time1),sig2_correct_notch(noNANlist,time2));
                JPSTC_correct_band(time1,time2) = corr(sig1_correct_band(noNANlist,time1),sig2_correct_band(noNANlist,time2));
                %shift_predictor(time1,time2) = corr(circshift(sig1_correct(noNANlist,time1),1),sig2_correct(noNANlist,time2));
            else
                JPSTC_correct(time1,time2) = NaN;
                JPSTC_correct_notch(time1,time2) = NaN;
                JPSTC_correct_band(time1,time2) = NaN;
                %shift_predictor(time1,time2) = NaN;
            end
        end
    end
    n_correct = size(sig1_correct,1);
    clear sig1_correct sig1_correct_notch sig1_correct_band ...
        sig2_correct sig2_correct_notch sig2_correct_band
    
    
    
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
    %save(['~/desktop/test/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg_target_truncated_filtering.mat'],'SRT','RFs','MFs','BestRF','BestMF','plottime','lags','JPSTC_correct','JPSTC_correct_notch','JPSTC_correct_band','cor_correct','cor_correct_notch','cor_correct_band','wf_sig1_correct','wf_sig1_correct_notch','wf_sig1_correct_band','wf_sig2_correct','wf_sig2_correct_notch','wf_sig2_correct_band','-mat')
             save(['//scratch/heitzrp/Output/correct_filtering_nosaturation/Matrices/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg_target_truncated_filtering_nosaturation.mat'],'SRT','RFs','MFs','BestRF','BestMF','plottime','lags','JPSTC_correct','JPSTC_correct_notch','JPSTC_correct_band','cor_correct','cor_correct_notch','cor_correct_band','wf_sig1_correct','wf_sig1_correct_notch','wf_sig1_correct_band','wf_sig2_correct','wf_sig2_correct_notch','wf_sig2_correct_band','-mat')
    %     end
    
    %======================================
    
    
    if plotFlag == 1
        %find color limits
        minCorrect = min(min(JPSTC_correct));
        minCorrect_notch = min(min(JPSTC_correct_notch));
        minCorrect_band = min(min(JPSTC_correct_band));
        
        maxCorrect = max(max(JPSTC_correct));
        maxCorrect_notch = max(max(JPSTC_correct_notch));
        maxCorrect_band = max(max(JPSTC_correct_band));
        
        minC = min(min(minCorrect,minCorrect_notch),minCorrect_band);
        maxC = max(max(maxCorrect,maxCorrect_notch),maxCorrect_band);
        clim = [minC maxC];
        %============================================
        %Figure 1: Correct trials no filtering, 60Hz notch filter,
        % and 55-80Hz band-stop
        figure
        orient landscape
        set(gcf,'renderer','painters')
        set(gcf,'Color','white')
        
        %JPSTC - no filter
        subplot(4,8,[1:2 9:10])
        surface(JPSTC_correct,'edgecolor','none')
        axis([0 450 0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        set(gca,'Clim',clim)
        
        %Plot lines marking target onset time
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)
        
        %Plot boxes around areas to average
        %
        %             %above, furthest
        %             line([52 64],[130 118],'color','g')
        %             line([52 302],[130 380],'color','g')
        %             line([302 314],[380 368],'color','g')
        %             line([64 314],[118 368],'color','g')
        %
        %             %above, far
        %             line([65 77],[117 105],'color','r')
        %             line([65 315],[117 367],'color','r')
        %             line([315 327],[367 355],'color','r')
        %             line([77 327],[105 355],'color','r')
        %
        %             %above, close
        %             line([78 90],[104 92],'color','b')
        %             line([78 328],[104 354],'color','b')
        %             line([328 340],[354 342],'color','b')
        %             line([90 340],[92 342],'color','b')
        %
        %             %below, close
        %             line([92 104],[90 78],'color','b','linestyle','--')
        %             line([92 342],[90 340],'color','b','linestyle','--')
        %             line([342 354],[340 328],'color','b','linestyle','--')
        %             line([104 354],[78 328],'color','b','linestyle','--')
        %
        %             %below, far
        %             line([105 117],[77 65],'color','r','linestyle','--')
        %             line([105 355],[77 327],'color','r','linestyle','--')
        %             line([355 367],[327 315],'color','r','linestyle','--')
        %             line([117 367],[65 315],'color','r','linestyle','--')
        %
        %             %below, furthest
        %             line([118 130],[64 52],'color','g','linestyle','--')
        %             line([118 368],[64 314],'color','g','linestyle','--')
        %             line([368 380],[314 302],'color','g','linestyle','--')
        %             line([130 380],[52 302],'color','g','linestyle','--')
        %
        %             %thickdiagonal
        %             line([52 130],[128 49],'color','k','linewidth',2)
        %             line([52 302],[128 383],'color','k','linewidth',2)
        %             line([302 383],[381 304],'color','k','linewidth',2)
        %             line([130 381],[49 304],'color','k','linewidth',2)
        
        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' No Filter'],'fontweight','bold')
        ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')
        
        
        %JPSTC - 60Hz notch filter
        subplot(4,8,[4:5 12:13])
        surface(JPSTC_correct_notch,'edgecolor','none')
        axis([0 450 0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        set(gca,'Clim',clim)
        
        %Plot lines marking target onset time
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)
        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' 60Hz Notch'],'fontweight','bold')
        ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')
        
        
        %JPSTC - 55-80Hz band-stop filter
        subplot(4,8,[7:8 15:16])
        surface(JPSTC_correct_band,'edgecolor','none')
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
        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' 55-80Hz Band-Stop'],'fontweight','bold')
        ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')
        
        
        %Plot sig1 vs sig2
        subplot(4,8,17:20)
        plot(plottime,wf_sig1_correct,'b',plottime,wf_sig1_correct_notch,'r',plottime,wf_sig1_correct_band,'g','linewidth',2)
        ylim([min((min(min(wf_sig1_correct),min(wf_sig1_correct_notch))),min(wf_sig1_correct_band)) max((max(max(wf_sig1_correct),max(wf_sig1_correct_notch))),max(wf_sig1_correct_band))])
        xlim([-50 400])
        ylabel('mV','fontweight','bold')
        set(gca,'ytick',[])
        legend([cell2mat(chanlist(pairings(pair,1))) ' No Filter'],[cell2mat(chanlist(pairings(pair,1))) ' 60Hz Notch'],[cell2mat(chanlist(pairings(pair,1))) ' 50-80 Band-Stop'])
        
        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold
        plot(plottime,wf_sig2_correct,'--b',plottime,wf_sig2_correct_notch,'--r',plottime,wf_sig2_correct_band,'--g','linewidth',2)
        ylim([min((min(min(wf_sig2_correct),min(wf_sig2_correct_notch))),min(wf_sig2_correct_band)) max((max(max(wf_sig2_correct),max(wf_sig2_correct_notch))),max(wf_sig2_correct_band))])
        xlim([-50 400])
        set(gca,'ytick',[])
        legend([cell2mat(chanlist(pairings(pair,2))) ' No Filter'],[cell2mat(chanlist(pairings(pair,2))) ' 60Hz Notch'],[cell2mat(chanlist(pairings(pair,2))) ' 55-80 Band-Stop'],'location','southeast')
        title('Mean Signals','fontweight','bold')
        
        %Plot FFTs
        %only plot FFTs for correct trials; likely to be the same, yet
        %attenuated, for error trials
        subplot(4,8,25:26)
        plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
        xlim([10 80])
        ylabel('Power','fontweight','bold')
        xlabel('Time','fontweight','bold')
        set(gca,'ytick',[])
        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold;
        plot(freq(5:end),FFT_correct_1_band(5:end),'r','linewidth',1)
        xlim([10 80])
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold off
        title('FFT (All Correct Trials)','fontweight','bold')
        
        
        %Plot Correlogram
        subplot(4,8,21:24)
        plot(lags,mean(cor_correct),'b',lags,mean(cor_correct_notch),'r',lags,mean(cor_correct_band),'g','linewidth',2)
        legend('No Filt','Notch','Band')
        xlabel('Lag','fontweight','bold')
        set(gca,'YAxisLocation','right')
        ylabel('Correlation','fontweight','bold')
        title('Correlogram','fontweight','bold')
        
        %
        %             %Plot Off-diagonal averages
        %             minvals(1) = min(above_close_ss2);      maxvals(1) = max(above_close_ss2);
        %             minvals(2) = min(above_far_ss2);        maxvals(2) = max(above_far_ss2);
        %             minvals(3) = min(above_furthest_ss2);   maxvals(3) = max(above_furthest_ss2);
        %             minvals(4) = min(below_close_ss2);      maxvals(4) = max(below_close_ss2);
        %             minvals(5) = min(below_far_ss2);        maxvals(5) = max(below_far_ss2);
        %             minvals(6) = min(below_furthest_ss2);   maxvals(6) = max(below_furthest_ss2);
        %             minvals(7) = min(above_close_ss4);      maxvals(7) = max(above_close_ss4);
        %             minvals(8) = min(above_far_ss4);        maxvals(8) = max(above_far_ss4);
        %             minvals(9) = min(above_furthest_ss4);   maxvals(9) = max(above_furthest_ss4);
        %             minvals(10) = min(below_close_ss4);     maxvals(10) = max(below_close_ss4);
        %             minvals(11) = min(below_far_ss4);       maxvals(11) = max(below_far_ss4);
        %             minvals(12) = min(below_furthest_ss4);  maxvals(12) = max(below_furthest_ss4);
        %             minvals(13) = min(above_close_ss8);     maxvals(13) = max(above_close_ss8);
        %             minvals(14) = min(above_far_ss8);       maxvals(14) = max(above_far_ss8);
        %             minvals(15) = min(above_furthest_ss8);  maxvals(15) = max(above_furthest_ss8);
        %             minvals(16) = min(below_close_ss8);     maxvals(16) = max(below_close_ss8);
        %             minvals(17) = min(below_far_ss8);       maxvals(17) = max(below_far_ss8);
        %             minvals(18) = min(below_furthest_ss8);  maxvals(18) = max(below_furthest_ss8);
        %
        %             minval = min(minvals);
        %             maxval = max(maxvals);
        %
        %
        %             %close
        %             subplot(4,8,27:28)
        %             plot(t_vector,above_close_ss2,'b',t_vector,above_close_ss4,'r',t_vector,above_close_ss8,'g',t_vector,below_close_ss2,'--b',t_vector,below_close_ss4,'--r',t_vector,below_close_ss8,'--g','linewidth',2)
        %             %legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
        %             ylim([minval maxval])
        %             xlim([t_vector(1) t_vector(end)])
        %             title('Close','fontweight','bold')
        %             %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])
        %
        %             %far
        %             subplot(4,8,29:30)
        %             plot(t_vector,above_far_ss2,'b',t_vector,above_far_ss4,'r',t_vector,above_far_ss8,'g',t_vector,below_far_ss2,'--b',t_vector,below_far_ss4,'--r',t_vector,below_far_ss8,'--g','linewidth',2)
        %             %legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
        %             ylim([minval maxval])
        %             xlim([t_vector(1) t_vector(end)])
        %             title('Far','fontweight','bold')
        %
        %             %furthest
        %             subplot(4,8,31:32)
        %             plot(t_vector,above_furthest_ss2,'b',t_vector,above_furthest_ss4,'r',t_vector,above_furthest_ss8,'g',t_vector,below_furthest_ss2,'--b',t_vector,below_furthest_ss4,'--r',t_vector,below_furthest_ss8,'--g','linewidth',2)
        %             legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
        %             ylim([minval maxval])
        %             xlim([t_vector(1) t_vector(end)])
        %             title('Furthest','fontweight','bold')
        
        
        [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct)],'y');
        set(h2,'FontSize',12,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'FontSize',12,'FontWeight','bold')
        
        
        
        if pdfFlag == 1
            %Print PDF
            %      eval(['print -dpdf ',q,'//scratch/heitzrp/Output/set_size/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_targ_reg.pdf',q])
            %Print JPG w/ 0% compression
            %eval(['print -djpeg100 ',q,'~/desktop/test/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_targ_reg.jpg',q])
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/correct_filtering_nosaturation/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_reg_target_truncated_filtering_nosaturation.jpg',q])
        end
        
        close all
    end
    
    
    
end %for current pair

%clean up variables that will change between comparisons for safety
clear JPSTC_correct JPSTC_correct_notch JPSTC_correct_band JPSTC_errors ...
    cor_correct cor_correct_notch cor_correct_band wf_sig1_correct ...
    wf_sig1_correct_notch wf_sig1_correct_band wf_sig2_correct wf_sig2_errors ...
    n_correct correct errors ...
    freq FFT_correct_1 FFT_correct_1_notch FFT_correct_1_band FFT_correct_2 ...
    FFT_corrct_2_notch FFT_correct_2_band


disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes

end %for current session

