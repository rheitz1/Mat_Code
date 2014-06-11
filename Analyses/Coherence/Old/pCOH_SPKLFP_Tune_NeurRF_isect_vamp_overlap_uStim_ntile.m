%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.

function [] = pCOH_SPKLFP_Tune_NeurRF_isect_vamp_overlap_uStim_ntile(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;

file_name

load(file_name,sig1_name,sig2_name, ...
    'MStim_','Target_','Correct_','RFs','Hemi','SRT','TrialStart_')

sig1 = eval(sig1_name);
sig2 = eval(sig2_name);


%MAKE SURE THAT ALL SET SIZES ARE REPRESENTED IN FILE
if (length(find(Target_(:,5) == 2)) < 10 || length(find(Target_(:,5) == 4)) < 10 || length(find(Target_(:,5) == 8)) < 10)
    disp('Less than 10 trials of a specific set size...aborting.')
    return
end


tapers = PreGenTapers([.2 5]);


%use selectivity of LFP to determine its RF
[RF1 ~] = LFPtuning(sig1);

RF2 = RFs.(sig2_name);

RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);

%now invert LFP so phase plots are correct
sig1 = sig1 * -1;

% Do median split for fast/slow comparison
nTiles.ss2 = prctile(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1),[25 50 75]);
nTiles.ss4 = prctile(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1),[25 50 75]);
nTiles.ss8 = prctile(SRT(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1),[25 50 75]);

in.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out.all = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

in.ss2.bin1 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) <= nTiles.ss2(1));
in.ss2.bin2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(1) & SRT(:,1) <= nTiles.ss2(2));
in.ss2.bin3 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(2) & SRT(:,1) <= nTiles.ss2(3));
in.ss2.bin4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(3) & SRT(:,1) < 2000);


out.ss2.bin1 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) <= nTiles.ss2(1));
out.ss2.bin2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(1) & SRT(:,1) <= nTiles.ss2(2));
out.ss2.bin3 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(2) & SRT(:,1) <= nTiles.ss2(3));
out.ss2.bin4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(3) & SRT(:,1) < 2000);


%not removing MStim trials from SRT calculation
RT.ss2.bin1 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) < nTiles.ss2(1)),1));
RT.ss2.bin2 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(1) & SRT(:,1) <= nTiles.ss2(2)),1));
RT.ss2.bin3 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(2) & SRT(:,1) <= nTiles.ss2(3)),1));
RT.ss2.bin4 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) > nTiles.ss2(3) & SRT(:,1) <= 2000),1));


in.ss4.bin1 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) <= nTiles.ss4(1));
in.ss4.bin2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(1) & SRT(:,1) <= nTiles.ss4(2));
in.ss4.bin3 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(2) & SRT(:,1) <= nTiles.ss4(3));
in.ss4.bin4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(3) & SRT(:,1) < 2000);

out.ss4.bin1 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) <= nTiles.ss4(1));
out.ss4.bin2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(1) & SRT(:,1) <= nTiles.ss4(2));
out.ss4.bin3 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(2) & SRT(:,1) <= nTiles.ss4(3));
out.ss4.bin4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(3) & SRT(:,1) < 2000);

%not removing MStim trials from SRT calculation
RT.ss4.bin1 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) < nTiles.ss4(1)),1));
RT.ss4.bin2 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(1) & SRT(:,1) <= nTiles.ss4(2)),1));
RT.ss4.bin3 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(2) & SRT(:,1) <= nTiles.ss4(3)),1));
RT.ss4.bin4 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) > nTiles.ss4(3) & SRT(:,1) <= 2000),1));


in.ss8.bin1 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 & SRT(:,1) > 50 & SRT(:,1) <= nTiles.ss8(1));
in.ss8.bin2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(1) & SRT(:,1) <= nTiles.ss8(2));
in.ss8.bin3 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(2) & SRT(:,1) <= nTiles.ss8(3));
in.ss8.bin4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(3) & SRT(:,1) < 2000);

out.ss8.bin1 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 &SRT(:,1) > 50 & SRT(:,1) <= nTiles.ss8(1));
out.ss8.bin2 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(1) & SRT(:,1) <= nTiles.ss8(2));
out.ss8.bin3 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(2) & SRT(:,1) <= nTiles.ss8(3));
out.ss8.bin4 = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(3) & SRT(:,1) < 2000);

