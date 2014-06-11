%generate matrix of "LFPs" at some frequency
freq = 20;
nTr = 20;

varLFP = 10;
varSPK = 10;

LFP = genSine(freq);

%tile LFP for n trials
LFP = repmat(LFP,nTr,1);

%vary the left by shifting it by 0:varLFP ms
for trl = 1:nTr
    LFP(trl,:) = circshift(LFP(trl,:),[0 round(rand*varLFP)]);
end


%create perfectly coherent spike times based on frequency of sine wave
% note: for magnitude of SFC (coherence), placement will not matter,
% although it will affect the phase angle
% % SPK = 1:(1000/freq):1000;
% % 
% % %tile
% % SPK = repmat(SPK,nTr,1);
% % 
% % %add noise to SPK
% % SPKnoise = round(rand(nTr,size(SPK,2))*varSPK);
% % SPK = SPK + SPKnoise;


SPK = genPoissonNeuron(nTr,1000,20);

tapers = PreGenTapers([.2 5]);
[coh,f,tout,~,~] = Spk_LFPCoh(SPK,LFP,tapers,1,[1 1000], 1000, .01, [0 100],1);


% Target_(1,1) = 0;
% [Fano,real_time] = getFano_targ(SPK,100,5,[0 1000],1:nTr,1);