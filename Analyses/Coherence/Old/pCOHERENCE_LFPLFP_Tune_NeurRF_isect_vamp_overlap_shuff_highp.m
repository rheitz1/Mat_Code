%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.

function [] = pCOHERENCE_LFPLFP_Tune_NeurRF_isect_vamp_overlap_shuff_highp(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;
shuffFlag = 1;
ClusShuffOpts.nShuffs = 5000; %number of shuffles for between condition tests

ClusShuffOpts.ActPer = [0 800];

nReps = 100; %number of times to subsample correct trials for comparison with error trials

file_name


load(file_name,sig1_name,sig2_name, ...
    'EyeX_','EyeY_','Target_','Errors_','newfile','Correct_','SRT','TrialStart_')

fixErrors

%get saccade locations for error trials
[SRT saccLoc] = getSRT(EyeX_,EyeY_);

clear EyeX_ EyeY_

sig1 = eval(sig1_name);
sig2 = eval(sig2_name);


tapers = PreGenTapers([.2 5]);
% disp('Altering Tapers...')
% tapers = PreGenTapers([.3 10 5]);

%use selectivity of LFP to determine its RF
[RF1 ~] = LFPtuning(sig1);
[RF2 ~] = LFPtuning(sig2);

RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);

%now invert LFP so phase plots are correct
sig1 = -sig1;
sig2 = -sig2;

% Do median split for fast/slow comparison
cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));

in.fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
in.slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
in.err = find(Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

out.fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
out.slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
out.err = find(Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
in.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
in.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
in.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &  SRT(:,1) < 2000 & SRT(:,1) > 50);

out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
out.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
out.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);


n.in.all = length(in.all);
n.in.ss2 = length(in.ss2);
n.in.ss4 = length(in.ss4);
n.in.ss8 = length(in.ss8);
n.in.fast = length(in.fast);
n.in.slow = length(in.slow);
n.in.err = length(in.err);

n.out.all = length(in.all);
n.out.ss2 = length(in.ss2);
n.out.ss4 = length(in.ss4);
n.out.ss8 = length(in.ss8);
n.out.fast = length(in.fast);
n.out.slow = length(in.slow);
n.out.err = length(in.err);


RT.all = nanmean([SRT(in.all,1); SRT(out.all,1)]);
RT.ss2 = nanmean([SRT(in.ss2,1); SRT(out.ss2,1)]);
RT.ss4 = nanmean([SRT(in.ss4,1); SRT(out.ss4,1)]);
RT.ss8 = nanmean([SRT(in.ss8,1); SRT(out.ss8,1)]);

RT.fast = nanmean([SRT(in.fast,1);SRT(out.fast,1)]);
RT.slow = nanmean([SRT(in.slow,1);SRT(out.slow,1)]);
RT.err = nanmean([SRT(in.err,1); SRT(out.err,1)]);

if length(in.err) < 5 | length(out.err) < 5
    disp('too few errors; setting to NaN')
    errskip = 1;
else
    errskip = 0;
end


%baseline correct
%sig1 = baseline_correct(sig1,[400 500]);

TDT.sig1.all = getTDT_AD(sig1,in.all,out.all);
TDT.sig1.ss2 = getTDT_AD(sig1,in.ss2,out.ss2);
TDT.sig1.ss4 = getTDT_AD(sig1,in.ss4,out.ss4);
TDT.sig1.ss8 = getTDT_AD(sig1,in.ss8,out.ss8);
TDT.sig1.fast = getTDT_AD(sig1,in.fast,out.fast);
TDT.sig1.slow = getTDT_AD(sig1,in.slow,out.slow);
TDT.sig1.err = getTDT_AD(sig1,in.err,out.err);

TDT.sig2.all = getTDT_AD(sig2,in.all,out.all);
TDT.sig2.ss2 = getTDT_AD(sig2,in.ss2,out.ss2);
TDT.sig2.ss4 = getTDT_AD(sig2,in.ss4,out.ss4);
TDT.sig2.ss8 = getTDT_AD(sig2,in.ss8,out.ss8);
TDT.sig2.fast = getTDT_AD(sig2,in.fast,out.fast);
TDT.sig2.slow = getTDT_AD(sig2,in.slow,out.slow);
TDT.sig2.err = getTDT_AD(sig2,in.err,out.err);

