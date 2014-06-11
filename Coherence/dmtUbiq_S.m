%dmtUbiq_S
%script m file that can be used by all coherence functions, i.e. LFP_LFP,
%Spk_Spk and Spk_LFP

%This script expects the main data in dat1 for Chan 1, and dat2 for Chan2
%with SpkFlag as a 2x1 vector indicating whether a given signal is a Spk (1)
%or not (0), and variable TwoSigsFlag to indicate whether or not two signals
%are present.... also if any Spks are present, the variable H is expected
%to have the fft of the tapers in the form (1:K x Freqs)

% Pooling across trials
%Xk = zeros(nch*K, diff(nfk)+1);
%Yk=Xk;
if detrendflag
    %tmp=detrend(tmp);  %detrends the columns of tmp (which are each one trial of X)
    %dat2=detrend(dat2);
    
    dat1=detrend(dat1,2);   %detrends the rows of dat1 (which are ecah one trial of X)
    if TwoSigsFlag;     dat2=detrend(dat2,2);       end
    
    if SplitTrsFlag && win==1;    warning('Detrending across trials before splitting trial data. Split trial type results may be off because of detrending. Either turn detrending off, or adjust this code to allow both detrending and splitting trial types accurately.');       end
end     %detrends the columns of tmp (which are trials of X)
if SpkFlag(1);   datmn1=mean(dat1,2);     end
if TwoSigsFlag && SpkFlag(2);   datmn2=mean(dat2,2);     end

%note: below: older code that I rewrote belwo to improve speed
% for ch=1:nch
%     %tmpch1=dat1(:,ch);
%     %curk = fft(tapers(:,1:K).*tmpch1(:,ones(1,K)),nf)';
%
%     curk = fft(tapers.*dat1( repmat(ch,K,1),: ),nf); %tapers should already be 1:K...
%     Xk((ch-1)*K+1:ch*K,:) = curk(:,nfk(1):nfk(2));  %so Xk will have nch*K down dim 1, and freqs down dim 2
%
%     %tmpch2=dat2(:,ch);
%     %curk = fft(tapers(:,1:K).*tmpch2(:,ones(1,K)),nf)';
%
%     curk = fft(tapers.*dat2( repmat(ch,K,1),: ),nf);
%     Yk((ch-1)*K+1:ch*K,:) = curk(:,nfk(1):nfk(2));
% end

%amazing- prestoring the tapers in the workspace rather than replicating them at the input
%to FFT seems to save a considerable amount of time... I would have thought otherwise
%i.e. whats below takes much less time than the alternative:   Xk = fft( tapers(repmat(1:K,nch,1),:).*dat1( tmpInds,: ),nf,2 );
%but for some reason it doesn't seem to speed things up to do that for replicating the data... perhaps it has to do with the number of times it has to replicate
%values of the matrix, and when this number is high it's better to pre-store that in the workspace? hard to say

%Though matlab is faster doing things down the first dim, we prefer to keep
%our data with trials as the first dim, and time in the trial as the second
%dim. I tested the speed of the code, and on my copmuter it turns out to be
%faster to do the fft (and eveyrthing else) down the second dim than to
%transpose the data and do things down the first dim...

