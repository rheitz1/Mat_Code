function [filtered_signal] = filtSig(sig,band,type)

if strcmp(type,'notch')
    filtered_signal = notch(sig,band);
elseif strcmp(type,'bandstop')
    disp(['Applying ' type ' zero-phase shift filter...'])
    filtered_signal = bandstop(sig,band);
elseif strcmp(type,'bandpass')
    disp(['Applying ' type ' zero-phase shift filter...'])
    filtered_signal = bandpass(sig,band);
elseif strcmp(type,'lowpass')
    disp(['Applying ' type ' zero-phase shift filter...'])
    filtered_signal = lowpass(sig,band);
elseif strcmp(type,'highpass')
    disp(['Applying ' type ' zero-phase shift filter...'])
    filtered_signal = highpass(sig,band);
end