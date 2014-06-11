%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.
%
% In this version, removing influence of spikes on LFP by interpolating
function [] = pCOH_SAT_SPKLFP_alltrls_shuff(file_name,ADname,SPKnam)

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


%check to see if AD and DSP are recorded on the same electrode.  If so, skip.

%RPH 5/19/13 Commenting out because this does not work with new file nameing convention. Consider
%updating.

% if (str2num(sig1_name(3:4)) == str2num(sig2_name(4:5)));
%     disp('Same Electrodes detected. Moving on')
%     return
% end


%also try to load MStim_ so we can tell if it is that kind of data set
load(file_name,ADname,SPKnam, ...
    'saccLoc','SAT_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_','FixTime_Jit_')


sig1 = eval(ADname);
sig2 = eval(SPKnam);
sig1_bc = baseline_correct(sig1,[Target_(1,1)-100 Target_(1,1)]); %baseline correction for LFPs, for display purposes only.


%tapers = PreGenTapers([.2 5]);
%tapers = PreGenTapers([.1 10]);
tapers = hann(200)';


% %use selectivity of LFP to determine its RF
% [RF1 ~] = LFPtuning(sig1);
% 
% RF2 = RFs.(sig2_name);
% 
% RF = intersect(RF1,RF2);
% antiRF = mod((RF+4),8);
% 
% if isempty(RF)
%     error('No RF Intersection')
% end


% inRF = find(ismember(Target_(:,2),RF));
% outRF = find(ismember(Target_(:,2),antiRF));

% inRF_err = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
% outRF_err = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));


getTrials_SAT

n.slow_all = length(slow_all);
n.med_all = length(med_all);
n.fast_all_withCleared = length(fast_all_withCleared);
% n.out.fast_correct_made_dead = length(out.fast_correct_made_dead);

RT.slow_all = nanmean(SRT(slow_all,1));
RT.med_all = nanmean(SRT(med_all,1));
RT.fast_all_withCleared = nanmean(SRT(fast_all_withCleared,1));


%KEEP TRACK OF WAVEFORMS.  (NOT ACTUALLY USED IN ANALYSIS)
%==========================================================
sig1_resp = response_align(sig1,SRT(:,1),[-500 500]);
sig1_resp = baseline_correct(sig1_resp,[1 50]);

sig1_fix = fix_align(sig1,FixTime_Jit_,[-200 3000]);
sig1_fix = baseline_correct(sig1_fix,[1 50]);



wf_targ.LFP.slow_all = nanmean(sig1_bc(slow_all,:));
wf_targ.LFP.fast_all = nanmean(sig1_bc(fast_all_withCleared,:));

wf_targ.SPK.slow_all = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],slow_all,TrialStart_);
wf_targ.SPK.fast_all = spikedensityfunct(sig2,Target_(:,1),[-Target_(1,1) 2500],fast_all_withCleared,TrialStart_);

wf_resp.LFP.slow_all = nanmean(sig1_resp(slow_all,:));
wf_resp.LFP.fast_all = nanmean(sig1_resp(fast_all_withCleared,:));

wf_resp.SPK.slow_all = spikedensityfunct(sig2,Target_(:,1)+SRT(:,1),[-500 500],slow_all,TrialStart_);
wf_resp.SPK.fast_all = spikedensityfunct(sig2,Target_(:,1)+SRT(:,1),[-500 500],fast_all_withCleared,TrialStart_);

wf_fix.LFP.slow_all = nanmean(sig1_fix(slow_all,:));
wf_fix.LFP.fast_all = nanmean(sig1_fix(fast_all_withCleared,:));

wf_fix.SPK.slow_all = spikedensityfunct(sig2,Target_(:,1)-FixTime_Jit_,[-200 3000],slow_all,TrialStart_);
wf_fix.SPK.fast_all = spikedensityfunct(sig2,Target_(:,1)-FixTime_Jit_,[-200 3000],fast_all_withCleared,TrialStart_);

% Test for statistically significant baseline effect in window 300:0 before target onset.
SDF = sSDF(sig2,Target_(:,1),[-1000 400]);

base_slow = nanmean(SDF(slow_all,600:1000),2);
base_fast = nanmean(SDF(fast_all_withCleared,600:1000),2);

[issig.h] = ttest2(base_slow,base_fast);

if issig.h == 1 & nanmean(base_slow) < nanmean(base_fast)
    issig.dir = 1;
elseif issig.h == 1 & nanmean(base_slow) > nanmean(base_fast)
    issig.dir = -1;
elseif issig.h == 0
    issig.dir = 0;
end

%==========================================================

clear sig1_bc

%fix Spike channel; change 0's to NaN and alter times.
%NOTE: important to do this HERE, and not before, so that the saved waveforms will be correct.
sig2(sig2 == 0) = NaN;

Spike_targ = sig2 - Target_(1,1);
Spike_resp = sig2 - repmat((Target_(1,1) + SRT(:,1)),1,size(sig2,2));
Spike_fix = sig2 - repmat(Target_(1,1) - FixTime_Jit_,1,size(sig2,2));

%now invert LFP so phase plots are correct
sig1 = sig1 * -1;


Plot_Time_targ = [-Target_(1,1) 2500];
Plot_Time_resp = [-500 500];
Plot_Time_fix = [-700 3000];


