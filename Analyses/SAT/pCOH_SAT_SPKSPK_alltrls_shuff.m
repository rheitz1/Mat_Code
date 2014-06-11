%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.
%
% In this version, removing influence of spikes on LFP by interpolating
function [] = pCOH_SAT_SPKSPK_alltrls_shuff(file_name,sig1_name,sig2_name)

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
    'saccLoc','SAT_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_','FixTime_Jit_')


sig1 = eval(sig1_name);
sig2 = eval(sig2_name);


%tapers = PreGenTapers([.2 5]);
%tapers = PreGenTapers([.1 10]);
tapers = hann(200)';


getTrials_SAT

n.slow_all = length(slow_all);
n.fast_all_withCleared = length(fast_all_withCleared);


RT.slow_all = nanmean(SRT(slow_all,1));
RT.fast_all_withCleared = nanmean(SRT(fast_all_withCleared,1));


%KEEP TRACK OF WAVEFORMS.  (NOT ACTUALLY USED IN ANALYSIS)
%==========================================================


wf_targ.SPK1.slow_all = spikedensityfunct(sig1,Target_(:,1),[-Target_(1,1) 2500],slow_all,TrialStart_);
wf_targ.SPK2.slow_all = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],slow_all,TrialStart_);

wf_resp.SPK1.slow_all = spikedensityfunct(sig1,Target_(:,1)+SRT(:,1),[-500 500],slow_all,TrialStart_);
wf_resp.SPK2.slow_all = spikedensityfunct(sig2,Target_(:,1)+SRT(:,1),[-500 500],slow_all,TrialStart_);

wf_fix.SPK1.slow_all = spikedensityfunct(sig1,Target_(:,1)-FixTime_Jit_,[-200 3000],slow_all,TrialStart_);
wf_fix.SPK2.slow_all = spikedensityfunct(sig2,Target_(:,1)-FixTime_Jit_,[-200 3000],slow_all,TrialStart_);

wf_targ.SPK1.fast_all = spikedensityfunct(sig1,Target_(:,1),[-Target_(1,1) 2500],fast_all_withCleared,TrialStart_);
wf_targ.SPK2.fast_all = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],fast_all_withCleared,TrialStart_);

wf_resp.SPK1.fast_all = spikedensityfunct(sig1,Target_(:,1)+SRT(:,1),[-500 500],fast_all_withCleared,TrialStart_);
wf_resp.SPK2.fast_all = spikedensityfunct(sig2,Target_(:,1)+SRT(:,1),[-500 500],fast_all_withCleared,TrialStart_);

wf_fix.SPK1.fast_all = spikedensityfunct(sig1,Target_(:,1)-FixTime_Jit_,[-200 3000],fast_all_withCleared,TrialStart_);
wf_fix.SPK2.fast_all = spikedensityfunct(sig2,Target_(:,1)-FixTime_Jit_,[-200 3000],fast_all_withCleared,TrialStart_);


% Test for statistically significant baseline effect in window 300:0 before target onset.
SDF1 = sSDF(sig1,Target_(:,1),[-1000 400]);
SDF2 = sSDF(sig2,Target_(:,1),[-1000 400]);

base1_slow = nanmean(SDF1(slow_all,600:1000),2);
base1_fast = nanmean(SDF1(fast_all_withCleared,600:1000),2);

base2_slow = nanmean(SDF2(slow_all,600:1000),2);
base2_fast = nanmean(SDF2(fast_all_withCleared,600:1000),2);

[issig1.h] = ttest2(base1_slow,base1_fast);
[issig2.h] = ttest2(base2_slow,base2_fast);

if issig1.h == 1 & nanmean(base1_slow) < nanmean(base1_fast)
    issig1.dir = 1;
elseif issig1.h == 1 & nanmean(base1_slow) > nanmean(base1_fast)
    issig1.dir = -1;
elseif issig1.h == 0
    issig1.dir = 0;
end

if issig2.h == 1 & nanmean(base2_slow) < nanmean(base2_fast)
    issig2.dir = 1;
elseif issig2.h == 1 & nanmean(base2_slow) > nanmean(base2_fast)
    issig2.dir = -1;
elseif issig2.h == 0
    issig2.dir = 0;
end

%==========================================================


%fix Spike channel; change 0's to NaN and alter times.
%NOTE: important to do this HERE, and not before, so that the saved waveforms will be correct.
sig1(sig1 == 0) = NaN;
sig2(sig2 == 0) = NaN;

Spike1_targ = sig1 - Target_(1,1);
Spike1_resp = sig1 - repmat((Target_(1,1) + SRT(:,1)),1,size(sig1,2));
Spike1_fix = sig1 - repmat(Target_(1,1) - FixTime_Jit_,1,size(sig1,2));

Spike2_targ = sig2 - Target_(1,1);
Spike2_resp = sig2 - repmat((Target_(1,1) + SRT(:,1)),1,size(sig2,2));
Spike2_fix = sig2 - repmat(Target_(1,1) - FixTime_Jit_,1,size(sig2,2));


Plot_Time_targ = [-Target_(1,1) 2500];
Plot_Time_resp = [-500 500];
Plot_Time_fix = [-200 3000];



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
disp('SLOW')

[coh_targ.slow,f,tout_targ,Sx_targ.slow,Sy_targ.slow,Pcoh_targ.slow,PSx_targ.slow,PSy_targ.slow] = Spk_SpkCoh(Spike1_targ(slow_all,:),Spike2_targ(slow_all,:),tapers,[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_resp.slow,f,tout_resp,Sx_resp.slow,Sy_resp.slow,Pcoh_resp.slow,PSx_resp.slow,PSy_resp.slow] = Spk_SpkCoh(Spike1_resp(slow_all,:),Spike2_resp(slow_all,:),tapers,[Plot_Time_resp(1) Plot_Time_resp(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_fix.slow,f,tout_fix,Sx_fix.slow,Sy_fix.slow,Pcoh_fix.slow,PSx_fix.slow,PSy_fix.slow] = Spk_SpkCoh(Spike1_fix(slow_all,:),Spike2_fix(slow_all,:),tapers,[Plot_Time_fix(1) Plot_Time_fix(2)], 1000, .01, [0 100],0,4,.05,0,2,2);



disp('FAST')
[coh_targ.fast,f,tout_targ,Sx_targ.fast,Sy_targ.fast,Pcoh_targ.fast,PSx_targ.fast,PSy_targ.fast] = Spk_SpkCoh(Spike1_targ(fast_all_withCleared,:),Spike2_targ(fast_all_withCleared,:),tapers,[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_resp.fast,f,tout_resp,Sx_resp.fast,Sy_resp.fast,Pcoh_resp.fast,PSx_resp.fast,PSy_resp.fast] = Spk_SpkCoh(Spike1_resp(fast_all_withCleared,:),Spike2_resp(fast_all_withCleared,:),tapers,[Plot_Time_resp(1) Plot_Time_resp(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_fix.fast,f,tout_fix,Sx_fix.fast,Sy_fix.fast,Pcoh_fix.fast,PSx_fix.fast,PSy_fix.fast] = Spk_SpkCoh(Spike1_fix(fast_all_withCleared,:),Spike2_fix(fast_all_withCleared,:),tapers,[Plot_Time_fix(1) Plot_Time_fix(2)], 1000, .01, [0 100],0,4,.05,0,2,2);

if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/alltrls/' file_name '_' ...
        sig1_name sig2_name '.mat'],'between_cond_shuff','coh_targ','coh_resp','coh_fix', ...
        'f_shuff','n','tout_targ','tout_resp','tout_fix','Sx_targ','Sx_resp','Sx_fix','Sy_targ','Sy_resp','Sy_fix', ...
        'RT','Pcoh_targ','Pcoh_resp','Pcoh_fix','PSx_targ','PSx_resp','PSx_fix','PSy_targ','PSy_resp','PSy_fix','wf_targ','wf_fix','wf_resp','issig*', ...
        'Plot_Time_targ','Plot_Time_resp','Plot_Time_fix','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/alltrls/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh_targ','coh_resp','coh_fix','f','n','tout_targ','tout_resp','tout_fix','Sx_targ','Sx_resp','Sx_fix','Sy_targ','Sy_resp','Sy_fix', ...
        'RT','Pcoh_targ','Pcoh_resp','Pcoh_fix','PSx_targ','PSx_resp','PSx_fix','PSy_targ','PSy_resp','PSy_fix','wf_targ','wf_resp','wf_fix','issig*', ...
        'Plot_Time_targ','Plot_Time_resp','Plot_Time_fix','-mat')

% if shuffFlag == 1 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'within_cond_shuff','between_cond_shuff','coh','f','f_shuff','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','TDT','issig*','-mat')
% elseif shuffFlag == 0 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'coh','f','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','issig*','-mat')
end


