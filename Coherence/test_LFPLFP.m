%example for LFP-LFP Coherence
nTr = 500;

sig1_40_80 = genSine(80) + genSine(40);
sig2_80 = genSine(80);

sig1_40_80 = repmat(sig1_40_80,nTr,1);
sig2_80 = repmat(sig2_80,nTr,1);

noise1 = rand(nTr,1001)*10;
noise2 = rand(nTr,1001)*10;

sig1_40_80 = sig1_40_80 + noise1;
sig2_80 = sig2_80 + noise2;

%add jitter to each simulated trial so that Partial coherence does not
%remove everything.  Circularly shift columns on a trials from 1 to 6 ms.
%This should lead to simulated 'induced' coherence.

% for trl = 1:size(sig1_40_80,1)
%     sig1_40_80(trl,:) = circshift(sig1_40_80(trl,:),[0 randi(6)]);
% end


%figure
%plot(nanmean(sig1_40_80))

tapers = PreGenTapers([.2 5]);
[coh_z, f, tout, Sx_z, Sy_z, Pcoh_z, PSx_z, PSy_z] = LFP_LFPCoh(sig1_40_80,sig2_80,tapers,1000,.01, [0 100], 0, -500, 0, 4,.05,0,2,1);
[coh, f, tout, Sx, Sy, Pcoh, PSx, PSy] = LFP_LFPCoh(sig1_40_80,sig2_80,tapers,1000,.01, [0 100], 0, -500, 0, 4,.05,0,2,0);


figure
fw
imagesc(tout,f,abs(coh'))
axis xy
colorbar