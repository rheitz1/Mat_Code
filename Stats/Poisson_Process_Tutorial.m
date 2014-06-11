% First generate a poisson process
% In a poisson process, inter-spike-intervals (ISI) are exponentially distributed.

% Here is the ISI distribution for a single trial, 1000 ms of data, with a 50 spikes/sec rate.

% NOTE:: Because we are generating INTER-SPIKE-INTERVALS, if we ultimately want a spike rate of 50 Hz,
% then the average waiting time will actually be 1000/50 = 20.



% UNFINISHED!!





% % %
% % % Hz = 50;
% % % nTrials = 1;
% % %
% % % ISI = exprnd(1000/Hz,1000,1);
% % %
% % % %The arrival times is just the cumulative sum of the ISI
% % % arrivals = cumsum(ISI);
% % %
% % % %Now lets remove unwanted spikes; those that fall outside of our 1000 ms window
% % %
% % % remove = find(arrivals > 1000);
% % %
% % % ISI(remove) = [];
% % % arrivals(remove) = [];
% % %
% % %
% % %
% % % %========
% % % % Now lets create the SDF and verify that the poisson process is giving us the appropriate Hz we asked
% % % % for.
% % % BinCenters = 1:1000;
% % % temp_hist = hist(arrivals,BinCenters);
% % %
% % % %normalize by # of trials
% % % temp_hist = temp_hist / nTrials;
% % %
% % % %Create Kernel
% % %
% % % Growth=1; Decay=20;
% % % Half_BW=round(Decay*8);
% % % BinSize=(Half_BW*2)+1;
% % % Kernel=[0:Half_BW];
% % % Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
% % % Half_Kernel=Half_Kernel./sum(Half_Kernel);
% % % Kernel(1:Half_BW)=0;
% % % Kernel(Half_BW+1:BinSize)=Half_Kernel;
% % % Kernel=Kernel.*1000;
% % % Kernel=Kernel';
% % %
% % % SDF = convn(temp_hist',Kernel,'same');
% % %
% % % figure
% % % plot(SDF)
% % % title(['Mean SDF = ' mat2str(round(mean(SDF)*100)/100)])
% % % %=====================
% % %
% % %
% % % %Now that we have the correct ISI distribution, lets do some statistics on it.
% % %
% % % %The coefficient of variation for a poisson process is 1/sqrt(lambda), where lambda = average number of events
% % % %within time window.
% % % lambda = 1000/Hz;
% % % CV_pred = 1/(sqrt(lambda))

%A Poisson neuron will yield the same Fano factor regardless of spike rate
Target_ = 0;

nTrials = 1000;
maxSpikeTime = 1000;

P_10 = genPoissonNeuron(nTrials,maxSpikeTime,10);
P_50 = genPoissonNeuron(nTrials,maxSpikeTime,50);
P_100 = genPoissonNeuron(nTrials,maxSpikeTime,100);
P_1000 = genPoissonNeuron(nTrials,maxSpikeTime,1000);

[F_10 real_time] = getFano_targ(P_10,50,10,[0 1000],1:size(P_10,1));
F_50 = getFano_targ(P_50,50,10,[0 1000],1:size(P_50,1));
[F_100 real_time CV2] = getFano_targ(P_100,50,10,[0 1000],1:size(P_100,1));
F_1000 = getFano_targ(P_1000,50,10,[0 1000],1:size(P_1000,1));






%==================
% SET UP SDF SCRIPT
BinCenters = 1:1000;

%Create Kernel

Growth=1; Decay=20;
Half_BW=round(Decay*8);
BinSize=(Half_BW*2)+1;
Kernel=[0:Half_BW];
Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
Half_Kernel=Half_Kernel./sum(Half_Kernel);
Kernel(1:Half_BW)=0;
Kernel(Half_BW+1:BinSize)=Half_Kernel;
Kernel=Kernel.*1000;
Kernel=Kernel';
%==================

temp_hist = hist(sort(P_10(:)),BinCenters);
temp_hist = temp_hist / nTrials;
SDF_10 = convn(temp_hist',Kernel,'same');
clear temp_hist

temp_hist = hist(sort(P_50(:)),BinCenters);
temp_hist = temp_hist / nTrials;
SDF_50 = convn(temp_hist',Kernel,'same');
clear temp_hist

temp_hist = hist(sort(P_100(:)),BinCenters);
temp_hist = temp_hist / nTrials;
SDF_100 = convn(temp_hist',Kernel,'same');
clear temp_hist

temp_hist = hist(sort(P_1000(:)),BinCenters);
temp_hist = temp_hist / nTrials;
SDF_1000 = convn(temp_hist',Kernel,'same');
clear temp_hist


figure
plot(1:1000,SDF_10,'k',1:1000,SDF_50,'r',1:1000,SDF_100,'g',1:1000,SDF_1000,'b')
title('Poisson process SDFs')

figure
plot(real_time,F_10,'k',real_time,F_50,'r',real_time,F_100,'g',real_time,F_1000,'b')
title('Fano Factors over different spike rates')
xlim([0 900])


% % % %==================================================
% % % % Now what if we use a Uniformly distributed neuron instead of a Poisson process?
% % % U_50 = genUnifNeuron(nTrials,maxSpikeTime,50);
% % % FU_50 = getFano_targ(U_50,50,10,[0 1000],1:size(U_50,1));
% % % 
% % % temp_hist = hist(sort(U_50(:)),BinCenters);
% % % temp_hist = temp_hist / nTrials;
% % % SDF_U50 = convn(temp_hist',Kernel,'same');
% % % clear temp_hist
% % % 
% % % 
% % % %==================================================
% % % % Now what if we use a Gaussian distributed neuron instead of a Poisson process?
% % % G_50 = genGaussNeuron(nTrials,maxSpikeTime,50,50);
% % % FG_50 = getFano_targ(G_50,50,10,[0 1000],1:size(G_50,1));
% % % 
% % % temp_hist = hist(sort(G_50(:)),BinCenters);
% % % temp_hist = temp_hist / nTrials;
% % % SDF_G50 = convn(temp_hist',Kernel,'same');
% % % clear temp_hist



%================================
% Now lets compare a poisson process to an inhomogeneous poisson process
P_50_inhomo = genPoissonNeuron_inhomo(nTrials,maxSpikeTime,50,5);
F_50_inhomo = getFano_targ(P_50_inhomo,50,10,[0 1000],1:size(P_50,1));

temp_hist = hist(sort(P_50_inhomo(:)),BinCenters);
temp_hist = temp_hist / nTrials;
SDF_50_inhomo = convn(temp_hist',Kernel,'same');
clear temp_hist

%Generate LFP of given frequency
base = genSine(50);
LFP = repmat(base,nTrials,1);