LFP_targ = sig1;
LFP_resp = response_align(sig1,SRT,[Plot_Time_resp(1) Plot_Time_resp(2)]);
LFP_fix = fix_align(sig1,FixTime_Jit_,[Plot_Time_fix(1) Plot_Time_fix(2)]);

remove_targ = find(any(isnan(LFP_targ),2));
remove_resp = find(any(isnan(LFP_resp),2));
remove_fix = find(any(isnan(LFP_fix),2));

remove = unique([remove_targ ; remove_resp ; remove_fix]);

[~,ix] = intersect(slow_all,remove);
slow_all(ix) = [];

[~,ix] = intersect(fast_all_withCleared,remove);
fast_all_withCleared(ix) = [];




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
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff,~,~] = Spk_LFPCoh(sig2(slow_vs_fast,:),sig1(slow_vs_fast,:),tapers,-Target_(1,1),[-Target_(1,1) 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
%     clear alltr
%     ClusShuffOpts.TrType = [];
    
     %with shuffling (pad = 0) & vsBaseline test
%     ClusShuffOpts.TestType = 1;
%     [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.all] = Spk_LFPCoh(sig2(slow_vs_fast,:),sig1(slow_vs_fast,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
    
end


% SLOW TRIALS
disp('SLOW')
[coh_targ.slow,f,tout_targ,Sx_targ.slow,Sy_targ.slow,Pcoh_targ.slow,PSx_targ.slow,PSy_targ.slow] = Spk_LFPCoh(Spike_targ(slow_all,:),LFP_targ(slow_all,:),tapers,Plot_Time_targ(1),[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_resp.slow,f,tout_resp,Sx_resp.slow,Sy_resp.slow,Pcoh_resp.slow,PSx_resp.slow,PSy_resp.slow] = Spk_LFPCoh(Spike_resp(slow_all,:),LFP_resp(slow_all,:),tapers,Plot_Time_resp(1),[Plot_Time_resp(1) Plot_Time_resp(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_fix.slow,f,tout_fix,Sx_fix.slow,Sy_fix.slow,Pcoh_fix.slow,PSx_fix.slow,PSy_fix.slow] = Spk_LFPCoh(Spike_fix(slow_all,:),LFP_fix(slow_all,:),tapers,Plot_Time_fix(1),[Plot_Time_fix(1) Plot_Time_fix(2)], 1000, .01, [0 100],0,4,.05,0,2,2);


disp('FAST')
[coh_targ.fast,f,tout_targ,Sx_targ.fast,Sy_targ.fast,Pcoh_targ.fast,PSx_targ.fast,PSy_targ.fast] = Spk_LFPCoh(Spike_targ(fast_all_withCleared,:),LFP_targ(fast_all_withCleared,:),tapers,Plot_Time_targ(1),[Plot_Time_targ(1) Plot_Time_targ(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_resp.fast,f,tout_resp,Sx_resp.fast,Sy_resp.fast,Pcoh_resp.fast,PSx_resp.fast,PSy_resp.fast] = Spk_LFPCoh(Spike_resp(fast_all_withCleared,:),LFP_resp(fast_all_withCleared,:),tapers,Plot_Time_resp(1),[Plot_Time_resp(1) Plot_Time_resp(2)], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh_fix.fast,f,tout_fix,Sx_fix.fast,Sy_fix.fast,Pcoh_fix.fast,PSx_fix.fast,PSy_fix.fast] = Spk_LFPCoh(Spike_fix(fast_all_withCleared,:),LFP_fix(fast_all_withCleared,:),tapers,Plot_Time_fix(1),[Plot_Time_fix(1) Plot_Time_fix(2)], 1000, .01, [0 100],0,4,.05,0,2,2);

if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/alltrls/' file_name '_' ...
        ADname SPKnam '.mat'],'between_cond_shuff','coh_targ','coh_resp','coh_fix', ...
        'f_shuff','n','tout_targ','tout_resp','tout_fix','Sx_targ','Sx_resp','Sx_fix','Sy_targ','Sy_resp','Sy_fix', ...
        'RT','Pcoh_targ','Pcoh_resp','Pcoh_fix','PSx_targ','PSx_resp','PSx_fix','PSy_targ','PSy_resp','PSy_fix','wf_targ','wf_resp','wf_fix','issig', ...
        'Plot_Time_targ','Plot_Time_resp','Plot_Time_fix','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/alltrls/' file_name '_' ...
        ADname SPKnam '.mat'],'coh_targ','coh_resp','coh_fix','f','n','tout_targ','tout_resp','tout_fix','Sx_targ','Sx_resp','Sx_fix','Sy_targ','Sy_resp','Sy_fix', ...
        'RT','Pcoh_targ','Pcoh_resp','Pcoh_fix','PSx_targ','PSx_resp','PSx_fix','PSy_targ','PSy_resp','PSy_fix','wf_targ','wf_resp','wf_fix','issig', ...
        'Plot_Time_targ','Plot_Time_resp','Plot_Time_fix','-mat')

% if shuffFlag == 1 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'within_cond_shuff','between_cond_shuff','coh','f','f_shuff','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','TDT','issig','-mat')
% elseif shuffFlag == 0 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'coh','f','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','issig','-mat')
end


