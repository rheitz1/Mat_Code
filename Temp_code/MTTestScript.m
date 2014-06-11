%MTTestScript.m
%
% comment out lines below that you don't want to test
%below code is written to test various Spec and Coh fxns...
% X and Y are the fake LFP signals (sine waves plus noise) and Spk and Spk2
% are the fake spike data, with Spikes at set times plus spikes at random
% times added

clear Spk*
nTr=10;

nt=1501;
X=repmat(0,nTr,nt);
Y=X;
t=0:nt-1;

FreqPer=12;     %ms/samps
for it=1:nTr
    tmpnums=randperm(1400);
    tmpnums=tmpnums-400;
    Spk(it,:)=[(300:FreqPer:600) tmpnums(1:20)];
    
    %insert Nans to test if those cause a problem
    Spk(it,end-it:end)=NaN;
    
    %Spk2(it,:)=[(100:FreqPer:800) tmpnums(21:40)];
    X(it,:)=cos(2*pi*t/FreqPer) + .2*randn(1,nt);
    Y(it,:)=cos(2*pi*t/FreqPer) + .4*randn(1,nt);
end

%[coh,f,tout,Sx, Sy, N,dn,nwin,err] = LFP_LFPCoh(X,Y,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, flag)
%[coh,f,tout,Sx, Sy]=LFP_LFPCoh(X,Y,[],1000);

%Spk_LFPCoh(Spk,X,[],0,[100 1000],1000,.01,200,1,2,0.05,1);

%[spec,f,tout,N,dn,nwin,err] = SpkSpec(Spk,tapers,bn, sampling, dn, fk, plotflag, pad, pval, flag)
SpkSpec(Spk,[],[-400 1000],1000,.01,200,1,2,0.05,1);