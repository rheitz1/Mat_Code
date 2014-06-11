%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons selected by plotting each neuron Tin vs Din and each
%LFP using the current neuron.  If both selected in significantly in the
%same direction, said to be valid, and will use neuron's RF.

function [] = pCOHERENCE_SPKLFP_Tune_NeurRF_isect_vamp_overlap_optimality(file_name,sig1_name,sig2_name)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;

file_name


load(file_name,sig1_name,sig2_name, ...
    'Target_','Errors_','newfile','Correct_','RFs','Hemi','SRT','TrialStart_')

fixErrors

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


in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

RT.all = nanmean([SRT(in.all,1); SRT(out.all,1)]);


%fix Spike channel; change 0's to NaN and alter times
sig2(sig2 == 0) = NaN;
sig2 = sig2 - 500;




%find trials with 'optimal' firing rate (from Churchland et al., 2006)
SDF.in = sSDF(sig2(in.all,:),Target_(in.all,1),[-500 2500]);
SDF.out = sSDF(sig2(out.all,:),Target_(out.all,1),[-500 2500]);

%first find mean firing rate in window of interest
window = [600 800];
%window = [400 500];

meanFire.in = nanmean(SDF.in(:,window(1):window(2)),2);
meanFire.out = nanmean(SDF.out(:,window(1):window(2)),2);

%for this window, calculate deviation
devFire.in = meanFire.in - nanmean(meanFire.in);
devFire.out = meanFire.out - nanmean(meanFire.out);


sd.in = std(devFire.in);
sd.out = std(devFire.out);


%to plot alongside RT
RTs.in = SRT(in.all,1);
RTs.out = SRT(out.all,1);


%find optimal trials.  For now, hard code so that 'optimal' trials are
%within 10 sp/sec of mean and non-optimal are outside of 50 ms.   This will
%of course be dependent on the firing rates of the cells

% optimalTrls.in = in.all(find(devFire.in > -10 & devFire.in < 10));
% nonoptimalTrls.in = in.all(find(devFire.in < -50 | devFire.in > 50));
% 
% optimalTrls.out = out.all(find(devFire.out > -10 & devFire.out < 10));
% nonoptimalTrls.out = out.all(find(devFire.out < -50 | devFire.out > 50));

optimalTrls.in = in.all(find(devFire.in < (mean(devFire.in) + sd.in) & devFire.in > (mean(devFire.in) - sd.in)));
nonoptimalTrls.in = in.all(find(devFire.in > (mean(devFire.in) + sd.in) | devFire.in < (mean(devFire.in) - sd.in)));

optimalTrls.out = out.all(find(devFire.out < (mean(devFire.out) + sd.out) & devFire.out > (mean(devFire.out) - sd.out)));
nonoptimalTrls.out = out.all(find(devFire.out > (mean(devFire.out) + sd.out) | devFire.out < (mean(devFire.out) - sd.out)));

n.optimalTrls.in = length(optimalTrls.in);
n.nonoptimalTrls.in = length(nonoptimalTrls.in);
n.optimalTrls.out = length(optimalTrls.out);
n.nonoptimalTrls.out = length(nonoptimalTrls.out);

%find minimum number of trials to use so held constant
nTr = findMin(length(optimalTrls.in),length(optimalTrls.out),length(nonoptimalTrls.in),length(nonoptimalTrls.out));

%randomly sample
optimalTrls.in = optimalTrls.in(randperm(nTr));
optimalTrls.out = optimalTrls.out(randperm(nTr));
nonoptimalTrls.out = nonoptimalTrls.out(randperm(nTr));
nonoptimalTrls.out = nonoptimalTrls.out(randperm(nTr));

%without shuffling (pad == 4) & no tests
[coh.in.optimal,f,tout,Sx.in.optimal,Sy.in.optimal,Pcoh.in.optimal,PSx.in.optimal,PSy.in.optimal] = Spk_LFPCoh(sig2(optimalTrls.in,:),sig1(optimalTrls.in,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.optimal,f,tout,Sx.out.optimal,Sy.out.optimal,Pcoh.out.optimal,PSx.out.optimal,PSy.out.optimal] = Spk_LFPCoh(sig2(optimalTrls.out,:),sig1(optimalTrls.out,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);

[coh.in.nonoptimal,f,tout,Sx.in.nonoptimal,Sy.in.nonoptimal,Pcoh.in.nonoptimal,PSx.in.nonoptimal,PSy.in.nonoptimal] = Spk_LFPCoh(sig2(nonoptimalTrls.in,:),sig1(nonoptimalTrls.in,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
[coh.out.nonoptimal,f,tout,Sx.out.nonoptimal,Sy.out.nonoptimal,Pcoh.out.nonoptimal,PSx.out.nonoptimal,PSy.out.nonoptimal] = Spk_LFPCoh(sig2(nonoptimalTrls.out,:),sig1(nonoptimalTrls.out,:),tapers,-500,[-500 2500], 1000, .01, [0 100],0,4,.05,0,2,2);
%=======================


% 
% if saveFlag == 1
%     save(['//scratch/heitzrp/Output/Coherence/Uber_Hemi_NeuronRF_intersection_shuff/overlap/' file_name '_' ...
%         sig1_name sig2_name '.mat'],'f','n','tout','Sx','Sy', ...
%         'RTs','n','devFire','Pcoh','PSx','PSy','-mat')
% end


if saveFlag == 1
    save(['/volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_optimality_constN/overlap/' file_name '_' ...
        sig1_name sig2_name '.mat'],'f','n','tout','Sx','Sy', ...
        'RTs','n','devFire','Pcoh','PSx','PSy','-mat')
end
