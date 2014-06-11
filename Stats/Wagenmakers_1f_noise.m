%From Wagenmakers, Farrell, & Ratcliff, 2004, PBR

randn('seed',5150)


simN = 100;

for n = 1:simN
%white noise
wn(n,1:1000) = randn(1,1000);
end

%random walk
randomwalk = cumsum(wn,2);

%first-order autoregressive
phi = .7;

ar1(1:simN,1:1000) = 0;

for n = 1:simN
    for t = 2:1000
        ar1(n,t) = phi * ar1(n,t-1) + wn(n,t);
    end
end


%first-order moving average
theta = .7;
ma1(1:simN,1:1000) = 0;

for n = 1:simN
    for t = 2:1000
        ma1(n,t) = theta * wn(n,t-1) + wn(n,t);
    end
end

%FFTs
for n = 1:simN
    [freq.wn(n,:) pow.wn(n,:)] = getFFT(wn(n,:),1);
    [freq.randomwalk(n,:) pow.randomwalk(n,:)] = getFFT(randomwalk(n,:),1);
    [freq.ar1(n,:) pow.ar1(n,:)] = getFFT(ar1(n,:),1);
    [freq.ma1(n,:) pow.ma1(n,:)] = getFFT(ma1(n,:),1);
end

%Cross-correlations
for n = 1:simN
    [c.wn(n,:) lags.wn(n,:)] = xcorr(wn(n,:),'coeff');
    [c.randomwalk(n,:) lags.randomwalk(n,:)] = xcorr(randomwalk(n,:),'coeff');
    [c.ar1(n,:) lags.ar1(n,:)] = xcorr(ar1(n,:),'coeff');
    [c.ma1(n,:) lags.ma1(n,:)] = xcorr(ma1(n,:),'coeff');
end



%
% fig1
% subplot(221)
% plot(wn)
% title('White Noise')
% 
% subplot(222)
% plot(randomwalk)
% title('Random Walk')
% 
% subplot(223)
% plot(ar1)
% title('AR-1')
% 
% subplot(224)
% plot(ma1)
% title('MA-1')
% 
% suplabel('Time Series','t')

fig2
subplot(221)
plot(nanmean(lags.wn),nanmean(c.wn))
xlim([0 30])
ylim([-.5 1])
h = hline(0,'k');
set(h,'linestyle','--')
title('White Noise')

subplot(222)
plot(nanmean(lags.randomwalk),nanmean(c.randomwalk))
xlim([0 30])
ylim([-.5 1])
h = hline(0,'k');
set(h,'linestyle','--')
title('Random Walk')

subplot(223)
plot(nanmean(lags.ar1),nanmean(c.ar1))
xlim([0 30])
ylim([-.5 1])
h = hline(0,'k');
set(h,'linestyle','--')
title('AR-1')

subplot(224)
plot(nanmean(lags.ma1),nanmean(c.ma1))
xlim([0 30])
ylim([-.5 1])
h = hline(0,'k');
set(h,'linestyle','--')
title('MA-1')

suplabel('Autocorrelation Functions','t')



fig3
subplot(221)
plot(log(nanmean(freq.wn)),log(nanmean(pow.wn)))
title('White Noise')

subplot(222)
plot(log(nanmean(freq.randomwalk)),log(nanmean(pow.randomwalk)));
title('Random Walk')

subplot(223)
plot(log(nanmean(freq.ar1)),log(nanmean(pow.ar1)));
title('AR-1')

subplot(224)
plot(log(nanmean(freq.ma1)),log(nanmean(pow.ma1)));
title('MA-1')

suplabel('Log-Log Frequency Spectra','t')
