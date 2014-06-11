%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.
%
% In this version, removing influence of spikes on LFP by interpolating
function [] = pCOH_SAT_SPKLFP_Tune_NeurRF_isect_vamp_overlap_shuff(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

shuffFlag = 1;
saveFlag = 1;

ClusShuffOpts.nShuffs = 5000; %number of shuffles for between condition tests
ClusShuffOpts.ActPer = [0 800];

file_name


%check to see if AD and DSP are recorded on the same electrode.  If so, skip.
if (str2num(sig1_name(3:4)) == str2num(sig2_name(4:5)));
    disp('Same Electrodes detected. Moving on')
    return
end


%also try to load MStim_ so we can tell if it is that kind of data set
load(file_name,sig1_name,sig2_name, ...
    'saccLoc','SAT_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_')


sig1 = eval(sig1_name);
sig2 = eval(sig2_name);
sig1_bc = baseline_correct(sig1,[400 500]); %baseline correction for LFPs, for display purposes only.


tapers = PreGenTapers([.2 5]);

%use selectivity of LFP to determine its RF
[RF1 ~] = LFPtuning(sig1);

RF2 = RFs.(sig2_name);

RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);

if isempty(RF)
    error('No RF Intersection')
end


inRF = find(ismember(Target_(:,2),RF));
outRF = find(ismember(Target_(:,2),antiRF));

% inRF_err = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
% outRF_err = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));


slow_correct_made_dead = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
med_correct = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));


in.slow_correct_made_dead = intersect(inRF,slow_correct_made_dead);
out.slow_correct_made_dead = intersect(outRF,slow_correct_made_dead);

in.fast_correct_made_dead = intersect(inRF,fast_correct_made_dead_withCleared);
out.fast_correct_made_dead = intersect(outRF,fast_correct_made_dead_withCleared);

in.med_correct = intersect(inRF,med_correct);
out.med_correct = intersect(outRF,med_correct);


in.all = [in.slow_correct_made_dead ; in.med_correct ; in.fast_correct_made_dead];
out.all = [out.slow_correct_made_dead ; out.med_correct ; out.fast_correct_made_dead];

n.in.slow_correct_made_dead = length(in.slow_correct_made_dead);
n.out.slow_correct_made_dead = length(out.slow_correct_made_dead);
n.in.med_correct = length(in.med_correct);
n.out.med_correct = length(out.med_correct);
n.in.fast_correct_made_dead = length(in.fast_correct_made_dead);
n.out.fast_correct_made_dead = length(out.fast_correct_made_dead);

RT.slow_correct_made_dead = nanmean(SRT(slow_correct_made_dead,1));
RT.med_correct = nanmean(SRT(med_correct,1));
RT.fast_correct_made_dead = nanmean(SRT(fast_correct_made_dead_withCleared,1));

%GET TDT's
%====================
TDT.AD.slow_correct_made_dead = getTDT_AD(sig1_bc,in.slow_correct_made_dead,out.slow_correct_made_dead);
TDT.SPK.slow_correct_made_dead = getTDT_SP(sig2,in.slow_correct_made_dead,out.slow_correct_made_dead);

TDT.AD.med_correct = getTDT_AD(sig1_bc,in.med_correct,out.med_correct);
TDT.SPK.med_correct = getTDT_SP(sig2,in.med_correct,out.med_correct);

TDT.AD.fast_correct_made_dead = getTDT_AD(sig1_bc,in.fast_correct_made_dead,out.fast_correct_made_dead);
TDT.SPK.fast_correct_made_dead = getTDT_SP(sig2,in.fast_correct_made_dead,out.fast_correct_made_dead);



%KEEP TRACK OF WAVEFORMS.  (NOT ACTUALLY USED IN ANALYSIS)
%==========================================================
wf.sig1_bc.in.slow_correct_made_dead = nanmean(sig1_bc(in.slow_correct_made_dead,:));
wf.sig1_bc.out.slow_correct_made_dead = nanmean(sig1_bc(out.slow_correct_made_dead,:));

wf.sig1_bc.in.med_correct = nanmean(sig1_bc(in.med_correct,:));
wf.sig1_bc.out.med_correct = nanmean(sig1_bc(out.med_correct,:));

wf.sig1_bc.in.fast_correct_made_dead = nanmean(sig1_bc(in.fast_correct_made_dead,:));
wf.sig1_bc.out.fast_correct_made_dead = nanmean(sig1_bc(out.fast_correct_made_dead,:));


wf.sig1.in.slow_correct_made_dead = nanmean(sig1(in.slow_correct_made_dead,:));
wf.sig1.out.slow_correct_made_dead = nanmean(sig1(out.slow_correct_made_dead,:));

wf.sig1.in.med_correct = nanmean(sig1(in.med_correct,:));
wf.sig1.out.med_correct = nanmean(sig1(out.med_correct,:));

