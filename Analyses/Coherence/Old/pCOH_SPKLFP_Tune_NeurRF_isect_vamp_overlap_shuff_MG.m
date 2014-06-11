%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.

function [] = pCOH_SPKLFP_Tune_NeurRF_isect_vamp_overlap_shuff_MG(file_name_MG,file_name_SRCH,sig1_name,sig2_name)

% path(path,'//scratch/heitzrp/')
% path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;

ClusShuffOpts.nShuffs = 5000; %number of shuffles for between condition tests

ClusShuffOpts.ActPer = [0 800];



nReps = 100; %number of times to subsample correct trials for comparison with error trials

file_name_MG

%first get LFP tuning from AD channel from Search data set
load(file_name_SRCH,sig1_name,'Correct_','Target_','SRT')

RF1 = LFPtuning(eval(sig1_name));
clear Correct_ Target_ SRT

%now load MG data set
load(file_name_MG,sig1_name,sig2_name, ...
    'EyeX_','EyeY_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_')


sig1 = eval(sig1_name);
sig2 = eval(sig2_name);


tapers = PreGenTapers([.2 5]);

%Unit RF should be the same between MG and SRCH
RF2 = RFs.(sig2_name);

RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);

%now invert LFP so phase plots are correct
sig1 = sig1 * -1;

% Do median split for fast/slow comparison
cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));

in.fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
in.slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);

out.fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
out.slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);

in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);


n.in.all = length(in.all);
n.in.fast = length(in.fast);
n.in.slow = length(in.slow);

n.out.all = length(in.all);
n.out.fast = length(in.fast);
n.out.slow = length(in.slow);


RT.all = nanmean([SRT(in.all,1); SRT(out.all,1)]);
RT.fast = nanmean([SRT(in.fast,1);SRT(out.fast,1)]);
RT.slow = nanmean([SRT(in.slow,1);SRT(out.slow,1)]);



%fix Spike channel; change 0's to NaN and alter times
sig2(sig2 == 0) = NaN;
sig2 = sig2 - 500;


%=======================
% Tin vs Din, all trials
alltr = [in.all;out.all];

ClusShuffOpts.TestType = 2;
ClusShuffOpts.TrType(1:length(in.all)) = 1;
ClusShuffOpts.TrType(length(in.all)+1:length(in.all)+length(out.all)) = 2;

%with shuffling (pad = 0) & between condition tests
try
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.all,~,~] = Spk_LFPCoh(sig2(alltr,:),sig1(alltr,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
catch
    between_cond_shuff.all.TrType1.Pcoh(1:281,1:21) = NaN;
    between_cond_shuff.all.TrType2.Pcoh(1:281,1:21) = NaN;
    between_cond_shuff.all.Coh.Pos.SigClusAssign(1:61,1:21) = NaN;
    between_cond_shuff.all.Coh.Neg.SigClusAssign(1:61,1:21) = NaN;
end

clear alltr
ClusShuffOpts.TrType = [];

%with shuffling (pad = 0) & vsBaseline test

% ClusShuffOpts.TestType = 1;
% [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.all] = Spk_LFPCoh(sig2(in.all,:),sig1(in.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
% [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.all] = Spk_LFPCoh(sig2(out.all,:),sig1(out.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);

%without shuffling (pad == 4) & no tests
[coh.in.all,f,tout,Sx.in.all,Sy.in.all,Pcoh.in.all,PSx.in.all,PSy.in.all,] = Spk_LFPCoh(sig2(in.all,:),sig1(in.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.all,f,tout,Sx.out.all,Sy.out.all,Pcoh.out.all,PSx.out.all,PSy.out.all] = Spk_LFPCoh(sig2(out.all,:),sig1(out.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
%=======================



%=======================
% Tin vs Din, fast

%without shuffling (pad == 4) & no tests
[coh.in.fast,f,tout,Sx.in.fast,Sy.in.fast,Pcoh.in.fast,PSx.in.fast,PSy.in.fast] = Spk_LFPCoh(sig2(in.fast,:),sig1(in.fast,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.fast,f,tout,Sx.out.fast,Sy.out.fast,Pcoh.out.fast,PSx.out.fast,PSy.out.fast] = Spk_LFPCoh(sig2(out.fast,:),sig1(out.fast,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

%=======================


%=======================
% Tin vs Din, slow

%without shuffling (pad == 4) & no tests
[coh.in.slow,f,tout,Sx.in.slow,Sy.in.slow,Pcoh.in.slow,PSx.in.slow,PSy.in.slow] = Spk_LFPCoh(sig2(in.slow,:),sig1(in.slow,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.slow,f,tout,Sx.out.slow,Sy.out.slow,Pcoh.out.slow,PSx.out.slow,PSy.out.slow] = Spk_LFPCoh(sig2(out.slow,:),sig1(out.slow,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

%=======================


if saveFlag == 1
    save(['/volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_MG/overlap/' file_name_MG '_' ...
        sig1_name sig2_name '.mat'],'between_cond_shuff','coh','f','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','-mat')
end


