%TestMTCodeScript.m
%below code is written to test various Spec and Coh fxns...

% comment out lines below that you don't want to test
% below code is written to test various Spec and Coh fxns...
% X and Y are the fake LFP signals (sine waves plus noise) and Spk and Spk2
% are the fake spike data, with Spikes at set times plus spikes at random
% times added

bn=[-400 900];
Fs=1000;

ClusShuffOpts.NormAboveThreshStats=1;
ClusShuffOpts.SpecTestStat=2;
ClusShuffOpts.nShuffs=2;
ClusShuffOpts.CohTest=1;
ClusShuffOpts.CohTestStat=2;   %1 for CohZPF, 2 for Fisher's Z
ClusShuffOpts.SpecTest=1;
ClusShuffOpts.SpecTestStat=1;   %1 to use a sign-rank test test stat, 2 to use the log-normalized differences as the test stat
ClusShuffOpts.PCohTest=0;
ClusShuffOpts.PCohTestStat=2;
ClusShuffOpts.PSpecTest=0;
ClusShuffOpts.PSpecTestStat=1;

%test the new options format of the code
%tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
options.tapers=[.2 5];
options.sampling=Fs;
options.fk=[0 300];
options.plotflag=1;
options.t0=bn(1);
options.bn=bn;
options.normfreqs=0;
options.pad=1;
options.JustPartFlag=1;
options.errType=2;
options.ZTransFlag=1;

options.ClusShuffOpts=ClusShuffOpts;

clear Spk*
nTr=300;

nt=1400;
X=repmat(0,nTr,nt);
Y=X;
t=0:nt-1;
Fs=1000;

phi1=pi/4;
phi2=pi;

FreqPer=12.5;     %samps/cyc
FreqPer2=100;
for it=1:nTr
    tmpnums=randperm(1400);
    tmpnums=tmpnums-400;
    Spk(it,:)=[(300:FreqPer:600) tmpnums(1:20)];
    
    %insert Nans to test if those cause a problem
    %Spk(it,end-it:end)=NaN;
    
    Spk2(it,:)=[(100:FreqPer:800) tmpnums(21:40)];
        
    %arranging spks for Chron Code
    SpkStruc1(it).times=Spk(it,:)';
    SpkStruc2(it).times=Spk2(it,:)';
    
    RAmp=rand;
    RAmp=1;

    X(it,:)=RAmp*cos(2*pi*t/FreqPer-phi1) + .01*randn(1,nt);
    Y(it,:)=RAmp*cos(2*pi*t/FreqPer2-phi2) + .01*randn(1,nt);       
    X1(it,:)=RAmp*exp(1i*(2*pi*t/FreqPer-phi1)) + .01*randn(1,nt);
    Y1(it,:)=RAmp*exp(1i*(2*pi*t/FreqPer2-phi2)) + .01*randn(1,nt);        
    Z(it,:)=X(it,:).*Y(it,:);
    Z1(it,:)=X1(it,:).*Y1(it,:);
end

%below- tests to see teh resulting spectrum from multiplying sinusoids when
%thinking about that paper that Corrie sent out a little while ago- Darvas
%et al 2009
% figure
% %plot(X,'Color',mycolors(1));
% hold on
% %plot(Y,'Color',mycolors(2));
% plot(real(X1(1,:)),'Color',mycolors(3));
% plot(real(Y1(1,:)),'Color',mycolors(4));
% %plot(imag(X1),'Color',mycolors(5));
% %plot(imag(Y1),'Color',mycolors(6));
% plot(real(Z1(1,:)),'Color',mycolors(7));
% %plot(imag(Z1),'Color',mycolors(2));
% plot(real(Z(1,:)),'Color',mycolors(5));
% plot(real(Z(1,:))-real(Z1(1,:)),'Color',mycolors(4));
% 
% [Sx, f, tout]=LFPSpec(X,options);
% [Sy, f, tout]=LFPSpec(Y,options);
% [Sz, f, tout]=LFPSpec(Z,options);



%[coh, f, tout, Sx, Sy, Pcoh, PSx, PSy, N, dn, nwin, errSF]=Spk_LFPCoh(Spk,X,options);
                    
%[Sx, f, tout, PSx, N, dn, nwin, errSSpec]=SpkSpec(Spk,options);

