%MTShuffTest_S.m
%
% called by LFP_LFPCoh, etc. After looping through all windows and calling dmtUbiq_S.m

%variables to distinguish what function ultimately called this are:
%SpkFlag as a 2x1 vector indicating whether a given signal is a Spk (1)
%or not (0), and variable TwoSigsFlag to indicate whether or not two signals
%are present....
useParallel = 0;
if usejava('desktop') %don't even try 'matlabpool' if we're working on computing cluster; will fail
    %if matlabpool('size') > 0;  useParallel = 1; end
    parallelCheck
end

%use_parallel = 0; %MAY NOT BE WORKING PROPERLY - EXAMINE THIS

if errType==2
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
    
    if TwoSigsFlag && (ClusShuffOpts.CohTest  || ClusShuffOpts.PCohTest)
        if ClusShuffOpts.CohAdjPh
            %get a PhShiftList for each BaseWin
            PhShiftList=repmat(0,[nInBasePer, diff(nfk)+1, nInActPer]);
            InBasePerI=find(InBasePer);
            for iBP=1:nInBasePer
                curAngDiffs=angle(coh(InActPer,:)) - repmat( angle(coh(InBasePerI(iBP),:)),nInActPer,1 );
                PhShiftList(iBP,:,:)=reshape( curAngDiffs', [1 diff(nfk)+1 nInActPer] );
            end
        end
        if ClusShuffOpts.CohAdjMag
            XAdjList=repmat(0,[nInBasePer, diff(nfk)+1, nInActPer]);
            YAdjList=XAdjList;
            %InBasePerI=find(InBasePer);
            for iBP=1:nInBasePer
                XAdjList(iBP,:,:)=mean(abs(ActXkoAll),1) ./ repmat( mean(abs(BaseXkoAll(:,:,iBP)),1) ,[1 1 nInActPer] );
                YAdjList(iBP,:,:)=mean(abs(ActYkoAll),1) ./ repmat( mean(abs(BaseYkoAll(:,:,iBP)),1) ,[1 1 nInActPer] );
            end
        end
    end
    
    tic
    
    if useParallel
        parfor iS=1:ClusShuffOpts.nShuffs
            if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
            
            tmprand=rand( nReps,1 );
            KeepBase=tmprand<0.5;
            BaseWin=mod( ceil(tmprand/(0.5/nInBasePer))-1,nInBasePer )+1;   %I believe the intention of this line is to use teh randomness already present in tmprand to select a particular timepoint for BaseWin to use for each shuffled trials as the comparison... the way this done below, this time sample gets replicated and is used to compare against every time sample in teh ActPer for that frequency (comment written post hoc on 091111 MJN)
            
            %note- trial order doesn't matter... the only thing that matters is which period is considered base, and which is considered act
            for iR=1:nReps
                if KeepBase(iR)
                    ShuffBaseXk( iR,:,: )=repmat( BaseXkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                    if TwoSigsFlag;
                        ShuffBaseYk( iR,:,: )=repmat( BaseYkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                        
                        if ClusShuffOpts.CohAdjPh
                            ShuffBaseYk( iR,:,: )=CompPhShift( ShuffBaseYk( iR,:,: ),PhShiftList(BaseWin(iR),:,:) );
                        end
                        if ClusShuffOpts.CohAdjMag
                            ShuffBaseXk( iR,:,: )=ShuffBaseXk( iR,:,: ) .*XAdjList(BaseWin(iR),:,:);
                            ShuffBaseYk( iR,:,: )=ShuffBaseYk( iR,:,: ) .*YAdjList(BaseWin(iR),:,:);
                        end
                    end
                    
                    ShuffActXk( iR,:,: )=ActXkoAll( iR,:,: );
                    if TwoSigsFlag;     ShuffActYk( iR,:,: )=ActYkoAll( iR,:,: );       end
                else
                    ShuffBaseXk( iR,:,: )=ActXkoAll( iR,:,: );
                    if TwoSigsFlag;     ShuffBaseYk( iR,:,: )=ActYkoAll( iR,:,: );      end
                    
                    ShuffActXk( iR,:,: )=repmat( BaseXkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                    if TwoSigsFlag;
                        ShuffActYk( iR,:,: )=repmat( BaseYkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                        
                        if ClusShuffOpts.CohAdjPh
                            ShuffActYk( iR,:,: )=CompPhShift( ShuffActYk( iR,:,: ),PhShiftList(BaseWin(iR),:,:) );
                        end
                        if ClusShuffOpts.CohAdjMag
                            ShuffBaseXk( iR,:,: )=ShuffBaseXk( iR,:,: ) .*XAdjList(BaseWin(iR),:,:);
                            ShuffBaseYk( iR,:,: )=ShuffBaseYk( iR,:,: ) .*YAdjList(BaseWin(iR),:,:);
                        end
                    end
                end
            end
            
            if ClusShuffOpts.CohTest && TwoSigsFlag;
                if ClusShuffOpts.CohTestStat==1
                    curTStat=CalcCohZPF(ShuffBaseXk,ShuffBaseYk,ShuffActXk,ShuffActYk);
                else
                    curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                    curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
                    curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                    curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
                    
                    curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
                    curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
                    curTStat= (atanh(curcoh2)-atanh(curcoh1))/sqrt(2/(2*nReps-2)); %we dont need to subtract the bias here b/c the dfs are necessarily the same, so the  biases would cancel out anyway
                end
                CohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
            end
            
            if ClusShuffOpts.SpecTest
                %here we need test the power spectra of both x and y
                
                if ClusShuffOpts.SpecTestStat==1
                    %unfortunately there's no way to use matlab's signrank to simultaneously test more than one sample at a time, so a for loop is necessary
                    %need to loop of Freqs and Time Wins
                    for iF=1:nrecf
                        for iW=1:nInActPer
                            %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                            %note- below is a rank sum test, so squaring the Xks and Yks isn't necessary, so is not done to save time
                            %the only diff b/t my_signrank and signrank is that stat.zval in my_signrank is pos when the first arg(Act) is higher than the second arg(Base), and vice versa... from signrank, stat.zval is always neg for some stupid reason
                            [h p stats]=my_signrank(abs(ShuffActXk(:,iF,iW)),abs(ShuffBaseXk(:,iF,iW)),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                            curTStat(iF,iW)=stats.zval;
                            if TwoSigsFlag;
                                [h p stats]=my_signrank(abs(ShuffActYk(:,iF,iW)),abs(ShuffBaseYk(:,iF,iW)),'method','approximate');
                                curTStat2(iF,iW)=stats.zval;
                            end
                            
                            %probably easier just to go with the pvals... thresh will be 0.05 of course, and met when the result is less than that
                            %[h curTStat(iF,iW)]=signrank(ShuffBaseXk(:,iF,iW),ShuffActXk(:,iF,iW));    %These approximate values are easier to work with and to know how to threshhold, among other things...
                            %[h curTStat2(iF,iW)]=signrank(ShuffBaseYk(:,iF,iW),ShuffActYk(:,iF,iW));
                            %Note- all that matters are the ranks of the shuffled stats relative to the real data stats, so the magnitude diffs in the trans b/t zval and pval don't matter...
                            %BUT- how the different significant points in each cluster sum will be affected... to match with what has proven to be sufficient in other cases, I'm deciding instead to go with the z-value above
                        end
                    end
                else
                    curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                    if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
                    curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                    if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
                    
                    curTStat= (log(curSX2)-log(curSX1))/sqrt(2*psi(1,nReps)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
                    if TwoSigsFlag;     curTStat2= (log(curSY2)-log(curSY1))/sqrt(2*psi(1,nReps));        end
                end
                Spec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                if TwoSigsFlag;     Spec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);      end
            end
            
            if ClusShuffOpts.PCohTest || ClusShuffOpts.PSpecTest
                ShuffBaseXk=ShuffBaseXk-repmat( mean(ShuffBaseXk),nReps,1 );
                if TwoSigsFlag;     ShuffBaseYk=ShuffBaseYk-repmat( mean(ShuffBaseYk),nReps,1 );        end
                ShuffActXk=ShuffActXk-repmat( mean(ShuffActXk),nReps,1 );
                if TwoSigsFlag;     ShuffActYk=ShuffActYk-repmat( mean(ShuffActYk),nReps,1 );           end
                
                if ClusShuffOpts.PCohTest && TwoSigsFlag;
                    if ClusShuffOpts.PCohTestStat==1
                        curTStat=CalcCohZPF(ShuffBaseXk,ShuffBaseYk,ShuffActXk,ShuffActYk);
                    else
                        curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                        curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
                        curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                        curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
                        
                        curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
                        curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
                        curTStat= (atanh(curcoh2)-atanh(curcoh1))/sqrt(2/(2*nReps-2)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
                    end
                    PCohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                end
                
                if ClusShuffOpts.PSpecTest
                    if ClusShuffOpts.PSpecTestStat==1
                        for iF=1:nrecf
                            for iW=1:nInActPer
                                %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                                [h p stats]=my_signrank(abs(ShuffActXk(:,iF,iW)),abs(ShuffBaseXk(:,iF,iW)),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                                curTStat(iF,iW)=stats.zval;    %We use my_signedrank so the sign of z is positive if the Act period is larger than the base period, and negative if that's not the case... with matlab's signed rank the zvals seem to come out of signrank as negative, regardless of the sign of the effect...
                                if TwoSigsFlag;
                                    [h p stats]=my_signrank(abs(ShuffActYk(:,iF,iW)),abs(ShuffBaseYk(:,iF,iW)),'method','approximate');
                                    curTStat2(iF,iW)=stats.zval;
                                end
                            end
                        end
                    else
                        curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                        if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
                        curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                        if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
                        
                        curTStat= (log(curSX2)-log(curSX1))/sqrt(2*psi(1,nReps)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
                        if TwoSigsFlag;     curTStat2= (log(curSY2)-log(curSY1))/sqrt(2*psi(1,nReps));        end
                    end
                    PSpec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                    if TwoSigsFlag;     PSpec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);     end
                end
            end
            
%             if iS==1
%                 disp('For first Shuff: ');
%                 toc
%                 tmptim=toc;
%                 disp(['Shuffling should be done in about ' num2str( ClusShuffOpts.nShuffs*tmptim/60 ) ' minutes'])
%             end
        end
    else
        
        for iS=1:ClusShuffOpts.nShuffs
            if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
            
            tmprand=rand( nReps,1 );
            KeepBase=tmprand<0.5;
            BaseWin=mod( ceil(tmprand/(0.5/nInBasePer))-1,nInBasePer )+1;   %I believe the intention of this line is to use teh randomness already present in tmprand to select a particular timepoint for BaseWin to use for each shuffled trials as the comparison... the way this done below, this time sample gets replicated and is used to compare against every time sample in teh ActPer for that frequency (comment written post hoc on 091111 MJN)
            
            %note- trial order doesn't matter... the only thing that matters is which period is considered base, and which is considered act
            for iR=1:nReps
                if KeepBase(iR)
                    ShuffBaseXk( iR,:,: )=repmat( BaseXkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                    if TwoSigsFlag;
                        ShuffBaseYk( iR,:,: )=repmat( BaseYkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                        
                        if ClusShuffOpts.CohAdjPh
                            ShuffBaseYk( iR,:,: )=CompPhShift( ShuffBaseYk( iR,:,: ),PhShiftList(BaseWin(iR),:,:) );
                        end
                        if ClusShuffOpts.CohAdjMag
                            ShuffBaseXk( iR,:,: )=ShuffBaseXk( iR,:,: ) .*XAdjList(BaseWin(iR),:,:);
                            ShuffBaseYk( iR,:,: )=ShuffBaseYk( iR,:,: ) .*YAdjList(BaseWin(iR),:,:);
                        end
                    end
                    
                    ShuffActXk( iR,:,: )=ActXkoAll( iR,:,: );
                    if TwoSigsFlag;     ShuffActYk( iR,:,: )=ActYkoAll( iR,:,: );       end
                else
                    ShuffBaseXk( iR,:,: )=ActXkoAll( iR,:,: );
                    if TwoSigsFlag;     ShuffBaseYk( iR,:,: )=ActYkoAll( iR,:,: );      end
                    
                    ShuffActXk( iR,:,: )=repmat( BaseXkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                    if TwoSigsFlag;
                        ShuffActYk( iR,:,: )=repmat( BaseYkoAll( iR,:,BaseWin(iR) ),[1 1 nInActPer] );
                        
                        if ClusShuffOpts.CohAdjPh
                            ShuffActYk( iR,:,: )=CompPhShift( ShuffActYk( iR,:,: ),PhShiftList(BaseWin(iR),:,:) );
                        end
                        if ClusShuffOpts.CohAdjMag
                            ShuffBaseXk( iR,:,: )=ShuffBaseXk( iR,:,: ) .*XAdjList(BaseWin(iR),:,:);
                            ShuffBaseYk( iR,:,: )=ShuffBaseYk( iR,:,: ) .*YAdjList(BaseWin(iR),:,:);
                        end
                    end
                end
            end
            
            if ClusShuffOpts.CohTest && TwoSigsFlag;
                if ClusShuffOpts.CohTestStat==1
                    curTStat=CalcCohZPF(ShuffBaseXk,ShuffBaseYk,ShuffActXk,ShuffActYk);
                else
                    curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                    curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
                    curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                    curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
                    
                    curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
                    curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
                    curTStat= (atanh(curcoh2)-atanh(curcoh1))/sqrt(2/(2*nReps-2)); %we dont need to subtract the bias here b/c the dfs are necessarily the same, so the  biases would cancel out anyway
                end
                CohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
            end
            
            if ClusShuffOpts.SpecTest
                %here we need test the power spectra of both x and y
                
                if ClusShuffOpts.SpecTestStat==1
                    %unfortunately there's no way to use matlab's signrank to simultaneously test more than one sample at a time, so a for loop is necessary
                    %need to loop of Freqs and Time Wins
                    for iF=1:nrecf
                        for iW=1:nInActPer
                            %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                            %note- below is a rank sum test, so squaring the Xks and Yks isn't necessary, so is not done to save time
                            %the only diff b/t my_signrank and signrank is that stat.zval in my_signrank is pos when the first arg(Act) is higher than the second arg(Base), and vice versa... from signrank, stat.zval is always neg for some stupid reason
                            [h p stats]=my_signrank(abs(ShuffActXk(:,iF,iW)),abs(ShuffBaseXk(:,iF,iW)),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                            curTStat(iF,iW)=stats.zval;
                            if TwoSigsFlag;
                                [h p stats]=my_signrank(abs(ShuffActYk(:,iF,iW)),abs(ShuffBaseYk(:,iF,iW)),'method','approximate');
                                curTStat2(iF,iW)=stats.zval;
                            end
                            
                            %probably easier just to go with the pvals... thresh will be 0.05 of course, and met when the result is less than that
                            %[h curTStat(iF,iW)]=signrank(ShuffBaseXk(:,iF,iW),ShuffActXk(:,iF,iW));    %These approximate values are easier to work with and to know how to threshhold, among other things...
                            %[h curTStat2(iF,iW)]=signrank(ShuffBaseYk(:,iF,iW),ShuffActYk(:,iF,iW));
                            %Note- all that matters are the ranks of the shuffled stats relative to the real data stats, so the magnitude diffs in the trans b/t zval and pval don't matter...
                            %BUT- how the different significant points in each cluster sum will be affected... to match with what has proven to be sufficient in other cases, I'm deciding instead to go with the z-value above
                        end
                    end
                else
                    curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                    if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
                    curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                    if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
                    
                    curTStat= (log(curSX2)-log(curSX1))/sqrt(2*psi(1,nReps)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
                    if TwoSigsFlag;     curTStat2= (log(curSY2)-log(curSY1))/sqrt(2*psi(1,nReps));        end
                end
                Spec1MaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                if TwoSigsFlag;     Spec2MaxClusStat(iS,:)=FindStatClus(curTStat2,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);      end
            end
            
            if ClusShuffOpts.PCohTest || ClusShuffOpts.PSpecTest
                ShuffBaseXk=ShuffBaseXk-repmat( mean(ShuffBaseXk),nReps,1 );
                if TwoSigsFlag;     ShuffBaseYk=ShuffBaseYk-repmat( mean(ShuffBaseYk),nReps,1 );        end
                ShuffActXk=ShuffActXk-repmat( mean(ShuffActXk),nReps,1 );
                if TwoSigsFlag;     ShuffActYk=ShuffActYk-repmat( mean(ShuffActYk),nReps,1 );           end
                
                if ClusShuffOpts.PCohTest && TwoSigsFlag;
                    if ClusShuffOpts.PCohTestStat==1
                        curTStat=CalcCohZPF(ShuffBaseXk,ShuffBaseYk,ShuffActXk,ShuffActYk);
                    else
                        curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                        curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );
                        curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                        curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
                        
                        curcoh1=abs( squeeze( mean(ShuffBaseXk.*conj(ShuffBaseYk)) )./sqrt( curSX1 .* curSY1 ) );
                        curcoh2=abs( squeeze( mean(ShuffActXk.*conj(ShuffActYk)) )./sqrt( curSX2 .* curSY2 ) );
                        curTStat= (atanh(curcoh2)-atanh(curcoh1))/sqrt(2/(2*nReps-2)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
                    end
                    PCohMaxClusStat(iS,:)=FindStatClus(curTStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff);
                end
                
                if ClusShuffOpts.PSpecTest
                    if ClusShuffOpts.PSpecTestStat==1
                        for iF=1:nrecf
                            for iW=1:nInActPer
                                %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                                [h p stats]=my_signrank(abs(ShuffActXk(:,iF,iW)),abs(ShuffBaseXk(:,iF,iW)),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                                curTStat(iF,iW)=stats.zval;    %We use my_signedrank so the sign of z is positive if the Act period is larger than the base period, and negative if that's not the case... with matlab's signed rank the zvals seem to come out of signrank as negative, regardless of the sign of the effect...
                                if TwoSigsFlag;
                                    [h p stats]=my_signrank(abs(ShuffActYk(:,iF,iW)),abs(ShuffBaseYk(:,iF,iW)),'method','approximate');
                                    curTStat2(iF,iW)=stats.zval;
                                end
                            end
                        end
                    else
                        curSX1=squeeze( mean(ShuffBaseXk.*conj(ShuffBaseXk)) );
                        if TwoSigsFlag;     curSY1=squeeze( mean(ShuffBaseYk.*conj(ShuffBaseYk)) );     end
                        curSX2=squeeze( mean(ShuffActXk.*conj(ShuffActXk)) );
                        if TwoSigsFlag;     curSY2=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );       end
                        
                        curTStat= (log(curSX2)-log(curSX1))/sqrt(2*psi(1,nReps)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
                        if TwoSigsFlag;     curTStat2= (log(curSY2)-log(curSY1))/sqrt(2*psi(1,nReps));        end
                    end
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
        disp('Done Shuffling')
    end
    
    
    
    
    err.wintimes=tout(InActPer); %these will be the center of each time win
    %Now calc Test Stats on orig data
    if ClusShuffOpts.CohTest && TwoSigsFlag;
        if ClusShuffOpts.CohTestStat==1
            curTStat=CalcCohZPF(BaseXkoAll,BaseYkoAll,ActXkoAll,ActYkoAll,mean(abs( coh(InBasePer,:) ),1)', abs(coh(InActPer,:)'));
        else
            tmpBasecoh=mean(abs( coh(InBasePer,:) ),1)';
            tmpBasecoh=repmat(tmpBasecoh,[1 nInActPer]);
            
            %curTStat needs to have Freqs down dim 1 and win down dim 2
            curTStat= (atanh( abs(coh(InActPer,:)') )-atanh( tmpBasecoh ))/sqrt(2/(2*nReps-2)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
        end
        
        [err.Coh err.CohNormAboveThresh]=CalcClusSig( curTStat,CohMaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
    end
    
    if ClusShuffOpts.SpecTest
        %for spec, compare real data to entire average baseline
        %here b/c we may be calcing a mean across windows, whether or not we compare squared or non-squared spectra makes a difference... so we'll take the square...
        tmpBaseSpec1=mean( BaseXkoAll.*conj(BaseXkoAll),3 );
        if TwoSigsFlag;     tmpBaseSpec2=mean( BaseYkoAll.*conj(BaseYkoAll),3 );        end
        tmpActSpec1=ShuffActXk.*conj(ShuffActXk);
        if TwoSigsFlag;     tmpActSpec2=ShuffActYk.*conj(ShuffActYk);       end
        if ClusShuffOpts.SpecTestStat==1
            
            for iF=1:nrecf
                for iW=1:nInActPer
                    %for stat to use for signrank test: go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                    [h p stats]=my_signrank(tmpActSpec1(:,iF,iW),tmpBaseSpec1(:,iF),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                    curTStat(iF,iW)=stats.zval;    %the zvals seem to come out of signrank as negative, regardless of the sign of the effect, but my_signrank makes them positive...
                    if TwoSigsFlag;
                        [h p stats]=my_signrank(tmpActSpec2(:,iF,iW),tmpBaseSpec1(:,iF),'method','approximate');
                        curTStat2(iF,iW)=stats.zval;
                    end
                end
            end
        else
            %actually- to compare to the shuffled data, we need to use the raw, unscaled Spec, so we need to recalculate the same way it was calcluate it here in the shuffling
            %             tmpBaseS1=mean( Sx(InBasePer,:) ,1)';
            %             tmpBaseS1=repmat(tmpBaseS1,[1 nInActPer]);
            %             tmpBaseS2=mean( Sy(InBasePer,:) ,1)';
            %             tmpBaseS2=repmat(tmpBaseS2,[1 nInActPer]);
            %
            %             curTStat= (log(Sx(InActPer,:))'-log(tmpBaseS1))/sqrt(2*psi(1,nReps));  %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
            %             curTStat2= (log(Sy(InActPer,:))'-log(tmpBaseS2))/sqrt(2*psi(1,nReps));
            
            %we want to take the mean spec over all wins in the baseline period, and then duplicate that mean to have the same number of windows as the activation perios
            curSX1=mean( mean(BaseXkoAll.*conj(BaseXkoAll)),3 )';  %it rurns out that squeeze d/n do anything to a 2D matrix... that sux... so we haave to use shiftdim
            if TwoSigsFlag;     curSY1=mean( mean(BaseYkoAll.*conj(BaseYkoAll)),3 )';   end
            curSX2=squeeze( mean(ActXkoAll.*conj(ActXkoAll)) );
            if TwoSigsFlag;     curSY2=squeeze( mean(ActYkoAll.*conj(ActYkoAll)) );     end
            
            %curTStat needs to have Freqs down dim 1 and win down dim 2
            curTStat= (log(curSX2)-log( curSX1(:,repmat(1,nInActPer,1) )))/sqrt(2*psi(1,nReps)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
            if TwoSigsFlag;     curTStat2= (log(curSY2)-log( curSY1(:,repmat(1,nInActPer,1) )))/sqrt(2*psi(1,nReps));     end
        end
        
        [err.Spec1 err.Spec1NormAboveThresh]=CalcClusSig(curTStat,Spec1MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
        if TwoSigsFlag;     [err.Spec2 err.Spec2NormAboveThresh]=CalcClusSig(curTStat2,Spec2MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );     end
    end
    
    if (ClusShuffOpts.PCohTest && ClusShuffOpts.PCohTestStat==1) || ClusShuffOpts.PSpecTest
        %then adjust the aggregated Xk's and Yk's
        BaseXkoAll=BaseXkoAll - repmat( mean(BaseXkoAll),nReps,1 );
        ActXkoAll=ActXkoAll - repmat( mean(ActXkoAll),nReps,1 );
        
        if TwoSigsFlag
            BaseYkoAll=BaseYkoAll - repmat( mean(BaseYkoAll),nReps,1 );
            ActYkoAll=ActYkoAll - repmat( mean(ActYkoAll),nReps,1 );
        end
    end
    
    if ClusShuffOpts.PCohTest
        if ClusShuffOpts.PCohTestStat==1
            curTStat=CalcCohZPF(BaseXkoAll,BaseYkoAll,ActXkoAll,ActYkoAll,mean(abs( coh(InBasePer,:) ),1)', abs(coh(InActPer,:)'));
        else
            tmpBasecoh=mean(abs( Pcoh(InBasePer,:) ),1)';
            tmpBasecoh=repmat(tmpBasecoh,[1 nInActPer]);
            
            %curTStat needs to have Freqs down dim 1 and win down dim 2
            curTStat= (atanh( abs(Pcoh(InActPer,:)') )-atanh( tmpBasecoh ))/sqrt(2/(2*nReps-2)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so the  biases would cancel out anyway
        end
        
        [err.PCoh  err.PCohNormAboveThresh]=CalcClusSig(curTStat,PCohMaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
    end
    
    if ClusShuffOpts.PSpecTest
        if ClusShuffOpts.PSpecTestStat==1
            %for spec, compare real data to entire average baseline
            %here b/c we may be calcing a mean across windows, whther or not we compare squared or non-squared spectra makes a difference... so we'll take the square...
            tmpBaseSpec1=mean( BaseXkoAll.*conj(BaseXkoAll),3 );
            if TwoSigsFlag;     tmpBaseSpec2=mean( BaseYkoAll.*conj(BaseYkoAll),3 );        end
            tmpActSpec1=ShuffActXk.*conj(ShuffActXk);
            if TwoSigsFlag;     tmpActSpec2=ShuffActYk.*conj(ShuffActYk);       end
            for iF=1:nrecf
                for iW=1:nInActPer
                    %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                    [h p stats]=my_signrank(tmpActSpec1(:,iF,iW),tmpBaseSpec1(:,iF),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                    curTStat(iF,iW)=stats.zval;    %the zvals seem to come out of signrank as negative, regardless of the sign of the effect... We'll have to denote at the end which Clusters in the real data are pos and which are neg...
                    if TwoSigsFlag;
                        [h p stats]=my_signrank(tmpActSpec2(:,iF,iW),tmpBaseSpec1(:,iF),'method','approximate');
                        curTStat2(iF,iW)=stats.zval;
                    end
                end
            end
        else
            %again, b/c of normalization of Sx, the below code won't work
            %             tmpBaseS1=mean( PSx(InBasePer,:) ,1)';
            %             tmpBaseS1=repmat(tmpBaseS1,[1 nInActPer]);
            %             tmpBaseS2=mean( PSy(InBasePer,:) ,1)';
            %             tmpBaseS2=repmat(tmpBaseS2,[1 nInActPer]);
            %
            %             %curTStat needs to have Freqs down dim 1 and win down dim 2
            %             curTStat= (log(PSx(InActPer,:))'-log(tmpBaseS1))/sqrt(2*psi(1,nReps));  %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
            %             curTStat2= (log(PSy(InActPer,:))'-log(tmpBaseS2))/sqrt(2*psi(1,nReps));
            
            curSX1=mean( mean(BaseXkoAll.*conj(BaseXkoAll)),3 )';  %it rurns out that squeeze d/n do anything to a 2D matrix... that sux... so we haave to use shiftdim
            if TwoSigsFlag;     curSY1=mean( mean(BaseYkoAll.*conj(BaseYkoAll)),3 )';   end
            curSX2=squeeze( mean(ActXkoAll.*conj(ActXkoAll)) );
            if TwoSigsFlag;     curSY2=squeeze( mean(ActYkoAll.*conj(ActYkoAll)) );     end
            
            %curTStat needs to have Freqs down dim 1 and win down dim 2
            curTStat= (log(curSX2)-log( curSX1(:,repmat(1,nInActPer,1) )))/sqrt(2*psi(1,nReps)); %we dont need to subtract the bias here b/c teh dfs are necessarily the same, so teh  biases would cancel out anyway
            if TwoSigsFlag;     curTStat2= (log(curSY2)-log( curSY1(:,repmat(1,nInActPer,1) )))/sqrt(2*psi(1,nReps));     end
        end
        
        [err.PSpec1  err.PSpec1NormAboveThresh]=CalcClusSig(curTStat,PSpec1MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
        if TwoSigsFlag;     [err.PSpec2  err.PSpec2NormAboveThresh]=CalcClusSig(curTStat2,PSpec2MaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );  end
    end
    
    
    %opts to plot this- when using imagesc for coh, you could only add each
    %cluster, and leave the rest of the space in teh graph blank... or you
    %could use matlab's edge function and draw a thick black ro whit line
    %around each cluster on the usual colorplot... one caveat to the edge
    %method- sometimes the output appears to be a little off, but it's
    %always close
elseif errType==1
    %you need to record the NTotSpksPerWin (and NTotSpksPerWin2 for Spk_SpkCoh, as a 1 x nWin vector before reaching here
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
    
    if CalcSpec;
        BaseCILimsHi=tmpdf1./ chi2inv( 1-pval/2,tmpdf1 );
        BaseCILimsLo=tmpdf1./ chi2inv( pval/2,tmpdf1 );
        err.Spec1CIHi=Sx.* BaseCILimsHi;
        err.Spec1CILo=Sx.* BaseCILimsLo;
        if exist('PSx','var');
            err.PSpec1CIHi=PSx.* BaseCILimsHi;
            err.PSpec1CILo=PSx.* BaseCILimsLo;
        end
    end
    if TwoSigsFlag;
        if CalcSpec;
            BaseCILimsHi=tmpdf2./ chi2inv( 1-pval/2,tmpdf2 );
            BaseCILimsLo=tmpdf2./ chi2inv( pval/2,tmpdf2 );
            err.Spec2CIHi=Sy.* BaseCILimsHi;
            err.Spec2CILo=Sy.* BaseCILimsLo;
            if exist('PSy','var');
                err.PSpec1CIHi=PSy.* BaseCILimsHi;
                err.PSpec1CILo=PSy.* BaseCILimsLo;
            end
        end
        
        tmpdf=min(tmpdf1,tmpdf2);
        err.Cohp=(tmpdf-2).*abs(coh).*(1-coh.^2).^(tmpdf/2-2);
        if CalcPart && ~JustPartFlag;    err.PCohp=(tmpdf-2).*abs(Pcoh).*(1-Pcoh.^2).^(tmpdf/2-2);        end
    end
end
