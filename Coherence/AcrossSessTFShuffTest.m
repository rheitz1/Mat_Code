function err=AcrossSessTFShuffTest( TestStats,t,f,Nms,ClusShuffOpts,pval )
%function err=AcrossSessTFShuffTest( TestStats,t,f,Nms,ClusShuffOpts,pval )
%
% It is assumed that the values of TestStat correspond to the (possibly
% transformed) values for measures like coherence or power spectra, not
% something like the raw Fourier components from which these values should
% be calculated after shuffling.
%
% This program will simply test the means of the activation periods vs the
% means of the base period using a signed rank test and shuffling and
% clustering procedure to determine significance
%
% Note- this is a MAGNITUDE based test. Inputs will be transformed to their
% magnitudes before performing the shuffling and test.
%
% Inputs:
%   TestStats-  a 3D array- [Time x Freq x nSess] of the values for each 
%               window you would like to test. This can cover more time 
%               windows than what's actually included in the activity or 
%               baseline period.
%   t-          a 1D vector corresponding to the times of the windows along
%               thes first dimeinsion of TestStats
%   f-          a 1D vector corresponding to the frequencies of the windows
%               along the second dimension of TestStats
%   Nms-        The length of the window (in ms) used to calculate
%               TestStats, which is assumed to be either coherence or
%               spectra. This defaults to 200 ms.
%   ClusShuffOpts-  A structure with various options for how to do the
%                   shuffling. See the code below for details.
%   pval-       The pvalue to used to determine which clusters are
%               significant.
%   
% Outputs:
%   err-        A structure with the fields Raw, and NormAboveThresh. 
%               Raw is a substructure containing the results when 
%               NormAboveThresh is set to 0, and NormAboveThresh is a
%               substructure containing results when NormAboveThresh is set
%               to 1. see the help comments in LFP_LFPCoh for more details
%               on what's in those substructures

use_parallel = 0;
if usejava('desktop') %don't even try 'matlabpool' if we're working on computing cluster; will fail
    if matlabpool('size') > 0;  use_parallel = 1; end
end

use_parallel = 0; %%%RPH: MAY NOT BE WORKING PROPERLY: EXAMINE MaxClusStat


nrecf=length(f);
nReps=size(TestStats,3);    %nReps is the number of sessions
TestStats=abs(TestStats);

%assign fields from ClusShuffOpts to workspace here in beginning, after setting defaults
nShuffs=5000;
BasePer=[-320 -80]; %in ms- this is the time window corresponding to the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the baseline period
ActPer=[0 800]; %in ms- this is the time window corresponding to the activity period, which are all the time periods you wish to test against the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the activity period
Thresh=1.96;
NClusCutOff=6;    %To improve speed, the algorithm operates two different ways (with the same result) based on the number of clusters in a given shuffle- one way is faster if there are more clusters and one way is faster if there are fewer clusters. This value sets the cutoff number of clusters value to determine which algorithm to use on a particular shuffle   
    
%I'm considering removing the below as an option and instead outputting both values for eth same shuffling        
%ClusShuffOpts.NormAboveThreshStats=1;   %if set to 1, when calc'ing clus sums, this sums the difference from the thresh of each test stat above thresh val, not the raw test stat val
%Setting to 1 will make the test more sensitive to indivdiual time and freq values way above thresh (i.e. for smaller clusters with more activation) and setting it 0 makes the test more sensitive to broader time-freq clusters of activation with individual values not as far above the threshhold        
%In practice, there are subtle but not major differences b/t setting this to 1 or 0          

if nargin < 4 || isempty(Nms);      Nms=200;      end
if nargin < 6 || isempty(pval);      pval=0.05;      end

%this takes any field in ClusShuffOpts and adds it to the workspace, thus
%writing over any defaults above if desired by the user input
if(nargin>=5) && ~isempty(ClusShuffOpts) 
    fieldlist=fieldnames(ClusShuffOpts);
    for ifld=1:length(fieldlist)        
        if length(ClusShuffOpts.(fieldlist{ifld}))>1
            eval([fieldlist{ifld} '=[' num2str(ClusShuffOpts.(fieldlist{ifld})) '];']);
        else
            eval([fieldlist{ifld} '=' num2str(ClusShuffOpts.(fieldlist{ifld})) ';']);
        end
    end
end


%Find wins that are in BasePer and ActPer
tst=t-Nms/2;
te=t+Nms/2;
InBasePer=isbetween(tst,BasePer) & isbetween(te,BasePer); %T or F based on whether a given window is completely within the baseline window
InActPer=isbetween(tst,ActPer) & isbetween(te,ActPer); %T or F based on whether a given window is completely within the baseline window
nInBasePer=sum(InBasePer);
nInActPer=sum(InActPer);

%separate TestStats into BaseAll and ActAll
BaseAll=TestStats(InBasePer,:,:);
ActAll=TestStats(InActPer,:,:);

