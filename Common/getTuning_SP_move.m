%plots tuning curve for AD channel.
%interval == time span to find maximum voltage change
function [tuning] = getTuning_SP_move(Spike,trls,interval,freqrange,plotFlag)

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
TrialStart_ = evalin('caller','TrialStart_');

if nargin < 5; plotFlag = 0; end
if nargin < 4; freqrange = [.05 5]; end %note that we exclude 0, which is DC-value
if nargin < 3; interval = [-20 -10]; end
if nargin < 2; trls = 1:size(Spike,1); end

if isempty(trls)
    tuning.minmax(1:8) = NaN;
    tuning.max(1:8) = NaN;
    tuning.min(1:8) = NaN;
    tuning.fft(1:8) = NaN;
end

%get single-trial SDFs.  Assume full-time DSP channel (not truncated)
%SDF = sSDF(Spike,Target_(:,1),interval);



%baseline correct
% no baseline correction enabled for spike channels

pos0 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 0));
pos1 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 1));
pos2 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 2));
pos3 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 3));
pos4 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 4));
pos5 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 5));
pos6 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 6));
pos7 = intersect(trls,find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 7));


SDF0 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos0,TrialStart_);
SDF1 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos1,TrialStart_);
SDF2 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos2,TrialStart_);
SDF3 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos3,TrialStart_);
SDF4 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos4,TrialStart_);
SDF5 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos5,TrialStart_);
SDF6 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos6,TrialStart_);
SDF7 = spikedensityfunct(Spike,SRT(:,1)+500,interval,pos7,TrialStart_);

% SDF0 = nanmean(SDF(pos0,:));
% SDF1 = nanmean(SDF(pos1,:));
% SDF2 = nanmean(SDF(pos2,:));
% SDF3 = nanmean(SDF(pos3,:));
% SDF4 = nanmean(SDF(pos4,:));
% SDF5 = nanmean(SDF(pos5,:));
% SDF6 = nanmean(SDF(pos6,:));
% SDF7 = nanmean(SDF(pos7,:));

[freq fft0] = getFFT(SDF0);
[freq fft1] = getFFT(SDF1);
[freq fft2] = getFFT(SDF2);
[freq fft3] = getFFT(SDF3);
[freq fft4] = getFFT(SDF4);
[freq fft5] = getFFT(SDF5);
[freq fft6] = getFFT(SDF6);
[freq fft7] = getFFT(SDF7);

%for FFT tuning, sum the power from 0:5 Hz
sumpow0 = sum(fft0(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow1 = sum(fft1(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow2 = sum(fft2(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow3 = sum(fft3(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow4 = sum(fft4(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow5 = sum(fft5(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow6 = sum(fft6(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow7 = sum(fft7(find(freq >= freqrange(1) & freq <= freqrange(2))));



maxmin0 = nanmax(SDF0) - nanmin(SDF0);
maxmin1 = nanmax(SDF1) - nanmin(SDF1);
maxmin2 = nanmax(SDF2) - nanmin(SDF2);
maxmin3 = nanmax(SDF3) - nanmin(SDF3);
maxmin4 = nanmax(SDF4) - nanmin(SDF4);
maxmin5 = nanmax(SDF5) - nanmin(SDF5);
maxmin6 = nanmax(SDF6) - nanmin(SDF6);
maxmin7 = nanmax(SDF7) - nanmin(SDF7);

max0 = nanmax(SDF0);
max1 = nanmax(SDF1);
max2 = nanmax(SDF2);
max3 = nanmax(SDF3);
max4 = nanmax(SDF4);
max5 = nanmax(SDF5);
max6 = nanmax(SDF6);
max7 = nanmax(SDF7);

min0 = nanmin(SDF0);
min1 = nanmin(SDF1);
min2 = nanmin(SDF2);
min3 = nanmin(SDF3);
min4 = nanmin(SDF4);
min5 = nanmin(SDF5);
min6 = nanmin(SDF6);
min7 = nanmin(SDF7);

mean0 = nanmean(SDF0);
mean1 = nanmean(SDF1);
mean2 = nanmean(SDF2);
mean3 = nanmean(SDF3);
mean4 = nanmean(SDF4);
mean5 = nanmean(SDF5);
mean6 = nanmean(SDF6);
mean7 = nanmean(SDF7);



tuning.minmax = [maxmin0 maxmin1 maxmin2 maxmin3 maxmin4 maxmin5 maxmin6 maxmin7];
tuning.max = [max0 max1 max2 max3 max4 max5 max6 max7];
tuning.min = [min0 min1 min2 min3 min4 min5 min6 min7];
tuning.fft = [sumpow0 sumpow1 sumpow2 sumpow3 sumpow4 sumpow5 sumpow6 sumpow7];
tuning.mean = [mean0 mean1 mean2 mean3 mean4 mean5 mean6 mean7];

if plotFlag == 1
    fig
    
    subplot(2,2,1)
    plot(interval(1):interval(2),SDF0,interval(1):interval(2),SDF1,interval(1):interval(2),SDF2,interval(1):interval(2),SDF3,interval(1):interval(2),SDF4,interval(1):interval(2),SDF5,interval(1):interval(2),SDF6,interval(1):interval(2),SDF7)
    xlim([interval(1) interval(2)])
    %legend('Pos0','Pos1','Pos2','Pos3','Pos4','Pos5','Pos6','Pos7')
    title('SDF channel, baseline-corrected averages')
    xlabel('Time from Target Onset')
    
    subplot(2,2,2)
    plot(0:7,tuning.minmax,'b',0:7,tuning.max,'r',0:7,tuning.min,'k')
    xlim([0 7])
    xlabel('Screen Position')
    legend('Max-Min','Max','Min')
    

    subplot(2,2,3)
    plot(freq,fft0,freq,fft1,freq,fft2,freq,fft3,freq,fft4,freq,fft5,freq,fft6,freq,fft7)
    
    xlim([0 10])
    legend('Pos0','Pos1','Pos2','Pos3','Pos4','Pos5','Pos6','Pos7','location','northeast')
    
    subplot(2,2,4)
    plot(0:7,tuning.fft)
    xlim([-.5 7.5])
    title('FFT Tuning')

end


% mystring = 'p(1) + p(2) * cos(theta - p(3))';
% myfun = inline(mystring,'p','theta');
% p = nlinfit(1:8,tuning_minmax,myfun,[1 1 0]);
% fit = myfun(p,tuning);
% disp('hi')