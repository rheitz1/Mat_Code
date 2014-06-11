% Returns and plots the Fourier transform of a signal.
% Assumes 1000 Hz sampling unless otherwise specified.
% In code I refer to "Power" but I actually mean magnitude (abs)
% RPH

function [freq,pow] = getFFT(wave,Fs,plotFlag)

if ~isvector(wave); error('Non-vector input detected...'); end

if nargin < 3; plotFlag = 0; end
if nargin < 2; Fs = 1000; plotFlag = 0; end


%OLD METHOD - IS WRONG
%ASSUMES 1000Hz sampling rate unless specified by Fs
N = length(wave);

%this part of the code generates the frequency axis
if mod(N,2)==0
    k=-N/2:N/2-1; % N even
else
    k=-(N-1)/2:(N-1)/2; % N odd
end

T=N/Fs;
freq=k/T;  %the frequency axis


%How much do we need to pad?
nfft= 2^(nextpow2(length(wave)));

%multiply by 2 because we are looking at single-sided frequency spectrum.
pow = 2.* (abs(fft(wave))/N);

%shift
pow = fftshift(pow); %shifts the fft data so that it is centered
%
% freq = freq(find(freq >= 0));
% fft_wave = fftshift(find(freq>=0));

%return only that part of the frequency spectrum corresponding to >= 0 Hz
%will chop off first value (DC value)
pow = pow(find(freq >= 0));

%limit to frequencies >= 0 (will be symmetrical about 0
freq = freq(find(freq >= 0));



if plotFlag == 1
    figure
    set(gcf,'color','white')
    set(gca,'fontsize',14,'fontweight','bold')

%    subplot(121)
    plot(freq,pow,'r')
    box off
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    
%     subplot(122)
%     plot(freq,10*log10(pow),'r')
%     box off
%     xlabel('Frequency (Hz)')
%     ylabel('dB')
%     
end