disp(['Starting Cluster Shuffling, ' num2str(nShuffs) ' Shuffs to do'])
MaxClusStat=repmat(0,nShuffs,2);



ShuffBase=repmat(0,[nInActPer, nrecf, nReps]);  %this matches the dims in the incput TestStats, but is different form the dims in the within session stats code in LFP_LFPCoh, etc.
ShuffAct=ShuffBase;

tic
if use_parallel
    parfor iS=1:nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmprand=rand( nReps,1 );
        KeepBase=tmprand<0.5;
        BaseWin=mod( ceil(tmprand/(0.5/nInBasePer))-1,nInBasePer )+1;
        
        %note- trial order doesn't matter... the only that matter is which period is considered base, and which is considered act
        curTStat=repmat(0,nrecf,nInActPer);
        for iR=1:nReps
            if KeepBase(iR)
%                 ShuffBase( :,:,iR )=repmat( BaseAll( BaseWin(iR),:,iR ),[nInActPer 1 1] );
%                 
%                 ShuffAct( :,:,iR )=ActAll( :,:,iR );
                ShuffBase = repmat(BaseAll(BaseWin(iR),:,iR),[nInActPer 1 1]);
                ShuffAct = ActAll(:,:,iR);
            else
%                 ShuffBase( :,:,iR )=ActAll( :,:,iR );
%                 
%                 ShuffAct( :,:,iR )=repmat( BaseAll( BaseWin(iR),:,iR ),[nInActPer 1 1] );

                ShuffBase = ActAll(:,:,iR);
                ShuffAct = repmat(BaseAll(BaseWin(iR),:,iR),[nInActPer 1 1]);
            end
        end
        %toc
        
        for iF=1:nrecf
            for iW=1:nInActPer
                %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
                [~, ~, stats]=my_signrank(squeeze( ShuffAct(iW,iF,:) ),squeeze( ShuffBase(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                curTStat(iF,iW)=stats.zval;
            end
        end
        %toc
        
        MaxClusStat(iS,:)=FindStatClus(curTStat,Thresh,NClusCutOff);

        %tic/toc fails with parfor
%         if iS==1
%             disp('For first Shuff: ');
%             toc
%             tmptim=toc;
%             disp(['Shuffling should be done in about ' num2str( nShuffs*tmptim/60 ) ' minutes'])
%         end
    end
else
    for iS=1:nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmprand=rand( nReps,1 );
        KeepBase=tmprand<0.5;
        BaseWin=mod( ceil(tmprand/(0.5/nInBasePer))-1,nInBasePer )+1;
        
        %note- trial order doesn't matter... the only that matter is which period is considered base, and which is considered act
        for iR=1:nReps
            if KeepBase(iR)
                 ShuffBase( :,:,iR )=repmat( BaseAll( BaseWin(iR),:,iR ),[nInActPer 1 1] );
                 
                 ShuffAct( :,:,iR )=ActAll( :,:,iR );


            else
                 ShuffBase( :,:,iR )=ActAll( :,:,iR );
                 
                 ShuffAct( :,:,iR )=repmat( BaseAll( BaseWin(iR),:,iR ),[nInActPer 1 1] );

            end
        end
        %toc
        
        for iF=1:nrecf
            for iW=1:nInActPer
                %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
                [~, ~, stats]=my_signrank(squeeze( ShuffAct(iW,iF,:) ),squeeze( ShuffBase(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                curTStat(iF,iW)=stats.zval;
            end
        end
        %toc
        
        MaxClusStat(iS,:)=FindStatClus(curTStat,Thresh,NClusCutOff);
        
        if iS==1
            disp('For first Shuff: ');
            toc
            tmptim=toc;
            disp(['Shuffling should be done in about ' num2str( nShuffs*tmptim/60 ) ' minutes'])
        end
    end
end

disp('Done Shuffling')

err.wintimes=t(InActPer); %these will be the center of each time win

%Now calc Test Stats on orig data
tmpBaseStats=mean( BaseAll,1 );
tmpBaseStats=repmat(tmpBaseStats,[nInActPer 1 1]);

%curTStat needs to have Freqs down dim 1 and win down dim 2
if use_parallel
    parfor iF=1:nrecf
        for iW=1:nInActPer
            %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
            [~, ~, stats]=my_signrank(squeeze( ActAll(iW,iF,:) ),squeeze( tmpBaseStats(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
            curTStat(iF,iW)=stats.zval;
        end
    end
else
    parfor iF=1:nrecf
        for iW=1:nInActPer
            %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
            [~, ~, stats]=my_signrank(squeeze( ActAll(iW,iF,:) ),squeeze( tmpBaseStats(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
            curTStat(iF,iW)=stats.zval;
        end
    end
end
[err.Raw err.NormAboveThresh]=CalcClusSig( curTStat,MaxClusStat,Thresh,NClusCutOff,nShuffs,err.wintimes,f,pval );
    
    
    