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
path(path,'//scratch/heitzrp/Data/MG/')

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

    %make sure we have data for all conditions
%     if isempty(errors) == 1
%         error_skip = 1;
%     end
    
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
    
    
    sig1_correct_targ = sig1_targ(correct,:);
    sig2_correct_targ = sig2_targ(correct,:);
   
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
    wf_sig1_correct_targ = nanmean(sig1_correct_targ,1);
    wf_sig2_correct_targ = nanmean(sig2_correct_targ,1);
    
    
    
    
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
    
    
    % preallocate space
    cor_correct_targ(1:size(sig1_correct_targ,1),1:401) = NaN;
    
    lags = -200:200;
    
    %Correlogram for correct trials
    
    for trl = 1:size(sig1_correct_targ,1)
        cor_correct_targ(trl,1:401) = xcorr(sig2_correct_targ(trl,:),sig1_correct_targ(trl,:),200,'coeff');
    end
    
    
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
    
    n_correct = size(sig1_correct_targ,1);
    
    disp('Coherence, Target-Aligned Correct')
    [coh_correct_targ,f,tout] = LFP_LFPCoh(sig1_correct_targ,sig2_correct_targ,tapers,1000,.01,[0,200],0,-500);
    
    tout_targ = tout;
    f_targ = f;
    
    h = figure;
    set(gcf,'color','white')
    orient landscape
    
    imagesc(tout,f,abs(coh_correct_targ'))
    axis xy
    xlabel('Time from Target','fontsize',14,'fontweight','bold')
    ylabel(['n = ' mat2str(n_correct)],'fontsize',14,'fontweight','bold')
    colorbar
 
    [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
    set(h3,'FontSize',14,'FontWeight','bold')
    
    eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/MG/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_MG.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct.jpg',q])
    close(h)
    
    
    % %     %======================================
    % %     % Save Variables
    % %     if saveFlag == 1
    % %         save(['//scratch/heitzrp/Output/Coherence/Matrices/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_Coherence.mat'],'cor_correct','cor_errors','spec1_correct','spec2_correct','spec1_errors','spec2_errors','coh_correct','coh_errors','-mat')
    % %     end
    
    %======================================
    
    if saveFlag == 1
        %save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/MG/Matrices/' file '_' ...
            cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
            '_Coherence_MG.mat'],'wf_sig1_correct_targ','wf_sig2_correct_targ', ...
           'cor_correct_targ','lags','coh_correct_targ', ...
            'tout_targ','f_targ','-mat')
    end
    
    %clean up variables that will change between comparisons for safety
    clear wf_sig1_correct_targ wf_sig2_correct_targ ...
           cor_correct_targ lags coh_correct_targ ...
           tout_targ f_targ tout f
    
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes