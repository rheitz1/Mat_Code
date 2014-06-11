%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.
%
% In this version, removing influence of spikes on LFP by interpolating
function [] = pCOH_SAT_LFPLFP_alltrls_shuff(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

shuffFlag = 0;
saveFlag = 1;

ClusShuffOpts.nShuffs = 5000; %number of shuffles for between condition tests
ClusShuffOpts.ActPer = [-3000 800];

file_name

%also try to load MStim_ so we can tell if it is that kind of data set
load(file_name,sig1_name,sig2_name, ...
    'saccLoc','SAT_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_')



% RE-REFERENCE LFP TO AVERAGE OF ALL AVAILABLE LFPS
avRef_LFP

if reRef
    sig1 = eval([sig1_name '_reref']);
    sig2 = eval([sig2_name '_reref']);
else
    sig1 = eval(sig1_name);
    sig2 = eval(sig2_name);
end

sig1_bc = baseline_correct(sig1,[Target_(1,1)-100 Target_(1,1)]); %baseline correction for LFPs, for display purposes only.
sig2_bc = baseline_correct(sig2,[Target_(1,1)-100 Target_(1,1)]); 

tapers = PreGenTapers([.2 5]);

if Hemi.(sig1_name) == Hemi.(sig2_name);
    sameHemi = 1;
else
    sameHemi = 0;
end

RF1 = LFPtuning(sig1_bc);
RF2 = LFPtuning(sig2_bc);

RF_Overlap = intersect(RF1,RF2);

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

%do a subsample of ACCURATE trials to match to Fast for comparison purposes
if length(slow_all) > length(fast_all_withCleared)
    slow_subsamp = slow_all(randperm(length(fast_all_withCleared)));
    RT.slow_subsamp = nanmean(SRT(slow_subsamp,1));
    wf.LFP1.slow_subsamp = nanmean(sig1_bc(slow_subsamp,:));
    wf.LFP2.slow_subsamp = nanmean(sig2_bc(slow_subsamp,:));
end

RT.slow_all = nanmean(SRT(slow_all,1));
RT.med_all = nanmean(SRT(med_correct,1));
RT.fast_all_withCleared = nanmean(SRT(fast_all_withCleared,1));

%KEEP TRACK OF WAVEFORMS.  (NOT ACTUALLY USED IN ANALYSIS)
%==========================================================

wf.LFP1.slow_all = nanmean(sig1_bc(slow_all,:));
wf.LFP1.med_all = nanmean(sig1_bc(med_all,:));
wf.LFP1.fast_all_withCleared = nanmean(sig1_bc(fast_all_withCleared,:));


wf.LFP2.slow_all = nanmean(sig2_bc(slow_all,:));
wf.LFP2.med_all = nanmean(sig2_bc(med_all,:));
wf.LFP2.fast_all_withCleared = nanmean(sig2_bc(fast_all_withCleared,:));

%==========================================================

clear sig1_bc sig2_bc



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
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff,~,~] = LFP_LFPCoh(sig2(slow_vs_fast,:),sig1(slow_vs_fast,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,2,ClusShuffOpts);
%     clear alltr
%     ClusShuffOpts.TrType = [];
    
     %with shuffling (pad = 0) & vsBaseline test
%     ClusShuffOpts.TestType = 1;
%     [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.all] = Spk_LFPCoh(sig2(slow_vs_fast,:),sig1(slow_vs_fast,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
    
end


% SLOW TRIALS
    disp('SLOW')
    [coh.slow,f,tout,Sx.slow,Sy.slow,Pcoh.slow,PSx.slow,PSy.slow] = LFP_LFPCoh(sig2(slow_all,:),sig1(slow_all,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,2);
    [Zcoh.slow,f,tout,ZSx.slow,ZSy.slow,ZPcoh.slow,ZPSx.slow,ZPSy.slow] = LFP_LFPCoh(sig2(slow_all,:),sig1(slow_all,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,1);
    
    if length(slow_all) > length(fast_all_withCleared)
        [coh.slow_subsamp,f,tout,Sx.slow_subsamp,Sy.slow_subsamp,Pcoh.slow_subsamp,PSx.slow_subsamp,PSy.slow_subsamp] = LFP_LFPCoh(sig2(slow_subsamp,:),sig1(slow_subsamp,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,2);
        [Zcoh.slow_subsamp,f,tout,ZSx.slow_subsamp,ZSy.slow_subsamp,ZPcoh.slow_subsamp,ZPSx.slow_subsamp,ZPSy.slow_subsamp] = LFP_LFPCoh(sig2(slow_subsamp,:),sig1(slow_subsamp,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,1);
    end
try
    disp('MED')
    [coh.med,f,tout,Sx.med,Sy.med,Pcoh.med,PSx.med,PSy.med] = LFP_LFPCoh(sig2(med_all,:),sig1(med_all,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,2);
    [Zcoh.med,f,tout,ZSx.med,ZSy.med,ZPcoh.med,ZPSx.med,ZPSy.med] = LFP_LFPCoh(sig2(med_all,:),sig1(med_all,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,1);
        
catch
    disp('Failed to Calculate MED')
    coh.med(1:length(tout),1:length(f)) = NaN;
    Sx.med(1:length(tout),1:length(f)) = NaN;
    Sy.med(1:length(tout),1:length(f)) = NaN;
    Pcoh.med(1:length(tout),1:length(f)) = NaN;
    PSx.med(1:length(tout),1:length(f)) = NaN;
    PSy.med(1:length(tout),1:length(f)) = NaN;
end

disp('FAST')
[coh.fast,f,tout,Sx.fast,Sy.fast,Pcoh.fast,PSx.fast,PSy.fast] = LFP_LFPCoh(sig2(fast_all_withCleared,:),sig1(fast_all_withCleared,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,2);
[Zcoh.fast,f,tout,ZSx.fast,ZSy.fast,ZPcoh.fast,ZPSx.fast,ZPSy.fast] = LFP_LFPCoh(sig2(fast_all_withCleared,:),sig1(fast_all_withCleared,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,4,.05,0,2,1);



if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/alltrls/' file_name '_' ...
        sig1_name sig2_name '.mat'],'between_cond_shuff','coh','Zcoh','f','f_shuff','n','tout','Sx','ZSx','Sy','ZSy', ...
        'RT','Pcoh','ZPcoh','PSx','ZPSx','PSy','ZPSy','wf','sameHemi','RF_Overlap','reRef','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/SAT/alltrls/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh','Zcoh','f','n','tout','Sx','ZSx','Sy','ZSy', ...
        'RT','Pcoh','ZPcoh','PSx','ZPSx','PSy','ZPSy','wf','sameHemi','RF_Overlap','reRef','-mat')

 
% if shuffFlag == 1 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'between_cond_shuff','coh','Zcoh','f','f_shuff','n','tout','Sx','ZSx','Sy','ZSy', ...
%         'RT','Pcoh','ZPcoh','PSx','ZPSx','PSy','ZPSy','wf','sameHemi','RF_Overlap','reRef','-mat')
% elseif shuffFlag == 0 & saveFlag == 1
%     save(['~/desktop/m/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'coh','Zcoh','f','n','tout','Sx','ZSx','Sy','ZSy', ...
%         'RT','Pcoh','ZPcoh','PSx','ZPSx','PSy','ZPSy','wf','sameHemi','RF_Overlap','reRef','-mat')

end


