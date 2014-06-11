%plots tuning curve for AD channel.
%interval == time span to find maximum voltage change
%freqrange == [start_freq end_freq], inclusive
function [tuning] = getTuning_AD(AD,interval,freqrange,plotFlag)

%if incorrect length of data, error out.
if size(AD,2) < 3001
    disp('Requires 3001 ms time interval')
    return
end

if nargin < 4; plotFlag = 0; end
if nargin < 3; freqrange = [.05 5]; end %note that we exclude 0, which is DC-value
if nargin < 2; interval = [0 400]; end

Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');

shift = Target_(1,1);

%baseline correct
AD = baseline_correct(AD,[Target_(1,1)-100 Target_(1,1)]);

pos0 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 0);
pos1 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 1);
pos2 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 2);
pos3 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 3);
pos4 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 4);
pos5 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 5);
pos6 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 6);
pos7 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == 7);

AD0 = nanmean(AD(pos0,:));
AD1 = nanmean(AD(pos1,:));
AD2 = nanmean(AD(pos2,:));
AD3 = nanmean(AD(pos3,:));
AD4 = nanmean(AD(pos4,:));
AD5 = nanmean(AD(pos5,:));
AD6 = nanmean(AD(pos6,:));
AD7 = nanmean(AD(pos7,:));

[freq fft0] = getFFT(AD0);
[freq fft1] = getFFT(AD1);
[freq fft2] = getFFT(AD2);
[freq fft3] = getFFT(AD3);
[freq fft4] = getFFT(AD4);
[freq fft5] = getFFT(AD5);
[freq fft6] = getFFT(AD6);
[freq fft7] = getFFT(AD7);

%for FFT tuning, sum the power from in range (but be sure to leave off 0 Hz
%because it is DC value
sumpow0 = sum(fft0(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow1 = sum(fft1(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow2 = sum(fft2(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow3 = sum(fft3(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow4 = sum(fft4(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow5 = sum(fft5(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow6 = sum(fft6(find(freq >= freqrange(1) & freq <= freqrange(2))));
sumpow7 = sum(fft7(find(freq >= freqrange(1) & freq <= freqrange(2))));



maxmin0 = nanmax(AD0(interval(1)+shift:interval(2)+shift)) - nanmin(AD0(interval(1)+shift:interval(2)+shift));
maxmin1 = nanmax(AD1(interval(1)+shift:interval(2)+shift)) - nanmin(AD1(interval(1)+shift:interval(2)+shift));
maxmin2 = nanmax(AD2(interval(1)+shift:interval(2)+shift)) - nanmin(AD2(interval(1)+shift:interval(2)+shift));
maxmin3 = nanmax(AD3(interval(1)+shift:interval(2)+shift)) - nanmin(AD3(interval(1)+shift:interval(2)+shift));
maxmin4 = nanmax(AD4(interval(1)+shift:interval(2)+shift)) - nanmin(AD4(interval(1)+shift:interval(2)+shift));
maxmin5 = nanmax(AD5(interval(1)+shift:interval(2)+shift)) - nanmin(AD5(interval(1)+shift:interval(2)+shift));
maxmin6 = nanmax(AD6(interval(1)+shift:interval(2)+shift)) - nanmin(AD6(interval(1)+shift:interval(2)+shift));
maxmin7 = nanmax(AD7(interval(1)+shift:interval(2)+shift)) - nanmin(AD7(interval(1)+shift:interval(2)+shift));

max0 = nanmax(AD0(interval(1)+shift:interval(2)+shift));
max1 = nanmax(AD1(interval(1)+shift:interval(2)+shift));
max2 = nanmax(AD2(interval(1)+shift:interval(2)+shift));
max3 = nanmax(AD3(interval(1)+shift:interval(2)+shift));
max4 = nanmax(AD4(interval(1)+shift:interval(2)+shift));
max5 = nanmax(AD5(interval(1)+shift:interval(2)+shift));
max6 = nanmax(AD6(interval(1)+shift:interval(2)+shift));
max7 = nanmax(AD7(interval(1)+shift:interval(2)+shift));

min0 = nanmin(AD0(interval(1)+shift:interval(2)+shift));
min1 = nanmin(AD1(interval(1)+shift:interval(2)+shift));
min2 = nanmin(AD2(interval(1)+shift:interval(2)+shift));
min3 = nanmin(AD3(interval(1)+shift:interval(2)+shift));
min4 = nanmin(AD4(interval(1)+shift:interval(2)+shift));
min5 = nanmin(AD5(interval(1)+shift:interval(2)+shift));
min6 = nanmin(AD6(interval(1)+shift:interval(2)+shift));
min7 = nanmin(AD7(interval(1)+shift:interval(2)+shift));


tuning.minmax = [maxmin0 maxmin1 maxmin2 maxmin3 maxmin4 maxmin5 maxmin6 maxmin7];
tuning.max = [max0 max1 max2 max3 max4 max5 max6 max7];
tuning.min = [min0 min1 min2 min3 min4 min5 min6 min7];
tuning.fft = [sumpow0 sumpow1 sumpow2 sumpow3 sumpow4 sumpow5 sumpow6 sumpow7];

if plotFlag == 1
    fig
    
    subplot(2,2,1)
    plot(-3500:2500,AD0,-3500:2500,AD1,-3500:2500,AD2,-3500:2500,AD3,-3500:2500,AD4,-3500:2500,AD5,-3500:2500,AD6,-3500:2500,AD7)
    xlim([interval(1) interval(2)])
    axis ij
    %legend('Pos0','Pos1','Pos2','Pos3','Pos4','Pos5','Pos6','Pos7')
    title('AD channel, baseline-corrected averages')
    xlabel('Time from Target Onset')
    
    subplot(2,2,2)
    plot(0:7,tuning.minmax,'b',0:7,tuning.max,'r',0:7,tuning.min,'k')
    xlim([0 7])
    xlabel('Screen Position')
    legend('Max-Min','Max','Min')
    

    subplot(2,2,3)
    plot(freq,fft0,freq,fft1,freq,fft2,freq,fft3,freq,fft4,freq,fft5,freq,fft6,freq,fft7)
    
    xlim([freqrange(1) freqrange(2)])
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