wf.sig1.in.all = nanmean(sig1(in.all,:));
wf.sig1.in.ss2 = nanmean(sig1(in.ss2,:));
wf.sig1.in.ss4 = nanmean(sig1(in.ss4,:));
wf.sig1.in.ss8 = nanmean(sig1(in.ss8,:));
wf.sig1.in.fast = nanmean(sig1(in.fast,:));
wf.sig1.in.slow = nanmean(sig1(in.slow,:));
wf.sig1.in.err = nanmean(sig1(in.err,:));

wf.sig1.out.all = nanmean(sig1(out.all,:));
wf.sig1.out.ss2 = nanmean(sig1(out.ss2,:));
wf.sig1.out.ss4 = nanmean(sig1(out.ss4,:));
wf.sig1.out.ss8 = nanmean(sig1(out.ss8,:));
wf.sig1.out.fast = nanmean(sig1(out.fast,:));
wf.sig1.out.slow = nanmean(sig1(out.slow,:));
wf.sig1.out.err = nanmean(sig1(out.err,:));

wf.sig2.in.all = nanmean(sig2(in.all,:));
wf.sig2.in.ss2 = nanmean(sig2(in.ss2,:));
wf.sig2.in.ss4 = nanmean(sig2(in.ss4,:));
wf.sig2.in.ss8 = nanmean(sig2(in.ss8,:));
wf.sig2.in.fast = nanmean(sig2(in.fast,:));
wf.sig2.in.slow = nanmean(sig2(in.slow,:));
wf.sig2.in.err = nanmean(sig2(in.err,:));

wf.sig2.out.all = nanmean(sig2(out.all,:));
wf.sig2.out.ss2 = nanmean(sig2(out.ss2,:));
wf.sig2.out.ss4 = nanmean(sig2(out.ss4,:));
wf.sig2.out.ss8 = nanmean(sig2(out.ss8,:));
wf.sig2.out.fast = nanmean(sig2(out.fast,:));
wf.sig2.out.slow = nanmean(sig2(out.slow,:));
wf.sig2.out.err = nanmean(sig2(out.err,:));



%=======================
% Tin vs Din, all trials
disp('ALL TRIALS')
if shuffFlag == 1
    alltr = [in.all;out.all];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.all)) = 1;
    ClusShuffOpts.TrType(length(in.all)+1:length(in.all)+length(out.all)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.all,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.all] = LFP_LFPCoh(sig1(in.all,:),sig2(in.all,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.all] = LFP_LFPCoh(sig1(out.all,:),sig2(out.all,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
end

%without shuffling (pad == 4) & no tests
[coh.in.all,f,tout,Sx.in.all,Sy.in.all,Pcoh.in.all,PSx.in.all,PSy.in.all,] = LFP_LFPCoh(sig1(in.all,:),sig2(in.all,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
[coh.out.all,f,tout,Sx.out.all,Sy.out.all,Pcoh.out.all,PSx.out.all,PSy.out.all] = LFP_LFPCoh(sig1(out.all,:),sig2(out.all,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
%=======================


%=======================
% Tin vs Din, SS2
disp('SET SIZE 2')
if shuffFlag == 1
    alltr = [in.ss2;out.ss2];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.ss2)) = 1;
    ClusShuffOpts.TrType(length(in.ss2)+1:length(in.ss2)+length(out.ss2)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.ss2] = LFP_LFPCoh(sig1(in.ss2,:),sig2(in.ss2,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.ss2] = LFP_LFPCoh(sig1(out.ss2,:),sig2(out.ss2,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
end

%without shuffling (pad == 4) & no tests
[coh.in.ss2,f,tout,Sx.in.ss2,Sy.in.ss2,Pcoh.in.ss2,PSx.in.ss2,PSy.in.ss2,] = LFP_LFPCoh(sig1(in.ss2,:),sig2(in.ss2,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
[coh.out.ss2,f,tout,Sx.out.ss2,Sy.out.ss2,Pcoh.out.ss2,PSx.out.ss2,PSy.out.ss2] = LFP_LFPCoh(sig1(out.ss2,:),sig2(out.ss2,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
%=======================


%=======================
% Tin vs Din, ss4
disp('SET SIZE 4')
if shuffFlag == 1
    alltr = [in.ss4;out.ss4];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.ss4)) = 1;
    ClusShuffOpts.TrType(length(in.ss4)+1:length(in.ss4)+length(out.ss4)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.ss4] = LFP_LFPCoh(sig1(in.ss4,:),sig2(in.ss4,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.ss4] = LFP_LFPCoh(sig1(out.ss4,:),sig2(out.ss4,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
end

%without shuffling (pad == 4) & no tests
[coh.in.ss4,f,tout,Sx.in.ss4,Sy.in.ss4,Pcoh.in.ss4,PSx.in.ss4,PSy.in.ss4,] = LFP_LFPCoh(sig1(in.ss4,:),sig2(in.ss4,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
[coh.out.ss4,f,tout,Sx.out.ss4,Sy.out.ss4,Pcoh.out.ss4,PSx.out.ss4,PSy.out.ss4] = LFP_LFPCoh(sig1(out.ss4,:),sig2(out.ss4,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);

%=======================


%=======================
% Tin vs Din, ss8
disp('SET SIZE 8')
if shuffFlag == 1
    alltr = [in.ss8;out.ss8];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.ss8)) = 1;
    ClusShuffOpts.TrType(length(in.ss8)+1:length(in.ss8)+length(out.ss8)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.ss8] = LFP_LFPCoh(sig1(in.ss8,:),sig2(in.ss8,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.ss8] = LFP_LFPCoh(sig1(out.ss8,:),sig2(out.ss8,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
end

%without shuffling (pad == 4) & no tests
[coh.in.ss8,f,tout,Sx.in.ss8,Sy.in.ss8,Pcoh.in.ss8,PSx.in.ss8,PSy.in.ss8,] = LFP_LFPCoh(sig1(in.ss8,:),sig2(in.ss8,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
[coh.out.ss8,f,tout,Sx.out.ss8,Sy.out.ss8,Pcoh.out.ss8,PSx.out.ss8,PSy.out.ss8] = LFP_LFPCoh(sig1(out.ss8,:),sig2(out.ss8,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);

%=======================


%=======================
% Tin vs Din, fast
disp('FAST')
if shuffFlag == 1
    alltr = [in.fast;out.fast];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.fast)) = 1;
    ClusShuffOpts.TrType(length(in.fast)+1:length(in.fast)+length(out.fast)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.fast,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.fast] = LFP_LFPCoh(sig1(in.fast,:),sig2(in.fast,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.fast] = LFP_LFPCoh(sig1(out.fast,:),sig2(out.fast,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
end

%without shuffling (pad == 4) & no tests
[coh.in.fast,f,tout,Sx.in.fast,Sy.in.fast,Pcoh.in.fast,PSx.in.fast,PSy.in.fast,] = LFP_LFPCoh(sig1(in.fast,:),sig2(in.fast,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
[coh.out.fast,f,tout,Sx.out.fast,Sy.out.fast,Pcoh.out.fast,PSx.out.fast,PSy.out.fast] = LFP_LFPCoh(sig1(out.fast,:),sig2(out.fast,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);


%=======================


%=======================
% Tin vs Din, slow
disp('SLOW')
if shuffFlag == 1
    alltr = [in.slow;out.slow];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.slow)) = 1;
    ClusShuffOpts.TrType(length(in.slow)+1:length(in.slow)+length(out.slow)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.slow,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
    
    %with shuffling (pad = 0) & vsBaseline test
    
    ClusShuffOpts.TestType = 1;
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.slow] = LFP_LFPCoh(sig1(in.slow,:),sig2(in.slow,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.slow] = LFP_LFPCoh(sig1(out.slow,:),sig2(out.slow,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
end

%without shuffling (pad == 4) & no tests
[coh.in.slow,f,tout,Sx.in.slow,Sy.in.slow,Pcoh.in.slow,PSx.in.slow,PSy.in.slow,] = LFP_LFPCoh(sig1(in.slow,:),sig2(in.slow,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
[coh.out.slow,f,tout,Sx.out.slow,Sy.out.slow,Pcoh.out.slow,PSx.out.slow,PSy.out.slow] = LFP_LFPCoh(sig1(out.slow,:),sig2(out.slow,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);


%=======================



%=======================
% Tin fast vs Tin slow
disp('Tin FAST vs. Tin SLOW')
if shuffFlag == 1
    alltr = [in.fast;in.slow];
    
    ClusShuffOpts.TestType = 2;
    ClusShuffOpts.TrType(1:length(in.fast)) = 1;
    ClusShuffOpts.TrType(length(in.fast)+1:length(in.fast)+length(in.slow)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.fast_slow,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    clear alltr
    ClusShuffOpts.TrType = [];
end

%THESE ARE ALREADY DONE ABOVE; NO NEED TO REPEAT
%without shuffling (pad = 4)
%ClusShuffOpts.TestType = 1;
%[coh.in.fast,f,tout,Sx.in.fast,Sy.in.fast,Pcoh.in.fast,PSx.in.fast,PSy.in.fast] = Spk_LFPCoh(sig2(in.fast,:),sig1(in.fast,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.10,0,2,2);
%[coh.out.fast,f,tout,Sx.out.fast,Sy.out.fast,Pcoh.out.fast,PSx.out.fast,PSy.out.fast] = Spk_LFPCoh(sig2(out.fast,:),sig1(out.fast,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.10,0,2,2);
%=======================


if errskip == 0
    
    %========================
    % Tin vs Din errors
    disp('ERRORS')
    if shuffFlag == 1
        alltr = [in.err;out.err];
        
        ClusShuffOpts.TestType = 2;
        ClusShuffOpts.TrType(1:length(in.err)) = 1;
        ClusShuffOpts.TrType(length(in.err)+1:length(in.err)+length(out.err)) = 2;
        
        %with shuffling (pad = 0) & between condition tests
        [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.err,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
        clear alltr
        ClusShuffOpts.TrType = [];
        
        %with shuffling (pad = 0) & vsBaseline test
        ClusShuffOpts.TestType = 1;
        [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.in.err] = LFP_LFPCoh(sig1(in.err,:),sig2(in.err,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
        [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.err] = LFP_LFPCoh(sig1(out.err,:),sig2(out.err,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
    end
    
    %with shuffling (pad == 4) & no tests
    [coh.in.err,f,tout,Sx.in.err,Sy.in.err,Pcoh.in.err,PSx.in.err,PSy.in.err] = LFP_LFPCoh(sig1(in.err,:),sig2(in.err,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
    [coh.out.err,f,tout,Sx.out.err,Sy.out.err,Pcoh.out.err,PSx.out.err,PSy.out.err] = LFP_LFPCoh(sig1(out.err,:),sig2(out.err,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
    %=======================
    
    
    %=======================
    % Tin correct vs Tin errors
    disp('Tin CORRECT vs. Tin ERRORS')
    if shuffFlag == 1
        alltr = [in.all;in.err];
        
        ClusShuffOpts.TestType = 2;
        ClusShuffOpts.TrType(1:length(in.all)) = 1;
        ClusShuffOpts.TrType(length(in.all)+1:length(in.all)+length(in.err)) = 2;
        
        %with shuffling (pad = 0)  & between condition tests
        [~,~,~,~,~,~,~,~,~,~,~,between_cond_shuff.corr_err,~,~] = LFP_LFPCoh(sig1(alltr,:),sig2(alltr,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2,ClusShuffOpts);
        clear alltr
        ClusShuffOpts.TrType = [];
    end
    
    %=======================
    
else
    coh.in.err(1:length(tout),1:length(f)) = NaN;
    Sx.in.err(1:length(tout),1:length(f)) = NaN;
    Sy.in.err(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.err(1:length(tout),1:length(f)) = NaN;
    PSx.in.err(1:length(tout),1:length(f)) = NaN;
    PSy.in.err(1:length(tout),1:length(f)) = NaN;
    
    coh.out.err(1:length(tout),1:length(f)) = NaN;
    Sx.out.err(1:length(tout),1:length(f)) = NaN;
    Sy.out.err(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.err(1:length(tout),1:length(f)) = NaN;
    PSx.out.err(1:length(tout),1:length(f)) = NaN;
    PSy.out.err(1:length(tout),1:length(f)) = NaN;
    
end


%==============================================
% Do subsampling of correct trials for comparison with error trials

if errskip == 0
    for rep = 1:nReps
        rep
        in.all_sub = shake(in.all);
        in.all_sub = in.all_sub(randperm(length(in.err)));
        
        out.all_sub = shake(out.all);
        out.all_sub = out.all_sub(randperm(length(out.err)));
        
        [tempcoh.in.all_sub, f, tout, tempSx.in.all_sub, tempSy.in.all_sub, tempPcoh.in.all_sub, tempPSx.in.all_sub, tempPSy.in.all_sub] = LFP_LFPCoh(sig1(in.all_sub,:),sig2(in.all_sub,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
        [tempcoh.out.all_sub, f, tout, tempSx.out.all_sub, tempSy.out.all_sub, tempPcoh.out.all_sub, tempPSx.out.all_sub, tempPSy.out.all_sub] = LFP_LFPCoh(sig1(out.all_sub,:),sig2(out.all_sub,:),tapers,1000,.01,[0 200],0,-500,0,4,.10,0,2,2);
        
        coh.in.all_sub(1:length(tout),1:length(f),rep) = tempcoh.in.all_sub;
        Sx.in.all_sub(1:length(tout),1:length(f),rep) = tempSx.in.all_sub;
        Sy.in.all_sub(1:length(tout),1:length(f),rep) = tempSy.in.all_sub;
        Pcoh.in.all_sub(1:length(tout),1:length(f),rep) = tempPcoh.in.all_sub;
        PSx.in.all_sub(1:length(tout),1:length(f),rep) = tempPSx.in.all_sub;
        PSy.in.all_sub(1:length(tout),1:length(f),rep) = tempPSy.in.all_sub;
        
        coh.out.all_sub(1:length(tout),1:length(f),rep) = tempcoh.out.all_sub;
        Sx.out.all_sub(1:length(tout),1:length(f),rep) = tempSx.out.all_sub;
        Sy.out.all_sub(1:length(tout),1:length(f),rep) = tempSy.out.all_sub;
        Pcoh.out.all_sub(1:length(tout),1:length(f),rep) = tempPcoh.out.all_sub;
        PSx.out.all_sub(1:length(tout),1:length(f),rep) = tempPSx.out.all_sub;
        PSy.out.all_sub(1:length(tout),1:length(f),rep) = tempPSy.out.all_sub;
        
        clear temp*
    end
    
    %take mean of repetitions now to keep file sizes smaller
    coh.in.all_sub = mean(coh.in.all_sub,3);
    Sx.in.all_sub = mean(Sx.in.all_sub,3);
    Sy.in.all_sub = mean(Sy.in.all_sub,3);
    Pcoh.in.all_sub = mean(Pcoh.in.all_sub,3);
    PSx.in.all_sub = mean(PSx.in.all_sub,3);
    PSy.in.all_sub = mean(PSy.in.all_sub,3);
    
    coh.out.all_sub = mean(coh.out.all_sub,3);
    Sx.out.all_sub = mean(Sx.out.all_sub,3);
    Sy.out.all_sub = mean(Sy.out.all_sub,3);
    Pcoh.out.all_sub = mean(Pcoh.out.all_sub,3);
    PSx.out.all_sub = mean(PSx.out.all_sub,3);
    PSy.out.all_sub = mean(PSy.out.all_sub,3);
    
else
    coh.in.all_sub(1:length(tout),1:length(f)) = NaN;
    Sx.in.all_sub(1:length(tout),1:length(f)) = NaN;
    Sy.in.all_sub(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.all_sub(1:length(tout),1:length(f)) = NaN;
    PSx.in.all_sub(1:length(tout),1:length(f)) = NaN;
    PSy.in.all_sub(1:length(tout),1:length(f)) = NaN;
    
    coh.out.all_sub(1:length(tout),1:length(f)) = NaN;
    Sx.out.all_sub(1:length(tout),1:length(f)) = NaN;
    Sy.out.all_sub(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.all_sub(1:length(tout),1:length(f)) = NaN;
    PSx.out.all_sub(1:length(tout),1:length(f)) = NaN;
    PSy.out.all_sub(1:length(tout),1:length(f)) = NaN;
    
end




if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/Uber_Tune_NeuronRF_intersection_shuff/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'f_shuff','within_cond_shuff','between_cond_shuff','coh','f','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/Uber_Tune_NeuronRF_intersection_shuff/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh','f','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
end