tmpInds=GenSecDimVarInds(K,nch);
tmpTaps=tapers(repmat([1:K]',nch,1),:);
%tmpTaps=tapers(:,repmat([1:K]',nch,1)); %if going down dim 1

if SpkFlag(1)
    Xk = fft( tmpTaps.*dat1( tmpInds,: ),nf,2 )-H(repmat(1:K,1,nch),:).*repmat( datmn1(tmpInds),1,nf );  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on...
else
    Xk = fft( tmpTaps.*dat1( tmpInds,: ),nf,2 );  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on...
end
if TwoSigsFlag
    if SpkFlag(2)
        Yk = fft( tmpTaps.*dat2( tmpInds,: ),nf,2 )-H(repmat(1:K,1,nch),:).*repmat( datmn2(tmpInds),1,nf );  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... so this outputs
    else
        Yk = fft( tmpTaps.*dat2( tmpInds,: ),nf,2 );  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... so this outputs
    end
end


%Xk = fft( tmpTaps.*dat1( :,tmpInds ),nf );  %if going down dim 1
%Yk = fft( tmpTaps.*dat2( :,tmpInds ),nf );  %if going down dim 1

if nfk(1)>1 || nfk(2)<size(Xk,2)
    %Xk = Xk(nfk(1):nfk(2),:);  %if going down dim 1
    %Yk = Yk(nfk(1):nfk(2),:);
    
    Xk = Xk(:,nfk(1):nfk(2));    %so Xk will have nch*K down dim 1 and freqs down dim 2
    if TwoSigsFlag;     Yk = Yk(:,nfk(1):nfk(2));   end
end
%note that these Xk and Yk won't quantitatively match the J1 and J2 in teh Chronux code for the same data, which is b/c they normalize differently, before teh fourier transform... this normalization has no effect on the resulting coherence values though

%for partial coherence, calc residual Fourier coefficients
if CalcPart
    XkResid=Xk-repmat( mean(Xk),nch*K,1 );
    if TwoSigsFlag;     YkResid=Yk-repmat( mean(Yk),nch*K,1 );      end
    
    if JustPartFlag
        if TwoSigsFlag;     coh(win,:) = mean(XkResid.*conj(YkResid))./sqrt( mean(abs(XkResid).^2) .* mean(abs(YkResid).^2) );
            %else                spec(win,:) = mean(XkResid.^2);
        end
    else
        if TwoSigsFlag;     Pcoh(win,:) = mean(XkResid.*conj(YkResid))./sqrt( mean(abs(XkResid).^2) .* mean(abs(YkResid).^2) );
            %else                Pspec(win,:) = mean(XkResid.^2);
        end
    end
    
    if SplitTrsFlag
        Xk1Resid=Xk(Tr1Inds,:)-repmat( mean(Xk(Tr1Inds,:)),sum(Tr1Inds),1 );
        Xk2Resid=Xk(Tr2Inds,:)-repmat( mean(Xk(Tr2Inds,:)),sum(Tr2Inds),1 );
        if TwoSigsFlag
            Yk1Resid=Yk(Tr1Inds,:)-repmat( mean(Yk(Tr1Inds,:)),sum(Tr1Inds),1 );
            Yk2Resid=Yk(Tr2Inds,:)-repmat( mean(Yk(Tr2Inds,:)),sum(Tr2Inds),1 );
        end
        
        if JustPartFlag
            if TwoSigsFlag
                err.TrType1.coh(win,:) = mean(Xk1Resid.*conj(Yk1Resid))./sqrt( mean(abs(Xk1Resid).^2) .* mean(abs(Yk1Resid).^2) );
                err.TrType2.coh(win,:) = mean(Xk2Resid.*conj(Yk2Resid))./sqrt( mean(abs(Xk2Resid).^2) .* mean(abs(Yk2Resid).^2) );
            end
        else
            if TwoSigsFlag;
                err.TrType1.Pcoh(win,:) = mean(Xk1Resid.*conj(Yk1Resid))./sqrt( mean(abs(Xk1Resid).^2) .* mean(abs(Yk1Resid).^2) );
                err.TrType2.Pcoh(win,:) = mean(Xk2Resid.*conj(Yk2Resid))./sqrt( mean(abs(Xk2Resid).^2) .* mean(abs(Yk2Resid).^2) );
            end
        end
    end
end

if ~JustPartFlag
    if TwoSigsFlag
        coh(win,:) = mean(Xk.*conj(Yk))./sqrt( mean(conj(Xk).*Xk) .* mean(conj(Yk).*Yk) );
        
        if SplitTrsFlag
            err.TrType1.coh(win,:) = mean(Xk(Tr1Inds,:).*conj(Yk(Tr1Inds,:)))./sqrt( mean(conj(Xk(Tr1Inds,:)).*Xk(Tr1Inds,:)) .* mean(conj(Yk(Tr1Inds,:)).*Yk(Tr1Inds,:)) );
            err.TrType2.coh(win,:) = mean(Xk(Tr2Inds,:).*conj(Yk(Tr2Inds,:)))./sqrt( mean(conj(Xk(Tr2Inds,:)).*Xk(Tr2Inds,:)) .* mean(conj(Yk(Tr2Inds,:)).*Yk(Tr2Inds,:)) );
        end
    end
    
    %coh(:,win) = mean(Xk.*conj(Yk),2)./sqrt( mean(abs(Xk).^2,2) .*mean(abs(Yk).^2,2) ); if going down dim 1
end

%save the raw Xk's for permutation tests if desired...
if errorchk && errType==2    %do cluster permutation tests similar to Maris et al. 2007 in JNM
    %here we just want to collect the baselin and activity period Four. components...
    if InBasePer(win) && ClusShuffOpts.TestType==1
        curBwin=sum(InBasePer(1:win));
        BaseXkoAll(:,:, curBwin )=Xk;
        if TwoSigsFlag;     BaseYkoAll(:,:, curBwin )=Yk;       end
        
        %decided not to take mean of mult base wins, instead randomly select 1 win for each shuff for each freq if multiple basewins are present
        %             if curBwin==nInBasePer  %then avg the Fourier copmonents across all the BaseWins
        %                 BaseXko=mean(BaseXkoAll,3);
        %                 BaseYko=mean(BaseXkoAll,3);
        %             end
    end
    
    if InActPer(win)
        curAwin=sum(InActPer(1:win));
        
        if ClusShuffOpts.TestType==1
            ActXkoAll(:,:, curAwin )=Xk;
            if TwoSigsFlag;     ActYkoAll(:,:, curAwin )=Yk;        end
        elseif ClusShuffOpts.TestType==2    %i.e. splitting trials
            ActXkoAll(:,:, curAwin )=Xk(Tr1Inds,:);
            if TwoSigsFlag;     ActYkoAll(:,:, curAwin )=Yk(Tr1Inds,:);        end
            
            BaseXkoAll(:,:, curAwin )=Xk(Tr2Inds,:);
            if TwoSigsFlag;     BaseYkoAll(:,:, curAwin )=Yk(Tr2Inds,:);        end
        end
    end
end

if CalcSpec || ~TwoSigsFlag
    if PSDScaleFlag
        Xk=abs(Xk)/sqrt(sampling);
        if TwoSigsFlag;         Yk=abs(Yk)/sqrt(sampling);      end
        if CalcPartSpec
            XkResid=abs(XkResid)/sqrt(sampling);
            if TwoSigsFlag;         YkResid=abs(YkResid)/sqrt(sampling);        end
            
            if SplitTrsFlag
                Xk1Resid=abs(Xk1Resid)/sqrt(sampling);
                Xk2Resid=abs(Xk2Resid)/sqrt(sampling);
                if TwoSigsFlag;
                    Yk1Resid=abs(Yk1Resid)/sqrt(sampling);
                    Yk2Resid=abs(Yk2Resid)/sqrt(sampling);
                end
            end
        end
    else
        OddTaps=[1:2:K]';    %to scale aptly for MS spec, we can only look at the odd tapers, b/c the even tapers sum to zero
        nOddTaps=length(OddTaps);
        
        tmpSelChans=repmat(OddTaps,nch,1);
        
        %Definitely no abs is desired in the line of code below
        %U=sum( tapers(:, repmat(OddTaps,1,nch)) ,1)';    %do this for a non-rect window instead of dividing by teh number of trials
        U=sum( tapers(tmpSelChans,:) ,2);
        %note the same U normalization vector applies to both signals X and Y
        
        %Note- Xk here was transposed (above) after the fft, so the dimension ordering here is different than in LFPSpec...
        %This doesn't work for multiple trials!... see code a little lower
        %Xk=abs(Xk( OddTaps,: ))./repmat(U',1,size(Xk,2));
        %Yk=abs(Yk( OddTaps,: ))./repmat(U',1,size(Yk,2));
        
        tmpSelChans=tmpSelChans+K*( ceil([1:nOddTaps*nch]'/nOddTaps)-1 );
        Xk=abs(Xk( tmpSelChans,: ))./repmat(U,1,size(Xk,2));
        if TwoSigsFlag;         Yk=abs(Yk( tmpSelChans,: ))./repmat(U,1,size(Yk,2));        end
        
        if CalcPartSpec || (CalcPart && ~TwoSigsFlag)
            XkResid=abs(XkResid( tmpSelChans,: ))./repmat(U,1,size(XkResid,2));
            if TwoSigsFlag;         YkResid=abs(YkResid( tmpSelChans,: ))./repmat(U,1,size(YkResid,2));         end
            
            if SplitTrsFlag
                if win==1
                    warning('The trial conditional split partial spectrum won''t be scaled properly with this collection of inputs.')
                end
            end
        end
    end
    
    %Note- Xk here was transposed (above) after the fft, so the dimension ordering here is different than in LFPSpec...
    if ~JustPartFlag
        Sx(win,:) = mean(Xk.^2,1);   %averaging across tapers and trials
        if TwoSigsFlag;     Sy(win,:) = mean(Yk.^2,1);        end     %averaging across tapers and trials
        
        if SplitTrsFlag
            err.TrType1.Sx(win,:) = mean(Xk(Tr1Inds,:).^2,1);   %averaging across tapers and trials
            err.TrType2.Sx(win,:) = mean(Xk(Tr2Inds,:).^2,1);   %averaging across tapers and trials
            
            if TwoSigsFlag
                err.TrType1.Sy(win,:) = mean(Yk(Tr1Inds,:).^2,1);   %averaging across tapers and trials
                err.TrType2.Sy(win,:) = mean(Yk(Tr2Inds,:).^2,1);   %averaging across tapers and trials
            end
        end
    end
    
    if CalcPartSpec || (CalcPart && ~TwoSigsFlag)
        if JustPartFlag
            Sx(win,:) = mean(XkResid.^2,1);   %averaging across tapers and trials
            if TwoSigsFlag;     Sy(win,:) = mean(YkResid.^2,1);          end         %averaging across tapers and trials
            
            if SplitTrsFlag
                err.TrType1.Sx(win,:) = mean(Xk1Resid.^2,1);   %averaging across tapers and trials
                err.TrType2.Sx(win,:) = mean(Xk2Resid.^2,1);   %averaging across tapers and trials
                if TwoSigsFlag
                    err.TrType1.Sy(win,:) = mean(Yk1Resid.^2,1);   %averaging across tapers and trials
                    err.TrType2.Sy(win,:) = mean(Yk2Resid.^2,1);   %averaging across tapers and trials
                end
            end
        else
            PSx(win,:) = mean(XkResid.^2);   %averaging across tapers and trials
            if TwoSigsFlag;     PSy(win,:) = mean(YkResid.^2,1);          end         %averaging across tapers and trials
            
            if SplitTrsFlag
                err.TrType1.PSx(win,:) = mean(Xk1Resid.^2,1);   %averaging across tapers and trials
                err.TrType2.PSx(win,:) = mean(Xk2Resid.^2,1);   %averaging across tapers and trials
                if TwoSigsFlag
                    err.TrType1.PSy(win,:) = mean(Yk1Resid.^2,1);   %averaging across tapers and trials
                    err.TrType2.PSy(win,:) = mean(Yk2Resid.^2,1);   %averaging across tapers and trials
                end
            end
        end
    end
    if scale
        Sx(win,:)=Sx(win,:)*2;    %because we're only using half the spectrum
        Sx(win,1)=Sx(win,1)/2;
        if TwoSigsFlag;
            Sy(win,:)=Sy(win,:)*2;    %because we're only using half the spectrum
            Sy(win,1)=Sy(win,1)/2;
        end
        if incNy % Nyquist component should also be unique.
            Sx(win,end)=Sx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
            if TwoSigsFlag;     Sy(win,end)=Sy(win,end)/2;      end     % Here NFFT is even; therefore,Nyquist point is included.
        end
        
        if SplitTrsFlag
            err.TrType1.Sx(win,:)=err.TrType1.Sx(win,:)*2;    %because we're only using half the spectrum
            err.TrType1.Sx(win,1)=err.TrType1.Sx(win,1)/2;
            err.TrType2.Sx(win,:)=err.TrType2.Sx(win,:)*2;    %because we're only using half the spectrum
            err.TrType2.Sx(win,1)=err.TrType2.Sx(win,1)/2;
            
            if TwoSigsFlag;
                err.TrType1.Sy(win,:)=err.TrType1.Sy(win,:)*2;    %because we're only using half the spectrum
                err.TrType1.Sy(win,1)=err.TrType1.Sy(win,1)/2;
                err.TrType2.Sy(win,:)=err.TrType2.Sy(win,:)*2;    %because we're only using half the spectrum
                err.TrType2.Sy(win,1)=err.TrType2.Sy(win,1)/2;
            end
            if incNy % Nyquist component should also be unique.
                err.TrType1.Sx(win,end)=err.TrType1.Sx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                err.TrType2.Sx(win,end)=err.TrType2.Sx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                if TwoSigsFlag
                    err.TrType1.Sy(win,end)=err.TrType1.Sy(win,end)/2;
                    err.TrType2.Sy(win,end)=err.TrType2.Sy(win,end)/2;
                end     % Here NFFT is even; therefore,Nyquist point is included.
            end
        end
        
        if ~JustPartFlag && (CalcPartSpec || (CalcPart && ~TwoSigsFlag))
            PSx(win,:)=PSx(win,:)*2;    %because we're only using half the spectrum
            PSx(win,1)=PSx(win,1)/2;
            if TwoSigsFlag;
                PSy(win,:)=PSy(win,:)*2;    %because we're only using half the spectrum
                PSy(win,1)=PSy(win,1)/2;
            end
            if incNy % Nyquist component should also be unique.
                PSx(win,end)=PSx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                if TwoSigsFlag;         PSy(win,end)=PSy(win,end)/2;            end      % Here NFFT is even; therefore,Nyquist point is included.
            end
            
            if SplitTrsFlag
                err.TrType1.PSx(win,:)=err.TrType1.PSx(win,:)*2;    %because we're only using half the spectrum
                err.TrType1.PSx(win,1)=err.TrType1.PSx(win,1)/2;
                err.TrType2.PSx(win,:)=err.TrType2.PSx(win,:)*2;    %because we're only using half the spectrum
                err.TrType2.PSx(win,1)=err.TrType2.PSx(win,1)/2;
                if TwoSigsFlag;
                    err.TrType1.PSy(win,:)=err.TrType1.PSy(win,:)*2;    %because we're only using half the spectrum
                    err.TrType1.PSy(win,1)=err.TrType1.PSy(win,1)/2;
                    err.TrType2.PSy(win,:)=err.TrType2.PSy(win,:)*2;    %because we're only using half the spectrum
                    err.TrType2.PSy(win,1)=err.TrType2.PSy(win,1)/2;
                end
                if incNy % Nyquist component should also be unique.
                    err.TrType1.PSx(win,end)=err.TrType1.PSx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                    err.TrType2.PSx(win,end)=err.TrType2.PSx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                    if TwoSigsFlag;
                        err.TrType1.PSy(win,end)=err.TrType1.PSy(win,end)/2;
                        err.TrType2.PSy(win,end)=err.TrType2.PSy(win,end)/2;
                    end      % Here NFFT is even; therefore,Nyquist point is included.
                end
            end
        end
    end
end

%you need to record the NTotSpksPerWin (and NTotSpksPerWin2 for Spk_SpkCoh, as a 1 x nWin vector before reaching here
%NTotSpksPerWin and NTotSpksPerWin2 will be initialized in the appropriate spk functions that call this
%
%NOTE- this is only needed for the quick and dirty significance testing, not for the shuffling testing...
if SpkFlag(1) && RecNSpksFlag
    NTotSpksPerWin(win)=sum(sum(dat1)); %this is the numbers of spikes across all trials and tapers...
end
if TwoSigsFlag && SpkFlag(2) && RecNSpksFlag
    NTotSpksPerWin2(win)=sum(sum(dat2)); %this is the numbers of spikes across all trials and tapers...
end