%not removing MStim trials from SRT calculation
RT.ss8.bin1 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 &SRT(:,1) > 50 & SRT(:,1) < nTiles.ss8(1)),1));
RT.ss8.bin2 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(1) & SRT(:,1) <= nTiles.ss8(2)),1));
RT.ss8.bin3 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(2) & SRT(:,1) <= nTiles.ss8(3)),1));
RT.ss8.bin4 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 &SRT(:,1) > nTiles.ss8(3) & SRT(:,1) <= 2000),1));



%make fast vs slow groups too
in.ss2.bin12 = [in.ss2.bin1;in.ss2.bin2];
in.ss4.bin12 = [in.ss4.bin1;in.ss4.bin2];
in.ss8.bin12 = [in.ss8.bin1;in.ss8.bin2];

in.ss2.bin34 = [in.ss2.bin3;in.ss2.bin4];
in.ss4.bin34 = [in.ss4.bin3;in.ss4.bin4];
in.ss8.bin34 = [in.ss8.bin3;in.ss8.bin4];

out.ss2.bin12 = [out.ss2.bin1;out.ss2.bin2];
out.ss4.bin12 = [out.ss4.bin1;out.ss4.bin2];
out.ss8.bin12 = [out.ss8.bin1;out.ss8.bin2];
 
out.ss2.bin34 = [out.ss2.bin3;out.ss2.bin4];
out.ss4.bin34 = [out.ss4.bin3;out.ss4.bin4];
out.ss8.bin34 = [out.ss8.bin3;out.ss8.bin4];

%Not removing MStim trials from SRT calculation
RT.ss2.bin12 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) > 50 & SRT(:,1) < nTiles.ss2(3)),1));
RT.ss2.bin34 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) >= nTiles.ss2(3) & SRT(:,1) < 2000),1));

RT.ss4.bin12 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) > 50 & SRT(:,1) < nTiles.ss4(3)),1));
RT.ss4.bin34 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) >= nTiles.ss4(3) & SRT(:,1) < 2000),1));

RT.ss8.bin12 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) > 50 & SRT(:,1) < nTiles.ss8(3)),1));
RT.ss8.bin34 = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) >= nTiles.ss8(3) & SRT(:,1) < 2000),1));

%fix Spike channel; change 0's to NaN and alter times
sig2(sig2 == 0) = NaN;
sig2 = sig2 - 500;


%=======================
% Tin vs Din, all trials

