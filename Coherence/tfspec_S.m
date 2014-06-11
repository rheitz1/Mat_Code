% tfspec_S
% for use with LFPSpec; formerly tfspec, with inputs written below
%
%function [spec, f, err] = tfspec(X, tapers, sampling, dn, fk, pad, pval, flag);
%TFSPEC  Moving window time-frequency spectrum using multitaper techniques.
%
% [SPEC, F, ERR] = TFSPEC(X, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG) 
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%			   	    [N,W] Form:  N = duration of analysis window in s.
%                                W = bandwidth of frequency smoothing in Hz.
%               Defaults to [N,3,5] where N is NT/10
%				and NT is duration of X. 
%               
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    DN		=  Amount to slide window each time sample. (In s)
%			       	Defaults to N/10;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
%	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
%
%  Outputs: SPEC	=  Spectrum of X in [Space/Trials, Time, Freq] form. 
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 
%   See also DPSS, PSD, SPECTROGRAM.


sX = size(X);
nt = sX(2);              % calculate the number of points
nch = sX(1);               % calculate the number of channels

[N K] = size(tapers); %K is # of tapers, N is number of Samples in a taper
if N > nt error(['Error: You probably need to transpose (rotate) your input data. Taper length: ' num2str(N) ' is longer than the time series, length: ' num2str(nt)]); end

dn = dn.*sampling;  %convert to number of samples
if ~isint(dn)
    dn=round(dn);
    disp(['Had to round dn to ' num2str(dn) ' samples for a ' num2str(dn/sampling*1e3) ' ms slide.'])
end

if pad==0
    nf=N;
else
    if FSPadFlag    nf = max(sampling*2^nextpow2(256/sampling), sampling*pad*2^nextpow2(N/sampling));
    else    nf = max(256, pad*2^nextpow2(N+1));     end %# of points for FFT
end

fstep=sampling/nf;
nfk(1)=floor(fk(1)/fstep)+1;    %this gives the index we go to for the FFT. It's plus 1 because the first index is the DC value. Note we can't always get any arbitrary frequency unless its a multiple of fstep
nfk(2)=ceil(fk(2)/fstep)+1;
f=(nfk(1)-1)*fstep:fstep:(nfk(2)-1)*fstep;
if iseven(nf) && f(end)==sampling/2 incNy=1;
else incNy=0;   end

nwin = (nt-N)/dn+1;           % calculate the number of windows
if ~isint(nwin)
    nwin=floor(nwin);
    %disp('Had to round nwin down and cut off some of the data')
end


% Pooling across trials
spec = zeros(nwin,diff(nfk)+1);
err = zeros(2,nwin,diff(nfk)+1);
for win = 1:nwin
    %if mod(win,25)==0   disp(['on win: ' num2str(win)]);    end
    dat1 = X(:,(win-1)*dn+1:(win-1)*dn+N)';   %changed to win-1 becasue that ignored the first few samples, also added 1 to nwin above
    
    %dmtspec_S
    dmtUbiq_S
end