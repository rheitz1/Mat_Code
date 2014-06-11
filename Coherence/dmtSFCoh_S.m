%dmtSFCoh_S
%script m file for use with Spk_SpkCoh
%scale=1;

%tapers = tapers*sqrt(sampling);
H = fft(tapers(:,1:K),nf);     %take the FFT of the tapers for the point proecess correction that applies to spikes but not LFPs

Xk = zeros(nch*K, diff(nfk)+1);
Yk=Xk;
if detrendflag
    tmp=detrend(tmp);
    tmp2=detrend(tmp2);
end     %detrends the columns of tmp (which are trials of X)
tmpmn=mean(tmp);    %tmpmn will be a row vec with the mean val for each Tr
%tmpmn2=mean(tmp2);     %Note- don't need to do this for X, the LFP

%note: I removed a for loop across trials from below ... but it turned out not to be any faster...
%Below: so we keep ch constant while varying K, and do this for each ch... but we can do that in one line without a for loop
Xk = fft( tapers(:, repmat(1:K,1,nch)).*tmp( :, GenSecDimVarInds(K,nch) ),nf )- ...  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... so this outputs
    H(:, repmat(1:K,1,nch)).*repmat( tmpmn( 1, GenSecDimVarInds(K,nch) ),nf,1 );
Yk = fft( tapers(:, repmat(1:K,1,nch)).*tmp2( :, GenSecDimVarInds(K,nch) ),nf ); % ...  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... so this outputs
%H(:, repmat(1:K,1,nch)).*repmat( tmpmn2( 1, GenSecDimVarInds(K,nch) ),nf,1 );
if nfk(1)>1 || nfk(2)<size(Xk,1)    %so Xk will have freqs down dim 1, and nch*K down dim 2
    Xk = Xk(nfk(1):nfk(2),:);
    Yk = Yk(nfk(1):nfk(2),:);
end

if CalcPart
    XkResid=Xk-repmat( mean(Xk,2),1,nch*K );
    YkResid=Yk-repmat( mean(Yk,2),1,nch*K );
    if JustPartFlag;    coh(win,:) = mean(XkResid.*conj(YkResid),2)./sqrt( mean(abs(XkResid).^2,2) .* mean(abs(YkResid).^2,2) );
    else    Pcoh(win,:) = mean(XkResid.*conj(YkResid),2)./sqrt( mean(abs(XkResid).^2,2) .* mean(abs(YkResid).^2,2) );
    end
end

%Xk=Xk/sampling;
if ~JustPartFlag
    coh(win,:) = mean(Xk.*conj(Yk),2)./sqrt( mean(abs(Xk).^2,2) .* mean(abs(Yk).^2,2) );
end

if CalcSpec
    if PSDScaleFlag
        Xk=abs(Xk)/sqrt(sampling);
        Yk=abs(Yk)/sqrt(sampling);
        
        if CalcPartSpec
            XkResid=abs(XkResid)/sqrt(sampling);
            YkResid=abs(YkResid)/sqrt(sampling);
        end
    else
        OddTaps=[1:2:K];    %to scale aptly for MS spec, we can only look at the odd tapers, b/c the even tapers sum to zero
        
        %Definitely no abs is desired in the line of code below
        U=sum( tapers(:, repmat(OddTaps,1,nch)) ,1);    %do this for a non-rect window instead of dividing by teh number of trials
        %note the same U normalization vector applies to both signals X and Y
        
        Xk=abs(Xk( :,OddTaps ))./repmat(U,size(Xk,1),1);
        Yk=abs(Yk( :,OddTaps ))./repmat(U,size(Yk,1),1);
        
        if CalcPartSpec
            XkResid=abs(XkResid( OddTaps,: ))./repmat(U,size(XkResid,1),1);
            YkResid=abs(YkResid( OddTaps,: ))./repmat(U,size(YkResid,1),1);
        end
    end
    
    S1(win,:) = mean(Xk.^2,2);   %averaging across tapers and trials
    S2(win,:) = mean(Yk.^2,2);   %averaging across tapers and trials
    if CalcPartSpec
        PS1(win,:) = mean(XkResid.^2,2);   %averaging across tapers and trials
        PS2(win,:) = mean(YkResid.^2,2);   %averaging across tapers and trials
    end
    
    if scale
        S1(win,:)=S1(win,:)*2;    %because we're only using half the spectrum
        S1(win,1)=S1(win,1)/2;
        S2(win,:)=S2(win,:)*2;    %because we're only using half the spectrum
        S2(win,1)=S2(win,1)/2;
        if incNy % Nyquist component should also be unique.
            S1(win,end)=S1(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
            S2(win,end)=S2(win,end)/2;
        end
        
        if CalcPartSpec
            PS1(win,:)=PS1(win,:)*2;    %because we're only using half the spectrum
            PS1(win,1)=PS1(win,1)/2;
            PS2(win,:)=PS2(win,:)*2;    %because we're only using half the spectrum
            PS2(win,1)=PS2(win,1)/2;
            if incNy % Nyquist component should also be unique.
                PS1(win,end)=PS1(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                PS2(win,end)=PS2(win,end)/2;
            end
        end
    end
end

%     if errorchk		%  Estimate error bars using Jacknife
%         dof = 2*nch*K;
%         for ik = 1:nch*K    %for each taper/trial combination
%             indices = setdiff([1:K*nch],[ik]);   %all taper/trial combs other than our current one (that's a lot... probably why it takes so long)
%             xj = Xk(indices,:);
%             jlsp(ik,:) = log(mean(abs(xj).^2,1));    %a jackknife sample in each row leaving a different taper/trial comb out, with a different frequency in each column
%         end
%         lsig = sqrt(nch*K-1).*std(jlsp,1);
%         crit = tinv(1-pval./2,dof-1);		% Determine the scaling factor; This gives you the t-statistic value (given the degrees of freedom) above which
%         % you would expect to be found only pval/2 percent of the time by chance
%         err(1,win,:) = exp(log(spec(win,:))+crit.*lsig);
%         err(2,win,:) = exp(log(spec(win,:))-crit.*lsig);
%     end
