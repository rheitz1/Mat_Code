function [] = COHERENCE_vampire_partialCoh_screenloc(file)
tic
% path(path,'/home/heitzrp/Mat_Code/Common')
% path(path,'/home/heitzrp/Mat_Code/JPSTC')
% path(path,'/home/heitzrp/Data')
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')

plotFlag = 1;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist)));
%DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist


ChanStruct = loadChan(file,'ALL');
chanlist = fieldnames(ChanStruct);
decodeChanStruct

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
    
    pos0 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 0));
    pos1 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 1));
    pos2 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 2));
    pos3 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 3));
    pos4 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 4));
    pos5 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 5));
    pos6 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 6));
    pos7 = shake(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 7));
    posall = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000);
    
    % additionally, we will compute coherence holding # of observations
    % constant.  Find minimum number of observations across screen
    % locations, then take random sample of those trials
    minTrials = findMin(length(pos0),length(pos1),length(pos2),length(pos3),length(pos4),length(pos5),length(pos6),length(pos7));
    
    pos0_eq = pos0(randperm(minTrials));
    pos1_eq = pos1(randperm(minTrials));
    pos2_eq = pos2(randperm(minTrials));
    pos3_eq = pos3(randperm(minTrials));
    pos4_eq = pos4(randperm(minTrials));
    pos5_eq = pos5(randperm(minTrials));
    pos6_eq = pos6(randperm(minTrials));
    pos7_eq = pos7(randperm(minTrials));
    
    
    %===========================================
    
    
    
    %==========================================================
    % GENERATE STARTING MATRICES FOR SIGNALS
    
    sig1_targ = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2_targ = eval(cell2mat(chanlist(pairings(pair,2))));
    %==========================================================
    
    
    %=============================================================
    % Get tuning curves: max, min, min-max, and FFT power 0-10 Hz
    getBundle
    decodeBundle
    
    if strmatch('AD',chanlist(pairings(pair,1)))
        tuning.sig1 = getTuning_AD(sig1_targ,Bundle);
    elseif strmatch('DSP',chanlist(pairings(pair,1)))
        tuning.sig1 = getTuning_Spike(sig1_targ,Bundle);
    end
    
    if strmatch('AD',chanlist(pairings(pair,2)))
        tuning.sig2 = getTuning_AD(sig2_targ,Bundle);
    elseif strmatch('DSP',chanlist(pairings(pair,2)))
        tuning.sig2 = getTuning_Spike(sig2_targ,Bundle);
    end
    %==========================================================
    
    
    
    
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
    
    
    %=========================================================
    % SET UP SIGNALS EQUALIZED BY NUMBER OF OBSERVATIONS
    sig1_correct_pos0_eq = sig1_targ(pos0_eq,:);
    sig1_correct_pos1_eq = sig1_targ(pos1_eq,:);
    sig1_correct_pos2_eq = sig1_targ(pos2_eq,:);
    sig1_correct_pos3_eq = sig1_targ(pos3_eq,:);
    sig1_correct_pos4_eq = sig1_targ(pos4_eq,:);
    sig1_correct_pos5_eq = sig1_targ(pos5_eq,:);
    sig1_correct_pos6_eq = sig1_targ(pos6_eq,:);
    sig1_correct_pos7_eq = sig1_targ(pos7_eq,:);
    
    sig2_correct_pos0_eq = sig2_targ(pos0_eq,:);
    sig2_correct_pos1_eq = sig2_targ(pos1_eq,:);
    sig2_correct_pos2_eq = sig2_targ(pos2_eq,:);
    sig2_correct_pos3_eq = sig2_targ(pos3_eq,:);
    sig2_correct_pos4_eq = sig2_targ(pos4_eq,:);
    sig2_correct_pos5_eq = sig2_targ(pos5_eq,:);
    sig2_correct_pos6_eq = sig2_targ(pos6_eq,:);
    sig2_correct_pos7_eq = sig2_targ(pos7_eq,:);
    %========================================================
    
    
    %========================================================
    
    
    
    
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
        
        sig2_correct_pos0_eq(any(isnan(sig1_correct_pos0_eq)'),:) = [];
        sig2_correct_pos1_eq(any(isnan(sig1_correct_pos1_eq)'),:) = [];
        sig2_correct_pos2_eq(any(isnan(sig1_correct_pos2_eq)'),:) = [];
        sig2_correct_pos3_eq(any(isnan(sig1_correct_pos3_eq)'),:) = [];
        sig2_correct_pos4_eq(any(isnan(sig1_correct_pos4_eq)'),:) = [];
        sig2_correct_pos5_eq(any(isnan(sig1_correct_pos5_eq)'),:) = [];
        sig2_correct_pos6_eq(any(isnan(sig1_correct_pos6_eq)'),:) = [];
        sig2_correct_pos7_eq(any(isnan(sig1_correct_pos7_eq)'),:) = [];
        
        
        
        sig1_correct_pos0(any(isnan(sig1_correct_pos0)'),:) = [];
        sig1_correct_pos1(any(isnan(sig1_correct_pos1)'),:) = [];
        sig1_correct_pos2(any(isnan(sig1_correct_pos2)'),:) = [];
        sig1_correct_pos3(any(isnan(sig1_correct_pos3)'),:) = [];
        sig1_correct_pos4(any(isnan(sig1_correct_pos4)'),:) = [];
        sig1_correct_pos5(any(isnan(sig1_correct_pos5)'),:) = [];
        sig1_correct_pos6(any(isnan(sig1_correct_pos6)'),:) = [];
        sig1_correct_pos7(any(isnan(sig1_correct_pos7)'),:) = [];
        sig1_correct_all(any(isnan(sig1_correct_all)'),:) = [];
        
        
        sig1_correct_pos0_eq(any(isnan(sig1_correct_pos0_eq)'),:) = [];
        sig1_correct_pos1_eq(any(isnan(sig1_correct_pos1_eq)'),:) = [];
        sig1_correct_pos2_eq(any(isnan(sig1_correct_pos2_eq)'),:) = [];
        sig1_correct_pos3_eq(any(isnan(sig1_correct_pos3_eq)'),:) = [];
        sig1_correct_pos4_eq(any(isnan(sig1_correct_pos4_eq)'),:) = [];
        sig1_correct_pos5_eq(any(isnan(sig1_correct_pos5_eq)'),:) = [];
        sig1_correct_pos6_eq(any(isnan(sig1_correct_pos6_eq)'),:) = [];
        sig1_correct_pos7_eq(any(isnan(sig1_correct_pos7_eq)'),:) = [];
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
    
    n.eq = minTrials;
    
    %compute coherence and spectra - must structure depending on nature of
    %signals (AD vs Spike)
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('AD',chanlist(pairings(pair,2))) == 1
        [coh_targ.pos0,f_targ,tout_targ,spec1_targ.pos0,spec2_targ.pos0,Pcoh.pos0] = LFP_LFPCoh(sig1_correct_pos0,sig2_correct_pos0,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos1,f_targ,tout_targ,spec1_targ.pos1,spec2_targ.pos1,Pcoh.pos1] = LFP_LFPCoh(sig1_correct_pos1,sig2_correct_pos1,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos2,f_targ,tout_targ,spec1_targ.pos2,spec2_targ.pos2,Pcoh.pos2] = LFP_LFPCoh(sig1_correct_pos2,sig2_correct_pos2,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos3,f_targ,tout_targ,spec1_targ.pos3,spec2_targ.pos3,Pcoh.pos3] = LFP_LFPCoh(sig1_correct_pos3,sig2_correct_pos3,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos4,f_targ,tout_targ,spec1_targ.pos4,spec2_targ.pos4,Pcoh.pos4] = LFP_LFPCoh(sig1_correct_pos4,sig2_correct_pos4,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos5,f_targ,tout_targ,spec1_targ.pos5,spec2_targ.pos5,Pcoh.pos5] = LFP_LFPCoh(sig1_correct_pos5,sig2_correct_pos5,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos6,f_targ,tout_targ,spec1_targ.pos6,spec2_targ.pos6,Pcoh.pos6] = LFP_LFPCoh(sig1_correct_pos6,sig2_correct_pos6,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos7,f_targ,tout_targ,spec1_targ.pos7,spec2_targ.pos7,Pcoh.pos7] = LFP_LFPCoh(sig1_correct_pos7,sig2_correct_pos7,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.all,f_targ,tout_targ,spec1_targ.all,spec2_targ.all,Pcoh.all] = LFP_LFPCoh(sig1_correct_all,sig2_correct_all,tapers,1000,.01,[0,200],0,-500);
        
        
        %for equated trial lengths by screen position
        [coh_targ.pos0_eq,f_targ,tout_targ,spec1_targ.pos0_eq,spec2_targ.pos0_eq,Pcoh.pos0_eq] = LFP_LFPCoh(sig1_correct_pos0_eq,sig2_correct_pos0_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos1_eq,f_targ,tout_targ,spec1_targ.pos1_eq,spec2_targ.pos1_eq,Pcoh.pos1_eq] = LFP_LFPCoh(sig1_correct_pos1_eq,sig2_correct_pos1_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos2_eq,f_targ,tout_targ,spec1_targ.pos2_eq,spec2_targ.pos2_eq,Pcoh.pos2_eq] = LFP_LFPCoh(sig1_correct_pos2_eq,sig2_correct_pos2_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos3_eq,f_targ,tout_targ,spec1_targ.pos3_eq,spec2_targ.pos3_eq,Pcoh.pos3_eq] = LFP_LFPCoh(sig1_correct_pos3_eq,sig2_correct_pos3_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos4_eq,f_targ,tout_targ,spec1_targ.pos4_eq,spec2_targ.pos4_eq,Pcoh.pos4_eq] = LFP_LFPCoh(sig1_correct_pos4_eq,sig2_correct_pos4_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos5_eq,f_targ,tout_targ,spec1_targ.pos5_eq,spec2_targ.pos5_eq,Pcoh.pos5_eq] = LFP_LFPCoh(sig1_correct_pos5_eq,sig2_correct_pos5_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos6_eq,f_targ,tout_targ,spec1_targ.pos6_eq,spec2_targ.pos6_eq,Pcoh.pos6_eq] = LFP_LFPCoh(sig1_correct_pos6_eq,sig2_correct_pos6_eq,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.pos7_eq,f_targ,tout_targ,spec1_targ.pos7_eq,spec2_targ.pos7_eq,Pcoh.pos7_eq] = LFP_LFPCoh(sig1_correct_pos7_eq,sig2_correct_pos7_eq,tapers,1000,.01,[0,200],0,-500);
        
        
        %for sig1 = AD and sig2 = Spike (must enter differently into Spk_LFPCoh
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        [coh_targ.pos0,f_targ,tout_targ,spec2_targ.pos0,spec1_targ.pos0,Pcoh.pos0] = Spk_LFPCoh(sig2_correct_pos0,sig1_correct_pos0,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos1,f_targ,tout_targ,spec2_targ.pos1,spec1_targ.pos1,Pcoh.pos1] = Spk_LFPCoh(sig2_correct_pos1,sig1_correct_pos1,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos2,f_targ,tout_targ,spec2_targ.pos2,spec1_targ.pos2,Pcoh.pos2] = Spk_LFPCoh(sig2_correct_pos2,sig1_correct_pos2,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos3,f_targ,tout_targ,spec2_targ.pos3,spec1_targ.pos3,Pcoh.pos3] = Spk_LFPCoh(sig2_correct_pos3,sig1_correct_pos3,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos4,f_targ,tout_targ,spec2_targ.pos4,spec1_targ.pos4,Pcoh.pos4] = Spk_LFPCoh(sig2_correct_pos4,sig1_correct_pos4,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos5,f_targ,tout_targ,spec2_targ.pos5,spec1_targ.pos5,Pcoh.pos5] = Spk_LFPCoh(sig2_correct_pos5,sig1_correct_pos5,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos6,f_targ,tout_targ,spec2_targ.pos6,spec1_targ.pos6,Pcoh.pos6] = Spk_LFPCoh(sig2_correct_pos6,sig1_correct_pos6,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos7,f_targ,tout_targ,spec2_targ.pos7,spec1_targ.pos7,Pcoh.pos7] = Spk_LFPCoh(sig2_correct_pos7,sig1_correct_pos7,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.all,f_targ,tout_targ,spec2_targ.all,spec1_targ.all,Pcoh.all] = Spk_LFPCoh(sig2_correct_all,sig1_correct_all,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        
        
        %for equated trial lengths by screen location
        [coh_targ.pos0_eq,f_targ,tout_targ,spec2_targ.pos0_eq,spec1_targ.pos0_eq,Pcoh.pos0_eq] = Spk_LFPCoh(sig2_correct_pos0_eq,sig1_correct_pos0_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos1_eq,f_targ,tout_targ,spec2_targ.pos1_eq,spec1_targ.pos1_eq,Pcoh.pos1_eq] = Spk_LFPCoh(sig2_correct_pos1_eq,sig1_correct_pos1_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos2_eq,f_targ,tout_targ,spec2_targ.pos2_eq,spec1_targ.pos2_eq,Pcoh.pos2_eq] = Spk_LFPCoh(sig2_correct_pos2_eq,sig1_correct_pos2_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos3_eq,f_targ,tout_targ,spec2_targ.pos3_eq,spec1_targ.pos3_eq,Pcoh.pos3_eq] = Spk_LFPCoh(sig2_correct_pos3_eq,sig1_correct_pos3_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos4_eq,f_targ,tout_targ,spec2_targ.pos4_eq,spec1_targ.pos4_eq,Pcoh.pos4_eq] = Spk_LFPCoh(sig2_correct_pos4_eq,sig1_correct_pos4_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos5_eq,f_targ,tout_targ,spec2_targ.pos5_eq,spec1_targ.pos5_eq,Pcoh.pos5_eq] = Spk_LFPCoh(sig2_correct_pos5_eq,sig1_correct_pos5_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos6_eq,f_targ,tout_targ,spec2_targ.pos6_eq,spec1_targ.pos6_eq,Pcoh.pos6_eq] = Spk_LFPCoh(sig2_correct_pos6_eq,sig1_correct_pos6_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos7_eq,f_targ,tout_targ,spec2_targ.pos7_eq,spec1_targ.pos7_eq,Pcoh.pos7_eq] = Spk_LFPCoh(sig2_correct_pos7_eq,sig1_correct_pos7_eq,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        
        
        
        %both signals are spikes
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        [coh_targ.pos0,f_targ,tout_targ,spec1_targ.pos0,spec2_targ.pos0,Pcoh.pos0] = Spk_SpkCoh(sig1_correct_pos0,sig2_correct_pos0,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos1,f_targ,tout_targ,spec1_targ.pos1,spec2_targ.pos1,Pcoh.pos1] = Spk_SpkCoh(sig1_correct_pos1,sig2_correct_pos1,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos2,f_targ,tout_targ,spec1_targ.pos2,spec2_targ.pos2,Pcoh.pos2] = Spk_SpkCoh(sig1_correct_pos2,sig2_correct_pos2,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos3,f_targ,tout_targ,spec1_targ.pos3,spec2_targ.pos3,Pcoh.pos3] = Spk_SpkCoh(sig1_correct_pos3,sig2_correct_pos3,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos4,f_targ,tout_targ,spec1_targ.pos4,spec2_targ.pos4,Pcoh.pos4] = Spk_SpkCoh(sig1_correct_pos4,sig2_correct_pos4,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos5,f_targ,tout_targ,spec1_targ.pos5,spec2_targ.pos5,Pcoh.pos5] = Spk_SpkCoh(sig1_correct_pos5,sig2_correct_pos5,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos6,f_targ,tout_targ,spec1_targ.pos6,spec2_targ.pos6,Pcoh.pos6] = Spk_SpkCoh(sig1_correct_pos6,sig2_correct_pos6,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos7,f_targ,tout_targ,spec1_targ.pos7,spec2_targ.pos7,Pcoh.pos7] = Spk_SpkCoh(sig1_correct_pos7,sig2_correct_pos7,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.all,f_targ,tout_targ,spec1_targ.all,spec2_targ.all,Pcoh.all] = Spk_SpkCoh(sig1_correct_all,sig2_correct_all,tapers,[-500 2500],1000,.01,[0,200],0);
        
        %for equated trial lengths by screen location
        [coh_targ.pos0_eq,f_targ,tout_targ,spec1_targ.pos0_eq,spec2_targ.pos0_eq,Pcoh.pos0_eq] = Spk_SpkCoh(sig1_correct_pos0_eq,sig2_correct_pos0_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos1_eq,f_targ,tout_targ,spec1_targ.pos1_eq,spec2_targ.pos1_eq,Pcoh.pos1_eq] = Spk_SpkCoh(sig1_correct_pos1_eq,sig2_correct_pos1_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos2_eq,f_targ,tout_targ,spec1_targ.pos2_eq,spec2_targ.pos2_eq,Pcoh.pos2_eq] = Spk_SpkCoh(sig1_correct_pos2_eq,sig2_correct_pos2_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos3_eq,f_targ,tout_targ,spec1_targ.pos3_eq,spec2_targ.pos3_eq,Pcoh.pos3_eq] = Spk_SpkCoh(sig1_correct_pos3_eq,sig2_correct_pos3_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos4_eq,f_targ,tout_targ,spec1_targ.pos4_eq,spec2_targ.pos4_eq,Pcoh.pos4_eq] = Spk_SpkCoh(sig1_correct_pos4_eq,sig2_correct_pos4_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos5_eq,f_targ,tout_targ,spec1_targ.pos5_eq,spec2_targ.pos5_eq,Pcoh.pos5_eq] = Spk_SpkCoh(sig1_correct_pos5_eq,sig2_correct_pos5_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos6_eq,f_targ,tout_targ,spec1_targ.pos6_eq,spec2_targ.pos6_eq,Pcoh.pos6_eq] = Spk_SpkCoh(sig1_correct_pos6_eq,sig2_correct_pos6_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.pos7_eq,f_targ,tout_targ,spec1_targ.pos7_eq,spec2_targ.pos7_eq,Pcoh.pos7_eq] = Spk_SpkCoh(sig1_correct_pos7_eq,sig2_correct_pos7_eq,tapers,[-500 2500],1000,.01,[0,200],0);
        
    end
    
    
    
    
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
        
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        
        for j = 0:7
            switch j
                case 0
                    screenloc = 6;
                    cond = Pcoh.pos0;
                    num = n.pos0;
                case 1
                    screenloc = 3;
                    cond = Pcoh.pos1;
                    num = n.pos1; 
                case 2
                    screenloc = 2;
                    cond = Pcoh.pos2;
                    num = n.pos2;
                case 3
                    screenloc = 1;
                    cond = Pcoh.pos3;
                    num = n.pos3;
                case 4
                    screenloc = 4;
                    cond = Pcoh.pos4;
                    num = n.pos4;
                case 5
                    screenloc = 7;
                    cond = Pcoh.pos5;
                    num = n.pos5;
                case 6
                    screenloc = 8;
                    cond = Pcoh.pos6;
                    num = n.pos6;
                case 7
                    screenloc = 9;
                    cond = Pcoh.pos7;
                    num = n.pos7;
            end
            
            %find max and min coherence values based on screen locations;
            %exclude coherence plot collapsed on screen location
            maxCol = findMax(abs(Pcoh.pos0),abs(Pcoh.pos1),abs(Pcoh.pos2),abs(Pcoh.pos3),abs(Pcoh.pos4),abs(Pcoh.pos5),abs(Pcoh.pos6),abs(Pcoh.pos7));
            minCol = findMin(abs(Pcoh.pos0),abs(Pcoh.pos1),abs(Pcoh.pos2),abs(Pcoh.pos3),abs(Pcoh.pos4),abs(Pcoh.pos5),abs(Pcoh.pos6),abs(Pcoh.pos7));
            
            cond = baseline_correct(cond',[1 11])';
            
            s1 = subplot(3,3,screenloc);
            imagesc(tout_targ,f_targ,abs(cond'))
            axis xy
            xlim([-100 500])
            ylim([0 100])
            title(mat2str(num))
            set(gca,'clim',[minCol maxCol])
        end
        
        %finally, plot coherence collapsed on screen location
        
        cond = baseline_correct(Pcoh.all',[1 11])';
        subplot(3,3,5)
        imagesc(tout_targ,f_targ,abs(cond'))
        axis xy
        xlim([-100 500])
        ylim([0 100])
        colorbar
        set(gca,'clim',[minCol maxCol])
        title([name1 ' ' name2 ' n = ' mat2str(n.all)],'fontweight','bold','fontsize',10)
        
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/screenloc/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc_baseline_corrected.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_screenloc_baseline_corrected.jpg',q])
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
                    cond = Pcoh.pos0;
                    num = n.pos0;
                case 1
                    screenloc = 3;
                    cond = Pcoh.pos1;
                    num = n.pos1; 
                case 2
                    screenloc = 2;
                    cond = Pcoh.pos2;
                    num = n.pos2;
                case 3
                    screenloc = 1;
                    cond = Pcoh.pos3;
                    num = n.pos3;
                case 4
                    screenloc = 4;
                    cond = Pcoh.pos4;
                    num = n.pos4;
                case 5
                    screenloc = 7;
                    cond = Pcoh.pos5;
                    num = n.pos5;
                case 6
                    screenloc = 8;
                    cond = Pcoh.pos6;
                    num = n.pos6;
                case 7
                    screenloc = 9;
                    cond = Pcoh.pos7;
                    num = n.pos7;
            end
            
            %find max and min coherence values based on screen locations;
            %exclude coherence plot collapsed on screen location
            maxCol = findMax(abs(Pcoh.pos0),abs(Pcoh.pos1),abs(Pcoh.pos2),abs(Pcoh.pos3),abs(Pcoh.pos4),abs(Pcoh.pos5),abs(Pcoh.pos6),abs(Pcoh.pos7));
            minCol = findMin(abs(Pcoh.pos0),abs(Pcoh.pos1),abs(Pcoh.pos2),abs(Pcoh.pos3),abs(Pcoh.pos4),abs(Pcoh.pos5),abs(Pcoh.pos6),abs(Pcoh.pos7));
            
            %cond = baseline_correct(cond',[1 11])';
            
            s1 = subplot(3,3,screenloc);
            imagesc(tout_targ,f_targ,abs(cond'))
            axis xy
            xlim([-100 500])
            ylim([0 100])
            title(mat2str(num))
            set(gca,'clim',[minCol maxCol])
        end
        
        %finally, plot coherence collapsed on screen location
        
        %cond = baseline_correct(Pcoh.all',[1 11])';
        subplot(3,3,5)
        plot(0:7,tuning.sig1.fft)
        xlim([0 7])
        newax
        plot(0:7,tuning.sig2.fft,'r')
        xlim([0 7])
        set(gca,'xticklabel',[])
        title([name1 ' ' name2],'fontweight','bold','fontsize',10)
        
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/screenloc/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_screenloc.jpg',q])
        close(h)
        
        
        
        
        
        
        
          
        %=======================================================
        % FIGURE 2: coherence by screen loc, baseline corrected & equated
        % for # of observations by screen location
        % and includes FFT tuning curve in middle
        
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        
        for j = 0:7
            switch j
                case 0
                    screenloc = 6;
                    cond = Pcoh.pos0_eq;
                    num = n.eq;
                case 1
                    screenloc = 3;
                    cond = Pcoh.pos1_eq;
                    num = n.eq; 
                case 2
                    screenloc = 2;
                    cond = Pcoh.pos2_eq;
                    num = n.eq;
                case 3
                    screenloc = 1;
                    cond = Pcoh.pos3_eq;
                    num = n.eq;
                case 4
                    screenloc = 4;
                    cond = Pcoh.pos4_eq;
                    num = n.eq;
                case 5
                    screenloc = 7;
                    cond = Pcoh.pos5_eq;
                    num = n.eq;
                case 6
                    screenloc = 8;
                    cond = Pcoh.pos6_eq;
                    num = n.eq;
                case 7
                    screenloc = 9;
                    cond = Pcoh.pos7_eq;
                    num = n.eq;
            end
            
            %find max and min coherence values based on screen locations;
            %exclude coherence plot collapsed on screen location
            maxCol = findMax(abs(Pcoh.pos0_eq),abs(Pcoh.pos1_eq),abs(Pcoh.pos2_eq),abs(Pcoh.pos3_eq),abs(Pcoh.pos4_eq),abs(Pcoh.pos5_eq),abs(Pcoh.pos6_eq),abs(Pcoh.pos7_eq));
            minCol = findMin(abs(Pcoh.pos0_eq),abs(Pcoh.pos1_eq),abs(Pcoh.pos2_eq),abs(Pcoh.pos3_eq),abs(Pcoh.pos4_eq),abs(Pcoh.pos5_eq),abs(Pcoh.pos6_eq),abs(Pcoh.pos7_eq));
            
            %cond = baseline_correct(cond',[1 11])';
            
            s1 = subplot(3,3,screenloc);
            imagesc(tout_targ,f_targ,abs(cond'))
            axis xy
            xlim([-100 500])
            ylim([0 100])
            title(mat2str(num))
            set(gca,'clim',[minCol maxCol])
        end
        
        %finally, plot coherence collapsed on screen location
        
        %cond = baseline_correct(Pcoh.all',[1 11])';
        subplot(3,3,5)
        plot(0:7,tuning.sig1.fft)
        xlim([0 7])
        newax
        plot(0:7,tuning.sig2.fft,'r')
        xlim([0 7])
        set(gca,'xticklabel',[])
        legend('sig 1','sig 2')
        title([name1 ' ' name2],'fontweight','bold','fontsize',10)
        
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/screenloc/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_screenloc_baseline_corrected_equated.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_screenloc.jpg',q])
        close(h)
        
        
    end %if plotFlag == 1
    
    
    
    %=====================================================================
    if saveFlag == 1
        %    save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/screenloc/Matrices/' file '_' ...
            name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
            '_Coherence.mat'],'tuning','wf_sig1','wf_sig2','n', ...
            'coh_targ','spec1_targ','spec2_targ','Pcoh','tout_targ','f_targ','-mat')
    end
    
    
    
    
    %clean up variables that will change between comparisons for safety
    clear tuning tout_targ tout_resp f_targ f_resp n RTs color_limits ...
        correct cMed correct_fast correct_slow correct_ss2 correct_ss4 correct_ss8 ...
        errors eMed errors_fast errors_slow correct_contra correct_ipsi correct_Tin ...
        correct_Din minTrials RF AntiRF tempname stub newname chan1_hemi chan2_hemi ...
        name1 name2 sig* wf* coh* spec*
    
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes