%dmtFFCoh_S.m
%script m file for use with tfspec
%scale=1;

% Pooling across trials
Xk = zeros(nch*K, diff(nfk)+1);
Yk=Xk;
if detrendflag
    tmp1=detrend(tmp1);
    tmp2=detrend(tmp2);
end     %detrends the columns of tmp (which are trials of X)

%note: I tried removing the for loop across trials from below to improve speed, but that had no effect on the speed!... so I kept the for loop in as it's easier to conceptualize
for ch=1:nch
    tmpch1=tmp1(:,ch);
    curk = fft(tapers(:,1:K).*tmpch1(:,ones(1,K)),nf)';
    Xk((ch-1)*K+1:ch*K,:) = curk(:,nfk(1):nfk(2));
    tmpch2=tmp2(:,ch);
    curk = fft(tapers(:,1:K).*tmpch2(:,ones(1,K)),nf)';
    Yk((ch-1)*K+1:ch*K,:) = curk(:,nfk(1):nfk(2));
end

%for partial coherence, calc residual Fourier coefficients
if CalcPart
    XkResid=Xk-repmat( mean(Xk),ch*K,1 );
    YkResid=Yk-repmat( mean(Yk),ch*K,1 );
    if JustPartFlag;    coh(win,:) = mean(XkResid.*conj(YkResid))./sqrt( mean(abs(XkResid).^2) .* mean(abs(YkResid).^2) );
    else    Pcoh(win,:) = mean(XkResid.*conj(YkResid))./sqrt( mean(abs(XkResid).^2) .* mean(abs(YkResid).^2) );
    end
end

if ~JustPartFlag
    coh(win,:) = mean(Xk.*conj(Yk))./sqrt( mean(abs(Xk).^2) .* mean(abs(Yk).^2) );
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
        
        %Note- Xk here was transposed (above) after the fft, so the dimension ordering here is different than in LFPSpec...
        Xk=abs(Xk( OddTaps,: ))./repmat(U',1,size(Xk,2));
        Yk=abs(Yk( OddTaps,: ))./repmat(U',1,size(Yk,2));
        
        if CalcPartSpec
            XkResid=abs(XkResid( OddTaps,: ))./repmat(U',1,size(XkResid,2));
            YkResid=abs(YkResid( OddTaps,: ))./repmat(U',1,size(YkResid,2));
        end
    end
    
    %Note- Xk here was transposed (above) after teh fft, so the dimension ordering here is different than in LFPSpec...
    Sx(win,:) = mean(Xk.^2);   %averaging across tapers and trials
    Sy(win,:) = mean(Yk.^2);   %averaging across tapers and trials
    
    if CalcPartSpec
        PSx(win,:) = mean(XkResid.^2);   %averaging across tapers and trials
        PSy(win,:) = mean(YkResid.^2);   %averaging across tapers and trials
    end
    if scale
        Sx(win,:)=Sx(win,:)*2;    %because we're only using half the spectrum
        Sx(win,1)=Sx(win,1)/2;
        Sy(win,:)=Sy(win,:)*2;    %because we're only using half the spectrum
        Sy(win,1)=Sy(win,1)/2;
        if incNy % Nyquist component should also be unique.
            Sx(win,end)=Sx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
            Sy(win,end)=Sy(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
        end
        
        if CalcPartSpec
            PSx(win,:)=PSx(win,:)*2;    %because we're only using half the spectrum
            PSx(win,1)=PSx(win,1)/2;
            PSy(win,:)=PSy(win,:)*2;    %because we're only using half the spectrum
            PSy(win,1)=PSy(win,1)/2;
            if incNy % Nyquist component should also be unique.
                PSx(win,end)=PSx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                PSy(win,end)=PSy(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
            end
        end
    end
end


%     if errorchk		%  Estimate error bars using Jacknife
%         coh_err = zeros(2, diff(nfk));
%         SX_err = zeros(2, diff(nfk));
%         SY_err = zeros(2, diff(nfk));
%
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
