%MTShuffCondsTest_S.m
%
% called by LFP_LFPCoh, etc. After looping through all windows and calling dmtUbiq_S.m

%variables to distinguish what function ultimately called this are:
%SpkFlag as a 2x1 vector indicating whether a given signal is a Spk (1)
%or not (0), and variable TwoSigsFlag to indicate whether or not two signals
%are present....

%don't need this...

useParallel = 0;
if usejava('desktop') %don't even try 'matlabpool' if we're working on computing cluster; will fail
    %if matlabpool('size') > 0;  use_parallel = 1; end
    parallelCheck
end


if TwoSigsFlag && (ClusShuffOpts.CohTest  || ClusShuffOpts.PCohTest)
    if ClusShuffOpts.CohAdjPh
        %adjust the phase of BaseYkoAll so that the overall relative phaes for the Base's are the same as the overall relative phase for the Act's
        %we want to add the TrType1 - TrType2 phase angle difference in angles to signal Y TrType 2...
        
        %below code wasn't right...  in this I multiply by Cdiff, and divide by the magnitude of Cdiff
        %Cdiff=err.TrType1.coh(InActPer,:) - err.TrType2.coh(InActPer,:);    %do this just to get phase diff
        %BaseYkoAll=BaseYkoAll .* repmat( reshape( (Cdiff ./ abs(Cdiff))' ,[1 diff(nfk)+1 nInActPer] ), nReps2,1);
        
        BaseYkoAll=CompPhShift( BaseYkoAll, repmat( reshape( (angle(err.TrType1.coh(InActPer,:)) - angle(err.TrType2.coh(InActPer,:)))' ,...
            [1 diff(nfk)+1 nInActPer] ), nReps2,1));
    end
    
    
    
    % 04/17/2011 RPH:
    % Here is what the magnitude adjustment does with respect to between-condition tests:
    % It equalizes Condition A and Condition B, then concatenates them, essentially removing any effect
    % between the conditions.  It seems that what you are left with is two sets of identical coherence
    % magnitudes. The null test distribution is then the amount of coherence you would expect to see if
    % there were no differences between the conditions.  The alternative would be a null test distribution
    %shuffling condition identity, which would then represent the amount of coherence you would see by
    %chance if condition membership didn't matter.  But, if there ARE large difference between the
    %conditions, this could lead to a null test distribution with too much variability.
    if ClusShuffOpts.CohAdjMag
        %we want to multiply, not add, to get the signal power comparable... specifically adjust TrType2 to make it like TrType1
        %note that we automatically want to do this for both signals since this only applies to coherence anyway
        
        %BaseXkoAll=BaseXkoAll .* repmat( sqrt( mean(ActXkoAll.^2,1) ./ mean(BaseXkoAll.^2,1) ), nReps2,1);
        %BaseYkoAll=BaseYkoAll .* repmat( sqrt( mean(ActYkoAll.^2,1) ./ mean(BaseYkoAll.^2,1) ), nReps2,1);
        
        %we do need to take an abs so i think below code is better than the above code
        BaseXkoAll=BaseXkoAll .* repmat( mean(abs(ActXkoAll),1) ./ mean(abs(BaseXkoAll),1), nReps2,1);
        BaseYkoAll=BaseYkoAll .* repmat( mean(abs(ActYkoAll),1) ./ mean(abs(BaseYkoAll),1), nReps2,1);
    end
end

TotXkoAll=[ActXkoAll; BaseXkoAll];
if TwoSigsFlag;     TotYkoAll=[ActYkoAll; BaseYkoAll];      end

%if errType==2
%first get test stats for orig data
%note that both the baseline and activation periods have the same num of df,... so there is no need to transform/correct the coh

%first do shuffs before getting clus stats on orig data
disp(['Starting Cluster Shuffling, ' num2str(ClusShuffOpts.nShuffs) ' Shuffs to do'])
if ClusShuffOpts.CohTest && TwoSigsFlag;
    CohMaxClusStat=repmat(0,ClusShuffOpts.nShuffs,2);       %col 1 w/ NormAboveThresh as 0, col 2 w/ NormAboveThresh as 1...
end
if ClusShuffOpts.SpecTest;
    Spec1MaxClusStat=repmat(0,ClusShuffOpts.nShuffs,2);
    if TwoSigsFlag;     Spec2MaxClusStat=Spec1MaxClusStat;      end
end
if ClusShuffOpts.PCohTest && TwoSigsFlag;
    PCohMaxClusStat=repmat(0,ClusShuffOpts.nShuffs,2);
end
if ClusShuffOpts.PSpecTest;
    PSpec1MaxClusStat=repmat(0,ClusShuffOpts.nShuffs,2);
    if TwoSigsFlag;     PSpec2MaxClusStat=PSpec1MaxClusStat;    end
end

if ClusShuffOpts.SpecTest || ClusShuffOpts.PSpecTest
    curTStat=repmat(0,nrecf,nInActPer);
    if TwoSigsFlag;     curTStat2=curTStat;     end
end
%nReps=size(BaseXkoAll,1);
ShuffBaseXk=repmat(0,[nReps, nrecf, nInActPer]);
ShuffActXk=ShuffBaseXk;
if TwoSigsFlag;
    ShuffBaseYk=ShuffBaseXk;
    ShuffActYk=ShuffBaseXk;
end

tic
if useParallel
    parfor iS=1:ClusShuffOpts.nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmpInds=randperm( nReps+nReps2 );
        %note- trial order doesn't matter... the only that matter is which period is considered base, and which is considered act
        %on 091112: I'm concerned about the equality of the appropriateness comparison of cohernece to shuffled coherence, but I'm looking into it
        ShuffBaseXk=TotXkoAll( tmpInds(1:nReps2),:,: );
        if TwoSigsFlag;     ShuffBaseYk=TotYkoAll( tmpInds(1:nReps2),:,: );         end
        ShuffActXk=TotXkoAll( tmpInds(nReps2+1:end),:,: );
        if TwoSigsFlag;     ShuffActYk=TotYkoAll( tmpInds(nReps2+1:end),:,: );         end
        
        if ClusShuffOpts.CohTest && TwoSigsFlag;    %for this between trials comparison, we can only do the Fisher transformed comparison... we can't do the CalcCohZPF even if we wanted to
            curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
            curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
            curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
            curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
            
            curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
            curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
            curTStat= ( (atanh(curcoh2)-1/(2*nReps-2)) - (atanh(curcoh1)-1/(2*nReps2-2)) )/sqrt(1/(2*nReps-2)+1/(2*nReps2-2));
            
            CohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
        end
        
        if ClusShuffOpts.SpecTest
            %here we need test the power spectra of both x and y
            curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
            if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
            curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
            if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
            
            curTStat= ((log(curSX2)-(psi(nReps)-log(nReps))) - (log(curSX1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));
            if TwoSigsFlag;     curTStat2= ((log(curSY2)-(psi(nReps)-log(nReps))) - (log(curSY1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));      end
            
            Spec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
            if TwoSigsFlag;     Spec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);      end
        end
        
        if ClusShuffOpts.PCohTest || ClusShuffOpts.PSpecTest
            ShuffBaseXk=ShuffBaseXk-repmat( mean(ShuffBaseXk),nReps,1 );
            if TwoSigsFlag;     ShuffBaseYk=ShuffBaseYk-repmat( mean(ShuffBaseYk),nReps,1 );        end
            ShuffActXk=ShuffActXk-repmat( mean(ShuffActXk),nReps,1 );
            if TwoSigsFlag;     ShuffActYk=ShuffActYk-repmat( mean(ShuffActYk),nReps,1 );           end
            %with above code, we've altere the Base and Act Xk's and Yk's ... so anything using them for the remainder of this shuffle will deal with partial coh and spec, even though from here on out it's exactly the same code
            
            if ClusShuffOpts.PCohTest && TwoSigsFlag;
                curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
                curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
                
                curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
                curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
                curTStat= ( (atanh(curcoh2)-1/(2*nReps-2)) - (atanh(curcoh1)-1/(2*nReps2-2)) )/sqrt(1/(2*nReps-2)+1/(2*nReps2-2));
                
                PCohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
            end
            
            if ClusShuffOpts.PSpecTest
                curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
                curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
                
                curTStat= ((log(curSX2)-(psi(nReps)-log(nReps))) - (log(curSX1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));
                if TwoSigsFlag;     curTStat2= ((log(curSY2)-(psi(nReps)-log(nReps))) - (log(curSY1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));      end
                
                PSpec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                if TwoSigsFlag;     PSpec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);     end
            end
        end
        
%         if iS==1 %not parfor friendly
%             disp('For first Shuff: ');
%             toc
%             tmptim=toc;
%             disp(['Shuffling should be done in about ' num2str( ClusShuffOpts.nShuffs*tmptim/60 ) ' minutes'])
%         end
    end
else
    for iS=1:ClusShuffOpts.nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmpInds=randperm( nReps+nReps2 );
        %note- trial order doesn't matter... the only that matter is which period is considered base, and which is considered act
        %on 091112: I'm concerned about the equality of the appropriateness comparison of cohernece to shuffled coherence, but I'm looking into it
        ShuffBaseXk=TotXkoAll( tmpInds(1:nReps2),:,: );
        if TwoSigsFlag;     ShuffBaseYk=TotYkoAll( tmpInds(1:nReps2),:,: );         end
        ShuffActXk=TotXkoAll( tmpInds(nReps2+1:end),:,: );
        if TwoSigsFlag;     ShuffActYk=TotYkoAll( tmpInds(nReps2+1:end),:,: );         end
        
        if ClusShuffOpts.CohTest && TwoSigsFlag;    %for this between trials comparison, we can only do the Fisher transformed comparison... we can't do the CalcCohZPF even if we wanted to
            curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
            curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
            curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
            curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
            
            curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
            curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
            curTStat= ( (atanh(curcoh2)-1/(2*nReps-2)) - (atanh(curcoh1)-1/(2*nReps2-2)) )/sqrt(1/(2*nReps-2)+1/(2*nReps2-2));
            
            CohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
        end
        
        if ClusShuffOpts.SpecTest
            %here we need test the power spectra of both x and y
            curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
            if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
            curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
            if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
            
            curTStat= ((log(curSX2)-(psi(nReps)-log(nReps))) - (log(curSX1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));
            if TwoSigsFlag;     curTStat2= ((log(curSY2)-(psi(nReps)-log(nReps))) - (log(curSY1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));      end
            
            Spec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
            if TwoSigsFlag;     Spec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);      end
        end
        
        if ClusShuffOpts.PCohTest || ClusShuffOpts.PSpecTest
            ShuffBaseXk=ShuffBaseXk-repmat( mean(ShuffBaseXk),nReps,1 );
            if TwoSigsFlag;     ShuffBaseYk=ShuffBaseYk-repmat( mean(ShuffBaseYk),nReps,1 );        end
            ShuffActXk=ShuffActXk-repmat( mean(ShuffActXk),nReps,1 );
            if TwoSigsFlag;     ShuffActYk=ShuffActYk-repmat( mean(ShuffActYk),nReps,1 );           end
            %with above code, we've altere the Base and Act Xk's and Yk's ... so anything using them for the remainder of this shuffle will deal with partial coh and spec, even though from here on out it's exactly the same code
            
            if ClusShuffOpts.PCohTest && TwoSigsFlag;
                curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
                curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
                
                curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
                curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
                curTStat= ( (atanh(curcoh2)-1/(2*nReps-2)) - (atanh(curcoh1)-1/(2*nReps2-2)) )/sqrt(1/(2*nReps-2)+1/(2*nReps2-2));
                
                PCohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
            end
            
            if ClusShuffOpts.PSpecTest
                curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
                curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
                
                curTStat= ((log(curSX2)-(psi(nReps)-log(nReps))) - (log(curSX1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));
                if TwoSigsFlag;     curTStat2= ((log(curSY2)-(psi(nReps)-log(nReps))) - (log(curSY1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));      end
                
                PSpec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                if TwoSigsFlag;     PSpec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);     end
            end
        end
        
        if iS==1
            disp('For first Shuff: ');
            toc
            tmptim=toc;
            disp(['Shuffling should be done in about ' num2str( ClusShuffOpts.nShuffs*tmptim/60 ) ' minutes'])
        end
    end
end
disp('Done Shuffling')

err.wintimes=tout(InActPer); %these will be the center of each time win
%Now calc Test Stats on orig data
if ClusShuffOpts.CohTest && TwoSigsFlag;
    %curTStat needs to have Freqs down dim 1 and win down dim 2
    curTStat=( (atanh( abs(err.TrType1.coh(InActPer,:)') )-1/(2*nReps-2)) - (atanh( abs(err.TrType2.coh(InActPer,:)'))-1/(2*nReps2-2)) ) / sqrt(1/(2*nReps-2)+1/(2*nReps2-2));
    
    [err.Coh err.CohNormAboveThresh]=CalcClusSig( curTStat,CohMaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
end

if ClusShuffOpts.SpecTest
    %we want to take the mean spec over all wins in the baseline period, and then duplicate that mean to have the same number of windows as the activation perios
    curSX1=squeeze( mean(BaseXkoAll.*conj(BaseXkoAll)) );
    if TwoSigsFlag;     curSY1=squeeze( mean(BaseYkoAll.*conj(BaseYkoAll)) );   end
    curSX2=squeeze( mean(ActXkoAll.*conj(ActXkoAll)) );
    if TwoSigsFlag;     curSY2=squeeze( mean(ActYkoAll.*conj(ActYkoAll)) );     end
    
    %curTStat needs to have Freqs down dim 1 and win down dim 2
    curTStat= ((log(curSX2)-(psi(nReps)-log(nReps))) - (log(curSX1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));
    if TwoSigsFlag;     curTStat2= ((log(curSY2)-(psi(nReps)-log(nReps))) - (log(curSY1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));      end
    
    [err.Spec1 err.Spec1NormAboveThresh]=CalcClusSig(curTStat,Spec1MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
    if TwoSigsFlag;     [err.Spec2 err.Spec2NormAboveThresh]=CalcClusSig(curTStat2,Spec2MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );     end
end

if (ClusShuffOpts.PCohTest && ClusShuffOpts.PCohTestStat==1) || ClusShuffOpts.PSpecTest
    %then adjust the aggregated Xk's and Yk's
    BaseXkoAll=BaseXkoAll - repmat( mean(BaseXkoAll),nReps2,1 );
    ActXkoAll=ActXkoAll - repmat( mean(ActXkoAll),nReps,1 );
    
    if TwoSigsFlag
        ActYkoAll=ActYkoAll - repmat( mean(ActYkoAll),nReps,1 );
        BaseYkoAll=BaseYkoAll - repmat( mean(BaseYkoAll),nReps2,1 );
    end
end

if ClusShuffOpts.PCohTest
    curSX1=squeeze( mean(BaseXkoAll.*conj(BaseXkoAll)) );
    curSY1=squeeze( mean(BaseYkoAll.*conj(BaseYkoAll)) );
    curSX2=squeeze( mean(ActXkoAll.*conj(ActXkoAll)) );
    curSY2=squeeze( mean(ActYkoAll.*conj(ActYkoAll)) );
    
    curcoh1=abs( squeeze( mean(BaseXkoAll.*conj(BaseYkoAll)) )./sqrt( curSX1 .* curSY1 ) );
    curcoh2=abs( squeeze( mean(ActXkoAll.*conj(ActYkoAll)) )./sqrt( curSX2 .* curSY2 ) );
    curTStat= ( (atanh(curcoh2)-1/(2*nReps-2)) - (atanh(curcoh1)-1/(2*nReps2-2)) )/sqrt(1/(2*nReps-2)+1/(2*nReps2-2));
    
    [err.PCoh  err.PCohNormAboveThresh]=CalcClusSig(curTStat,PCohMaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
end

if ClusShuffOpts.PSpecTest
    %again, b/c of normalization of Sx, the below code won't work
    %             tmpBaseS1=mean( PSx(InBasePer,:) ,1)';
    %             tmpBaseS1=repmat(tmpBaseS1,[1 nInActPer]);
    %             tmpBaseS2=mean( PSy(InBasePer,:) ,1)';
    %             tmpBaseS2=repmat(tmpBaseS2,[1 nInActPer]);
    %
    %             %curTStat needs to have Freqs down dim 1 and win down dim 2
    %             curTStat= (log(PSx(InActPer,:))'-log(tmpBaseS1))/sqrt(2*psi(1,2*nReps));  %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
    %             curTStat2= (log(PSy(InActPer,:))'-log(tmpBaseS2))/sqrt(2*psi(1,2*nReps));
    
    curSX1=squeeze( mean(BaseXkoAll.*conj(BaseXkoAll)) );
    if TwoSigsFlag;     curSY1=squeeze( mean(BaseYkoAll.*conj(BaseYkoAll)) );   end
    curSX2=squeeze( mean(ActXkoAll.*conj(ActXkoAll)) );
    if TwoSigsFlag;     curSY2=squeeze( mean(ActYkoAll.*conj(ActYkoAll)) );     end
    
    %curTStat needs to have Freqs down dim 1 and win down dim 2
    curTStat= ((log(curSX2)-(psi(nReps)-log(nReps))) - (log(curSX1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));
    if TwoSigsFlag;     curTStat2= ((log(curSY2)-(psi(nReps)-log(nReps))) - (log(curSY1)-(psi(nReps2)-log(nReps2))) )/sqrt(psi(1,2*nReps)+psi(1,2*nReps2));      end
    
    [err.PSpec1  err.PSpec1NormAboveThresh]=CalcClusSig(curTStat,PSpec1MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
    if TwoSigsFlag;     [err.PSpec2  err.PSpec2NormAboveThresh]=CalcClusSig(curTStat2,PSpec2MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );  end
end


%opts to plot this- when using imagesc for coh, you could only add each
%cluster, and leave the rest of the space in teh graph blank... or you
%could use matlab's edge function and draw a thick black ro whit line
%around each cluster on the usual colorplot... one caveat to the edge
%method- sometimes the output appears to be a little off, but it's
%always close
%end
