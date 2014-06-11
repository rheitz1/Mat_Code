% Returns the Fourier transform of a signal.
% Assumes 1000 Hz sampling unless otherwise specified
% RPH

function [freq,mag] = getFFT2(wave,Fs,zeropad,plotFlag)

if ~isvector(wave); error('Non-vector input detected...'); end

if nargin < 4; plotFlag = 0; end

if nargin < 3; zeropad = 0; end

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


if zeropad
    %normalize the FFT
    mag = abs(fft(wave,nfft)/N);
else
    mag = abs(fft(wave)/N);
end


%shift
%mag = fftshift(mag); %shifts the fft data so that it is centered

%keep single-sided power spectrum
mag(N/2:length(wave)-1) = [];

%multiply by 2 to account for loss of other side of spectrum
mag(2:length(mag)) = mag(2:length(mag)) .* 2;

%return only that part of the frequency spectrum corresponding to >= 0 Hz
%will chop off first value (DC value)



if plotFlag == 1
    figure
    set(gcf,'color','white')
    set(gca,'fontsize',14,'fontweight','bold')
    plot(freq,mag,'r')
    box off
    
    xlabel('Frequency (Hz)')
    ylabel('Power')
end