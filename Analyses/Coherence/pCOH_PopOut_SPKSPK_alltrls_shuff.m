%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.
%
% In this version, removing influence of spikes on LFP by interpolating
function [] = pCOH_PopOut_SPKSPK_alltrls_shuff(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

shuffFlag = 0;
saveFlag = 1;

ClusShuffOpts.nShuffs = 5000; %number of shuffles for between condition tests
ClusShuffOpts.ActPer = [-1100 -100];

file_name


load(file_name,sig1_name,sig2_name, ...
    'Target_','newfile','Correct_','TrialStart_')


sig1 = eval(sig1_name);
sig2 = eval(sig2_name);


%tapers = PreGenTapers([.2 5]);
%tapers = PreGenTapers([.1 10]);
tapers = hann(200)';


crt = find(Correct_(:,2) == 1);
err = find(Correct_(:,2) == 0);


%KEEP TRACK OF WAVEFORMS.  (NOT ACTUALLY USED IN ANALYSIS)
%==========================================================


wf_targ.SPK1.all = spikedensityfunct(sig1,Target_(:,1),[-Target_(1,1) 2500],1:size(sig1,1),TrialStart_);
wf_targ.SPK2.all = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],1:size(sig2,1),TrialStart_);

wf_targ.SPK1.correct = spikedensityfunct(sig1,Target_(:,1),[-Target_(1,1) 2500],crt,TrialStart_);
wf_targ.SPK2.correct = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],crt,TrialStart_);

wf_targ.SPK1.errors = spikedensityfunct(sig1,Target_(:,1),[-Target_(1,1) 2500],err,TrialStart_);
wf_targ.SPK2.errors = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],err,TrialStart_);

% Test for statistically significant baseline effect in window 300:0 before target onset.
SDF1 = sSDF(sig1,Target_(:,1),[-1000 400]);
SDF2 = sSDF(sig2,Target_(:,1),[-1000 400]);

%==========================================================


%fix Spike channel; change 0's to NaN and alter times.
%NOTE: important to do this HERE, and not before, so that the saved waveforms will be correct.
sig1(sig1 == 0) = NaN;
sig2(sig2 == 0) = NaN;

Spike1_targ = sig1 - Target_(1,1);
Spike2_targ = sig2 - Target_(1,1);
Plot_Time_targ = [-Target_(1,1) 2500];




% COHERENCE CALCULATIONS AND SHUFFLE TESTS
%=========================================
disp('Entering Coherence Calculations and shuffle tests')
%=========================================



% SHUFFLE TESTS, Tin vs Din, all trials
if shuffFlag == 1
    slow_vs_fast = [slow_all ; fast_all_withCleared];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(slow_all)) = 1;
    ClusShuffOpts.TrType(length(slow_all)+1:length(slow_all)+length(fast_all_withCleared)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff,~,~] = Spk_SpkCoh(sig1(slow_vs_fast,:),sig2(slow_vs_fast,:),tapers,[-Target_(1,1) 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    
%     clear alltr
%     ClusShuffOpts.TrType = [];
    
     %with shuffling (pad = 0) & vsBaseline test
%     ClusShuffOpts.TestType = 1;
%     [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.all] = Spk_LFPCoh(sig2(slow_vs_fast,:),sig1(slow_vs_fast,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
    
end

% NOTE: for Spike - LFP coherence, T0 and BN(1) must be identical due to the way the code is written
% SLOW TRIALS
disp('Calculating Coherence')

[coh_targ.all,f,tout_targ,Sx_targ.all,Sy_targ.all,Pcoh_targ.all,PSx_targ.all,PSy_targ.all] = Spk_SpkCoh(Spike1_targ(1:size(sig1,1),:),Spike2_targ(1:size(sig2,1),:),tapers,[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_targ.correct,f,tout_targ,Sx_targ.correct,Sy_targ.correct,Pcoh_targ.correct,PSx_targ.correct,PSy_targ.correct] = Spk_SpkCoh(Spike1_targ(crt,:),Spike2_targ(crt,:),tapers,[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_targ.errors,f,tout_targ,Sx_targ.errors,Sy_targ.errors,Pcoh_targ.errors,PSx_targ.errors,PSy_targ.errors] = Spk_SpkCoh(Spike1_targ(err,:),Spike2_targ(err,:),tapers,[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);

if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/PopOut/alltrls/' file_name '_' ...
        sig1_name sig2_name '.mat'],'between_cond_shuff','coh_targ', ...
        'f_shuff','tout_targ','Sx_targ','Sy_targ', ...
        'Pcoh_targ','PSx_targ','PSy_targ','wf_targ', ...
        'Plot_Time_targ','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/PopOut/alltrls/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh_targ','f','tout_targ','Sx_targ','Sy_targ', ...
        'Pcoh_targ','PSx_targ','PSy_targ','wf_targ', ...
        'Plot_Time_targ','-mat')

% if shuffFlag == 1 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'within_cond_shuff','between_cond_shuff','coh','f','f_shuff','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','TDT','issig*','-mat')
% elseif shuffFlag == 0 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'coh','f','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','issig*','-mat')
end


