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

%load all AD and DSP channels
ChanStruct = loadChan(file,'ALL');
decodeChanStruct

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);

%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist)));
DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist

%do for each spike channel
for Spikechan = 1:size(DSPlist,1)
    %do for each AD channel
    for ADchan = 1:size(ADlist,1)
        
%Compute comparisons backwards so we get LFP correlations out first
    disp(['Comparing... ' DSPlist(Spikechan,:) ' vs ' ADlist(ADchan,:)])
    
    fixErrors
    error_skip = 0;
    set_size_skip = 0;
    homog_skip = 0;
    
    %====================================================
    % SET UP DATA
    %find relevant trials, exclude catch trials (255)
    correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    
    %make sure we have data for all conditions
    %     if isempty(errors) == 1
    %         error_skip = 1;
    %     end
    
    %     %T E M P:  For Debugging
    %     AD09 = AD09(1:100,:);
    %     AD10 = AD10(1:100,:);
    %     correct = 1:100;
    %     errors = 1:100;
    
    
    %set up signals. Sig1 is always Spike
    
    %need to correct spike times by subtracting 500 ms.  All 0's will
    %become -500, but this should not be a problem
    sig1_targ = eval(DSPlist(Spikechan,:));
    temp_spike = sig1_targ;
    
    sig1_targ = sig1_targ - 500;
    sig2_targ = eval(ADlist(ADchan,:));
    
%     
%     
%     sig1_resp = response_align(sig1_targ,SRT,[-300 600]);
%     sig2_resp = response_align(sig2_targ,SRT,[-300 600]);
    
    %shorten target-aligned signal size
%     sig1_targ = sig1_targ(:,300:1200);
%     sig2_targ = sig2_targ(:,300:1200);
    
    sig1_correct_targ_ss2 = sig1_targ(correct_ss2,:);
    sig1_correct_targ_ss4 = sig1_targ(correct_ss4,:);
    sig1_correct_targ_ss8 = sig1_targ(correct_ss8,:);
    
    %save SDFs
    Align_Time = Target_(:,1);
    Plot_Time = [-500 2500];
    SDF_ss2 = spikedensityfunct(temp_spike, Align_Time, Plot_Time, correct_ss2, TrialStart_);
    SDF_ss4 = spikedensityfunct(temp_spike, Align_Time, Plot_Time, correct_ss4, TrialStart_);
    SDF_ss8 = spikedensityfunct(temp_spike, Align_Time, Plot_Time, correct_ss8, TrialStart_);
    clear temp_spike Align_Time Plot_Time
    
    sig2_correct_targ_ss2 = sig2_targ(correct_ss2,:);
    sig2_correct_targ_ss4 = sig2_targ(correct_ss4,:);
    sig2_correct_targ_ss8 = sig2_targ(correct_ss8,:);
    
%     sig1_correct_resp_ss2 = sig1_resp(correct_ss2,:);
%     sig1_correct_resp_ss4 = sig1_resp(correct_ss4,:);
%     sig1_correct_resp_ss8 = sig1_resp(correct_ss8,:);
%     
%     sig2_correct_resp_ss2 = sig2_resp(correct_ss2,:);
%     sig2_correct_resp_ss4 = sig2_resp(correct_ss4,:);
%     sig2_correct_resp_ss8 = sig2_resp(correct_ss8,:);
    
    
%     %spectra and coherence can't handle NaNs so need to remove from
%     %response-aligned signals.  Note that both signals must have a non-nan
%     %trial for it to be included.
%     index = 1;
%     for trl = 1:size(sig1_correct_resp_ss2,1)
%         if isempty(find(isnan(sig1_correct_resp_ss2(trl,:)))) == 1 && isempty(find(isnan(sig2_correct_resp_ss2(trl,:)))) == 1
%             temp1(index,1:size(sig1_correct_resp_ss2,2)) = sig1_correct_resp_ss2(trl,:);
%             temp2(index,1:size(sig2_correct_resp_ss2,2)) = sig2_correct_resp_ss2(trl,:);
%             index = index + 1;
%         end
%     end
%     clear sig1_correct_resp_ss2 sig2_correct_resp_ss2 index
%     sig1_correct_resp_ss2 = temp1;
%     sig2_correct_resp_ss2 = temp2;
%     clear temp1 temp2
%     
%     index = 1;
%     for trl = 1:size(sig1_correct_resp_ss4,1)
%         if isempty(find(isnan(sig1_correct_resp_ss4(trl,:)))) == 1 && isempty(find(isnan(sig2_correct_resp_ss4(trl,:)))) == 1
%             temp1(index,1:size(sig1_correct_resp_ss4,2)) = sig1_correct_resp_ss4(trl,:);
%             temp2(index,1:size(sig2_correct_resp_ss4,2)) = sig2_correct_resp_ss4(trl,:);
%             index = index + 1;
%         end
%     end
%     clear sig1_correct_resp_ss4 sig2_correct_resp_ss4 index
%     sig1_correct_resp_ss4 = temp1;
%     sig2_correct_resp_ss4 = temp2;
%     clear temp1 temp2
%     
%     index = 1;
%     for trl = 1:size(sig1_correct_resp_ss8,1)
%         if isempty(find(isnan(sig1_correct_resp_ss8(trl,:)))) == 1 && isempty(find(isnan(sig2_correct_resp_ss8(trl,:)))) == 1
%             temp1(index,1:size(sig1_correct_resp_ss8,2)) = sig1_correct_resp_ss8(trl,:);
%             temp2(index,1:size(sig2_correct_resp_ss8,2)) = sig2_correct_resp_ss8(trl,:);
%             index = index + 1;
%         end
%     end
%     clear sig1_correct_resp_ss8 sig2_correct_resp_ss8 index
%     sig1_correct_resp_ss8 = temp1;
%     sig2_correct_resp_ss8 = temp2;
%     clear temp1 temp2
    
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
    
    %sig1
%     wf_sig1_correct_targ_ss2 = nanmean(sig1_correct_targ_ss2,1);
%     wf_sig1_correct_targ_ss4 = nanmean(sig1_correct_targ_ss4,1);
%     wf_sig1_correct_targ_ss8 = nanmean(sig1_correct_targ_ss8,1);
%     
%     wf_sig1_correct_resp_ss2 = nanmean(sig1_correct_resp_ss2,1);
%     wf_sig1_correct_resp_ss4 = nanmean(sig1_correct_resp_ss4,1);
%     wf_sig1_correct_resp_ss8 = nanmean(sig1_correct_resp_ss8,1);
%     
    %sig2
    
    wf_sig2_correct_targ_ss2 = nanmean(sig2_correct_targ_ss2,1);
    wf_sig2_correct_targ_ss4 = nanmean(sig2_correct_targ_ss4,1);
    wf_sig2_correct_targ_ss8 = nanmean(sig2_correct_targ_ss8,1);
    
%     wf_sig2_correct_resp_ss2 = nanmean(sig2_correct_resp_ss2,1);
%     wf_sig2_correct_resp_ss4 = nanmean(sig2_correct_resp_ss4,1);
%     wf_sig2_correct_resp_ss8 = nanmean(sig2_correct_resp_ss8,1);
    
    
    
    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise
    
    %sig1-target aligned
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
    
    
%     % preallocate space
%     cor_correct_targ_ss2(1:size(sig1_correct_targ_ss2,1),1:401) = NaN;
%     cor_correct_targ_ss4(1:size(sig1_correct_targ_ss4,1),1:401) = NaN;
%     cor_correct_targ_ss8(1:size(sig1_correct_targ_ss8,1),1:401) = NaN;
%     
%     lags = -200:200;
%     
%     %Correlogram for correct trials
%     
%     for trl = 1:size(sig1_correct_targ_ss2,1)
%         cor_correct_targ_ss2(trl,1:401) = xcorr(sig2_correct_targ_ss2(trl,:),sig1_correct_targ_ss2(trl,:),200,'coeff');
%     end
%     
%     for trl = 1:size(sig1_correct_targ_ss4,1)
%         cor_correct_targ_ss4(trl,1:401) = xcorr(sig2_correct_targ_ss4(trl,:),sig1_correct_targ_ss4(trl,:),200,'coeff');
%     end
%     
%     for trl = 1:size(sig1_correct_targ_ss8,1)
%         cor_correct_targ_ss8(trl,1:401) = xcorr(sig2_correct_targ_ss8(trl,:),sig1_correct_targ_ss8(trl,:),200,'coeff');
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % COHERENCE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials]')
    
    %get spectral analysis of each, print % save
    
    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);
        
    n_ss2 = size(sig1_correct_targ_ss2,1);
    n_ss4 = size(sig1_correct_targ_ss4,1);
    n_ss8 = size(sig1_correct_targ_ss8,1);
    
    disp('Coherence, Target-Aligned Correct')
    [spec1_correct_targ_ss2,f,tout] = SpkSpec(sig1_correct_targ_ss2,tapers,[-500 2500],1000,.01,[0,200],0);
    [spec1_correct_targ_ss4,f,tout] = SpkSpec(sig1_correct_targ_ss4,tapers,[-500 2500],1000,.01,[0,200],0);
    [spec1_correct_targ_ss8,f,tout] = SpkSpec(sig1_correct_targ_ss8,tapers,[-500 2500],1000,.01,[0,200],0);
    [spec2_correct_targ_ss2,f,tout] = LFPSpec(sig2_correct_targ_ss2,tapers,1000,.01,[0,200],0,-500);
    [spec2_correct_targ_ss4,f,tout] = LFPSpec(sig2_correct_targ_ss4,tapers,1000,.01,[0,200],0,-500);
    [spec2_correct_targ_ss8,f,tout] = LFPSpec(sig2_correct_targ_ss8,tapers,1000,.01,[0,200],0,-500);
    [coh_correct_targ_ss2,f,tout] = Spk_LFPCoh(sig1_correct_targ_ss2,sig2_correct_targ_ss2,tapers,-500,[-500 2500],1000,.01,[0,200],0);
    [coh_correct_targ_ss4,f,tout] = Spk_LFPCoh(sig1_correct_targ_ss4,sig2_correct_targ_ss4,tapers,-500,[-500 2500],1000,.01,[0,200],0);
    [coh_correct_targ_ss8,f,tout] = Spk_LFPCoh(sig1_correct_targ_ss8,sig2_correct_targ_ss8,tapers,-500,[-500 2500],1000,.01,[0,200],0);

    tout_targ = tout;
    f_targ = f;
    
    if plotFlag == 1;
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        %SS2 Target Aligned
        subplot(1,3,1)
        imagesc(tout,f,abs(coh_correct_targ_ss2'))
        axis xy
        xlabel('Time from Target','fontsize',14,'fontweight','bold')
        ylabel(['n = ' mat2str(n_ss2)],'fontsize',14,'fontweight','bold')
        colorbar
        title('SS2','fontsize',14,'fontweight','bold')
        color_limits(1,1:2) = get(gca,'clim');
        
        %SS4 Target Aligned
        subplot(1,3,2)
        imagesc(tout,f,abs(coh_correct_targ_ss4'))
        axis xy
        xlabel('Time from Target','fontsize',14,'fontweight','bold')
        ylabel(['n = ' mat2str(n_ss4)],'fontsize',14,'fontweight','bold')
        colorbar
        title('SS4','fontsize',14,'fontweight','bold')
        color_limits(2,1:2) = get(gca,'clim');
        
        %SS8 Target Aligned
        subplot(1,3,3)
        imagesc(tout,f,abs(coh_correct_targ_ss8'))
        axis xy
        xlabel('Time from Target','fontsize',14,'fontweight','bold')
        ylabel(['n = ' mat2str(n_ss8)],'fontsize',14,'fontweight','bold')
        colorbar
        title('SS8','fontsize',14,'fontweight','bold')
        color_limits(3,1:2) = get(gca,'clim');
        
        %find min and max of color_limits, then go back and rescale
        min_col = min(color_limits(:,1));
        max_col = max(color_limits(:,2));
        new_lims = [min_col max_col];
        
        subplot(1,3,1)
        set(gca,'clim',new_lims)
        subplot(1,3,2)
        set(gca,'clim',new_lims)
        subplot(1,3,3)
        set(gca,'clim',new_lims)
        
%         
%         subplot(2,3,4)
%         imagesc(tout,f,abs(coh_correct_resp_ss2'))
%         axis xy
%         xlabel('Time from Target','fontsize',14,'fontweight','bold')
%         ylabel('Frequency','fontsize',14,'fontweight','bold')
%         colorbar
%         title('SS2','fontsize',14,'fontweight','bold')
%         set(gca,'clim',[0 .6])
%         
%         subplot(2,3,5)
%         imagesc(tout,f,abs(coh_correct_resp_ss4'))
%         axis xy
%         xlabel('Time from Target','fontsize',14,'fontweight','bold')
%         ylabel('Frequency','fontsize',14,'fontweight','bold')
%         colorbar
%         title('SS4','fontsize',14,'fontweight','bold')
%         set(gca,'clim',[0 .6])
%         
%         subplot(2,3,6)
%         imagesc(tout,f,abs(coh_correct_resp_ss8'))
%         axis xy
%         xlabel('Time from Target','fontsize',14,'fontweight','bold')
%         ylabel('Frequency','fontsize',14,'fontweight','bold')
%         colorbar
%         title('SS8','fontsize',14,'fontweight','bold')
%         set(gca,'clim',[0 .6])
%         
        
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'FontSize',14,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/SetSize/JPG/',file,'_',[DSPlist(Spikechan,:) ADlist(ADchan,:)],'_coherence_setsize.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[DSPlist(Spikechan,:) ADlist(ADchan,:)],'_coherence_setsize.jpg',q])
        close(h)
    end
    
    % %     %======================================
    % %     % Save Variables
    % %     if saveFlag == 1
    % %         save(['//scratch/heitzrp/Output/Coherence/Matrices/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_Coherence.mat'],'cor_correct','cor_errors','spec1_correct','spec2_correct','spec1_errors','spec2_errors','coh_correct','coh_errors','-mat')
    % %     end
    
    %======================================
    
    if saveFlag == 1
        %save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/SetSize/Matrices/' file '_' ...
            DSPlist(Spikechan,:) ADlist(ADchan,:) ...
            '_Coherence_setsize.mat'],'wf_sig2_correct_targ_ss2','wf_sig2_correct_targ_ss4', ...
            'wf_sig2_correct_targ_ss8','coh_correct_targ_ss2','coh_correct_targ_ss4', ...
            'coh_correct_targ_ss8','spec1_correct_targ_ss2', ...
            'spec1_correct_targ_ss4','spec1_correct_targ_ss8','spec2_correct_targ_ss2', ...
            'spec2_correct_targ_ss4','spec2_correct_targ_ss8','tout_targ','f_targ', ...
            'SDF_ss2','SDF_ss4','SDF_ss8','-mat')
    end
    
    %clean up variables that will change between comparisons for safety
    clear wf_sig2_correct_targ_ss2 wf_sig2_correct_targ_ss4 ...
        wf_sig2_correct_targ_ss8 wf_sig2_correct_resp_ss2 wf_sig2_correct_resp_ss4 ...
        wf_sig2_correct_resp_ss8 cor_correct_targ_ss2 cor_correct_targ_ss4 ...
        cor_correct_targ_ss8 lags coh_correct_targ_ss2 coh_correct_targ_ss4 ...
        coh_correct_targ_ss8 coh_correct_resp_ss2 coh_correct_resp_ss4 coh_correct_resp_ss8 ...
        tout_targ f_targ tout f spec1_correct_targ_ss2 spec1_correct_targ_ss4 ...
        spec1_correct_targ_ss8 spec2_correct_targ_ss2 spec2_correct_targ_ss4 spec2_correct_targ_ss8 ...
        SDF_ss2 SDF_ss4 SDF_ss8
    
    end
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes