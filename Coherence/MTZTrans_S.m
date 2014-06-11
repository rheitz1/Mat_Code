%MTZTrans_S.m
%
% Called at the end of a main MT Spectral function (i.e. LFPSPec, etc.) if
% the user desires the output of the function to be Z transformed
%
% Note: The Z transformation is done on magnitudes, though this code will
% preserve phases after aplpying the transformation on the magnitudes

if ZTransFlag==2
    CorrectedRawValForm=1; %For both coh and Spec, setting this to one will subtract the bias in the proper transformed space, then return to the raw space without dividing by the variance. IT'S THE DIVISION BY THE VARIANCE THAT MAKES THE EXPECTED VALUE DEPENDENT ON THE DF WHEN TEH NULL IS NOT TRUE. So- the result for coh or spectra will then be on teh scale of raw values, but still corrected for bias          
else
    CorrectedRawValForm=0;
end
    
if SpkFlag(1)
    tmpdf1=repmat( 2./ (  repmat(1/(2*nReps),nwin,1) +1./(2*NTotSpksPerWin)),1,nrecf );
else
    tmpdf1=repmat(2*nReps,nwin,nrecf);
end
if TwoSigsFlag
    if SpkFlag(2)    %we need to check the dfs of the second signal in case this is spk lfp coh,. in which case they might be different
        tmpdf2=repmat( 2./ (  repmat(1/(2*nReps),nwin,1) +1./(2*NTotSpksPerWin2)),1,nrecf );        
    else
        tmpdf2=repmat(2*nReps,nwin,nrecf);
    end
end

if TwoSigsFlag
    tmpdf=min(tmpdf1,tmpdf2);
    
    tmpang=angle(coh);
    if CorrectedRawValForm  %see the comment above where this is defined for an explanation    
        coh=tanh( atanh( abs(coh) )-1./(tmpdf-2) );
    else
        coh=sqrt(tmpdf-2).*atanh(coh)-1./sqrt(tmpdf-2);   %according to Thompson and Chave, and Koopmans, this is approximately distributed as a standard Gausian
        %note- the expected value of the above is actually: sqrt(tmpdf-2)*atanh(coh), so sessions with more Reps will have a larger coherence after this transformation; BUT- under the null, coh=0, so in this case, the variance and the expected val of each session is independent of the number of Reps, which teh assumption we want to test with our staitistical tests...
        %the above is equivalent to: z=( atanh(coh)-1/(tmpdf-2) )/(sqrt(1/(tmpdf-2)));
    end
    coh=coh.*exp(1i*tmpang);
    
    if CalcPart && ~JustPartFlag     
        tmpang=angle(Pcoh);
        if CorrectedRawValForm  %see the comment above where this is defined for an explanation    
            Pcoh=tanh( atanh(Pcoh)-1./(tmpdf-2) );
        else
            Pcoh=sqrt(tmpdf-2).*atanh(Pcoh)-1./sqrt(tmpdf-2);     
        end
        Pcoh=Pcoh.*exp(1i*tmpang);
    end
end
if CalcSpec || ~TwoSigsFlag
    if CorrectedRawValForm  %see the comment above where this is defined for an explanation
        Sx=exp( ( log(Sx)-(psi(tmpdf1/2)-log(tmpdf1/2)) ) );
        if TwoSigsFlag;     Sy=exp( ( log(Sy)-(psi(tmpdf2/2)-log(tmpdf2/2)) ) );    end        
    else
        Sx=( log(Sx)-(psi(tmpdf1/2)-log(tmpdf1/2)) )./sqrt(psi(1,tmpdf1/2));
        if TwoSigsFlag;     Sy=( log(Sy)-(psi(tmpdf2/2)-log(tmpdf2/2)) )./sqrt(psi(1,tmpdf2/2));    end
    end
    
    %if CalcPartSpec || (CalcPart && ~TwoSigsFlag)
    if exist('PSx','var');
        if CorrectedRawValForm  %see the comment above where this is defined for an explanation
            PSx=exp( ( log(PSx)-(psi(tmpdf1/2)-log(tmpdf1/2)) ) );
            if TwoSigsFlag;     PSy=exp( ( log(PSy)-(psi(tmpdf2/2)-log(tmpdf2/2)) ) );    end
        else
            PSx=( log(PSx)-(psi(tmpdf1/2)-log(tmpdf1/2)) )./sqrt(psi(1,tmpdf1/2));
            if TwoSigsFlag && exist('PSy','var');     PSy=( log(PSy)-(psi(tmpdf2/2)-log(tmpdf2/2)) )./sqrt(psi(1,tmpdf2/2));      end
        end
    end
end