%[coh, f, tout, Sx, Sy, Pcoh, PSx, PSy, N, dn, nwin]=Spk_SpkCoh(Spk,Spk2,options);

%return
%times can't be neg b/c chron sux
%bn=bn+400;


%spk checks
%[spec,f,tout,N,dn,nwin,err] = SpkSpec(Spk,tapers,bn, sampling, dn, fk, plotflag, pad, pval, flag)
%[coh,Myf,tout,MyS1,MyS2,N,dn,nwin,err] = Spk_SpkCoh(Spk,Spk2,tapers,bn, sampling, dn, fk, plotflag, pad, pval, flag)
%tic
%[coh,Myf,tout,MyS1,MyS2,Pcoh,PS1,PS2] = Spk_SpkCoh(Spk,Spk2,[],bn, [], [], [500], 1);
%toc

%[coh,f,tout,S1,S2,Pcoh,PS1,PS2,N,dn,nwin,err] = Spk_LFPCoh(Spk,Y,tapers,t0,bn, sampling, dn, fk, plotflag, pad, pval, JustPartFlag,errType,ZTransFlag)
[coh,Myf,tout,MyS1,MyS2,Pcoh,PS1,PS2] = Spk_LFPCoh(Spk,X,[],0,[0 1000], 1000, [], [500], 1);

return

%crhon opts
params.tapers=[1 1];
params.trialave=1;
params.Fs=1;
params.pad=2;

%chron check
%[C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=coherencypt(SpkStruc1,SpkStruc2,params,fscorr,t)
%[C,phi,S12,S1,S2,f]=coherencypt(SpkStruc1,SpkStruc2,params,0,t)
%[C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr]=cohgrampt(data1,data2,movingwin,params,fscorr)
%tic
%[C,phi,S12,S1,S2,t,f]=cohgrampt(SpkStruc1,SpkStruc2,[200 10],params,0);
%toc

%LFP checks
%[coh,f,tout, Sx, Sy,Pcoh, N,dn,nwin,err] = LFP_LFPCoh(X,Y,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, flag, JustPartFlag)
tic
[coh,Myf,tout, Sx, Sy] = LFP_LFPCoh(X,Y,[],1000, [], [500], 0,[],[],4);
toc

%[C,phi,S12,S1,S2,t,f,confC,phistd,Cerr]=cohgramc(data1,data2,movingwin,params)
% tic
% [C,phi,S12,S1,S2,t,f]=cohgramc(X',Y',[200 10],params);
% %figure
% %plot_matrix(C,t,f,'n')
% toc

return


figure
plot(X)
hold on
tmpperm=randperm(length(X));
plot(X( 1,tmpperm ),'r')
[spec,f]=GetOneSlepSpec(X,1000,[],0);
[shspec,shf]=GetOneSlepSpec(X(1,tmpperm),1000,[],0);
figure
loglog(f,spec,'b')
hold on
loglog(shf,shspec,'r')
return

%below portion of code tests of mtfiltering to work out strategies to apply anti-aliasing filtering
%digitally before sub-sampling
Fs=1000;
taps=[.2 400];

%tic
XF2=mtfilter(X, taps, 1000, 0);     %this actually works slightly faster than the version below, and produces essentially the same output
%toc

% tic
% MyFilt=mtfilt(taps,1000,0);
% XF1=filtfilt(MyFilt,1,X);
% toc

figure
%plot(XF1,'b')
hold on
plot(XF2,'r')
plot(X,'g')

Xn=randn(1,20000);
XnF2=mtfilter(Xn, taps, 1000, 0);
%LFPSpec(XnF2,[.2 5],1000,.01,500,1);
return

%[spec,f,tout,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, flag)
%LFPSpec(X,[],1000,[],[],[],1);

%[coh,f,tout,Sx, Sy, N,dn,nwin,err] = LFP_LFPCoh(X,Y,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, flag)
%[coh,f,tout,Sx, Sy]=LFP_LFPCoh(X,Y,[],1000);
Spk_LFPCoh(Spk,X,[],0,[100 1000],1000,.01,200,1,2,0.05,1);

%[spec,f,tout,N,dn,nwin,err] = SpkSpec(Spk,tapers,bn, sampling, dn, fk, plotflag, pad, pval, flag)
%SpkSpec(Spk,[],[-400 1000],1000,.01,200,1,2,0.05,1);
return


