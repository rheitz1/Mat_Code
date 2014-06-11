%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.
%
% In this version, removing influence of spikes on LFP by interpolating
function [] = pCOHERENCE_SPKLFP_Tune_NeurRF_isect_vamp_nooverlap_shuff(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

shuffFlag = 1;
saveFlag = 1;
SendEmails = 0; %does not work on ACCRE

ClusShuffOpts.nShuffs = 5000; %number of shuffles for between condition tests
ClusShuffOpts.ActPer = [0 800];

%number of times to subsample correct trials for comparison with error
%trials.  ACCRE cannot handle that much more than 100 because you have to
%store so many n x p matrices.
nReps = 100; 

file_name

%also try to load MStim_ so we can tell if it is that kind of data set
load(file_name,sig1_name,sig2_name, ...
    'MStim_','EyeX_','EyeY_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_')

fixErrors

%get saccade locations for error trials
[SRT saccLoc] = getSRT(EyeX_,EyeY_);

clear EyeX_ EyeY_

sig1 = eval(sig1_name);
sig2 = eval(sig2_name);

tapers = PreGenTapers([.2 5]);
% disp('Altering Tapers...')
% tapers = PreGenTapers([.3 10 5]);


% NO OVERLAP CONDITION: Make RF to what it WOULD have been had they been
% overlapping. Target in will be in reference to spike.

[RF1 ~] = LFPtuning(sig1);

%INVERT RFS BECAUSE NON-OVERLAPPING
RF1 = mod((RF1+4),8);

RF2 = RFs.(sig2_name);

RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);

if isempty(RF)
    if SendEmails == 1
        SendEmailNotification('richard.p.heitz@vanderbilt.edu','No RF Intersection',['file = ' file_name '_' sig1_name sig2_name])
    end
    error('No RF Intersection')
end

%Remove influence of spikes on the LFP.  Use a -2 to +2 window
%sig1 = RemSpkAndInterpLFP(sig1,sig2,0,[-2 2]);


% SET UP TRIALS
%=====================================
if exist('MStim_') == 0 %not a uStim session
    % Do median split for fast/slow comparison for each set size
    cMed.all = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    % Do median split for fast/slow comparison
    cMed.ss2 = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    cMed.ss4 = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    cMed.ss8 = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    %all trials
    in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    % fast & slow SS2
    in.fast.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) < cMed.ss2 & SRT(:,1) > 50);
    in.slow.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) >= cMed.ss2 & SRT(:,1) < 2000);
    out.fast.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < cMed.ss2 & SRT(:,1) > 50);
    out.slow.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) >= cMed.ss2 & SRT(:,1) < 2000);
    
    % fast & slow ss4
    in.fast.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) < cMed.ss4 & SRT(:,1) > 50);
    in.slow.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) >= cMed.ss4 & SRT(:,1) < 2000);
    out.fast.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < cMed.ss4 & SRT(:,1) > 50);
    out.slow.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) >= cMed.ss4 & SRT(:,1) < 2000);
    
    %fast & slow ss8
    in.fast.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & SRT(:,1) < cMed.ss8 & SRT(:,1) > 50);
    in.slow.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & SRT(:,1) >= cMed.ss8 & SRT(:,1) < 2000);
    out.fast.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < cMed.ss8 & SRT(:,1) > 50);
    out.slow.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) >= cMed.ss8 & SRT(:,1) < 2000);
    
    %fast & slow all SS
    in.fast.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed.all & SRT(:,1) > 50);
    in.slow.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed.all & SRT(:,1) < 2000);
    out.fast.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed.all & SRT(:,1) > 50);
    out.slow.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed.all & SRT(:,1) < 2000);
    
    %all error trials
    in.err = find(Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.err = find(Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    %set size, collapsed on fast/slow
    in.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
elseif exist('MStim_') == 1 %is a uStim session
    % Do median split for fast/slow comparison for each set size
    cMed.all = nanmedian(SRT(find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    % Do median split for fast/slow comparison
    cMed.ss2 = nanmedian(SRT(find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    cMed.ss4 = nanmedian(SRT(find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    cMed.ss8 = nanmedian(SRT(find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    
    %all trials
    in.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    % fast & slow SS2
    in.fast.ss2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) < cMed.ss2 & SRT(:,1) > 50);
    in.slow.ss2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) >= cMed.ss2 & SRT(:,1) < 2000);
    out.fast.ss2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < cMed.ss2 & SRT(:,1) > 50);
    out.slow.ss2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) >= cMed.ss2 & SRT(:,1) < 2000);
    
    % fast & slow ss4
    in.fast.ss4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) < cMed.ss4 & SRT(:,1) > 50);
    in.slow.ss4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) >= cMed.ss4 & SRT(:,1) < 2000);
    out.fast.ss4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < cMed.ss4 & SRT(:,1) > 50);
    out.slow.ss4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) >= cMed.ss4 & SRT(:,1) < 2000);
    
    %fast & slow ss8
    in.fast.ss8 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & SRT(:,1) < cMed.ss8 & SRT(:,1) > 50);
    in.slow.ss8 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & SRT(:,1) >= cMed.ss8 & SRT(:,1) < 2000);
    out.fast.ss8 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < cMed.ss8 & SRT(:,1) > 50);
    out.slow.ss8 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) >= cMed.ss8 & SRT(:,1) < 2000);
    
    %fast & slow all SS
    in.fast.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed.all & SRT(:,1) > 50);
    in.slow.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed.all & SRT(:,1) < 2000);
    out.fast.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed.all & SRT(:,1) > 50);
    out.slow.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed.all & SRT(:,1) < 2000);
    
    %all error trials
    in.err = find(isnan(MStim_(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.err = find(isnan(MStim_(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    %set size, collapsed on fast/slow
    in.ss2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss8 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
end
%==================================================


%KEEP TRACK OF N'S
%==================================================
n.in.all = length(in.all);
n.in.fast.ss2 = length(in.fast.ss2);
n.in.fast.ss4 = length(in.fast.ss4);
n.in.fast.ss8 = length(in.fast.ss8);
n.in.slow.ss2 = length(in.slow.ss2);
n.in.slow.ss4 = length(in.slow.ss4);
n.in.slow.ss8 = length(in.slow.ss8);
n.in.fast.all = length(in.fast.all);
n.in.slow.all = length(in.slow.all);
n.in.ss2 = length(in.ss2);
n.in.ss4 = length(in.ss4);
n.in.ss8 = length(in.ss8);
n.in.err = length(in.err);

n.out.all = length(out.all);
n.out.fast.ss2 = length(out.fast.ss2);
n.out.fast.ss4 = length(out.fast.ss4);
n.out.fast.ss8 = length(out.fast.ss8);
n.out.slow.ss2 = length(out.slow.ss2);
n.out.slow.ss4 = length(out.slow.ss4);
n.out.slow.ss8 = length(out.slow.ss8);
n.out.fast.all = length(out.fast.all);
n.out.slow.all = length(out.slow.all);
n.out.ss2 = length(out.ss2);
n.out.ss4 = length(out.ss4);
n.out.ss8 = length(out.ss8);
n.out.err = length(out.err);
%===================================================


%KEEP TRACK OF RTs
%===================================================
RT.all = nanmean([SRT(in.all,1); SRT(out.all,1)]);
RT.ss2 = nanmean([SRT(in.ss2,1); SRT(out.ss2,1)]);
RT.ss4 = nanmean([SRT(in.ss4,1); SRT(out.ss4,1)]);
RT.ss8 = nanmean([SRT(in.ss8,1); SRT(out.ss8,1)]);
RT.fast.ss2 = nanmean([SRT(in.fast.ss2,1);SRT(out.fast.ss2,1)]);
RT.fast.ss4 = nanmean([SRT(in.fast.ss4,1);SRT(out.fast.ss4,1)]);
RT.fast.ss8 = nanmean([SRT(in.fast.ss8,1);SRT(out.fast.ss8,1)]);
RT.slow.ss2 = nanmean([SRT(in.slow.ss2,1);SRT(out.slow.ss2,1)]);
RT.slow.ss4 = nanmean([SRT(in.slow.ss4,1);SRT(out.slow.ss4,1)]);
RT.slow.ss8 = nanmean([SRT(in.slow.ss8,1);SRT(out.slow.ss8,1)]);
RT.fast.all = nanmean([SRT(in.fast.all,1);SRT(out.fast.all,1)]);
RT.slow.all = nanmean([SRT(in.slow.all,1);SRT(out.slow.all,1)]);
RT.err = nanmean([SRT(in.err,1); SRT(out.err,1)]);
%===================================================


if length(in.err) < 5 | length(out.err) < 5
    disp('too few errors; setting to NaN')
    errskip = 1;
else
    errskip = 0;
end


%baseline correct
%NOTE: do not use baseline corrected version in coherence calculation.
%They are only slightly, trivially different but limited to the low
%frequency bands.  Use baseline corrected versions only for TDT calculation
%and saved average waveforms.
sig1_bc = baseline_correct(sig1,[400 500]);

%CALCULATE TDT FOR EACH CONDITION
%=========================================
TDT.sig1.all = getTDT_AD(sig1_bc,in.all,out.all);
TDT.sig1.ss2 = getTDT_AD(sig1_bc,in.ss2,out.ss2);
TDT.sig1.ss4 = getTDT_AD(sig1_bc,in.ss4,out.ss4);
TDT.sig1.ss8 = getTDT_AD(sig1_bc,in.ss8,out.ss8);
TDT.sig1.fast.ss2 = getTDT_AD(sig1_bc,in.fast.ss2,out.fast.ss2);
TDT.sig1.fast.ss4 = getTDT_AD(sig1_bc,in.fast.ss4,out.fast.ss4);
TDT.sig1.fast.ss8 = getTDT_AD(sig1_bc,in.fast.ss8,out.fast.ss8);
TDT.sig1.slow.ss2 = getTDT_AD(sig1_bc,in.slow.ss2,out.slow.ss2);
TDT.sig1.slow.ss4 = getTDT_AD(sig1_bc,in.slow.ss4,out.slow.ss4);
TDT.sig1.slow.ss8 = getTDT_AD(sig1_bc,in.slow.ss8,out.slow.ss8);
TDT.sig1.fast.all = getTDT_AD(sig1_bc,in.fast.all,out.fast.all);
TDT.sig1.slow.all = getTDT_AD(sig1_bc,in.slow.all,out.slow.all);
TDT.sig1.err = getTDT_AD(sig1_bc,in.err,out.err);

TDT.sig2.all = getTDT_SP(sig2,in.all,out.all);
TDT.sig2.ss2 = getTDT_SP(sig2,in.ss2,out.ss2);
TDT.sig2.ss4 = getTDT_SP(sig2,in.ss4,out.ss4);
TDT.sig2.ss8 = getTDT_SP(sig2,in.ss8,out.ss8);
TDT.sig2.fast.ss2 = getTDT_SP(sig2,in.fast.ss2,out.fast.ss2);
TDT.sig2.fast.ss4 = getTDT_SP(sig2,in.fast.ss4,out.fast.ss4);
TDT.sig2.fast.ss8 = getTDT_SP(sig2,in.fast.ss8,out.fast.ss8);
TDT.sig2.slow.ss2 = getTDT_SP(sig2,in.slow.ss2,out.slow.ss2);
TDT.sig2.slow.ss4 = getTDT_SP(sig2,in.slow.ss4,out.slow.ss4);
TDT.sig2.slow.ss8 = getTDT_SP(sig2,in.slow.ss8,out.slow.ss8);
TDT.sig2.fast.all = getTDT_SP(sig2,in.fast.all,out.fast.all);
TDT.sig2.slow.all = getTDT_SP(sig2,in.slow.all,out.slow.all);
TDT.sig2.err = getTDT_SP(sig2,in.err,out.err);
%==========================================



%KEEP TRACK OF WAVEFORMS.  (NOT ACTUALLY USED IN ANALYSIS)
%==========================================================
wf.sig1.in.all = nanmean(sig1_bc(in.all,:));
wf.sig1.in.ss2 = nanmean(sig1_bc(in.ss2,:));
wf.sig1.in.ss4 = nanmean(sig1_bc(in.ss4,:));
wf.sig1.in.ss8 = nanmean(sig1_bc(in.ss8,:));
wf.sig1.in.fast.ss2 = nanmean(sig1_bc(in.fast.ss2,:));
wf.sig1.in.fast.ss4 = nanmean(sig1_bc(in.fast.ss4,:));
wf.sig1.in.fast.ss8 = nanmean(sig1_bc(in.fast.ss8,:));
wf.sig1.in.slow.ss2 = nanmean(sig1_bc(in.slow.ss2,:));
wf.sig1.in.slow.ss4 = nanmean(sig1_bc(in.slow.ss4,:));
wf.sig1.in.slow.ss8 = nanmean(sig1_bc(in.slow.ss8,:));
wf.sig1.in.fast.all = nanmean(sig1_bc(in.fast.all,:));
wf.sig1.in.slow.all = nanmean(sig1_bc(in.slow.all,:));
wf.sig1.in.err = nanmean(sig1_bc(in.err,:));

wf.sig1.out.all = nanmean(sig1_bc(out.all,:));
wf.sig1.out.ss2 = nanmean(sig1_bc(out.ss2,:));
wf.sig1.out.ss4 = nanmean(sig1_bc(out.ss4,:));
wf.sig1.out.ss8 = nanmean(sig1_bc(out.ss8,:));
wf.sig1.out.fast.ss2 = nanmean(sig1_bc(out.fast.ss2,:));
wf.sig1.out.fast.ss4 = nanmean(sig1_bc(out.fast.ss4,:));
wf.sig1.out.fast.ss8 = nanmean(sig1_bc(out.fast.ss8,:));
wf.sig1.out.slow.ss2 = nanmean(sig1_bc(out.slow.ss2,:));
wf.sig1.out.slow.ss4 = nanmean(sig1_bc(out.slow.ss4,:));
wf.sig1.out.slow.ss8 = nanmean(sig1_bc(out.slow.ss8,:));
wf.sig1.out.fast.all = nanmean(sig1_bc(out.fast.all,:));
wf.sig1.out.slow.all = nanmean(sig1_bc(out.slow.all,:));
wf.sig1.out.err = nanmean(sig1_bc(out.err,:));


wf.sig2.in.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.all,TrialStart_);
wf.sig2.in.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss2,TrialStart_);
wf.sig2.in.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss4,TrialStart_);
wf.sig2.in.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss8,TrialStart_);
wf.sig2.in.fast.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast.ss2,TrialStart_);
wf.sig2.in.fast.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast.ss4,TrialStart_);
wf.sig2.in.fast.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast.ss8,TrialStart_);
wf.sig2.in.slow.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow.ss2,TrialStart_);
wf.sig2.in.slow.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow.ss4,TrialStart_);
wf.sig2.in.slow.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow.ss8,TrialStart_);
wf.sig2.in.fast.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast.all,TrialStart_);
wf.sig2.in.slow.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow.all,TrialStart_);
wf.sig2.in.err = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.err,TrialStart_);

wf.sig2.out.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.all,TrialStart_);
wf.sig2.out.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss2,TrialStart_);
wf.sig2.out.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss4,TrialStart_);
wf.sig2.out.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss8,TrialStart_);
wf.sig2.out.fast.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast.ss2,TrialStart_);
wf.sig2.out.fast.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast.ss4,TrialStart_);
wf.sig2.out.fast.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast.ss8,TrialStart_);
wf.sig2.out.slow.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow.ss2,TrialStart_);
wf.sig2.out.slow.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow.ss4,TrialStart_);
wf.sig2.out.slow.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow.ss8,TrialStart_);
wf.sig2.out.fast.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast.all,TrialStart_);
wf.sig2.out.slow.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow.all,TrialStart_);
wf.sig2.out.err = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.err,TrialStart_);
%==========================================================

clear sig1_bc

%fix Spike channel; change 0's to NaN and alter times.
%NOTE: important to do this HERE, and not before, so that the saved waveforms will be correct.
sig2(sig2 == 0) = NaN;
sig2 = sig2 - 500;

%now invert LFP so phase plots are correct
sig1 = sig1 * -1;


% COHERENCE CALCULATIONS AND SHUFFLE TESTS
%
% WE ARE ONLY GOING TO DO THE SHUFFLE TESTS FOR THE 'ALL' DATA SETS.  WE
% WILL THEN USE THIS TO IDENTIFY SINGLE SESSIONS WITH SIGNIFICANT COHERENCE
% WITHIN A FREQUENCY BAND OF INTEREST.  I HAVE NOT BEEN USING SHUFFLE TESTS
% FOR ANY OF THE MORE SPECIFIED CONDITIONS (e.g., set-size 2)
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
    [~,~,~,~,~,~,~,~,~,~,~,within_cond_shuff.out.all] = Spk_LFPCoh(sig2(out.all,:),sig1(out.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2,ClusShuffOpts);
end


% ALL TRIALS
try
    [coh.in.all,f,tout,Sx.in.all,Sy.in.all,Pcoh.in.all,PSx.in.all,PSy.in.all,] = Spk_LFPCoh(sig2(in.all,:),sig1(in.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.all,f,tout,Sx.out.all,Sy.out.all,Pcoh.out.all,PSx.out.all,PSy.out.all] = Spk_LFPCoh(sig2(out.all,:),sig1(out.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
catch
    disp('Failed to Calculate All trials')
    coh.in.all(1:length(tout),1:length(f)) = NaN;
    Sx.in.all(1:length(tout),1:length(f)) = NaN;
    Sy.in.all(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.all(1:length(tout),1:length(f)) = NaN;
    PSx.in.all(1:length(tout),1:length(f)) = NaN;
    PSy.in.all(1:length(tout),1:length(f)) = NaN;
    
    coh.out.all(1:length(tout),1:length(f)) = NaN;
    Sx.out.all(1:length(tout),1:length(f)) = NaN;
    Sy.out.all(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.all(1:length(tout),1:length(f)) = NaN;
    PSx.out.all(1:length(tout),1:length(f)) = NaN;
    PSy.out.all(1:length(tout),1:length(f)) = NaN;
    
end


% SS2
try
    [coh.in.ss2,f,tout,Sx.in.ss2,Sy.in.ss2,Pcoh.in.ss2,PSx.in.ss2,PSy.in.ss2] = Spk_LFPCoh(sig2(in.ss2,:),sig1(in.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.ss2,f,tout,Sx.out.ss2,Sy.out.ss2,Pcoh.out.ss2,PSx.out.ss2,PSy.out.ss2] = Spk_LFPCoh(sig2(out.ss2,:),sig1(out.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('SS2')
catch
    disp('Failed to Calculate SS2')
    coh.in.ss2(1:length(tout),1:length(f)) = NaN;
    Sx.in.ss2(1:length(tout),1:length(f)) = NaN;
    Sy.in.ss2(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.ss2(1:length(tout),1:length(f)) = NaN;
    PSx.in.ss2(1:length(tout),1:length(f)) = NaN;
    PSy.in.ss2(1:length(tout),1:length(f)) = NaN;
    
    coh.out.ss2(1:length(tout),1:length(f)) = NaN;
    Sx.out.ss2(1:length(tout),1:length(f)) = NaN;
    Sy.out.ss2(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.ss2(1:length(tout),1:length(f)) = NaN;
    PSx.out.ss2(1:length(tout),1:length(f)) = NaN;
    PSy.out.ss2(1:length(tout),1:length(f)) = NaN;
    
end

% SS4
try
    [coh.in.ss4,f,tout,Sx.in.ss4,Sy.in.ss4,Pcoh.in.ss4,PSx.in.ss4,PSy.in.ss4] = Spk_LFPCoh(sig2(in.ss4,:),sig1(in.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.ss4,f,tout,Sx.out.ss4,Sy.out.ss4,Pcoh.out.ss4,PSx.out.ss4,PSy.out.ss4] = Spk_LFPCoh(sig2(out.ss4,:),sig1(out.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('SS4')
catch
    disp('Failed to Calculate SS4')
    coh.in.ss4(1:length(tout),1:length(f)) = NaN;
    Sx.in.ss4(1:length(tout),1:length(f)) = NaN;
    Sy.in.ss4(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.ss4(1:length(tout),1:length(f)) = NaN;
    PSx.in.ss4(1:length(tout),1:length(f)) = NaN;
    PSy.in.ss4(1:length(tout),1:length(f)) = NaN;
    
    coh.out.ss4(1:length(tout),1:length(f)) = NaN;
    Sx.out.ss4(1:length(tout),1:length(f)) = NaN;
    Sy.out.ss4(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.ss4(1:length(tout),1:length(f)) = NaN;
    PSx.out.ss4(1:length(tout),1:length(f)) = NaN;
    PSy.out.ss4(1:length(tout),1:length(f)) = NaN;
end


% SS8
try
    [coh.in.ss8,f,tout,Sx.in.ss8,Sy.in.ss8,Pcoh.in.ss8,PSx.in.ss8,PSy.in.ss8] = Spk_LFPCoh(sig2(in.ss8,:),sig1(in.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.ss8,f,tout,Sx.out.ss8,Sy.out.ss8,Pcoh.out.ss8,PSx.out.ss8,PSy.out.ss8] = Spk_LFPCoh(sig2(out.ss8,:),sig1(out.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('SS8')
catch
    disp('Failed to Calculate SS8')
    coh.in.ss8(1:length(tout),1:length(f)) = NaN;
    Sx.in.ss8(1:length(tout),1:length(f)) = NaN;
    Sy.in.ss8(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.ss8(1:length(tout),1:length(f)) = NaN;
    PSx.in.ss8(1:length(tout),1:length(f)) = NaN;
    PSy.in.ss8(1:length(tout),1:length(f)) = NaN;
    
    coh.out.ss8(1:length(tout),1:length(f)) = NaN;
    Sx.out.ss8(1:length(tout),1:length(f)) = NaN;
    Sy.out.ss8(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.ss8(1:length(tout),1:length(f)) = NaN;
    PSx.out.ss8(1:length(tout),1:length(f)) = NaN;
    PSy.out.ss8(1:length(tout),1:length(f)) = NaN;
end


% FAST, SS2
try
    [coh.in.fast.ss2,f,tout,Sx.in.fast.ss2,Sy.in.fast.ss2,Pcoh.in.fast.ss2,PSx.in.fast.ss2,PSy.in.fast.ss2] = Spk_LFPCoh(sig2(in.fast.ss2,:),sig1(in.fast.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.fast.ss2,f,tout,Sx.out.fast.ss2,Sy.out.fast.ss2,Pcoh.out.fast.ss2,PSx.out.fast.ss2,PSy.out.fast.ss2] = Spk_LFPCoh(sig2(out.fast.ss2,:),sig1(out.fast.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Fast, SS2')
catch
    disp('Failed to Calculate Fast_SS2')
    coh.in.fast.ss2(1:length(tout),1:length(f)) = NaN;
    Sx.in.fast.ss2(1:length(tout),1:length(f)) = NaN;
    Sy.in.fast.ss2(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.fast.ss2(1:length(tout),1:length(f)) = NaN;
    PSx.in.fast.ss2(1:length(tout),1:length(f)) = NaN;
    PSy.in.fast.ss2(1:length(tout),1:length(f)) = NaN;
    
    coh.out.fast.ss2(1:length(tout),1:length(f)) = NaN;
    Sx.out.fast.ss2(1:length(tout),1:length(f)) = NaN;
    Sy.out.fast.ss2(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.fast.ss2(1:length(tout),1:length(f)) = NaN;
    PSx.out.fast.ss2(1:length(tout),1:length(f)) = NaN;
    PSy.out.fast.ss2(1:length(tout),1:length(f)) = NaN;
    
end


% FAST, SS4
try
    [coh.in.fast.ss4,f,tout,Sx.in.fast.ss4,Sy.in.fast.ss4,Pcoh.in.fast.ss4,PSx.in.fast.ss4,PSy.in.fast.ss4] = Spk_LFPCoh(sig2(in.fast.ss4,:),sig1(in.fast.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.fast.ss4,f,tout,Sx.out.fast.ss4,Sy.out.fast.ss4,Pcoh.out.fast.ss4,PSx.out.fast.ss4,PSy.out.fast.ss4] = Spk_LFPCoh(sig2(out.fast.ss4,:),sig1(out.fast.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Fast, SS4')
catch
    disp('Failed to Calculate Fast_SS4')
    coh.in.fast.ss4(1:length(tout),1:length(f)) = NaN;
    Sx.in.fast.ss4(1:length(tout),1:length(f)) = NaN;
    Sy.in.fast.ss4(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.fast.ss4(1:length(tout),1:length(f)) = NaN;
    PSx.in.fast.ss4(1:length(tout),1:length(f)) = NaN;
    PSy.in.fast.ss4(1:length(tout),1:length(f)) = NaN;
    
    coh.out.fast.ss4(1:length(tout),1:length(f)) = NaN;
    Sx.out.fast.ss4(1:length(tout),1:length(f)) = NaN;
    Sy.out.fast.ss4(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.fast.ss4(1:length(tout),1:length(f)) = NaN;
    PSx.out.fast.ss4(1:length(tout),1:length(f)) = NaN;
    PSy.out.fast.ss4(1:length(tout),1:length(f)) = NaN;
    
end


% FAST, SS8
try
    [coh.in.fast.ss8,f,tout,Sx.in.fast.ss8,Sy.in.fast.ss8,Pcoh.in.fast.ss8,PSx.in.fast.ss8,PSy.in.fast.ss8] = Spk_LFPCoh(sig2(in.fast.ss8,:),sig1(in.fast.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.fast.ss8,f,tout,Sx.out.fast.ss8,Sy.out.fast.ss8,Pcoh.out.fast.ss8,PSx.out.fast.ss8,PSy.out.fast.ss8] = Spk_LFPCoh(sig2(out.fast.ss8,:),sig1(out.fast.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Fast, SS8')
catch
    disp('Failed to Calculate Fast_SS8')
    coh.in.fast.ss8(1:length(tout),1:length(f)) = NaN;
    Sx.in.fast.ss8(1:length(tout),1:length(f)) = NaN;
    Sy.in.fast.ss8(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.fast.ss8(1:length(tout),1:length(f)) = NaN;
    PSx.in.fast.ss8(1:length(tout),1:length(f)) = NaN;
    PSy.in.fast.ss8(1:length(tout),1:length(f)) = NaN;
    
    coh.out.fast.ss8(1:length(tout),1:length(f)) = NaN;
    Sx.out.fast.ss8(1:length(tout),1:length(f)) = NaN;
    Sy.out.fast.ss8(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.fast.ss8(1:length(tout),1:length(f)) = NaN;
    PSx.out.fast.ss8(1:length(tout),1:length(f)) = NaN;
    PSy.out.fast.ss8(1:length(tout),1:length(f)) = NaN;
    
end


% SLOW, SS2
try
    [coh.in.slow.ss2,f,tout,Sx.in.slow.ss2,Sy.in.slow.ss2,Pcoh.in.slow.ss2,PSx.in.slow.ss2,PSy.in.slow.ss2] = Spk_LFPCoh(sig2(in.slow.ss2,:),sig1(in.slow.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.slow.ss2,f,tout,Sx.out.slow.ss2,Sy.out.slow.ss2,Pcoh.out.slow.ss2,PSx.out.slow.ss2,PSy.out.slow.ss2] = Spk_LFPCoh(sig2(out.slow.ss2,:),sig1(out.slow.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Slow, SS2')
catch
    disp('Failed to Calculate Slow_SS2')
    coh.in.slow.ss2(1:length(tout),1:length(f)) = NaN;
    Sx.in.slow.ss2(1:length(tout),1:length(f)) = NaN;
    Sy.in.slow.ss2(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.slow.ss2(1:length(tout),1:length(f)) = NaN;
    PSx.in.slow.ss2(1:length(tout),1:length(f)) = NaN;
    PSy.in.slow.ss2(1:length(tout),1:length(f)) = NaN;
    
    coh.out.slow.ss2(1:length(tout),1:length(f)) = NaN;
    Sx.out.slow.ss2(1:length(tout),1:length(f)) = NaN;
    Sy.out.slow.ss2(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.slow.ss2(1:length(tout),1:length(f)) = NaN;
    PSx.out.slow.ss2(1:length(tout),1:length(f)) = NaN;
    PSy.out.slow.ss2(1:length(tout),1:length(f)) = NaN;
    
end


% SLOW SS4
try
    [coh.in.slow.ss4,f,tout,Sx.in.slow.ss4,Sy.in.slow.ss4,Pcoh.in.slow.ss4,PSx.in.slow.ss4,PSy.in.slow.ss4] = Spk_LFPCoh(sig2(in.slow.ss4,:),sig1(in.slow.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.slow.ss4,f,tout,Sx.out.slow.ss4,Sy.out.slow.ss4,Pcoh.out.slow.ss4,PSx.out.slow.ss4,PSy.out.slow.ss4] = Spk_LFPCoh(sig2(out.slow.ss4,:),sig1(out.slow.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Slow, SS4')
catch
    disp('Failed to Calculate Slow_SS4')
    coh.in.slow.ss4(1:length(tout),1:length(f)) = NaN;
    Sx.in.slow.ss4(1:length(tout),1:length(f)) = NaN;
    Sy.in.slow.ss4(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.slow.ss4(1:length(tout),1:length(f)) = NaN;
    PSx.in.slow.ss4(1:length(tout),1:length(f)) = NaN;
    PSy.in.slow.ss4(1:length(tout),1:length(f)) = NaN;
    
    coh.out.slow.ss4(1:length(tout),1:length(f)) = NaN;
    Sx.out.slow.ss4(1:length(tout),1:length(f)) = NaN;
    Sy.out.slow.ss4(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.slow.ss4(1:length(tout),1:length(f)) = NaN;
    PSx.out.slow.ss4(1:length(tout),1:length(f)) = NaN;
    PSy.out.slow.ss4(1:length(tout),1:length(f)) = NaN;
    
end


% SLOW, SS8
try
    [coh.in.slow.ss8,f,tout,Sx.in.slow.ss8,Sy.in.slow.ss8,Pcoh.in.slow.ss8,PSx.in.slow.ss8,PSy.in.slow.ss8] = Spk_LFPCoh(sig2(in.slow.ss8,:),sig1(in.slow.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.slow.ss8,f,tout,Sx.out.slow.ss8,Sy.out.slow.ss8,Pcoh.out.slow.ss8,PSx.out.slow.ss8,PSy.out.slow.ss8] = Spk_LFPCoh(sig2(out.slow.ss8,:),sig1(out.slow.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Slow, SS8')
catch
    disp('Failed to Calculate Slow_SS8')
    coh.in.slow.ss8(1:length(tout),1:length(f)) = NaN;
    Sx.in.slow.ss8(1:length(tout),1:length(f)) = NaN;
    Sy.in.slow.ss8(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.slow.ss8(1:length(tout),1:length(f)) = NaN;
    PSx.in.slow.ss8(1:length(tout),1:length(f)) = NaN;
    PSy.in.slow.ss8(1:length(tout),1:length(f)) = NaN;
    
    coh.out.slow.ss8(1:length(tout),1:length(f)) = NaN;
    Sx.out.slow.ss8(1:length(tout),1:length(f)) = NaN;
    Sy.out.slow.ss8(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.slow.ss8(1:length(tout),1:length(f)) = NaN;
    PSx.out.slow.ss8(1:length(tout),1:length(f)) = NaN;
    PSy.out.slow.ss8(1:length(tout),1:length(f)) = NaN;
    
end


% FAST, ALL SET SIZES
try
    [coh.in.fast.all,f,tout,Sx.in.fast.all,Sy.in.fast.all,Pcoh.in.fast.all,PSx.in.fast.all,PSy.in.fast.all] = Spk_LFPCoh(sig2(in.fast.all,:),sig1(in.fast.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.fast.all,f,tout,Sx.out.fast.all,Sy.out.fast.all,Pcoh.out.fast.all,PSx.out.fast.all,PSy.out.fast.all] = Spk_LFPCoh(sig2(out.fast.all,:),sig1(out.fast.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Fast, all SS')
catch
    disp('Failed to Calculate Fast_All')
    coh.in.fast.all(1:length(tout),1:length(f)) = NaN;
    Sx.in.fast.all(1:length(tout),1:length(f)) = NaN;
    Sy.in.fast.all(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.fast.all(1:length(tout),1:length(f)) = NaN;
    PSx.in.fast.all(1:length(tout),1:length(f)) = NaN;
    PSy.in.fast.all(1:length(tout),1:length(f)) = NaN;
    
    coh.out.fast.all(1:length(tout),1:length(f)) = NaN;
    Sx.out.fast.all(1:length(tout),1:length(f)) = NaN;
    Sy.out.fast.all(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.fast.all(1:length(tout),1:length(f)) = NaN;
    PSx.out.fast.all(1:length(tout),1:length(f)) = NaN;
    PSy.out.fast.all(1:length(tout),1:length(f)) = NaN;
    
end


% SLOW, ALL SET SIZES
try
    [coh.in.slow.all,f,tout,Sx.in.slow.all,Sy.in.slow.all,Pcoh.in.slow.all,PSx.in.slow.all,PSy.in.slow.all] = Spk_LFPCoh(sig2(in.slow.all,:),sig1(in.slow.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    [coh.out.slow.all,f,tout,Sx.out.slow.all,Sy.out.slow.all,Pcoh.out.slow.all,PSx.out.slow.all,PSy.out.slow.all] = Spk_LFPCoh(sig2(out.slow.all,:),sig1(out.slow.all,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
    disp('Slow, all SS')
catch
    disp('Failed to Calculate Slow_All')
    coh.in.slow.all(1:length(tout),1:length(f)) = NaN;
    Sx.in.slow.all(1:length(tout),1:length(f)) = NaN;
    Sy.in.slow.all(1:length(tout),1:length(f)) = NaN;
    Pcoh.in.slow.all(1:length(tout),1:length(f)) = NaN;
    PSx.in.slow.all(1:length(tout),1:length(f)) = NaN;
    PSy.in.slow.all(1:length(tout),1:length(f)) = NaN;
    
    coh.out.slow.all(1:length(tout),1:length(f)) = NaN;
    Sx.out.slow.all(1:length(tout),1:length(f)) = NaN;
    Sy.out.slow.all(1:length(tout),1:length(f)) = NaN;
    Pcoh.out.slow.all(1:length(tout),1:length(f)) = NaN;
    PSx.out.slow.all(1:length(tout),1:length(f)) = NaN;
    PSy.out.slow.all(1:length(tout),1:length(f)) = NaN;
    
end


% ERROR TRIALS
if errskip == 0
    try
        [coh.in.err,f,tout,Sx.in.err,Sy.in.err,Pcoh.in.err,PSx.in.err,PSy.in.err] = Spk_LFPCoh(sig2(in.err,:),sig1(in.err,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
        [coh.out.err,f,tout,Sx.out.err,Sy.out.err,Pcoh.out.err,PSx.out.err,PSy.out.err] = Spk_LFPCoh(sig2(out.err,:),sig1(out.err,:),tapers,-500,[-500 2500], 1000, .01, [0 200],0,4,.05,0,2,2);
        disp('Errors')
    catch
        disp('Failed to Calculate Errors')
    end
    
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


% SUB-SAMPLING ROUTINE TO EXAMINE HOW LEVELS OF COHERENCE CHANGE W/
% RESTRICTED NUMBERS OF TRIALS FOR ERRORS
%==============================================
% Do subsampling of correct trials for comparison with error trials

if errskip == 0
    for rep = 1:nReps
        if mod(rep,100) == 0
            disp(rep);
        end
        
        in.all_sub = shake(in.all);
        in.all_sub = in.all_sub(randperm(length(in.err)));
        
        out.all_sub = shake(out.all);
        out.all_sub = out.all_sub(randperm(length(out.err)));
        
        [tempcoh.in.all_sub, f, tout, tempSx.in.all_sub, tempSy.in.all_sub, tempPcoh.in.all_sub, tempPSx.in.all_sub, tempPSy.in.all_sub] = Spk_LFPCoh(sig2(in.all_sub,:),sig1(in.all_sub,:),tapers,-500,[-500 2500],1000,.01,[0 200],0,4,.05,0,2,2);
        [tempcoh.out.all_sub, f, tout, tempSx.out.all_sub, tempSy.out.all_sub, tempPcoh.out.all_sub, tempPSx.out.all_sub, tempPSy.out.all_sub] = Spk_LFPCoh(sig2(out.all_sub,:),sig1(out.all_sub,:),tapers,-500,[-500 2500],1000,.01,[0 200],0,4,.05,0,2,2);
        
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

if SendEmails == 1
    SendEmailNotification('richard.p.heitz@vanderbilt.edu','About to Save',['file = ' file_name '_' sig1_name sig2_name])
end


if shuffFlag == 1 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/Uber_Tune_NeuronRF_intersection_shuff/nooverlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'within_cond_shuff','between_cond_shuff','coh','f','f_shuff','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
elseif shuffFlag == 0 & saveFlag == 1
    save(['//scratch/heitzrp/Output/Coherence/Uber_Tune_NeuronRF_intersection_shuff/nooverlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh','f','f_shuff','n','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','wf','TDT','-mat')
end