%without shuffling (pad == 4) & no tests
[coh.all.in,f,tout,Sx.all.in,Sy.all.in,Pcoh.all.in,PSx.all.in,PSy.all.in] = Spk_LFPCoh(sig2(in.all,:),sig1(in.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.all.out,f,tout,Sx.all.out,Sy.all.out,Pcoh.all.out,PSx.all.out,PSy.all.out] = Spk_LFPCoh(sig2(out.all,:),sig1(out.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss2.in.bin1,f,tout,Sx.ss2.in.bin1,Sy.ss2.in.bin1,Pcoh.ss2.in.bin1,PSx.ss2.in.bin1,PSy.ss2.in.bin1] = Spk_LFPCoh(sig2(in.ss2.bin1,:),sig1(in.ss2.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.in.bin2,f,tout,Sx.ss2.in.bin2,Sy.ss2.in.bin2,Pcoh.ss2.in.bin2,PSx.ss2.in.bin2,PSy.ss2.in.bin2] = Spk_LFPCoh(sig2(in.ss2.bin2,:),sig1(in.ss2.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.in.bin3,f,tout,Sx.ss2.in.bin3,Sy.ss2.in.bin3,Pcoh.ss2.in.bin3,PSx.ss2.in.bin3,PSy.ss2.in.bin3] = Spk_LFPCoh(sig2(in.ss2.bin3,:),sig1(in.ss2.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.in.bin4,f,tout,Sx.ss2.in.bin4,Sy.ss2.in.bin4,Pcoh.ss2.in.bin4,PSx.ss2.in.bin4,PSy.ss2.in.bin4] = Spk_LFPCoh(sig2(in.ss2.bin4,:),sig1(in.ss2.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss2.out.bin1,f,tout,Sx.ss2.out.bin1,Sy.ss2.out.bin1,Pcoh.ss2.out.bin1,PSx.ss2.out.bin1,PSy.ss2.out.bin1] = Spk_LFPCoh(sig2(out.ss2.bin1,:),sig1(out.ss2.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.out.bin2,f,tout,Sx.ss2.out.bin2,Sy.ss2.out.bin2,Pcoh.ss2.out.bin2,PSx.ss2.out.bin2,PSy.ss2.out.bin2] = Spk_LFPCoh(sig2(out.ss2.bin2,:),sig1(out.ss2.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.out.bin3,f,tout,Sx.ss2.out.bin3,Sy.ss2.out.bin3,Pcoh.ss2.out.bin3,PSx.ss2.out.bin3,PSy.ss2.out.bin3] = Spk_LFPCoh(sig2(out.ss2.bin3,:),sig1(out.ss2.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.out.bin4,f,tout,Sx.ss2.out.bin4,Sy.ss2.out.bin4,Pcoh.ss2.out.bin4,PSx.ss2.out.bin4,PSy.ss2.out.bin4] = Spk_LFPCoh(sig2(out.ss2.bin4,:),sig1(out.ss2.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss4.in.bin1,f,tout,Sx.ss4.in.bin1,Sy.ss4.in.bin1,Pcoh.ss4.in.bin1,PSx.ss4.in.bin1,PSy.ss4.in.bin1] = Spk_LFPCoh(sig2(in.ss4.bin1,:),sig1(in.ss4.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.in.bin2,f,tout,Sx.ss4.in.bin2,Sy.ss4.in.bin2,Pcoh.ss4.in.bin2,PSx.ss4.in.bin2,PSy.ss4.in.bin2] = Spk_LFPCoh(sig2(in.ss4.bin2,:),sig1(in.ss4.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.in.bin3,f,tout,Sx.ss4.in.bin3,Sy.ss4.in.bin3,Pcoh.ss4.in.bin3,PSx.ss4.in.bin3,PSy.ss4.in.bin3] = Spk_LFPCoh(sig2(in.ss4.bin3,:),sig1(in.ss4.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.in.bin4,f,tout,Sx.ss4.in.bin4,Sy.ss4.in.bin4,Pcoh.ss4.in.bin4,PSx.ss4.in.bin4,PSy.ss4.in.bin4] = Spk_LFPCoh(sig2(in.ss4.bin4,:),sig1(in.ss4.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss4.out.bin1,f,tout,Sx.ss4.out.bin1,Sy.ss4.out.bin1,Pcoh.ss4.out.bin1,PSx.ss4.out.bin1,PSy.ss4.out.bin1] = Spk_LFPCoh(sig2(out.ss4.bin1,:),sig1(out.ss4.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.out.bin2,f,tout,Sx.ss4.out.bin2,Sy.ss4.out.bin2,Pcoh.ss4.out.bin2,PSx.ss4.out.bin2,PSy.ss4.out.bin2] = Spk_LFPCoh(sig2(out.ss4.bin2,:),sig1(out.ss4.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.out.bin3,f,tout,Sx.ss4.out.bin3,Sy.ss4.out.bin3,Pcoh.ss4.out.bin3,PSx.ss4.out.bin3,PSy.ss4.out.bin3] = Spk_LFPCoh(sig2(out.ss4.bin3,:),sig1(out.ss4.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.out.bin4,f,tout,Sx.ss4.out.bin4,Sy.ss4.out.bin4,Pcoh.ss4.out.bin4,PSx.ss4.out.bin4,PSy.ss4.out.bin4] = Spk_LFPCoh(sig2(out.ss4.bin4,:),sig1(out.ss4.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss8.in.bin1,f,tout,Sx.ss8.in.bin1,Sy.ss8.in.bin1,Pcoh.ss8.in.bin1,PSx.ss8.in.bin1,PSy.ss8.in.bin1] = Spk_LFPCoh(sig2(in.ss8.bin1,:),sig1(in.ss8.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.in.bin2,f,tout,Sx.ss8.in.bin2,Sy.ss8.in.bin2,Pcoh.ss8.in.bin2,PSx.ss8.in.bin2,PSy.ss8.in.bin2] = Spk_LFPCoh(sig2(in.ss8.bin2,:),sig1(in.ss8.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.in.bin3,f,tout,Sx.ss8.in.bin3,Sy.ss8.in.bin3,Pcoh.ss8.in.bin3,PSx.ss8.in.bin3,PSy.ss8.in.bin3] = Spk_LFPCoh(sig2(in.ss8.bin3,:),sig1(in.ss8.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.in.bin4,f,tout,Sx.ss8.in.bin4,Sy.ss8.in.bin4,Pcoh.ss8.in.bin4,PSx.ss8.in.bin4,PSy.ss8.in.bin4] = Spk_LFPCoh(sig2(in.ss8.bin4,:),sig1(in.ss8.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss8.out.bin1,f,tout,Sx.ss8.out.bin1,Sy.ss8.out.bin1,Pcoh.ss8.out.bin1,PSx.ss8.out.bin1,PSy.ss8.out.bin1] = Spk_LFPCoh(sig2(out.ss8.bin1,:),sig1(out.ss8.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.out.bin2,f,tout,Sx.ss8.out.bin2,Sy.ss8.out.bin2,Pcoh.ss8.out.bin2,PSx.ss8.out.bin2,PSy.ss8.out.bin2] = Spk_LFPCoh(sig2(out.ss8.bin2,:),sig1(out.ss8.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.out.bin3,f,tout,Sx.ss8.out.bin3,Sy.ss8.out.bin3,Pcoh.ss8.out.bin3,PSx.ss8.out.bin3,PSy.ss8.out.bin3] = Spk_LFPCoh(sig2(out.ss8.bin3,:),sig1(out.ss8.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.out.bin4,f,tout,Sx.ss8.out.bin4,Sy.ss8.out.bin4,Pcoh.ss8.out.bin4,PSx.ss8.out.bin4,PSy.ss8.out.bin4] = Spk_LFPCoh(sig2(out.ss8.bin4,:),sig1(out.ss8.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);


[coh.ss2.in.bin12,f,tout,Sx.ss2.in.bin12,Sy.ss2.in.bin12,Pcoh.ss2.in.bin12,PSx.ss2.in.bin12,PSy.ss2.in.bin12] = Spk_LFPCoh(sig2(in.ss2.bin12,:),sig1(in.ss2.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.out.bin12,f,tout,Sx.ss2.out.bin12,Sy.ss2.out.bin12,Pcoh.ss2.out.bin12,PSx.ss2.out.bin12,PSy.ss2.out.bin12] = Spk_LFPCoh(sig2(out.ss2.bin12,:),sig1(out.ss2.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss4.in.bin12,f,tout,Sx.ss4.in.bin12,Sy.ss4.in.bin12,Pcoh.ss4.in.bin12,PSx.ss4.in.bin12,PSy.ss4.in.bin12] = Spk_LFPCoh(sig2(in.ss4.bin12,:),sig1(in.ss4.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.out.bin12,f,tout,Sx.ss4.out.bin12,Sy.ss4.out.bin12,Pcoh.ss4.out.bin12,PSx.ss4.out.bin12,PSy.ss4.out.bin12] = Spk_LFPCoh(sig2(out.ss4.bin12,:),sig1(out.ss4.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss8.in.bin12,f,tout,Sx.ss8.in.bin12,Sy.ss8.in.bin12,Pcoh.ss8.in.bin12,PSx.ss8.in.bin12,PSy.ss8.in.bin12] = Spk_LFPCoh(sig2(in.ss8.bin12,:),sig1(in.ss8.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.out.bin12,f,tout,Sx.ss8.out.bin12,Sy.ss8.out.bin12,Pcoh.ss8.out.bin12,PSx.ss8.out.bin12,PSy.ss8.out.bin12] = Spk_LFPCoh(sig2(out.ss8.bin12,:),sig1(out.ss8.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.ss2.in.bin34,f,tout,Sx.ss2.in.bin34,Sy.ss2.in.bin34,Pcoh.ss2.in.bin34,PSx.ss2.in.bin34,PSy.ss2.in.bin34] = Spk_LFPCoh(sig2(in.ss2.bin34,:),sig1(in.ss2.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss2.out.bin34,f,tout,Sx.ss2.out.bin34,Sy.ss2.out.bin34,Pcoh.ss2.out.bin34,PSx.ss2.out.bin34,PSy.ss2.out.bin34] = Spk_LFPCoh(sig2(out.ss2.bin34,:),sig1(out.ss2.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
 
[coh.ss4.in.bin34,f,tout,Sx.ss4.in.bin34,Sy.ss4.in.bin34,Pcoh.ss4.in.bin34,PSx.ss4.in.bin34,PSy.ss4.in.bin34] = Spk_LFPCoh(sig2(in.ss4.bin34,:),sig1(in.ss4.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss4.out.bin34,f,tout,Sx.ss4.out.bin34,Sy.ss4.out.bin34,Pcoh.ss4.out.bin34,PSx.ss4.out.bin34,PSy.ss4.out.bin34] = Spk_LFPCoh(sig2(out.ss4.bin34,:),sig1(out.ss4.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
 
[coh.ss8.in.bin34,f,tout,Sx.ss8.in.bin34,Sy.ss8.in.bin34,Pcoh.ss8.in.bin34,PSx.ss8.in.bin34,PSy.ss8.in.bin34] = Spk_LFPCoh(sig2(in.ss8.bin34,:),sig1(in.ss8.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.ss8.out.bin34,f,tout,Sx.ss8.out.bin34,Sy.ss8.out.bin34,Pcoh.ss8.out.bin34,PSx.ss8.out.bin34,PSy.ss8.out.bin34] = Spk_LFPCoh(sig2(out.ss8.bin34,:),sig1(out.ss8.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);



ClusShuffOpts.TestType = 2;
ClusShuffOpts.nShuffs = 5000;

%WITH SHUFFLING
alltr.all = [in.all;out.all];

alltr.ss2.bin1 = [in.ss2.bin1;out.ss2.bin1];
alltr.ss2.bin2 = [in.ss2.bin2;out.ss2.bin2];
alltr.ss2.bin3 = [in.ss2.bin3;out.ss2.bin3];
alltr.ss2.bin4 = [in.ss2.bin4;out.ss2.bin4];

alltr.ss4.bin1 = [in.ss4.bin1;out.ss4.bin1];
alltr.ss4.bin2 = [in.ss4.bin2;out.ss4.bin2];
alltr.ss4.bin3 = [in.ss4.bin3;out.ss4.bin3];
alltr.ss4.bin4 = [in.ss4.bin4;out.ss4.bin4];

alltr.ss8.bin1 = [in.ss8.bin1;out.ss8.bin1];
alltr.ss8.bin2 = [in.ss8.bin2;out.ss8.bin2];
alltr.ss8.bin3 = [in.ss8.bin3;out.ss8.bin3];
alltr.ss8.bin4 = [in.ss8.bin4;out.ss8.bin4];

alltr.ss2.bin12 = [in.ss2.bin12;out.ss2.bin12];
alltr.ss2.bin34 = [in.ss2.bin34;out.ss2.bin34];

alltr.ss4.bin12 = [in.ss4.bin12;out.ss4.bin12];
alltr.ss4.bin34 = [in.ss4.bin34;out.ss4.bin34];

alltr.ss8.bin12 = [in.ss8.bin12;out.ss8.bin12];
alltr.ss8.bin34 = [in.ss8.bin34;out.ss8.bin34];



%============
% All trials
ClusShuffOpts.TrType(1:length(in.all)) = 1;
ClusShuffOpts.TrType(length(in.all)+1:length(in.all)+length(out.all)) = 2;

%with shuffling (pad = 0) & between condition tests
[~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.all,~,~] = Spk_LFPCoh(sig2(alltr.all,:),sig1(alltr.all,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
ClusShuffOpts.TrType = [];




%======================
% Median Split

%ss2, fast
if length(in.ss2.bin12) > 10 && length(out.ss2.bin12) > 10
    ClusShuffOpts.TrType(1:length(in.ss2.bin12)) = 1;
    ClusShuffOpts.TrType(length(in.ss2.bin12)+1:length(in.ss2.bin12)+length(out.ss2.bin12)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2.bin12,~,~] = Spk_LFPCoh(sig2(alltr.ss2.bin12,:),sig1(alltr.ss2.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss2.bin12 = NaN;
end

%ss4, fast
if length(in.ss4.bin12) > 10 && length(out.ss4.bin12) > 10
    ClusShuffOpts.TrType(1:length(in.ss4.bin12)) = 1;
    ClusShuffOpts.TrType(length(in.ss4.bin12)+1:length(in.ss4.bin12)+length(out.ss4.bin12)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4.bin12,~,~] = Spk_LFPCoh(sig2(alltr.ss4.bin12,:),sig1(alltr.ss4.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss4.bin12 = NaN;
end

%ss8, fast
if length(in.ss8.bin12) > 10 && length(out.ss8.bin12) > 10
    ClusShuffOpts.TrType(1:length(in.ss8.bin12)) = 1;
    ClusShuffOpts.TrType(length(in.ss8.bin12)+1:length(in.ss8.bin12)+length(out.ss8.bin12)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8.bin12,~,~] = Spk_LFPCoh(sig2(alltr.ss8.bin12,:),sig1(alltr.ss8.bin12,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin12 = NaN;
end


%ss2, slow
if length(in.ss2.bin34) > 10 && length(out.ss2.bin34) > 10
    ClusShuffOpts.TrType(1:length(in.ss2.bin34)) = 1;
    ClusShuffOpts.TrType(length(in.ss2.bin34)+1:length(in.ss2.bin34)+length(out.ss2.bin34)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2.bin34,~,~] = Spk_LFPCoh(sig2(alltr.ss2.bin34,:),sig1(alltr.ss2.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss2.bin34 = NaN;
end
 
%ss4, slow
if length(in.ss4.bin34) > 10 && length(out.ss4.bin34) > 10
    ClusShuffOpts.TrType(1:length(in.ss4.bin34)) = 1;
    ClusShuffOpts.TrType(length(in.ss4.bin34)+1:length(in.ss4.bin34)+length(out.ss4.bin34)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4.bin34,~,~] = Spk_LFPCoh(sig2(alltr.ss4.bin34,:),sig1(alltr.ss4.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss4.bin34 = NaN;
end
 
%ss8, slow
if length(in.ss8.bin34) > 10 && length(out.ss8.bin34) > 10
    ClusShuffOpts.TrType(1:length(in.ss8.bin34)) = 1;
    ClusShuffOpts.TrType(length(in.ss8.bin34)+1:length(in.ss8.bin34)+length(out.ss8.bin34)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8.bin34,~,~] = Spk_LFPCoh(sig2(alltr.ss8.bin34,:),sig1(alltr.ss8.bin34,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin34 = NaN;
end





%===================
% Quartile split

% SS2, bin1
if length(in.ss2.bin1) > 10 && length(out.ss2.bin1) > 10
    ClusShuffOpts.TrType(1:length(in.ss2.bin1)) = 1;
    ClusShuffOpts.TrType(length(in.ss2.bin1)+1:length(in.ss2.bin1)+length(out.ss2.bin1)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2.bin1,~,~] = Spk_LFPCoh(sig2(alltr.ss2.bin1,:),sig1(alltr.ss2.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss2.bin1 = NaN;
end
%=======================

% SS2, bin2
if length(in.ss2.bin2) > 10 && length(out.ss2.bin2) > 10
    ClusShuffOpts.TrType(1:length(in.ss2.bin2)) = 1;
    ClusShuffOpts.TrType(length(in.ss2.bin2)+1:length(in.ss2.bin2)+length(out.ss2.bin2)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2.bin2,~,~] = Spk_LFPCoh(sig2(alltr.ss2.bin2,:),sig1(alltr.ss2.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else between_cond_shuff.ss2.bin2 = NaN;
end


% SS2, bin3
if length(in.ss2.bin3) > 10 && length(out.ss2.bin3) > 10
    ClusShuffOpts.TrType(1:length(in.ss2.bin3)) = 1;
    ClusShuffOpts.TrType(length(in.ss2.bin3)+1:length(in.ss2.bin3)+length(out.ss2.bin3)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2.bin3,~,~] = Spk_LFPCoh(sig2(alltr.ss2.bin3,:),sig1(alltr.ss2.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss2.bin3 = NaN;
end


% SS2, bin4
if length(in.ss2.bin4) > 10 && length(out.ss2.bin4) > 10
    ClusShuffOpts.TrType(1:length(in.ss2.bin4)) = 1;
    ClusShuffOpts.TrType(length(in.ss2.bin4)+1:length(in.ss2.bin4)+length(out.ss2.bin4)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss2.bin4,~,~] = Spk_LFPCoh(sig2(alltr.ss2.bin4,:),sig1(alltr.ss2.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss2.bin4 = NaN;
end


% ss4, bin1
if length(in.ss4.bin1) > 10 && length(out.ss4.bin1) > 10
    ClusShuffOpts.TrType(1:length(in.ss4.bin1)) = 1;
    ClusShuffOpts.TrType(length(in.ss4.bin1)+1:length(in.ss4.bin1)+length(out.ss4.bin1)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4.bin1,~,~] = Spk_LFPCoh(sig2(alltr.ss4.bin1,:),sig1(alltr.ss4.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss4.bin1 = NaN;
end

%=======================

% ss4, bin2
if length(in.ss4.bin2) > 10 && length(out.ss4.bin2) > 10
    ClusShuffOpts.TrType(1:length(in.ss4.bin2)) = 1;
    ClusShuffOpts.TrType(length(in.ss4.bin2)+1:length(in.ss4.bin2)+length(out.ss4.bin2)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4.bin2,~,~] = Spk_LFPCoh(sig2(alltr.ss4.bin2,:),sig1(alltr.ss4.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss4.bin2 = NaN;
end


% ss4, bin3
if length(in.ss4.bin3) > 10 && length(out.ss4.bin3) > 10
    ClusShuffOpts.TrType(1:length(in.ss4.bin3)) = 1;
    ClusShuffOpts.TrType(length(in.ss4.bin3)+1:length(in.ss4.bin3)+length(out.ss4.bin3)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4.bin3,~,~] = Spk_LFPCoh(sig2(alltr.ss4.bin3,:),sig1(alltr.ss4.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss4.bin3 = NaN;
end



% ss4, bin4
if length(in.ss4.bin4) > 10 && length(out.ss4.bin4) > 10
    ClusShuffOpts.TrType(1:length(in.ss4.bin4)) = 1;
    ClusShuffOpts.TrType(length(in.ss4.bin4)+1:length(in.ss4.bin4)+length(out.ss4.bin4)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss4.bin4,~,~] = Spk_LFPCoh(sig2(alltr.ss4.bin4,:),sig1(alltr.ss4.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin4 = NaN;
end



% ss8, bin1
if length(in.ss8.bin1) > 10 && length(out.ss8.bin1) > 10
    ClusShuffOpts.TrType(1:length(in.ss8.bin1)) = 1;
    ClusShuffOpts.TrType(length(in.ss8.bin1)+1:length(in.ss8.bin1)+length(out.ss8.bin1)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8.bin1,~,~] = Spk_LFPCoh(sig2(alltr.ss8.bin1,:),sig1(alltr.ss8.bin1,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin1 = NaN;
end

%=======================

% ss8, bin2
if length(in.ss8.bin2) > 10 && length(out.ss8.bin2) > 10
    ClusShuffOpts.TrType(1:length(in.ss8.bin2)) = 1;
    ClusShuffOpts.TrType(length(in.ss8.bin2)+1:length(in.ss8.bin2)+length(out.ss8.bin2)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8.bin2,~,~] = Spk_LFPCoh(sig2(alltr.ss8.bin2,:),sig1(alltr.ss8.bin2,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin2 = NaN;
end


% ss8, bin3
if length(in.ss8.bin3) > 10 && length(out.ss8.bin3) > 10
    ClusShuffOpts.TrType(1:length(in.ss8.bin3)) = 1;
    ClusShuffOpts.TrType(length(in.ss8.bin3)+1:length(in.ss8.bin3)+length(out.ss8.bin3)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8.bin3,~,~] = Spk_LFPCoh(sig2(alltr.ss8.bin3,:),sig1(alltr.ss8.bin3,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin3 = NaN;
end


% ss8, bin4
if length(in.ss8.bin4) > 10 && length(out.ss8.bin4) > 10
    ClusShuffOpts.TrType(1:length(in.ss8.bin4)) = 1;
    ClusShuffOpts.TrType(length(in.ss8.bin4)+1:length(in.ss8.bin4)+length(out.ss8.bin4)) = 2;
    
    %with shuffling (pad = 0) & between condition tests
    [~,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff.ss8.bin4,~,~] = Spk_LFPCoh(sig2(alltr.ss8.bin4,:),sig1(alltr.ss8.bin4,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2,ClusShuffOpts);
    ClusShuffOpts.TrType = [];
else
    between_cond_shuff.ss8.bin4 = NaN;
end



if exist('f_shuff') == 0
    f_shuff = NaN;
end



if saveFlag == 1
    %     save(['//scratch/heitzrp/Output/Coherence/Uber_Tune_NeuronRF_intersection_shuff_uStim/overlap/' file_name '_' ...
    %         sig1_name sig2_name '.mat'],'between_cond_shuff','coh','f','f_shuff','tout','Sx','Sy', ...
    %         'RT','Pcoh','PSx','PSy','-mat')
    save(['/volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL_ntile/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'between_cond_shuff','coh','f','f_shuff','tout','Sx','Sy', ...
        'RT','Pcoh','PSx','PSy','-mat')

end



