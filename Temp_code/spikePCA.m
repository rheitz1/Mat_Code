% load spikes
% ...
x = DSP09a_waves;
y = DSP11a_waves;

% first column is trial number; remove it.

x(:,1) = [];
y(:,1) = [];


X = [x ; y];
%center the data by subtracting mean waveform

X = X - repmat(mean(X),size(X,1),1);


%get principle components

[V PCscores PCvar] = princomp(X);


%generate time axis.
%   Plexon samples at 40kHz or 40,000 Hz

if size(x,2) == 56
    %if 56, we know that spike window was 1.4 us, because (40000*1.4) / 1000 = 56
    

%scree plot
figure

subplot(221)
plot(nanmean(x),'r')

subplot(222)
plot(sqrt(PCvar),'ob')

%plot PCA clusters
subplot(223)
scatter(PCscores(:,1),PCscores(:,2))
hline(0)
vline(0)