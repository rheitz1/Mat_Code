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
    sig1_hemi = cell2mat(Hemi(strmatch(chanlist(pairings(pair,1)),Hemi(:,1)),2));
    sig2_hemi = cell2mat(Hemi(strmatch(chanlist(pairings(pair,2)),Hemi(:,1)),2));
    
    correct_left = find(ismember(Target_(:,2),[3 4 5]) & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    correct_right = find(ismember(Target_(:,2),[7 0 1]) & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    
    errors_left = find(ismember(Target_(:,2),[3 4 5]) & ismember(SaccDir_(:,1),[7 0 1]) & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    errors_right = find(ismember(Target_(:,2),[7 0 1]) & ismember(SaccDir_(:,1),[3 4 5]) & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    
    %make sure we have data for all conditions
    if (isempty(errors_left) == 1 || isempty(errors_right) == 1)
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
    
    
    %if midline electrode, abort comparison
    if (sig1_hemi == 'M' || sig2_hemi == 'M')
        continue
    end
    
    %create contra/ipsi signals based on stored hemisphere information
    if sig1_hemi == 'L'
        sig1_correct_targ_contra = sig1_targ(correct_right,:);
        sig1_errors_targ_contra =  sig1_targ(errors_right,:);
        
        sig2_correct_targ_contra = sig2_targ(correct_right,:);
        sig2_errors_targ_contra =  sig2_targ(errors_right,:);
        
        sig1_correct_targ_ipsi = sig1_targ(correct_left,:);
        sig1_errors_targ_ipsi =  sig1_targ(errors_left,:);
        
        sig2_correct_targ_ipsi = sig2_targ(correct_left,:);
        sig2_errors_targ_ipsi =  sig2_targ(errors_left,:);
        
    elseif sig1_hemi == 'R'
        sig1_correct_targ_contra = sig1_targ(correct_left,:);
        sig1_errors_targ_contra =  sig1_targ(errors_left,:);
        
        sig2_correct_targ_contra = sig2_targ(correct_left,:);
        sig2_errors_targ_contra =  sig2_targ(errors_left,:);
        
        sig1_correct_targ_ipsi = sig1_targ(correct_right,:);
        sig1_errors_targ_ipsi =  sig1_targ(errors_right,:);
        
        sig2_correct_targ_ipsi = sig2_targ(correct_right,:);
        sig2_errors_targ_ipsi =  sig2_targ(errors_right,:);
    end
    
    %are electrode in same hemisphere?
    if sig1_hemi == sig2_hemi
        placement = 'IntraHemi';
    else
        placement = 'InterHemi';
    end
    
    
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
    wf_sig1_correct_contra = nanmean(sig1_correct_targ_contra,1);
    wf_sig1_errors_contra = nanmean(sig1_errors_targ_contra,1);
    wf_sig1_correct_ipsi = nanmean(sig1_correct_targ_ipsi,1);
    wf_sig1_errors_ipsi = nanmean(sig1_errors_targ_ipsi,1);
    
    %sig2-target aligned
    wf_sig2_correct_contra = nanmean(sig2_correct_targ_contra,1);
    wf_sig2_errors_contra = nanmean(sig2_errors_targ_contra,1);
    wf_sig2_correct_ipsi = nanmean(sig2_correct_targ_ipsi,1);
    wf_sig2_errors_ipsi = nanmean(sig2_errors_targ_ipsi,1);
    
    
    
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
    cor_correct_contra(1:size(sig1_correct_targ_contra,1),1:401) = NaN;
    cor_errors_contra(1:size(sig1_errors_targ_contra,1),1:401) = NaN;
    
    cor_correct_ipsi(1:size(sig1_correct_targ_ipsi,1),1:401) = NaN;
    cor_errors_ipsi(1:size(sig1_errors_targ_ipsi,1),1:401) = NaN;
    
    lags = -200:200;
    
    %Correlogram for correct trials
    %Need to correct for truncated signals.
    %Find NOT NAN trials - will be the same for both sig1 and sig2, so can
    %just check one of them.
    for trl = 1:size(sig1_correct_targ_contra,1)
        % EndDat = length(find(~isnan(sig1_correct(trl,:))));
        % cor_correct(trl,1:401) = xcorr(sig2_correct(trl,1:EndDat),sig1_correct(trl,1:EndDat),200,'coeff');
        cor_correct_contra(trl,1:401) = xcorr(sig2_correct_targ_contra(trl,:),sig1_correct_targ_contra(trl,:),200,'coeff');
    end
    
    for trl = 1:size(sig1_correct_targ_ipsi,1)
        cor_correct_ipsi(trl,1:401) = xcorr(sig2_correct_targ_ipsi(trl,:),sig1_correct_targ_ipsi(trl,:),200,'coeff');
    end
    
    %Correlogram for error trials
    for trl = 1:size(sig1_errors_targ_contra,1)
        %EndDat = length(find(~isnan(sig1_errors(trl,:))));
        %cor_errors(trl,1:401) = xcorr(sig2_errors(trl,1:EndDat),sig1_errors(trl,1:EndDat),200,'coeff');
        cor_errors_targ_contra(trl,1:401) = xcorr(sig2_errors_targ_contra(trl,:),sig1_errors_targ_contra(trl,:),200,'coeff');
    end
    
    for trl = 1:size(sig1_errors_targ_ipsi,1)
        cor_errors_targ_ipsi(trl,1:401) = xcorr(sig2_errors_targ_ipsi(trl,:),sig1_errors_targ_ipsi(trl,:),200,'coeff');
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
    
    %calculate and plot spectra
    %get pesky tvals,tind,freqvals,freqind
    clear global
    global tvals
    global tind
    global freqvals
    global freqind
    
    
    
    n_correct_contra = size(sig1_correct_targ_contra,1);
    n_correct_ipsi = size(sig1_correct_targ_ipsi,1);
    
    
    
    
    disp('Coherence, Correct')
    [coh_correct_targ_contracontra,f,tout] = LFP_LFPCoh(sig1_correct_targ_contra,sig2_correct_targ_contra,tapers,1000,.001,[0,200],0,-500);
    % [coh_correct_targ_contraipsi] = LFP_LFPCoh(sig1_correct_targ_contra,sig2_correct_targ_ipsi,tapers,1000,.001,[0,200],0,-500);
    % [coh_correct_targ_ipsicontra] = LFP_LFPCoh(sig1_correct_targ_ipsi,sig2_correct_targ_contra,tapers,1000,.001,[0,200],0,-500);
    [coh_correct_targ_ipsiipsi,f,tout] = LFP_LFPCoh(sig1_correct_targ_ipsi,sig2_correct_targ_ipsi,tapers,1000,.001,[0,200],0,-500);
    
    tout_targ = tout;
    f_targ = f;
    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    %TARGET ALIGNED
    subplot(1,2,1)
    imagesc(tout,f,abs(coh_correct_targ_contracontra'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,1))) ' Contra-Contra ' placement])
    
    subplot(1,2,2)
    imagesc(tout,f,abs(coh_correct_targ_ipsiipsi'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,2))) ' Ipsi-Ipsi ' placement])
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
    
    
    [ax,h2] = suplabel(['nCorrect_contra = ' mat2str(n_correct_contra) ' nCorrect_ipsi = ' mat2str(n_correct_ipsi)],'y');
    set(h2,'FontSize',12,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',12,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/ContraIpsi/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_contraipsi_correct.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_contraipsi_correct.jpg',q])
    close(h)
    
    
    %================================================
    % 1) ERROR TRIALS
    
    disp('Running... [Correct Trials]')
    
    %get spectral analysis of each, print % save
    
    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);
    
    n_errors_contra = size(sig1_errors_targ_contra,1);
    n_errors_ipsi = size(sig1_errors_targ_ipsi,1);
    
    disp('Coherence, Errors')
    [coh_errors_targ_contracontra,f,tout] = LFP_LFPCoh(sig1_errors_targ_contra,sig2_errors_targ_contra,tapers,1000,.001,[0,200],0,-500);
    % [coh_errors_targ_contraipsi] = LFP_LFPCoh(sig1_errors_targ_contra,sig2_errors_targ_ipsi,tapers,1000,.001,[0,200],0,-500);
    %  [coh_errors_targ_ipsicontra] = LFP_LFPCoh(sig1_errors_targ_ipsi,sig2_errors_targ_contra,tapers,1000,.001,[0,200],0,-500);
    [coh_errors_targ_ipsiipsi,f,tout] = LFP_LFPCoh(sig1_errors_targ_ipsi,sig2_errors_targ_ipsi,tapers,1000,.001,[0,200],0,-500);
    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    subplot(1,2,1)
    imagesc(tout,f,abs(coh_errors_targ_contracontra'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    set(gca,'clim',[0 .6])
    title([cell2mat(chanlist(pairings(pair,1))) ' Contra-Contra ' placement])
    
    subplot(1,2,2)
    imagesc(tout,f,abs(coh_errors_targ_ipsiipsi'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    set(gca,'clim',[0 .6])
    title([cell2mat(chanlist(pairings(pair,2))) ' Ipsi-Ipsi ' placement])
    %
    %     subplot(2,2,3)
    %     imagesc(abs(coh_errors_targ_contraipsi'))
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
    %     imagesc(abs(coh_errors_targ_ipsicontra'))
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
    %     plot(lags,nanmean(cor_errors_targ))
    %     xlabel('Time from Target')
    %     ylabel('r')
    %     title('Correlogram')
    
    
    [ax,h2] = suplabel(['nCorrect_contra = ' mat2str(n_errors_contra) ' nCorrect_ipsi = ' mat2str(n_errors_ipsi)],'y');
    set(h2,'FontSize',12,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',12,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/ContraIpsi/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_contraipsi_errors.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_contraipsi_errors.jpg',q])
    close(h)
    
    
    %======================================
    
    if saveFlag == 1
        %save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/Matrices/' file '_' ...
            cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
            '_Coherence_contraipsi.mat'],'wf_sig1_correct_contra','wf_sig1_errors_contra', ...
            'wf_sig1_correct_ipsi','wf_sig1_errors_ipsi','wf_sig2_correct_contra', ...
            'wf_sig2_errors_contra','wf_sig2_correct_ipsi','wf_sig2_errors_ipsi', ...
            'cor_correct_contra','cor_errors_contra','cor_correct_ipsi','cor_errors_ipsi', ...
            'lags','tout_targ','f_targ','coh_correct_targ_contracontra', ...
            'coh_correct_targ_ipsiipsi', 'coh_errors_targ_contracontra', ...
            'coh_errors_targ_ipsiipsi','-mat')
    end
    
    %clean up variables that will change between comparisons for safety
    clear placement wf_sig1_correct_contra wf_sig1_errors_contra ...
        wf_sig1_correct_ipsi wf_sig1_errors_ipsi wf_sig2_correct_contra ...
        wf_sig2_errors_contra wf_sig2_correct_ipsi wf_sig2_errors_ipsi ...
        cor_correct_contra cor_errors_contra cor_correct_ipsi cor_errors_ipsi ...
        lags tvals_targ tind_targ freqvals_targ freqind_targ coh_correct_targ_contracontra ...
        coh_correct_targ_contraipsi coh_correct_targ_ipsicontra ...
        coh_correct_targ_ipsiipsi coh_errors_targ_contracontra ...
        coh_errors_targ_contraipsi coh_errors_targ_ipsicontra ...
        coh_errors_targ_ipsiipsi n_correct_contra n_correct_ipsi n_errors_contra ...
        n_errors_ipsi tout_targ f_targ tout f h tapers ...
        sig1_hemi sig2_hemi sig1_targ sig2_targ
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes