%partial coherence for SPK-LFP comparisons
%
%Calculates fast vs slow coherence separately for each set size.

function [] = pCOH_SPKLFP_Tune_NeurRF_isect_local_overlap_ss_fast_slow(file_name,sig1_name,sig2_name)
% 
% path(path,'//scratch/heitzrp/')
% path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;

file_name


load(file_name,sig1_name,sig2_name, ...
    'EyeX_','EyeY_','Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_')

fixErrors

%get saccade locations for error trials
[SRT saccLoc] = getSRT(EyeX_,EyeY_);

clear EyeX_ EyeY_

sig1 = eval(sig1_name);
sig2 = eval(sig2_name);


tapers = PreGenTapers([.2 5]);

%use selectivity of LFP to determine its RF
[RF1 ~] = LFPtuning(sig1);

RF2 = RFs.(sig2_name);

RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);

%now invert LFP so phase plots are correct
sig1 = sig1 * -1;

% Do median split for fast/slow comparison
cMed.ss2 = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
cMed.ss4 = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
cMed.ss8 = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));


in.fast.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed.ss2 & SRT(:,1) > 50);
in.slow.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed.ss2 & SRT(:,1) < 2000);
out.fast.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed.ss2 & SRT(:,1) > 50);
out.slow.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed.ss2 & SRT(:,1) < 2000);

in.fast.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed.ss4 & SRT(:,1) > 50);
in.slow.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed.ss4 & SRT(:,1) < 2000);
out.fast.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed.ss4 & SRT(:,1) > 50);
out.slow.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed.ss4 & SRT(:,1) < 2000);
  
in.fast.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed.ss8 & SRT(:,1) > 50);
in.slow.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed.ss8 & SRT(:,1) < 2000);
out.fast.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed.ss8 & SRT(:,1) > 50);
out.slow.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed.ss8 & SRT(:,1) < 2000);
 

%fix Spike channel; change 0's to NaN and alter times
sig2(sig2 == 0) = NaN;
sig2 = sig2 - 500;


%without shuffling (pad = 4)
%ClusShuffOpts.TestType = 1;
[coh.in.fast.ss2,f,tout,Sx.in.fast.ss2,Sy.in.fast.ss2,Pcoh.in.fast.ss2,PSx.in.fast.ss2,PSy.in.fast.ss2] = Spk_LFPCoh(sig2(in.fast.ss2,:),sig1(in.fast.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.fast.ss2,f,tout,Sx.out.fast.ss2,Sy.out.fast.ss2,Pcoh.out.fast.ss2,PSx.out.fast.ss2,PSy.out.fast.ss2] = Spk_LFPCoh(sig2(out.fast.ss2,:),sig1(out.fast.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.in.fast.ss4,f,tout,Sx.in.fast.ss4,Sy.in.fast.ss4,Pcoh.in.fast.ss4,PSx.in.fast.ss4,PSy.in.fast.ss4] = Spk_LFPCoh(sig2(in.fast.ss4,:),sig1(in.fast.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.fast.ss4,f,tout,Sx.out.fast.ss4,Sy.out.fast.ss4,Pcoh.out.fast.ss4,PSx.out.fast.ss4,PSy.out.fast.ss4] = Spk_LFPCoh(sig2(out.fast.ss4,:),sig1(out.fast.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.in.fast.ss8,f,tout,Sx.in.fast.ss8,Sy.in.fast.ss8,Pcoh.in.fast.ss8,PSx.in.fast.ss8,PSy.in.fast.ss8] = Spk_LFPCoh(sig2(in.fast.ss8,:),sig1(in.fast.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.fast.ss8,f,tout,Sx.out.fast.ss8,Sy.out.fast.ss8,Pcoh.out.fast.ss8,PSx.out.fast.ss8,PSy.out.fast.ss8] = Spk_LFPCoh(sig2(out.fast.ss8,:),sig1(out.fast.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.in.slow.ss2,f,tout,Sx.in.slow.ss2,Sy.in.slow.ss2,Pcoh.in.slow.ss2,PSx.in.slow.ss2,PSy.in.slow.ss2] = Spk_LFPCoh(sig2(in.slow.ss2,:),sig1(in.slow.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.slow.ss2,f,tout,Sx.out.slow.ss2,Sy.out.slow.ss2,Pcoh.out.slow.ss2,PSx.out.slow.ss2,PSy.out.slow.ss2] = Spk_LFPCoh(sig2(out.slow.ss2,:),sig1(out.slow.ss2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
 
[coh.in.slow.ss4,f,tout,Sx.in.slow.ss4,Sy.in.slow.ss4,Pcoh.in.slow.ss4,PSx.in.slow.ss4,PSy.in.slow.ss4] = Spk_LFPCoh(sig2(in.slow.ss4,:),sig1(in.slow.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.slow.ss4,f,tout,Sx.out.slow.ss4,Sy.out.slow.ss4,Pcoh.out.slow.ss4,PSx.out.slow.ss4,PSy.out.slow.ss4] = Spk_LFPCoh(sig2(out.slow.ss4,:),sig1(out.slow.ss4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
 
[coh.in.slow.ss8,f,tout,Sx.in.slow.ss8,Sy.in.slow.ss8,Pcoh.in.slow.ss8,PSx.in.slow.ss8,PSy.in.slow.ss8] = Spk_LFPCoh(sig2(in.slow.ss8,:),sig1(in.slow.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.slow.ss8,f,tout,Sx.out.slow.ss8,Sy.out.slow.ss8,Pcoh.out.slow.ss8,PSx.out.slow.ss8,PSy.out.slow.ss8] = Spk_LFPCoh(sig2(out.slow.ss8,:),sig1(out.slow.ss8,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);


%=======================

%==============================================
% Do subsampling of correct trials for comparison with error trials





if saveFlag == 1
    save(['/volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_ss_fast_slow/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'coh','f','tout','Sx','Sy', ...
        'Pcoh','PSx','PSy','-mat')
end


