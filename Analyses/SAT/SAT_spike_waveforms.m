%Plots average spike waveforms for FAST and SLOW baseline periods
%S.E.M. is plotted around each mean waveform.
%
% RPH

function [] = SAT_spike_waveforms(name,time_window)

Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
SAT_ = evalin('caller','SAT_');
Correct_ = evalin('caller','Correct_');
Spike = evalin('caller',name);
Waves = evalin('caller',[name '_waves']);

trunc_RT = 2000;

if nargin < 2; time_window = [-500 2500]; end

%vectorize Spike times, correct by -500, and remove 0's
SpkTimes = Spike(:);
SpkTimes(find(SpkTimes == 0)) = [];
SpkTimes = SpkTimes - 500;


%check to make sure lengths are accurate
if length(SpkTimes) ~= size(Waves,1)
    disp('Error in vector lengths...check!')
end


%put spike times into register with waveforms
Waves = [SpkTimes Waves];

%find Trials
slow_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));

slowbase = find(Waves(:,1) >= time_window(1) & Waves(:,1) <= time_window(2) & ismember(Waves(:,2),slow_correct_made_dead));
fastbase = find(Waves(:,1) >= time_window(1) & Waves(:,1) <= time_window(2) & ismember(Waves(:,2),fast_correct_made_dead_withCleared));

t = linspace(-100,1400,56);


%calculate standard error.  Add & subtract from mean for plotting purposes
%(3rd party function 'fill area')
sem_slow_upper = nanmean(Waves(slowbase,3:end)) + (std(Waves(slowbase,3:end),[],1) / sqrt(length(slowbase)));
sem_slow_lower = nanmean(Waves(slowbase,3:end)) - (std(Waves(slowbase,3:end),[],1) / sqrt(length(slowbase)));
sem_fast_upper = nanmean(Waves(fastbase,3:end)) + (std(Waves(fastbase,3:end),[],1) / sqrt(length(fastbase)));
sem_fast_lower = nanmean(Waves(fastbase,3:end)) - (std(Waves(fastbase,3:end),[],1) / sqrt(length(fastbase)));

figure;
mf
fon
plot(t,nanmean(Waves(slowbase,3:end)),'r',t,nanmean(Waves(fastbase,3:end)),'g','linewidth',1)
xlim([-100 1400])
ylim(ylim + [-.02 .02])
title([name ' Waveforms'])
xlabel('Time uS')
ylabel('mV')
%box off

%fill in area of +/-  1 s.e.m.
fill_area(t,sem_slow_lower,sem_slow_upper,'r','r',1,.5)
fill_area(t,sem_fast_lower,sem_fast_upper,'g','g',1,.5)