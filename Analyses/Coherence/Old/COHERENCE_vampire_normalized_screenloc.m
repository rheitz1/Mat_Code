%Computes coherence (normalized coh, unnormalized coh, normalized partial
%coh, unnormalized partial coh.  Plots normalized partial coh & tuning
%curves as well as spectra.

function [] = COHERENCE_vampire_normalized_screenloc(file)
tic


% path(path,'/home/heitzrp/Mat_Code/Common')
% path(path,'/home/heitzrp/Mat_Code/JPSTC')
% path(path,'/home/heitzrp/Data')
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')
path(path,'//scratch/heitzrp/Data/MG/')

plotFlag = 0;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist)));
%DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist


ChanStruct = loadChan(file,'LFP');
chanlist1 = fieldnames(ChanStruct);
decodeChanStruct

ChanStruct = loadChan(file,'DSP');
chanlist2 = fieldnames(ChanStruct);
decodeChanStruct

chanlist = cat(1,chanlist1,chanlist2);
clear chanlist1 chanlist2

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);

%rename LFP channels for consistency

%Find all possible pairings of channels
pairings = nchoosek(1:length(chanlist),2);


%Compute comparisons backwards so we get Spike and LFP coherence out first
for pair = size(pairings,1):-1:1
%for pair = 1:size(pairings,1)
    disp(['Comparing... ' cell2mat(chanlist(pairings(pair,1))) ' vs ' cell2mat(chanlist(pairings(pair,2))) ' ... ' mat2str(length(pairings) - pair + 1) ' of ' mat2str(size(pairings,1))])
    
    
    
    fixErrors
    
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
    
    %IMPORTANT NOTE:
    %if channels are not in the same hemisphere, use all screen locations
    %if in same hemisphere & are both AD, compare contra vs. ipsi
    %if in same hemisphere & one or both are DSP, compare T_in vs D_in
    
    %===========================================
    %find hemisphere
    if Hemi.(chanlist{pairings(pair,1)}) == 'R'
        chan1_hemi = {'R'};
    elseif Hemi.(chanlist{pairings(pair,1)}) == 'L'
        chan1_hemi = {'L'};
    elseif Hemi.(chanlist{pairings(pair,1)}) == 'M'
        chan1_hemi = {'M'};
    end
    
    if Hemi.(chanlist{pairings(pair,2)}) == 'R'
        chan2_hemi = {'R'};
    elseif Hemi.(chanlist{pairings(pair,2)}) == 'L'
        chan2_hemi = {'L'};
    elseif Hemi.(chanlist{pairings(pair,2)}) == 'M'
        chan2_hemi = {'M'};
    end
    %===========================================
    
    %Check to see if neuron;  then check for RF.  if no RF, then
    %unclassified neuron and should not be included
    if strmatch('DSP',chanlist(pairings(pair,1))) 
        if isempty(RFs.(chanlist{pairings(pair,1)}))
            disp('Empty RF, moving on')
            continue
        end
    end
    
    if strmatch('DSP',chanlist(pairings(pair,2)))
        if isempty(RFs.(chanlist{pairings(pair,2)}))
            disp('Empty RF, moving on')
            continue
        end
    end
    
    
    %=====================================================================
    %=====================================================================
    % SET UP TRIALS
    % randomize them too for use with randperm later; order will not matter
    % otherwise
    
    pos0 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 0);
    pos1 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 1);
    pos2 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 2);
    pos3 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 3);
    pos4 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 4);
    pos5 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 5);
    pos6 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 6);
    pos7 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 7);
    posall = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000);
    

    
    
    %===========================================
    
    
    
    %==========================================================
    % GENERATE STARTING MATRICES FOR SIGNALS
    
    sig1_targ = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2_targ = eval(cell2mat(chanlist(pairings(pair,2))));
    %==========================================================
    
    
    %=============================================================
    % Get tuning curves: max, min, min-max, and FFT power 0-10 Hz
    Bundle.Correct_ = Correct_;
    Bundle.Target_ = Target_;
    Bundle.SRT = SRT;
    Bundle.TrialStart_ = TrialStart_;
        
        
    if strmatch('AD',chanlist(pairings(pair,1)))
        tuning.sig1.band3_10 = getTuning_AD(sig1_targ,Bundle,[0 400],[3 10]);
        tuning.sig1.band20_40 = getTuning_AD(sig1_targ,Bundle,[0 400],[20 40]);
    elseif strmatch('DSP',chanlist(pairings(pair,1)))
        tuning.sig1.band3_10 = getTuning_SP(sig1_targ,Bundle,[0 400],[3 10]);
        tuning.sig1.band20_40 = getTuning_SP(sig1_targ,Bundle,[0 400],[20 40]);
    end
    
    if strmatch('AD',chanlist(pairings(pair,2)))
        tuning.sig2.band3_10 = getTuning_AD(sig2_targ,Bundle,[0 400],[3 10]);
        tuning.sig2.band20_40 = getTuning_AD(sig2_targ,Bundle,[0 400],[20 40]);
    elseif strmatch('DSP',chanlist(pairings(pair,2)))
        tuning.sig2.band3_10 = getTuning_SP(sig2_targ,Bundle,[0 400],[3 10]);
        tuning.sig2.band20_40 = getTuning_SP(sig2_targ,Bundle,[0 400],[20 40]);
    end
    %==========================================================
    
    
    %do Matt's Tuning Test.  Need fourier components by trial
    [tuning.sig1.MN_band3_10.PD tuning.sig1.MN_band3_10.R tuning.sig1.MN_band3_10.NormR tuning.sig1.MN_band3_10.P] = TuningTest(tuning.sig1.band3_10.fft,[0 1 2 3 4 5 6 7]);
    [tuning.sig2.MN_band3_10.PD tuning.sig2.MN_band3_10.R tuning.sig2.MN_band3_10.NormR tuning.sig2.MN_band3_10.P] = TuningTest(tuning.sig2.band3_10.fft,[0 1 2 3 4 5 6 7]);
    
    [tuning.sig1.MN_band20_40.PD tuning.sig1.MN_band20_40.R tuning.sig1.MN_band20_40.NormR tuning.sig1.MN_band20_40.P] = TuningTest(tuning.sig1.band20_40.fft,[0 1 2 3 4 5 6 7]);
    [tuning.sig2.MN_band20_40.PD tuning.sig2.MN_band20_40.R tuning.sig2.MN_band20_40.NormR tuning.sig2.MN_band20_40.P] = TuningTest(tuning.sig2.band20_40.fft,[0 1 2 3 4 5 6 7]);
    
    %=========================================
    % Time-correction for spikes
    % if is an AD channel, can use response_align script.
    % otherwise, is a DSP channel and must response align using SRT.
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1
        sig1_resp = response_align(sig1_targ,SRT,[-600 300]);
    else
        sig1_targ(find(sig1_targ == 0)) = NaN;
        
        %create correction factors. For target aligned, subtract matrix of
        %500's.  For response align, subtract matrix of SRT + 500.
        targ_correction = repmat(500,size(sig1_targ,1),size(sig1_targ,2));
        resp_correction = repmat(SRT(:,1),1,size(sig1_targ,2)) + 500;
        
        sig1_resp = sig1_targ - resp_correction;
        %below correction MUST be done 2nd
        sig1_targ = sig1_targ - targ_correction;
        
        clear targ_correction resp_correction
    end
    
    if strmatch('AD',chanlist(pairings(pair,2))) == 1
        sig2_resp = response_align(sig2_targ,SRT,[-600 300]);
    else
        sig2_targ(find(sig2_targ == 0)) = NaN;
        
        targ_correction = repmat(500,size(sig2_targ,1),size(sig2_targ,2));
        resp_correction = repmat(SRT(:,1),1,size(sig2_targ,2)) + 500;
        
        sig2_resp = sig2_targ - resp_correction;
        %below correction MUST be done 2nd
        sig2_targ = sig2_targ - targ_correction;
        
        clear targ_correction resp_correction
    end
    %===========================================================
    
    
    
    
    %=======================================================
    % SET UP NONDEPENDENT SIGNALS
    % Sig 1, target-aligned
    sig1_correct_pos0 = sig1_targ(pos0,:);
    sig1_correct_pos1 = sig1_targ(pos1,:);
    sig1_correct_pos2 = sig1_targ(pos2,:);
    sig1_correct_pos3 = sig1_targ(pos3,:);
    sig1_correct_pos4 = sig1_targ(pos4,:);
    sig1_correct_pos5 = sig1_targ(pos5,:);
    sig1_correct_pos6 = sig1_targ(pos6,:);
    sig1_correct_pos7 = sig1_targ(pos7,:);
    sig1_correct_all = sig1_targ(posall,:);
    
    sig2_correct_pos0 = sig2_targ(pos0,:);
    sig2_correct_pos1 = sig2_targ(pos1,:);
    sig2_correct_pos2 = sig2_targ(pos2,:);
    sig2_correct_pos3 = sig2_targ(pos3,:);
    sig2_correct_pos4 = sig2_targ(pos4,:);
    sig2_correct_pos5 = sig2_targ(pos5,:);
    sig2_correct_pos6 = sig2_targ(pos6,:);
    sig2_correct_pos7 = sig2_targ(pos7,:);
    sig2_correct_all = sig2_targ(posall,:);
    %=========================================================
    
       
    
    %========================================================
    % Spectra and coherence can't handle NaNs so need to remove from
    % response-aligned signals.
    % Only need to do it for AD channels (spike channels will not have NaNs
    % but instead 0's
    % BUT Because both signals must have same trials, have to eliminate
    % them from both.  Run it on Sig2 first (using sig1 to find the NaNs)
    % because when computing AD-Spike coherence, need to make sure Spikes
    % have same trials removed.  Have to use sig1 in this case because sig2
    % won't have any NaNs.
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1
        %for cases shen the Spike channel is 2nd, this will eliminate same
        %trials. Note that are indexing sig1 but holding it in sig2
        
        %Need to run this in reverse order because otherwise, signal would
        %already be changed and not contain any NaNs
        sig2_correct_pos0(any(isnan(sig1_correct_pos0)'),:) = [];
        sig2_correct_pos1(any(isnan(sig1_correct_pos1)'),:) = [];
        sig2_correct_pos2(any(isnan(sig1_correct_pos2)'),:) = [];
        sig2_correct_pos3(any(isnan(sig1_correct_pos3)'),:) = [];
        sig2_correct_pos4(any(isnan(sig1_correct_pos4)'),:) = [];
        sig2_correct_pos5(any(isnan(sig1_correct_pos5)'),:) = [];
        sig2_correct_pos6(any(isnan(sig1_correct_pos6)'),:) = [];
        sig2_correct_pos7(any(isnan(sig1_correct_pos7)'),:) = [];
        sig2_correct_all(any(isnan(sig1_correct_all)'),:) = [];
        
        
        sig1_correct_pos0(any(isnan(sig1_correct_pos0)'),:) = [];
        sig1_correct_pos1(any(isnan(sig1_correct_pos1)'),:) = [];
        sig1_correct_pos2(any(isnan(sig1_correct_pos2)'),:) = [];
        sig1_correct_pos3(any(isnan(sig1_correct_pos3)'),:) = [];
        sig1_correct_pos4(any(isnan(sig1_correct_pos4)'),:) = [];
        sig1_correct_pos5(any(isnan(sig1_correct_pos5)'),:) = [];
        sig1_correct_pos6(any(isnan(sig1_correct_pos6)'),:) = [];
        sig1_correct_pos7(any(isnan(sig1_correct_pos7)'),:) = [];
        sig1_correct_all(any(isnan(sig1_correct_all)'),:) = [];
        
    end
    
    %===============================================================
    
    
    
    
    
    
    %=========================================================
    % Keep track of average waveforms
    % If AD channel, take mean
    % If Spike channel, get SDF (note: we cannot use the sigx_resp variable
    % because it has been modified.  Use sigx_targ with Align_Time
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1
        wf_sig1.pos0 = nanmean(sig1_targ(pos0,:));
        wf_sig1.pos1 = nanmean(sig1_targ(pos1,:));
        wf_sig1.pos2 = nanmean(sig1_targ(pos2,:));
        wf_sig1.pos3 = nanmean(sig1_targ(pos3,:));
        wf_sig1.pos4 = nanmean(sig1_targ(pos4,:));
        wf_sig1.pos5 = nanmean(sig1_targ(pos5,:));
        wf_sig1.pos6 = nanmean(sig1_targ(pos6,:));
        wf_sig1.pos7 = nanmean(sig1_targ(pos7,:));
        wf_sig1.all = nanmean(sig1_targ(posall,:));
        
        
    else
        %already corrected spike times, so should align at 0
        Align_Time = zeros(length(Target_),1);
        Plot_Time = [-500 2500];
        
        wf_sig1.pos0 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos0,TrialStart_);
        wf_sig1.pos1 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos1,TrialStart_);
        wf_sig1.pos2 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos2,TrialStart_);
        wf_sig1.pos3 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos3,TrialStart_);
        wf_sig1.pos4 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos4,TrialStart_);
        wf_sig1.pos5 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos5,TrialStart_);
        wf_sig1.pos6 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos6,TrialStart_);
        wf_sig1.pos7 = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,pos7,TrialStart_);
        wf_sig1.all = spikedensityfunct(sig1_targ,Align_Time,Plot_Time,posall,TrialStart_);
        
        
    end
    
    %for signal 2
    if strmatch('AD',chanlist(pairings(pair,2))) == 1
        wf_sig2.pos0 = nanmean(sig2_targ(pos0,:));
        wf_sig2.pos1 = nanmean(sig2_targ(pos1,:));
        wf_sig2.pos2 = nanmean(sig2_targ(pos2,:));
        wf_sig2.pos3 = nanmean(sig2_targ(pos3,:));
        wf_sig2.pos4 = nanmean(sig2_targ(pos4,:));
        wf_sig2.pos5 = nanmean(sig2_targ(pos5,:));
        wf_sig2.pos6 = nanmean(sig2_targ(pos6,:));
        wf_sig2.pos7 = nanmean(sig2_targ(pos7,:));
        wf_sig2.all = nanmean(sig2_targ(posall,:));
        
        
    else
        Plot_Time = [-500 2500];
        %already corrected spike times, so should align at 0
        Align_Time = zeros(length(Target_),1);
        
        wf_sig2.pos0 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos0,TrialStart_);
        wf_sig2.pos1 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos1,TrialStart_);
        wf_sig2.pos2 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos2,TrialStart_);
        wf_sig2.pos3 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos3,TrialStart_);
        wf_sig2.pos4 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos4,TrialStart_);
        wf_sig2.pos5 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos5,TrialStart_);
        wf_sig2.pos6 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos6,TrialStart_);
        wf_sig2.pos7 = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,pos7,TrialStart_);
        wf_sig2.all = spikedensityfunct(sig2_targ,Align_Time,Plot_Time,posall,TrialStart_);
        
    end
    
    
    
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
    n.pos0 = length(pos0);
    n.pos1 = length(pos1);
    n.pos2 = length(pos2);
    n.pos3 = length(pos3);
    n.pos4 = length(pos4);
    n.pos5 = length(pos5);
    n.pos6 = length(pos6);
    n.pos7 = length(pos7);
    n.all = length(posall);

    
    %compute coherence and spectra - must structure depending on nature of
    %signals (AD vs Spike)
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('AD',chanlist(pairings(pair,2))) == 1
        [coh_targ.pos0,f_targ,tout_targ,spec1_targ.pos0,spec2_targ.pos0,Pcoh_targ.pos0,Pspec1_targ.pos0,Pspec2_targ.pos0] = LFP_LFPCoh(sig1_correct_pos0,sig2_correct_pos0,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos1,f_targ,tout_targ,spec1_targ.pos1,spec2_targ.pos1,Pcoh_targ.pos1,Pspec1_targ.pos1,Pspec2_targ.pos1] = LFP_LFPCoh(sig1_correct_pos1,sig2_correct_pos1,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos2,f_targ,tout_targ,spec1_targ.pos2,spec2_targ.pos2,Pcoh_targ.pos2,Pspec1_targ.pos2,Pspec2_targ.pos2] = LFP_LFPCoh(sig1_correct_pos2,sig2_correct_pos2,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos3,f_targ,tout_targ,spec1_targ.pos3,spec2_targ.pos3,Pcoh_targ.pos3,Pspec1_targ.pos3,Pspec2_targ.pos3] = LFP_LFPCoh(sig1_correct_pos3,sig2_correct_pos3,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos4,f_targ,tout_targ,spec1_targ.pos4,spec2_targ.pos4,Pcoh_targ.pos4,Pspec1_targ.pos4,Pspec2_targ.pos4] = LFP_LFPCoh(sig1_correct_pos4,sig2_correct_pos4,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos5,f_targ,tout_targ,spec1_targ.pos5,spec2_targ.pos5,Pcoh_targ.pos5,Pspec1_targ.pos5,Pspec2_targ.pos5] = LFP_LFPCoh(sig1_correct_pos5,sig2_correct_pos5,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos6,f_targ,tout_targ,spec1_targ.pos6,spec2_targ.pos6,Pcoh_targ.pos6,Pspec1_targ.pos6,Pspec2_targ.pos6] = LFP_LFPCoh(sig1_correct_pos6,sig2_correct_pos6,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.pos7,f_targ,tout_targ,spec1_targ.pos7,spec2_targ.pos7,Pcoh_targ.pos7,Pspec1_targ.pos7,Pspec2_targ.pos7] = LFP_LFPCoh(sig1_correct_pos7,sig2_correct_pos7,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        [coh_targ.all,f_targ,tout_targ,spec1_targ.all,spec2_targ.all,Pcoh_targ.all,Pspec1_targ.all,Pspec2_targ.all] = LFP_LFPCoh(sig1_correct_all,sig2_correct_all,tapers,1000,.01,[0 80],0,-500,0,4,.05,0,2,1);
        
        
        %for sig1 = AD and sig2 = Spike (must enter differently into Spk_LFPCoh
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        [coh_targ.pos0,f_targ,tout_targ,spec2_targ.pos0,spec1_targ.pos0,Pcoh_targ.pos0,Pspec2_targ.pos0,Pspec1_targ.pos0] = Spk_LFPCoh(sig2_correct_pos0,sig1_correct_pos0,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos1,f_targ,tout_targ,spec2_targ.pos1,spec1_targ.pos1,Pcoh_targ.pos1,Pspec2_targ.pos1,Pspec1_targ.pos1] = Spk_LFPCoh(sig2_correct_pos1,sig1_correct_pos1,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos2,f_targ,tout_targ,spec2_targ.pos2,spec1_targ.pos2,Pcoh_targ.pos2,Pspec2_targ.pos2,Pspec1_targ.pos2] = Spk_LFPCoh(sig2_correct_pos2,sig1_correct_pos2,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos3,f_targ,tout_targ,spec2_targ.pos3,spec1_targ.pos3,Pcoh_targ.pos3,Pspec2_targ.pos3,Pspec1_targ.pos3] = Spk_LFPCoh(sig2_correct_pos3,sig1_correct_pos3,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos4,f_targ,tout_targ,spec2_targ.pos4,spec1_targ.pos4,Pcoh_targ.pos4,Pspec2_targ.pos4,Pspec1_targ.pos4] = Spk_LFPCoh(sig2_correct_pos4,sig1_correct_pos4,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos5,f_targ,tout_targ,spec2_targ.pos5,spec1_targ.pos5,Pcoh_targ.pos5,Pspec2_targ.pos5,Pspec1_targ.pos5] = Spk_LFPCoh(sig2_correct_pos5,sig1_correct_pos5,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos6,f_targ,tout_targ,spec2_targ.pos6,spec1_targ.pos6,Pcoh_targ.pos6,Pspec2_targ.pos6,Pspec1_targ.pos6] = Spk_LFPCoh(sig2_correct_pos6,sig1_correct_pos6,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos7,f_targ,tout_targ,spec2_targ.pos7,spec1_targ.pos7,Pcoh_targ.pos7,Pspec2_targ.pos7,Pspec1_targ.pos7] = Spk_LFPCoh(sig2_correct_pos7,sig1_correct_pos7,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.all,f_targ,tout_targ,spec2_targ.all,spec1_targ.all,Pcoh_targ.all,Pspec2_targ.all,Pspec1_targ.all] = Spk_LFPCoh(sig2_correct_all,sig1_correct_all,tapers,-500,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
                
        
        %both signals are spikes
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        [coh_targ.pos0,f_targ,tout_targ,spec1_targ.pos0,spec2_targ.pos0,Pcoh_targ.pos0,Pspec1_targ.pos0,Pspec2_targ.pos0] = Spk_SpkCoh(sig1_correct_pos0,sig2_correct_pos0,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos1,f_targ,tout_targ,spec1_targ.pos1,spec2_targ.pos1,Pcoh_targ.pos1,Pspec1_targ.pos1,Pspec2_targ.pos1] = Spk_SpkCoh(sig1_correct_pos1,sig2_correct_pos1,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos2,f_targ,tout_targ,spec1_targ.pos2,spec2_targ.pos2,Pcoh_targ.pos2,Pspec1_targ.pos2,Pspec2_targ.pos2] = Spk_SpkCoh(sig1_correct_pos2,sig2_correct_pos2,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos3,f_targ,tout_targ,spec1_targ.pos3,spec2_targ.pos3,Pcoh_targ.pos3,Pspec1_targ.pos3,Pspec2_targ.pos3] = Spk_SpkCoh(sig1_correct_pos3,sig2_correct_pos3,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos4,f_targ,tout_targ,spec1_targ.pos4,spec2_targ.pos4,Pcoh_targ.pos4,Pspec1_targ.pos4,Pspec2_targ.pos4] = Spk_SpkCoh(sig1_correct_pos4,sig2_correct_pos4,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos5,f_targ,tout_targ,spec1_targ.pos5,spec2_targ.pos5,Pcoh_targ.pos5,Pspec1_targ.pos5,Pspec2_targ.pos5] = Spk_SpkCoh(sig1_correct_pos5,sig2_correct_pos5,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos6,f_targ,tout_targ,spec1_targ.pos6,spec2_targ.pos6,Pcoh_targ.pos6,Pspec1_targ.pos6,Pspec2_targ.pos6] = Spk_SpkCoh(sig1_correct_pos6,sig2_correct_pos6,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.pos7,f_targ,tout_targ,spec1_targ.pos7,spec2_targ.pos7,Pcoh_targ.pos7,Pspec1_targ.pos7,Pspec2_targ.pos7] = Spk_SpkCoh(sig1_correct_pos7,sig2_correct_pos7,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);
        [coh_targ.all,f_targ,tout_targ,spec1_targ.all,spec2_targ.all,Pcoh_targ.all,Pspec1_targ.all,Pspec2_targ.all] = Spk_SpkCoh(sig1_correct_all,sig2_correct_all,tapers,[-500 2500],1000,.01,[0 80],0,4,.05,0,2,1);

    end
%=========================================================================
    
    
    
    
    
    %==============================================================
    % PLOTTING
    
    
    %get Monkey name
    getMonk
    
    %Naming Conventions
    if strmatch('AD01',chanlist(pairings(pair,1))) == 1
        name1 = 'Oz';
    elseif strmatch('AD02',chanlist(pairings(pair,1))) == 1 & monkey == 'S'
        name1 = 'OR';
    elseif strmatch('AD02',chanlist(pairings(pair,1))) == 1 & monkey == 'Q'
        name1 = 'T6';
    elseif strmatch('AD03',chanlist(pairings(pair,1))) == 1 & monkey == 'S'
        name1 = 'OL';
    elseif strmatch('AD03',chanlist(pairings(pair,1))) == 1 & monkey == 'Q'
        name1 = 'T5';
    elseif strmatch('AD04',chanlist(pairings(pair,1))) == 1 & monkey == 'S'
        name1 = 'C4';
    elseif strmatch('AD04',chanlist(pairings(pair,1))) == 1 & monkey == 'Q'
        name1 = 'rLFP';
    elseif strmatch('AD05',chanlist(pairings(pair,1))) == 1
        name1 = 'C3';
    elseif strmatch('AD06',chanlist(pairings(pair,1))) == 1
        name1 = 'F4';
    elseif strmatch('AD07',chanlist(pairings(pair,1))) == 1
        name1 = 'F3';
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'L'
        name1 = 'lLFP';
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'R'
        name1 = 'rLFP';
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'L'
        name1 = 'lNeu';
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'R'
        name1 = 'rNeu';
    end
    
    if strmatch('AD01',chanlist(pairings(pair,2))) == 1
        name2 = 'Oz';
    elseif strmatch('AD02',chanlist(pairings(pair,2))) == 1 & monkey == 'S'
        name2 = 'OR';
    elseif strmatch('AD02',chanlist(pairings(pair,2))) == 1 & monkey == 'Q'
        name2 = 'T6';
    elseif strmatch('AD03',chanlist(pairings(pair,2))) == 1 & monkey == 'S'
        name2 = 'OL';
    elseif strmatch('AD03',chanlist(pairings(pair,2))) == 1 & monkey == 'Q'
        name2 = 'T5';
    elseif strmatch('AD04',chanlist(pairings(pair,2))) == 1 & monkey == 'S'
        name2 = 'C4';
    elseif strmatch('AD04',chanlist(pairings(pair,2))) == 1 & monkey == 'Q'
        name2 = 'rLFP';
    elseif strmatch('AD05',chanlist(pairings(pair,2))) == 1
        name2 = 'C3';
    elseif strmatch('AD06',chanlist(pairings(pair,2))) == 1
        name2 = 'F4';
    elseif strmatch('AD07',chanlist(pairings(pair,2))) == 1
        name2 = 'F3';
    elseif strmatch('AD',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'L'
        name2 = 'lLFP';
    elseif strmatch('AD',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'R'
        name2 = 'rLFP';
    elseif strmatch('DSP',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'L'
        name2 = 'lNeu';
    elseif strmatch('DSP',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'R'
        name2 = 'rNeu';
    end
    
    disp(' ... ')
    disp(' ... ')
    disp([cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))])
    disp([name1 name2])
    
    
    
    if plotFlag == 1
        
        
        
        
        
        %=======================================================
        % FIGURE 0: coherence by screen loc, baseline corrected
        
        %NOTE NOTE NOTE:
        %BASLINE CORRECT MUST BE GIVEN THE ABSOLUTE VALUE OF THE COHERENCE
        %MATRIX; INCORRECT OTHERWISE
        
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        
        for j = 0:7
            switch j
                case 0
                    screenloc = 6;
                    cond = abs(Pcoh_targ.pos0);
                    num = n.pos0;
                case 1
                    screenloc = 3;
                    cond = abs(Pcoh_targ.pos1);
                    num = n.pos1; 
                case 2
                    screenloc = 2;
                    cond = abs(Pcoh_targ.pos2);
                    num = n.pos2;
                case 3
                    screenloc = 1;
                    cond = abs(Pcoh_targ.pos3);
                    num = n.pos3;
                case 4
                    screenloc = 4;
                    cond = abs(Pcoh_targ.pos4);
                    num = n.pos4;
                case 5
                    screenloc = 7;
                    cond = abs(Pcoh_targ.pos5);
                    num = n.pos5;
                case 6
                    screenloc = 8;
                    cond = abs(Pcoh_targ.pos6);
                    num = n.pos6;
                case 7
                    screenloc = 9;
                    cond = abs(Pcoh_targ.pos7);
                    num = n.pos7;
            end
            
            %find max and min coherence values based on screen locations;
            %exclude coherence plot collapsed on screen location
%             maxCol = findMax(abs(Pcoh_targ.pos0),abs(Pcoh_targ.pos1),abs(Pcoh_targ.pos2),abs(Pcoh_targ.pos3),abs(Pcoh_targ.pos4),abs(Pcoh_targ.pos5),abs(Pcoh_targ.pos6),abs(Pcoh_targ.pos7));
%             minCol = findMin(abs(Pcoh_targ.pos0),abs(Pcoh_targ.pos1),abs(Pcoh_targ.pos2),abs(Pcoh_targ.pos3),abs(Pcoh_targ.pos4),abs(Pcoh_targ.pos5),abs(Pcoh_targ.pos6),abs(Pcoh_targ.pos7));
            
            cond = baseline_correct(cond',[1 11])';
            
            s1 = subplot(3,3,screenloc);
            imagesc(tout_targ,f_targ,cond')
            axis xy
            xlim([-100 500])
            ylim([0 80])
            title(mat2str(num))
          %  set(gca,'clim',[minCol maxCol])
        end
        
        %finally, plot coherence collapsed on screen location
        
        cond = baseline_correct(abs(Pcoh_targ.all)',[1 11])';
        subplot(3,3,5)
        imagesc(tout_targ,f_targ,cond')
        axis xy
        xlim([-100 500])
        ylim([0 80])
        colorbar
        %set(gca,'clim',[minCol maxCol])
        title([name1 ' ' name2 ' n = ' mat2str(n.all)],'fontweight','bold','fontsize',10)
        
        %equate color scale for all subplots
        rescale_subplots(figure(h),[3 3],'c')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/screenloc/JPG/normalized/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc_baseline_corrected.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc_baseline_corrected.jpg',q])
        close(h)
        
        
         
        
        
        
        %=======================================================
        % FIGURE 1: coherence by screen loc, not baseline corrected
        % and includes FFT tuning curve in middle
        
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        
        for j = 0:7
            switch j
                case 0
                    screenloc = 6;
                    cond = Pcoh_targ.pos0;
                    num = n.pos0;
                case 1
                    screenloc = 3;
                    cond = Pcoh_targ.pos1;
                    num = n.pos1; 
                case 2
                    screenloc = 2;
                    cond = Pcoh_targ.pos2;
                    num = n.pos2;
                case 3
                    screenloc = 1;
                    cond = Pcoh_targ.pos3;
                    num = n.pos3;
                case 4
                    screenloc = 4;
                    cond = Pcoh_targ.pos4;
                    num = n.pos4;
                case 5
                    screenloc = 7;
                    cond = Pcoh_targ.pos5;
                    num = n.pos5;
                case 6
                    screenloc = 8;
                    cond = Pcoh_targ.pos6;
                    num = n.pos6;
                case 7
                    screenloc = 9;
                    cond = Pcoh_targ.pos7;
                    num = n.pos7;
            end
            
            %find max and min coherence values based on screen locations;
            %exclude coherence plot collapsed on screen location
%             maxCol = findMax(abs(Pcoh_targ.pos0),abs(Pcoh_targ.pos1),abs(Pcoh_targ.pos2),abs(Pcoh_targ.pos3),abs(Pcoh_targ.pos4),abs(Pcoh_targ.pos5),abs(Pcoh_targ.pos6),abs(Pcoh_targ.pos7));
%             minCol = findMin(abs(Pcoh_targ.pos0),abs(Pcoh_targ.pos1),abs(Pcoh_targ.pos2),abs(Pcoh_targ.pos3),abs(Pcoh_targ.pos4),abs(Pcoh_targ.pos5),abs(Pcoh_targ.pos6),abs(Pcoh_targ.pos7));
            
            %cond = baseline_correct(cond',[1 11])';
            
            s1 = subplot(3,3,screenloc);
            imagesc(tout_targ,f_targ,abs(cond'))
            axis xy
            xlim([-100 500])
            ylim([0 80])
            title(mat2str(num))
           % set(gca,'clim',[minCol maxCol])
        end
        
        %finally, plot tuning
        
        %cond = baseline_correct(Pcoh.all',[1 11])';
        subplot(3,3,5)
        plot(0:7,tuning.sig1.band3_10.fft)
        xlim([0 7])
        newax
        plot(0:7,tuning.sig2.band3_10.fft,'r')
        xlim([0 7])
        set(gca,'xticklabel',[])
        title([name1 ' ' name2],'fontweight','bold','fontsize',10)
        
        %equate color scale
        rescale_subplots(figure(h),[3 3],'c',5)
        
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/screenloc/JPG/normalized/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc_no_baseline_correction.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc.jpg',q])
        close(h)
        
        
       
        
    end %if plotFlag == 1
    
    
    
    %=====================================================================
    if saveFlag == 1
        %  save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/screenloc/Matrices/normalized/' file '_' ...
            name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
            '_Coherence.mat'],'tuning','wf_sig1','wf_sig2','n', ...
            'coh_targ','spec1_targ','spec2_targ','Pcoh_targ','Pspec1_targ','Pspec2_targ','tout_targ','f_targ','-mat')
    end
    
     
    
    %clean up variables that will change between comparisons for safety
    clear tuning tout_targ tout_resp f_targ f_resp n RTs color_limits ...
        correct cMed correct_fast correct_slow correct_ss2 correct_ss4 correct_ss8 ...
        errors eMed errors_fast errors_slow correct_contra correct_ipsi correct_Tin ...
        correct_Din minTrials RF AntiRF tempname stub newname chan1_hemi chan2_hemi ...
        name1 name2 sig* wf* coh* spec* Pcoh* Pspec*
    
end %for current comparison

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes