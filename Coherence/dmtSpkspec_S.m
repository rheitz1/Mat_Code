%dmtSpkspec_S
%script m file for use with tfspec
%scale=1;

%tapers = tapers*sqrt(sampling);
H = fft(tapers(:,1:K),nf);     %take the FFT of the tapers for the point proecess correction that applies to spikes but not LFPs

Xk = zeros(nch*K, diff(nfk)+1);
if detrendflag  tmp=detrend(tmp);   end     %detrends the columns of tmp (which are trials of X)
tmpmn=mean(tmp);    %tmpmn will be a row vec with the mean val for each tr

%note: I removed a for loop across trials from below ... but it turned out not to be any faster...
%Below: so we keep ch constant while varying K, and do this for each ch... but we can do that in one line without a for loop
Xk = fft( tapers(:, repmat(1:K,1,nch)).*tmp( :, GenSecDimVarInds(K,nch) ),nf )- ...  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... so this outputs
    H(:, repmat(1:K,1,nch)).*repmat( tmpmn( 1, GenSecDimVarInds(K,nch) ),nf,1 );
if nfk(1)>1 || nfk(2)<size(Xk,1)    %so Xk will have freqs down dim 1, and nch*K down dim 2
    Xk = Xk(nfk(1):nfk(2),:);
end
%Xk=Xk/sampling;

if CalcPart
    XkResid=Xk-repmat( mean(Xk,2),1,ch*K );
    YkResid=Yk-repmat( mean(Yk,2),1,ch*K );
end

if PSDScaleFlag
    Xk=abs(Xk)/sqrt(sampling);  %note that after this scaling, these (obviously) aren't the raw fourier components anymore, even though I'm keeping the same variable label Xk...
    if CalcPart
        XkResid=abs(XkResid)/sqrt(sampling);
    end
else
    OddTaps=[1:2:K];    %to scale aptly for MS spec, we can only look at the odd tapers, b/c the even tapers sum to zero
    
    %Definitely no abs is desired in the line of code below
    U=sum( tapers(:, repmat(OddTaps,1,nch)) ,1);    %do this for a non-rect window instead of dividing by teh number of trials
    
    Xk=abs(Xk( :,OddTaps ))./repmat(U,size(Xk,1),1);    %note that after this scaling, these (obviously) aren't the raw fourier components anymore, even though I'm keeping the same variable label Xk...
    if CalcPart
        XkResid=abs(XkResid( :,OddTaps ))./repmat(U,size(XkResid,1),1);
    end
end

if CalcPart
    if JustPartFlag;     spec(win,:) = mean(XkResid.^2,2);   %averaging across tapers and trials
    else    Pspec(win,:) = mean(XkResid.^2,2);   %averaging across tapers and trials
    end
end

if ~JustPartFlag
    spec(win,:) = mean(Xk.^2,2);   %averaging across tapers and trials
end

if scale
    spec(win,:)=spec(win,:)*2;    %because we're only using half the spectrum
    spec(win,1)=spec(win,1)/2;
    if incNy % Nyquist component should also be unique.
        spec(win,end)=spec(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
    end
    
    if CalcPart && ~JustPartFlag
        Pspec(win,:)=Pspec(win,:)*2;    %because we're only using half the spectrum
        Pspec(win,1)=Pspec(win,1)/2;
        if incNy % Nyquist component should also be unique.
            Pspec(win,end)=Pspec(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
        end
    end
end

% if errorchk		%  Estimate error bars using Jacknife
%     dof = 2*nch*K;
%     for ik = 1:nch*K    %for each taper/trial combination
%         indices = setdiff([1:K*nch],[ik]);   %all taper/trial combs other than our current one (that's a lot... probably why it takes so long)
%         xj = Xk(indices,:);
%         jlsp(ik,:) = log(mean(abs(xj).^2,1));    %a jackknife sample in each row leaving a different taper/trial comb out, with a different frequency in each column
%     end
%     lsig = sqrt(nch*K-1).*std(jlsp,1);
%     crit = tinv(1-pval./2,dof-1);		% Determine the scaling factor; This gives you the t-statistic value (given the degrees of freedom) above which
%     % you would expect to be found only pval/2 percent of the time by chance
%     err(1,win,:) = exp(log(spec(win,:))+crit.*lsig);
%     err(2,win,:) = exp(log(spec(win,:))-crit.*lsig);
% end