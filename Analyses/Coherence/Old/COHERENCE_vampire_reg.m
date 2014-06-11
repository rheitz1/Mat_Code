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
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    
    %make sure we have data for all conditions
    if isempty(errors) == 1
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
    sig1_resp = response_align(sig1_targ,SRT,[-300 600]);
    sig2_resp = response_align(sig2_targ,SRT,[-300 600]);

        
    sig1_correct_targ = sig1_targ(correct,:);
    sig1_errors_targ =  sig1_targ(errors,:);
    sig2_correct_targ = sig2_targ(correct,:);
    sig2_errors_targ =  sig2_targ(errors,:);
    
    sig1_correct_resp = sig1_resp(correct,:);
    sig1_errors_resp = sig1_resp(errors,:);
    sig2_correct_resp = sig2_resp(correct,:);
    sig2_errors_resp = sig2_resp(errors,:);

    %spectra and coherence can't handle NaNs so need to remove from
    %response-aligned signals.  Note that both signals must have a non-nan
    %trial for it to be included.
    index = 1;
    for trl = 1:size(sig1_correct_resp,1)
        if isempty(find(isnan(sig1_correct_resp(trl,:)))) == 1 && isempty(find(isnan(sig2_correct_resp(trl,:)))) == 1
            temp1(index,1:size(sig1_correct_resp,2)) = sig1_correct_resp(trl,:);
            temp2(index,1:size(sig1_correct_resp,2)) = sig2_correct_resp(trl,:);
            index = index + 1;
        end
    end
    clear sig1_correct_resp sig2_correct_resp index
    sig1_correct_resp = temp1;
    sig2_correct_resp = temp2;
    clear temp1 temp2
    
    index = 1;
    for trl = 1:size(sig1_errors_resp,1)
        if isempty(find(isnan(sig1_errors_resp(trl,:)))) == 1 && isempty(find(isnan(sig2_errors_resp(trl,:)))) == 1
            temp1(index,1:size(sig1_errors_resp,2)) = sig1_errors_resp(trl,:);
            temp2(index,1:size(sig1_errors_resp,2)) = sig2_errors_resp(trl,:);
            index = index + 1;
        end
    end
    clear sig1_errors_resp sig2_errors_resp index
    sig1_errors_resp = temp1;
    sig2_errors_resp = temp2;
    clear temp1 temp2
    
    clear sig1_targ sig2_targ sig1_resp sig2_resp correct errors
    
    
    %NOTE: Coherence & Spectral analysis cannot handle NaN's, so can not
    %truncate @ second saccade.
    %
    %
    %     %truncate correct trial signals at SRT (and then shift back another 20
    %     %ms to help account for any pre-movement buildup
    %     %also, start at 450 (actually a 50 ms pre-target baseline)
    %     for trl = 1:length(correct)
    %         if ~isnan(SRT(correct(trl),1)) && ceil(SRT(correct(trl),1)) + 50 < 450
    %             sig1_correct(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
    %             sig2_correct(trl,1:ceil(SRT(correct(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(correct(trl),1)) + 500 - 20);
    %         else
    %             sig1_correct(trl,1:451) = sig1(correct(trl),450:900);
    %             sig2_correct(trl,1:451) = sig2(correct(trl),450:900);
    %         end
    %     end
    %
    %     %truncate error trial signals at SRT
    %     for trl = 1:length(errors)
    %         if ~isnan(SRT(errors(trl),1)) && ceil(SRT(errors(trl),1)) + 50 < 450
    %             sig1_errors(trl,1:ceil(SRT(errors(trl),1)) + 50 + 1 - 20) = sig1(trl,450:ceil(SRT(errors(trl),1)) + 500 - 20);
    %             sig2_errors(trl,1:ceil(SRT(errors(trl),1)) + 50 + 1 - 20) = sig2(trl,450:ceil(SRT(errors(trl),1)) + 500 - 20);
    %         else
    %             sig1_errors(trl,1:451) = sig1(errors(trl),450:900);
    %             sig2_errors(trl,1:451) = sig2(errors(trl),450:900);
    %         end
    %     end
    
    
    %==========================================================================

    
    
    %=========================================================
    % Keep track of average waveforms
    
    %sig1-target aligned
    wf_sig1_correct_targ = nanmean(sig1_correct_targ,1);
    wf_sig1_errors_targ = nanmean(sig1_errors_targ,1);
    wf_sig1_correct_resp = nanmean(sig1_correct_resp,1);
    wf_sig1_errors_resp = nanmean(sig1_errors_resp,1);
    
    %sig2-target aligned
    wf_sig2_correct_targ = nanmean(sig2_correct_targ,1);
    wf_sig2_errors_targ = nanmean(sig2_errors_targ,1);
    wf_sig2_correct_resp = nanmean(sig2_correct_resp,1);
    wf_sig2_errors_resp = nanmean(sig2_errors_resp,1);
    
    
    
    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise
        
    %sig1-target aligned
    [freq FFT_correct_1_targ] = getFFT(wf_sig1_correct_targ);
    [freq FFT_errors_1_targ] = getFFT(wf_sig1_errors_targ);
    
    %sig2-target aligned
    [freq FFT_correct_2_targ] = getFFT(wf_sig2_correct_targ);
    [freq FFT_errors_2_targ] = getFFT(wf_sig2_errors_targ);
    
    
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
    cor_correct_targ(1:size(sig1_correct_targ,1),1:401) = NaN;
    cor_errors_targ(1:size(sig1_errors_targ,1),1:401) = NaN;
    cor_correct_resp(1:size(sig1_correct_resp,1),1:401) = NaN;
    cor_errors_resp(1:size(sig1_errors_resp,1),1:401) = NaN;
    
    lags = -200:200;
    
    %Correlogram for correct trials
    %Need to correct for truncated signals.
    %Find NOT NAN trials - will be the same for both sig1 and sig2, so can
    %just check one of them.
    for trl = 1:size(sig1_correct_targ,1)
       % EndDat = length(find(~isnan(sig1_correct(trl,:))));
       % cor_correct(trl,1:401) = xcorr(sig2_correct(trl,1:EndDat),sig1_correct(trl,1:EndDat),200,'coeff');
       cor_correct_targ(trl,1:401) = xcorr(sig2_correct_targ(trl,:),sig1_correct_targ(trl,:),200,'coeff');
    end
    
    for trl = 1:size(sig1_correct_resp,1)
         cor_correct_resp(trl,1:401) = xcorr(sig2_correct_resp(trl,:),sig1_correct_resp(trl,:),200,'coeff');
    end
    
    %Correlogram for error trials
    for trl = 1:size(sig1_errors_targ,1)
        %EndDat = length(find(~isnan(sig1_errors(trl,:))));
        %cor_errors(trl,1:401) = xcorr(sig2_errors(trl,1:EndDat),sig1_errors(trl,1:EndDat),200,'coeff');
        cor_errors_targ(trl,1:401) = xcorr(sig2_errors_targ(trl,:),sig1_errors_targ(trl,:),200,'coeff');
    end
    
    for trl = 1:size(sig1_errors_resp,1)
        cor_errors_resp(trl,1:401) = xcorr(sig2_errors_resp(trl,:),sig1_errors_resp(trl,:),200,'coeff');
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
    
    
    n_correct = size(sig1_correct_targ,1);
    disp('Signal 1 Spectra, Target-Aligned Correct')
    [spec1_correct_targ,f,tout] = LFPSpec(sig1_correct_targ,tapers,1000,.001,[0,200],0,-500);
    disp('Signal 2 Spectra, Target-Aligned Correct')
    [spec2_correct_targ,f,tout] = LFPSpec(sig2_correct_targ,tapers,1000,.001,[0,200],0,-500);
    %calculate coherence
    disp('Coherence, Target-Aligned Correct')
    [coh_correct_targ,f,tout] = LFP_LFPCoh(sig1_correct_targ,sig2_correct_targ,tapers,1000,.001,[0,200],0,-500);
    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    %TARGET ALIGNED
    subplot(2,4,1)
    imagesc(tout,f,log10(spec1_correct_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra'])
    
    subplot(2,4,2)
    imagesc(tout,f,log10(spec2_correct_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra'])
    
    subplot(2,4,3)
    imagesc(tout,f,abs(coh_correct_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Coherence')
    
    subplot(2,4,4)
    imagesc(tout,f,angle(coh_correct_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Phase Angle')
    
    tout_targ = tout;
    f_targ = f;
    clear tout f
%     subplot(2,5,5)
%     plot(lags,nanmean(cor_correct_targ))
%     xlabel('Time from Target')
%     ylabel('r')
%     title('Correlogram')
    
    
    %RESPONSE ALIGNED
    %have to calculate here because of use of global variables; tvals will
    %change because size of matrix is different for response-aligned

    disp('Signal 1 Spectra, Response-Aligned Correct')
    [spec1_correct_resp,f,tout] = LFPSpec(sig1_correct_resp,tapers,1000,.001,[0,200],0,-300);
    disp('Signal 2 Spectra, Response-Aligned Correct')
    [spec2_correct_resp,f,tout] = LFPSpec(sig2_correct_resp,tapers,1000,.001,[0,200],0,-300);
    disp('Coherence, Response-Aligned Correct')
    [coh_correct_resp,f,tout] = LFP_LFPCoh(sig1_correct_resp,sig2_correct_resp,tapers,1000,.001,[0,200],0,-300);
    
    
    subplot(2,4,5)
    imagesc(tout,f,log10(spec1_correct_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra'])
    
    subplot(2,4,6)
    imagesc(tout,f,log10(spec2_correct_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra'])
    
    subplot(2,4,7)
    imagesc(tout,f,abs(coh_correct_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Coherence')
    
    subplot(2,4,8)
    imagesc(tout,f,angle(coh_correct_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Phase Angle')
    
%     subplot(2,5,10)
%     plot(lags,nanmean(cor_correct_resp))
%     xlabel('Time from Target')
%     ylabel('r')
%     title('Correlogram')
    tout_resp = tout;
    f_resp = f;
    clear tout f
    
    [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct)],'y');
    set(h2,'FontSize',12,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',12,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct.jpg',q])
    close(h)
    
    
    %================================================
   % 2) ERROR TRIALS
    disp('Running... [Error Trials]')
    
    %get spectral analysis of each, print % save
    
    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);
    
   
    n_errors = size(sig1_errors_targ,1);
    disp('Signal 1 Spectra, Target-Aligned Errors')
    [spec1_errors_targ,f,tout] = LFPSpec(sig1_errors_targ,tapers,1000,.001,[0,200],0,-500);
    disp('Signal 2 Spectra, Target-Aligned Errors')
    [spec2_errors_targ,f,tout] = LFPSpec(sig2_errors_targ,tapers,1000,.001,[0,200],0,-500);
    %calculate coherence
    disp('Coherence, Target-Aligned Errors')
    [coh_errors_targ,f,tout] = LFP_LFPCoh(sig1_errors_targ,sig2_errors_targ,tapers,1000,.001,[0,200],0,-500);
    

    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    %TARGET ALIGNED
    subplot(2,4,1)
    imagesc(tout,f,log10(spec1_errors_targ'))
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra'])
    
    subplot(2,4,2)
    imagesc(tout,f,log10(spec2_errors_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra'])
    
    subplot(2,4,3)
    imagesc(tout,f,abs(coh_errors_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Coherence')
    
    subplot(2,4,4)
    imagesc(tout,f,angle(coh_errors_targ'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Phase Angle')
    
%     subplot(2,5,5)
%     plot(lags,nanmean(cor_errors_targ))
%     xlabel('Time from Target')
%     ylabel('r')
%     title('Correlogram')
    
    
    %RESPONSE ALIGNED
    %have to calculate here because of use of global variables; tvals will
    %change because size of matrix is different for response-aligned
    
    disp('Signal 1 Spectra, Response-Aligned Errors')
    [spec1_errors_resp,f,tout] = LFPSpec(sig1_errors_resp,tapers,1000,.001,[0,200],0,-300);
    disp('Signal 2 Spectra, Response-Aligned Errors')
    [spec2_errors_resp,f,tout] = LFPSpec(sig2_errors_resp,tapers,1000,.001,[0,200],0,-300);
    disp('Coherence, Response-Aligned Errors')
    [coh_errors_resp,f,tout] = LFP_LFPCoh(sig1_errors_targ,sig2_errors_targ,tapers,1000,.001,[0,200],0,-300);
    
    subplot(2,4,5)
    imagesc(tout,f,log10(spec1_errors_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,1))) ' Spectra'])
    
    subplot(2,4,6)
    imagesc(tout,f,log10(spec2_errors_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title([cell2mat(chanlist(pairings(pair,2))) ' Spectra'])
    
    subplot(2,4,7)
    imagesc(tout,f,abs(coh_errors_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Coherence')
    
    subplot(2,4,8)
    imagesc(tout,f,angle(coh_errors_resp'))
    axis xy
    xlabel('Time from Target')
    ylabel('Frequency')
    colorbar
    title('Phase Angle')
    
%     subplot(2,5,10)
%     plot(lags,nanmean(cor_errors_resp))
%     xlabel('Time from Target')
%     ylabel('r')
%     title('Correlogram')
    
    
    [ax,h2] = suplabel(['nErrors = ' mat2str(n_errors)],'y');
    set(h2,'FontSize',12,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',12,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_errors.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_errors.jpg',q])
    close(h)
    
% %     %======================================
% %     % Save Variables
% %     if saveFlag == 1
% %         save(['//scratch/heitzrp/Output/Coherence/Matrices/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_Coherence.mat'],'cor_correct','cor_errors','spec1_correct','spec2_correct','spec1_errors','spec2_errors','coh_correct','coh_errors','-mat')
% %     end
    
    %======================================

    if saveFlag == 1
        %save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/Matrices/' file '_' ...
        cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
        '_Coherence.mat'],'wf_sig1_correct_targ','wf_sig1_errors_targ', ...
        'wf_sig1_correct_resp', 'wf_sig1_errors_resp','wf_sig2_correct_targ', ...
        'wf_sig2_errors_targ', 'wf_sig2_correct_resp','wf_sig2_errors_resp','FFT_correct_1_targ', ...
        'FFT_errors_1_targ','FFT_correct_2_targ','FFT_errors_2_targ', ...
        'cor_correct_targ','cor_errors_targ','cor_correct_resp','cor_errors_resp', ...
        'lags','spec1_correct_targ','spec2_correct_targ','coh_correct_targ', ...
        'spec1_correct_resp','spec2_correct_resp','coh_correct_resp', ...
        'spec1_errors_targ','spec2_errors_targ','coh_errors_targ', ...
        'spec1_errors_resp','spec2_errors_resp','coh_errors_resp', ...
        'tout_targ','tout_resp','f_targ','f_resp','-mat')
    end    
    
    %clean up variables that will change between comparisons for safety
    clear axhand wf_sig1_correct_targ wf_sig1_errors_targ wf_sig1_correct_resp ...
        wf_sig1_errors_resp wf_sig2_correct_targ wf_sig2_errors_targ wf_sig2_correct_resp ...
        wf_sig2_errors_resp freq FFT_correct_1_targ FFT_errors_1_targ FFT_correct_2_targ ...
        FFT_errors_2_targ cor_correct_targ cor_errors_targ cor_correct_resp cor_errors_resp ...
        lags tapers n_correct n_errors spec1_correct_targ spec2_correct_targ ...
        coh_correct_targ h spec1_correct_resp spec2_correct_resp coh_correct_resp ...
        spec1_errors_targ spec2_errors_targ coh_errors_targ spec1_errors_resp ...
        spec2_errors_resp coh_errors_rep tout_targ tout_resp f_targ f_resp
    
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes