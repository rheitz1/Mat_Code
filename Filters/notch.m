%retuns a signal with frequency Hz attenuated by 20 db (I think its 30 db...).
%set parameter Apass to 30.
function sig = notch(sig,freq)

parallelCheck

Fs = 1000;      % Sampling Frequency

Fnotch = freq;  % Notch Frequency
BW     = 1;     % Bandwidth

%preliminary tests suggest that more attentuate will induce large phase
%shifts

Apass  = 30;    % Bandwidth Attenuation

[b, a] = iirnotch(Fnotch/(Fs/2), BW/(Fs/2), Apass);

%dfilt.df2 is zero-phase shift?
Hd     = dfilt.df2(b, a);

disp(['Notch Filter with ' mat2str(Apass) 'db attenutation'])


%if matrix, do trial by trial; otherwise, just filter vector
if isvector(sig)
    sig = filter(Hd,sig);
else
    if useParallel
        parfor trl = 1:size(sig,1)
            sig(trl,:) = filter(Hd,sig(trl,:));
        end
    else
        for trl = 1:size(sig,1)
            sig(trl,1:size(sig,2)) = filter(Hd,sig(trl,:));
        end
    end
end