wf.sig1.in.fast_correct_made_dead = nanmean(sig1(in.fast_correct_made_dead,:));
wf.sig1.out.fast_correct_made_dead = nanmean(sig1(out.fast_correct_made_dead,:));


wf.sig2.in.slow_correct_made_dead = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow_correct_made_dead,TrialStart_);
wf.sig2.out.slow_correct_made_dead = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow_correct_made_dead,TrialStart_);

wf.sig2.in.med_correct = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.med_correct,TrialStart_);
wf.sig2.out.med_correct = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.med_correct,TrialStart_);

wf.sig2.in.fast_correct_made_dead = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast_correct_made_dead,TrialStart_);
wf.sig2.out.fast_correct_made_dead = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast_correct_made_dead,TrialStart_);


%==========================================================

clear sig1_bc

%fix Spike channel; change 0's to NaN and alter times.
%NOTE: important to do this HERE, and not before, so that the saved waveforms will be correct.
sig2(sig2 == 0) = NaN;
sig2 = sig2 - 500;

%now invert LFP so phase plots are correct
sig1 = sig1 * -1;




% COHERENCE CALCULATIONS AND SHUFFLE TESTS
%=========================================
disp('Entering Coherence Calculations and shuffle tests')
%=========================================



% SHUFFLE TESTS, Tin vs Din, all trials
if shuffFlag == 1
    alltr = [in.all;out.all];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.all)) = 1;
    ClusShuffOpts.TrType(length(in.all)+1:length(in.all)+length(out.all)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.all,~,~] = Spk_LFPCoh(sig2(alltr,:),sig1(alltr,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.all] = Spk_LFPCoh(sig2(in.all,:),sig1(in.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
    %[~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.all] = Spk_LFPCoh(sig2(out.all,:),sig1(out.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
end


% SLOW TRIALS
    disp('SLOW')
    [coh.in.slow,f,tout,Sx.in.slow,Sy.in.slow,Pcoh.in.slow,PSx.in.slow,PSy.in.slow] = Spk_LFPCoh(sig2(in.slow_correct_made_dead,:),sig1(in.slow_correct_made_dead,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
    [coh.out.slow,f,tout,Sx.out.slow,Sy.out.slow,Pcoh.out.slow,PSx.out.slow,PSy.out.slow] = Spk_LFPCoh(sig2(out.slow_correct_made_dead,:),sig1(out.slow_correct_made_dead,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
    
try
    disp('MED')
    [coh.in.med,f,tout,Sx.in.med,Sy.in.med,Pcoh.in.med,PSx.in.med,PSy.in.med] = Spk_LFPCoh(sig2(in.med_correct,:),sig1(in.med_correct,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
    [coh.out.med,f,tout,Sx.out.med,Sy.out.med,Pcoh.out.med,PSx.out.med,PSy.out.med] = Spk_LFPCoh(sig2(out.med_correct,:),sig1(out.med_correct,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
    
catch
    disp('Failed to Calculate MED')
    coh.in.med(1:length(tout),1:length(f)) = NaN;
    Sx.in.med(1:length(tout),1:length(f)) = NaN;
    Sy.in.med(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.med(1:length(tout),1:length(f)) = NaN;
    PSx.in.med(1:length(tout),1:length(f)) = NaN;
    PSy.in.med(1:length(tout),1:length(f)) = NaN;
    
    coh.out.med(1:length(tout),1:length(f)) = NaN;
    Sx.out.med(1:length(tout),1:length(f)) = NaN;
    Sy.out.med(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.med(1:length(tout),1:length(f)) = NaN;
    PSx.out.med(1:length(tout),1:length(f)) = NaN;
    PSy.out.med(1:length(tout),1:length(f)) = NaN;
    
end

disp('FAST')
[coh.in.fast,f,tout,Sx.in.fast,Sy.in.fast,Pcoh.in.fast,PSx.in.fast,PSy.in.fast] = Spk_LFPCoh(sig2(in.fast_correct_made_dead,:),sig1(in.fast_correct_made_dead,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.fast,f,tout,Sx.out.fast,Sy.out.fast,Pcoh.out.fast,PSx.out.fast,PSy.out.fast] = Spk_LFPCoh(sig2(out.fast_correct_made_dead,:),sig1(out.fast_correct_made_dead,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);




if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'within_cond_shuff','between_cond_shuff','coh','f','f_shuff','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh','f','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','wf','TDT','-mat')

% if shuffFlag == 1 & saveFlag == 1
%     save(['~/desktop/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'within_cond_shuff','between_cond_shuff','coh','f','f_shuff','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
% elseif shuffFlag == 0 & saveFlag == 1
%     save(['//scratch/heitzrp/Output/Coherence/Uber_Tune_NeuronRF_intersection_shuff/overlap/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'coh','f','f_shuff','n','tout','Sx','Sy', ...
%         'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
end


