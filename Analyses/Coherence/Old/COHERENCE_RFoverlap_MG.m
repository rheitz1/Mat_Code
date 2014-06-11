% Joint Peri-stimulus time correlogram
% time-based correlation analysis for EEG-EEG, LFP-FLP, and LFP-EEG
% comparisons.

% (c) Richard P. Heitz, Vanderbilt 2008
% All rights reserved.

function [] = COHERENCE_RFoverlap_MG(file)

plotFlag = 1;
pdfFlag = 1;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];



%load DSP channels
[file_list neuron1 neuron2] = textread('RFoverlap_MG.txt','%s %s %s');

%load supporting variables
for f = 1:size(file_list,1)
    eval(['load(' q [cell2mat(file_list(f)) '.mat'] qcq cell2mat(neuron1(f)) qcq cell2mat(neuron2(f)) qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);

    disp([mat2str(cell2mat(file_list(f))) ' ' mat2str(cell2mat(neuron1(f))) ' vs ' mat2str(cell2mat(neuron2(f)))])

    %find appropriate RFs based on DSP channels in workspace
    getRF

    %find RF overlap
    overlapRF = intersect(RF{1},RF{2});
    overlapAntiRF = getAntiRF(overlapRF);

    fixErrors
    error_skip = 0;


    %====================================================
    % SET UP DATA
    %find relevant trials, exclude catch trials (255)

    %analyze: spectra and coherence for:
    % -all correct
    % -all errors
    % -fast and slow correct
    % -fast and slow errors
    % -correct set size 2 vs 4 vs 8
    % everything target aligned and response aligned

    correct_in = find(ismember(Target_(:,2),overlapRF) & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
    

    
    %abort if no trials
    if isempty(correct_in)
        disp('No Trials')
        keep plotFlag saveFlag q c qcq file_list neuron1 neuron2
        continue
    end

    %==================================================


    %==========================================================
    % GENERATE STARTING MATRICES FOR SIGNALS

    sig1_targ = eval(cell2mat(neuron1(f)));
    sig2_targ = eval(cell2mat(neuron2(f)));

    %Time-correction for spikes
    %if is an AD channel, can use response_align script.
    %otherwise, is a DSP channel and must response align using SRT.
    %create correction factors. For target aligned, subtract matrix of
    %500's.  For response align, subtract matrix of SRT + 500.
    targ_correction = repmat(500,size(sig1_targ,1),size(sig1_targ,2));
    sig1_targ = sig1_targ - targ_correction;
    clear targ_correction

    targ_correction = repmat(500,size(sig2_targ,1),size(sig2_targ,2));

    %below correction MUST be done 2nd
    sig2_targ = sig2_targ - targ_correction;

    clear targ_correction

    %===========================================================




    %=======================================================
    % SET UP SIGNALS
    % Sig 1, target-aligned
    sig1_correct_targ_in = sig1_targ(correct_in,:);

    % Sig 2, target-aligned
    sig2_correct_targ_in = sig2_targ(correct_in,:);
    %========================================================






    %=========================================================
    % Keep track of average waveforms
    % If AD channel, take mean
    % If Spike channel, get SDF (note: we cannot use the sigx_resp variable
    % because it has been modified.  Use sigx_targ with Align_Time

    %already corrected spike times, so should align at 0
    Align_Time = zeros(length(Target_),1);
    Plot_Time = [-500 2500];

    wf_sig1_targ.correct_in = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_in, TrialStart_);
  
    wf_sig2_targ.correct_in = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_in, TrialStart_);
  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % COHERENCE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS

    %get spectral analysis of each, print % save

    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);

    %keep track of numbers of trials
    n.correct_in = size(sig1_correct_targ_in,1);
   
    %both signals are spikes

    [coh_targ.correct_in,f_targ,tout_targ,spec1_targ.correct_in,spec2_targ.correct_in] = Spk_SpkCoh(sig1_correct_targ_in,sig2_correct_targ_in,tapers,[-500 2500],1000,.01,[0,200],0);
   

    %==============================================================
    % PLOTTING
    % FIGURE 1: Spectra

    h = figure;
    set(gcf,'color','white')
    orient landscape

    subplot(2,2,1)
    imagesc(tout_targ,f_targ,log10(spec1_targ.correct_in'))
    axis xy
    xlabel('Time from Target','fontweight','bold','fontsize',14)
    ylabel('Frequency','fontweight','bold','fontsize',14)
    xlim([-200 1200])
    colorbar
    title([cell2mat(neuron1(f)) ' Spectra Correct InTrials'],'fontweight','bold','fontsize',14)
    color_limits(1,1:2) = get(gca,'CLim');


    subplot(2,2,2)
    imagesc(tout_targ,f_targ,log10(spec2_targ.correct_in'))
    axis xy
    xlabel('Time from Target','fontweight','bold','fontsize',14)
    ylabel('Frequency','fontweight','bold','fontsize',14)
    xlim([-200 1200])
    colorbar
    title([cell2mat(neuron2(f)) ' Spectra Correct InTrials'],'fontweight','bold','fontsize',14)
    color_limits(2,1:2) = get(gca,'CLim');

    c = [min(color_limits(:,1)) max(color_limits(:,2))];
    
    subplot(2,2,1)
    set(gca,'CLim',c)
    subplot(2,2,2)
    set(gca,'CLim',c)
    
    subplot(2,2,3)
    imagesc(tout_targ,f_targ,abs(coh_targ.correct_in'))
    axis xy
    xlabel('Time from Target','fontweight','bold','fontsize',14)
    ylabel('Frequency','fontweight','bold','fontsize',14)
    xlim([-200 1200])
    colorbar
    title([cell2mat(neuron1(f)) cell2mat(neuron2(f)) ' Coherence Correct InTrials'],'fontweight','bold','fontsize',14)
 
    subplot(2,2,4)
    plot(-500:2500,wf_sig1_targ.correct_in,'b',-500:2500,wf_sig2_targ.correct_in,'r')
    xlim([-200 1200])
    legend(cell2mat(neuron1(f)),cell2mat(neuron2(f)))
    
    
    [ax,h2] = suplabel(['nCorrect InTrials = ' mat2str(n.correct_in)],'y');
    set(h2,'fontsize',14,'FontWeight','bold')
    [ax,h3] = suplabel(['   File: ',cell2mat(file_list(f)),'   Generated: ',date],'t');
    set(h3,'fontsize',14,'FontWeight','bold')

    eval(['print -djpeg100 ',q,'/volumes/Dump2/Coherence/RFoverlap_MG/JPG/',cell2mat(file_list(f)),'_',[cell2mat(neuron1(f)) cell2mat(neuron2(f))],'_MG.jpg',q])
    %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_fastslow_errors.jpg',q])
    close(h)




    %=====================================================================
    if saveFlag == 1
        %save(['~/desktop/s/' file '_' ...
        save(['/volumes/Dump2/Coherence/RFoverlap_MG/Matrices/' cell2mat(file_list(f)) '_' ...
            cell2mat(neuron1(f)) cell2mat(neuron2(f)) ...
            '_Coherence_MG.mat'],'wf_sig1_targ','wf_sig2_targ','n', ...
            'coh_targ','spec1_targ','spec2_targ','-mat')
    end




    %clean up variables that will change between comparisons for safety
    keep plotFlag saveFlag q c qcq file_list neuron1 neuron2

end

% disp('Completed')
% disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes