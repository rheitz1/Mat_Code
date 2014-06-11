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
eval(['load(' q file qcq 'newfile' qcq 'Hemi' qcq 'SaccDir_' qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);

%if Saccade direction not stored on-line, calculate
if length(find(~isnan(SaccDir_))) < 5
    eval(['load(' q file qcq 'EyeX_' qcq 'EyeY_' q ')'])
    getMonk
    [x SaccDir_] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
    clear x EyeX_ EyeY_ ASL_Delay monkey
end
%rename LFP channels for consistency
clear ADlist
varlist = who;
chanlist = varlist(strmatch('AD',varlist));
clear varlist

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
    
    
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    cMed = nanmedian(SRT(correct,1));
    correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50);
    correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    eMed = nanmedian(SRT(errors,1));
    errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50);
    errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) < 2000);
    %make sure we have data for all conditions
    if (isempty(errors) == 1)
        error_skip = 1;
    end
    
    %     %T E M P:  For Debugging
    %     AD09 = AD09(1:100,:);
    %     AD10 = AD10(1:100,:);
    %     correct = 1:100;
    %     errors = 1:100;
    
    
    %generate matrices, limit size of channels
    %truncate on saccade so we eliminate artifactual correlation due to
    %saccade
    sig1_targ = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2_targ = eval(cell2mat(chanlist(pairings(pair,2))));
    
    %     sig1_resp = response_align(sig1_targ,SRT,[-300 600]);
    %     sig2_resp = response_align(sig2_targ,SRT,[-300 600]);
    
    sig1_correct_targ_fast = sig1_targ(correct_fast,:);
    sig1_correct_targ_slow = sig1_targ(correct_slow,:);
    sig1_errors_targ_fast = sig1_targ(errors_fast,:);
    sig1_errors_targ_slow = sig1_targ(errors_slow,:);
    
    sig2_correct_targ_fast = sig2_targ(correct_fast,:);
    sig2_correct_targ_slow = sig2_targ(correct_slow,:);
    sig2_errors_targ_fast = sig2_targ(errors_fast,:);
    sig2_errors_targ_slow = sig2_targ(errors_slow,:);
    
    % % %     %spectra and coherence can't handle NaNs so need to remove from
    % % %     %response-aligned signals.  Note that both signals must have a non-nan
    % % %     %trial for it to be included.
    % % %     index = 1;
    % % %     for trl = 1:size(sig1_correct_resp,1)
    % % %         if isempty(find(isnan(sig1_correct_resp(trl,:)))) == 1 && isempty(find(isnan(sig2_correct_resp(trl,:)))) == 1
    % % %             temp1(index,1:size(sig1_correct_resp,2)) = sig1_correct_resp(trl,:);
    % % %             temp2(index,1:size(sig1_correct_resp,2)) = sig2_correct_resp(trl,:);
    % % %             index = index + 1;
    % % %         end
    % % %     end
    % % %     clear sig1_correct_resp sig2_correct_resp index
    % % %     sig1_correct_resp = temp1;
    % % %     sig2_correct_resp = temp2;
    % % %     clear temp1 temp2
    % % %
    % % %     index = 1;
    % % %     for trl = 1:size(sig1_errors_resp,1)
    % % %         if isempty(find(isnan(sig1_errors_resp(trl,:)))) == 1 && isempty(find(isnan(sig2_errors_resp(trl,:)))) == 1
    % % %             temp1(index,1:size(sig1_errors_resp,2)) = sig1_errors_resp(trl,:);
    % % %             temp2(index,1:size(sig1_errors_resp,2)) = sig2_errors_resp(trl,:);
    % % %             index = index + 1;
    % % %         end
    % % %     end
    % % %     clear sig1_errors_resp sig2_errors_resp index
    % % %     sig1_errors_resp = temp1;
    % % %     sig2_errors_resp = temp2;
    % % %     clear temp1 temp2
    % % %
    % % %     clear sig1_targ sig2_targ sig1_resp sig2_resp correct errors
    % % %
    % % %
    % % %     %NOTE: Coherence & Spectral analysis cannot handle NaN's, so can not
    % % %     %truncate @ second saccade.
    % % %     %
    % % %     %
    % % %     %     %truncate correct trial signals at SRT (and then shift back another 20
    % % %     %     %ms to help account for any pre-movement buildup
    % % %     %     %also, start at 450 (actually a 50 ms pre-target baseline)
    % % %     %     for trl = 1:length(correct)
    % % %     %         if ~isnan(SRT(correct(trl),1)) && ceil(SRT(correct(trl),1)) + 50 < 450
    % % %     %             sig1_correct(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
    % % %     %             sig2_correct(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
    % % %     %         else
    % % %     %             sig1_correct(trl,1:451) = sig1(correct(trl),450:900);
    % % %     %             sig2_correct(trl,1:451) = sig2(correct(trl),450:900);
    % % %     %         end
    % % %     %     end
    % % %     %
    % % %     %     %truncate error trial signals at SRT
    % % %     %     for trl = 1:length(errors)
    % % %     %         if ~isnan(SRT(errors(trl),1)) && ceil(SRT(errors(trl),1)) + 50 < 450
    % % %     %             sig1_errors(trl,1:ceil(SRT(errors(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(errors(trl),1)) + 500 - 20);
    % % %     %             sig2_errors(trl,1:ceil(SRT(errors(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(errors(trl),1)) + 500 - 20);
    % % %     %         else
    % % %     %             sig1_errors(trl,1:451) = sig1(errors(trl),450:900);
    % % %     %             sig2_errors(trl,1:451) = sig2(errors(trl),450:900);
    % % %     %         end
    % % %     %     end
    % % %
    % % %
    % % %     %==========================================================================
    
    
    
    %=========================================================
    % Keep track of average waveforms
    
    %sig1-target aligned
    wf_sig1_correct_fast = nanmean(sig1_correct_targ_fast,1);
    wf_sig1_errors_fast = nanmean(sig1_errors_targ_fast,1);
    wf_sig1_correct_slow = nanmean(sig1_correct_targ_slow,1);
    wf_sig1_errors_slow = nanmean(sig1_errors_targ_slow,1);
    
    %sig2-target aligned
    wf_sig2_correct_fast = nanmean(sig2_correct_targ_fast,1);
    wf_sig2_errors_fast = nanmean(sig2_errors_targ_fast,1);
    wf_sig2_correct_slow = nanmean(sig2_correct_targ_slow,1);
    wf_sig2_errors_slow = nanmean(sig2_errors_targ_slow,1);
    
    
    
    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise
    
    %     %sig1-target aligned
    %     [freq FFT_correct_1_targ] = getFFT(wf_sig1_correct_targ);
    %     [freq FFT_errors_1_targ] = getFFT(wf_sig1_errors_targ);
    %
    %     %sig2-target aligned
    %     [freq FFT_correct_2_targ] = getFFT(wf_sig2_correct_targ);
    %     [freq FFT_errors_2_targ] = getFFT(wf_sig2_errors_targ);
    
    
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
    cor_correct_fast(1:size(sig1_correct_targ_fast,1),1:401) = NaN;
    cor_errors_fast(1:size(sig1_errors_targ_fast,1),1:401) = NaN;
    
    cor_correct_slow(1:size(sig1_correct_targ_slow,1),1:401) = NaN;
    cor_errors_slow(1:size(sig1_errors_targ_slow,1),1:401) = NaN;
    
    lags = -200:200;
    
    %Correlogram for correct trials
    %Need to correct for truncated signals.
    %Find NOT NAN trials - will be the same for both sig1 and sig2, so can
    %just check one of them.
    for trl = 1:size(sig1_correct_targ_fast,1)
        % EndDat = length(find(~isnan(sig1_correct(trl,:))));
        % cor_correct(trl,1:401) = xcorr(sig2_correct(trl,1:EndDat),sig1_correct(trl,1:EndDat),200,'coeff');
        cor_correct_fast(trl,1:401) = xcorr(sig2_correct_targ_fast(trl,:),sig1_correct_targ_fast(trl,:),200,'coeff');
    end
    
    for trl = 1:size(sig1_correct_targ_slow,1)
        cor_correct_slow(trl,1:401) = xcorr(sig2_correct_targ_slow(trl,:),sig1_correct_targ_slow(trl,:),200,'coeff');
    end
    
    %Correlogram for error trials
    for trl = 1:size(sig1_errors_targ_fast,1)
        %EndDat = length(find(~isnan(sig1_errors(trl,:))));
        %cor_errors(trl,1:401) = xcorr(sig2_errors(trl,1:EndDat),sig1_errors(trl,1:EndDat),200,'coeff');
        cor_errors_targ_fast(trl,1:401) = xcorr(sig2_errors_targ_fast(trl,:),sig1_errors_targ_fast(trl,:),200,'coeff');
    end
    
    for trl = 1:size(sig1_errors_targ_slow,1)
        cor_errors_targ_slow(trl,1:401) = xcorr(sig2_errors_targ_slow(trl,:),sig1_errors_targ_slow(trl,:),200,'coeff');
    end
    %clear EndDat
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % COHERENCE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    
    disp('Running... [Correct Trials]')
    
    %get spectral analysis of each, print % save
    
    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);

    n_correct_fast = size(sig1_correct_targ_fast,1);
    n_correct_slow = size(sig1_correct_targ_slow,1);
    
    [spec1_correct_targ_fast,f,tout] = LFPSpec(sig1_correct_targ_fast,tapers,1000,.01,[0,200],0,-500);
    [spec1_correct_targ_slow,f,tout] = LFPSpec(sig1_correct_targ_slow,tapers,1000,.01,[0,200],0,-500);
    
    [spec2_correct_targ_fast,f,tout] = LFPSpec(sig2_correct_targ_fast,tapers,1000,.01,[0,200],0,-500);
    [spec2_correct_targ_slow,f,tout] = LFPSpec(sig2_correct_targ_slow,tapers,1000,.01,[0,200],0,-500);
    
    [coh_correct_targ_fast,f,tout] = LFP_LFPCoh(sig1_correct_targ_fast,sig2_correct_targ_fast,tapers,1000,.01,[0,200],0,-500);
    [coh_correct_targ_slow,f,tout] = LFP_LFPCoh(sig1_correct_targ_slow,sig2_correct_targ_slow,tapers,1000,.01,[0,200],0,-500);
    
    tout_targ = tout;
    f_targ = f;
    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    subplot(2,4,1)
    imagesc(tout,f,log10(spec1_correct_targ_fast'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra Fast'])
    
    
    subplot(2,4,2)
    imagesc(tout,f,log10(spec1_correct_targ_slow'))
    axis xy
    axhand = gca;
    set(axhand,'YTickLabel',freqvals);
    set(axhand,'YTick',freqind);
    set(axhand,'XTickLabel',tvals);
    set(axhand,'XTick',tind);
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra Slow'])
    
    
    subplot(2,4,3)
    imagesc(tout,f,log10(spec2_correct_targ_fast'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra Fast'])
    
    
    subplot(2,4,4)
    imagesc(tout,f,log10(spec2_correct_targ_slow'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra Slow'])
    
    subplot(2,4,[5:6])
    imagesc(tout,f,abs(coh_correct_targ_fast'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ' Coherence Fast'])
    
    subplot(2,4,[7:8])
    imagesc(tout,f,abs(coh_correct_targ_slow'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,2))) cell2mat(chanlist(pairings(pair,2))) ' Coherence Slow'])
    %
    %     subplot(2,2,3)
    %     imagesc(abs(coh_correct_targ_contraipsi'))
    %     axis xy
    %     axhand = gca;
    %     set(axhand,'YTickLabel',freqvals);
    %     set(axhand,'YTick',freqind);
    %     set(axhand,'XTickLabel',tvals);
    %     set(axhand,'XTick',tind);
    %     xlabel('Time from Target')
    %     ylabel('Frequency')
    %     colorbar
    %     title([cell2mat(chanlist(pairings(pair,2))) ' Contra-Ipsi ' placement])
    %
    %     subplot(2,2,4)
    %     imagesc(abs(coh_correct_targ_ipsicontra'))
    %     axis xy
    %     axhand = gca;
    %     set(axhand,'YTickLabel',freqvals);
    %     set(axhand,'YTick',freqind);
    %     set(axhand,'XTickLabel',tvals);
    %     set(axhand,'XTick',tind);
    %     xlabel('Time from Target')
    %     ylabel('Frequency')
    %     colorbar
    %     title([cell2mat(chanlist(pairings(pair,2))) ' Ipsi-Contra ' placement])
    %
    %     subplot(2,5,5)
    %     plot(lags,nanmean(cor_correct_targ))
    %     xlabel('Time from Target')
    %     ylabel('r')
    %     title('Correlogram')
    
    
    [ax,h2] = suplabel(['nCorrect fast = ' mat2str(n_correct_fast) ' nCorrect slow = ' mat2str(n_correct_slow)],'y');
    set(h2,'FontSize',12,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',12,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/FastSlow/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_fastslow_correct.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_fastslow_correct.jpg',q])
    close(h)
    
    
    %================================================
    % 1) ERROR TRIALS
    
    disp('Running... [Error Trials]')
    
    %get spectral analysis of each, print % save
    
    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);
    
      
    n_errors_fast = size(sig1_errors_targ_fast,1);
    n_errors_slow = size(sig1_errors_targ_slow,1);
    
    [spec1_errors_targ_fast,f,tout] = LFPSpec(sig1_errors_targ_fast,tapers,1000,.01,[0,200],0,-500);
    [spec1_errors_targ_slow,f,tout] = LFPSpec(sig1_errors_targ_slow,tapers,1000,.01,[0,200],0,-500);
    
    [spec2_errors_targ_fast,f,tout] = LFPSpec(sig2_errors_targ_fast,tapers,1000,.01,[0,200],0,-500);
    [spec2_errors_targ_slow,f,tout] = LFPSpec(sig2_errors_targ_slow,tapers,1000,.01,[0,200],0,-500);
    
    [coh_errors_targ_fast,f,tout] = LFP_LFPCoh(sig1_errors_targ_fast,sig2_errors_targ_fast,tapers,1000,.01,[0,200],0,-500);
    [coh_errors_targ_slow,f,tout] = LFP_LFPCoh(sig1_errors_targ_slow,sig2_errors_targ_slow,tapers,1000,.01,[0,200],0,-500);
    
    tout_resp = tout;
    f_resp = f;
    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    subplot(2,4,1)
    imagesc(tout,f,log10(spec1_errors_targ_fast'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
   % set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra Fast'])
    
    
    subplot(2,4,2)
    imagesc(tout,f,log10(spec1_errors_targ_slow'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra Slow'])
    
    
    subplot(2,4,3)
    imagesc(tout,f,log10(spec2_errors_targ_fast'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra Fast'])
    
    
    subplot(2,4,4)
    imagesc(tout,f,log10(spec2_errors_targ_slow'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    %set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra Slow'])
    
    subplot(2,4,[5:6])
    imagesc(tout,f,abs(coh_errors_targ_fast'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ' Coherence Fast'])
    
    subplot(2,4,[7:8])
    imagesc(tout,f,abs(coh_errors_targ_slow'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    set(gca,'clim',[0 .8])
    title([cell2mat(chanlist(pairings(pair,2))) cell2mat(chanlist(pairings(pair,2))) ' Coherence Slow'])
   
    
    [ax,h2] = suplabel(['nErrors fast = ' mat2str(n_errors_fast) ' nErrors slow = ' mat2str(n_errors_slow)],'y');
    set(h2,'FontSize',12,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',12,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/FastSlow/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_fastslow_errors.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_fastslow_errors.jpg',q])
    close(h)
    
    
    %======================================
    
    if saveFlag == 1
        %save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/FastSlow/Matrices/' file '_' ...
            cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
            '_Coherence_fastslow.mat'],'wf_sig1_correct_fast','wf_sig1_errors_fast', ...
            'wf_sig1_correct_slow','wf_sig1_errors_slow','wf_sig2_correct_fast', ...
            'wf_sig2_errors_fast','wf_sig2_correct_slow','wf_sig2_errors_slow', ...
            'cor_correct_fast','cor_errors_fast','cor_correct_slow','cor_errors_slow', ...
            'lags','tout_targ','tout_resp','f_targ','f_resp', ...
            'spec1_correct_targ_fast','spec1_correct_targ_slow','spec2_correct_targ_fast', ...
            'spec2_correct_targ_slow','spec1_errors_targ_fast','spec1_errors_targ_slow', ...
            'spec2_errors_targ_fast','spec2_errors_targ_slow','coh_correct_targ_fast', ...
            'coh_correct_targ_slow', 'coh_errors_targ_fast', ...
            'coh_errors_targ_slow','-mat')
    end
    
    %clean up variables that will change between comparisons for safety
    clear placement wf_sig1_correct_fast wf_sig1_errors_fast ...
        wf_sig1_correct_slow wf_sig1_errors_slow wf_sig2_correct_fast ...
        wf_sig2_errors_fast wf_sig2_correct_slow wf_sig2_errors_slow ...
        cor_correct_fast cor_errors_fast cor_correct_slow cor_errors_slow ...
        lags tvals_targ tind_targ freqvals_targ freqind_targ spec1_correct_targ_fast ...
        spec1_correct_targ_slow spec2_correct_targ_fast spec2_correct_targ_slow ...
        spec1_errors_targ_fast spec1_errors_targ_slow spec2_errors_targ_fast ...
        spec2_errors_targ_slow coh_correct_targ_fast ...
        coh_correct_targ_slow coh_errors_targ_fast coh_errors_targ_slow ...
        n_correct_fast n_correct_slow n_errors_fast ...
        n_errors_slow tout_targ tout_resp f_targ f_resp tout f h tapers ...
        
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes