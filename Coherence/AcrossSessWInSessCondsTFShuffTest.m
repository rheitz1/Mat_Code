function err=AcrossSessWInSessCondsTFShuffTest( TestStats1,TestStats2,t,f,Nms,ClusShuffOpts,pval )
%function err=AcrossSessWInSessCondsTFShuffTest( TestStats,TestStats2,t,f,Nms,ClusShuffOpts,pval )
%
% Like AcrossSessTFShuffTest, but instead of copmaring TestSats in the
% activation period to the baseline period, this compares TestStats1 to
% TestStats2 at every time and frequency location in each. This code enacts
% a between sessions test.
%
%               Note that in terms of the output- TestStats2 is like the
%               "baseline" in other programs in this series. In other
%               words, a significant positive cluster means that TestStats1
%               is significantly higher than TestStats2 at that location,
%               while a significant negative cluster indicates the reverse.
%
% Note that this program does the more common (for monkey neurophysiology)
% within sessions test, used for example if you wanted to compare set size
% 2 and 4 across sessions where data for each set size was gathered. Look
% to AcrossSessWInSessCondsTFShuffTest for the less common between sessions
% test, which compares the values from one group of a type of session to
% the values of a totally different set of a type of session where the
% numbers of sessions in each group don't necessarily have to match up.
% (and as of right now [091111] that code does not work... but I can finish
% it if it is ever needed.)
%
% It is assumed that the values of TestStat correspond to the (possibly
% transformed) values for measures like coherence or power spectra, not
% something like the raw Fourier components from which these values should
% be calculated after shuffling.
%
% This program will simply test the means in TestStats1 vs TestStats2 using
% a signed rank test and shuffling and clustering procedure to determine
% significance
%
% Note- this is a MAGNITUDE based test. Inputs will eb transformed to their
% magnitudes before performing the shuffling and test.
%
% Inputs:
%   TestStats1- a 3D array- [Time x Freq x nSess] of the values for the
%               first condition for each window you would like to test.
%   TestStats2- a 3D array- [Time x Freq x nSess] of the values for the
%               second condition for each window that you would like to
%               test.
%
%               For this code, TestStats1 and Teststas2 MUST BE THE SAME
%               SIZE IN EVERY DIMENSION. This code will take in values for
%               t and f, and ActPer (through ClusShoffOpts) but not
%               BasePer, and it will only test time windows that fall within
%               ActPer (just to maintain consistency with my other code).
%   t-          a 1D vector corresponding to the times of the windows along
%               the first dimeinsion of TestStats
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
%
%               Note that in terms of the output- TestStas2 is like the
%               "baseline" in other programs in this series. In other
%               words, a significant positive cluster means that TestStats1
%               is significantly higher than TestStats2 at that location,
%               while a significant negative cluster indicates the reverse.

useParallel = 0;
if usejava('desktop') %don't even try 'matlabpool' if we're working on computing cluster; will fail
    %if matlabpool('size') > 0;  use_parallel = 1; end
    parallelCheck
end
%use_parallel = 0; %%%RPH: MAY NOT BE WORKING PROPERLY: EXAMINE MaxClusStat

%remove NaN pairings, if they exist
paircount = 1;
toRemove = [];
for pair = 1:size(TestStats1,3);
    if all(all(isnan(TestStats1(:,:,pair))))
        toRemove(paircount,1) = pair;
        paircount = paircount + 1;
    end
end

TestStats1(:,:,toRemove) = [];
TestStats2(:,:,toRemove) = [];
disp(['Removing ' mat2str(length(toRemove)) ' NaN pairs'])

nrecf=length(f);
if nrecf~=size(TestStats1,2);       error(['f and TestStats1 don''t match. Input vector f has ' num2str(nrecf) ' elements, while input array TestStats1 has ' num2str(size(TestStats1,2)) ' elements.']);      end
nReps=size(TestStats1,3);    %nReps is the number of sessions
if nReps~=size(TestStats2,3);       error('Number of sess in TestStats1 and TestStats2 don''t match, which is necessary for the within sessions across sessions test this code runs.');      end
TestStats1=abs(TestStats1);
TestStats2=abs(TestStats2);

%assign fields from ClusShuffOpts to workspace here in beginning, after setting defaults
nShuffs=5000;
%%%Note- no BasePer needed... btu what eth hell, I'll use ActPer
%BasePer=[-320 -80]; %in ms- this is the time window corresponding to the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the baseline period
ActPer=[0 800]; %in ms- this is the time window corresponding to the activity period, which are all the time periods you wish to test against the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the activity period
Thresh=1.96;
NClusCutOff=6;    %To improve speed, the algorithm operates two different ways (with the same result) based on the number of clusters in a given shuffle- one way is faster if there are more clusters and one way is faster if there are fewer clusters. This value sets the cutoff number of clusters value to determine which algorithm to use on a particular shuffle

%I'm considering removing the below as an option and instead outputting both values for the same shuffling
%ClusShuffOpts.NormAboveThreshStats=1;   %if set to 1, when calc'ing clus sums, this sums the difference from the thresh of each test stat above thresh val, not the raw test stat val
%Setting to 1 will make the test more sensitive to indivdiual time and freq values way above thresh (i.e. for smaller clusters with more activation) and setting it 0 makes the test more sensitive to broader time-freq clusters of activation with individual values not as far above the threshhold
%In practice, there are subtle but not major differences b/t setting this to 1 or 0

if nargin < 5 || isempty(Nms);      Nms=200;      end
if nargin < 7 || isempty(pval);      pval=0.05;      end

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


%Find wins that are ENTIRELY within ActPer
tst=t-Nms/2;
te=t+Nms/2;
%InBasePer=isbetween(tst,BasePer) & isbetween(te,BasePer); %T or F based on whether a given window is completely within the baseline window
InActPer=isbetween(tst,ActPer) & isbetween(te,ActPer); %T or F based on whether a given window is completely within the baseline window
%nInBasePer=sum(InBasePer);
nInActPer=sum(InActPer);

%separate TestStats into BaseAll and ActAll
%BaseAll=TestStats(InBasePer,:,:);
Act1All=TestStats1(InActPer,:,:);
Act2All=TestStats2(InActPer,:,:);

disp(['Starting Cluster Shuffling, ' num2str(nShuffs) ' Shuffs to do'])
MaxClusStat=repmat(0,nShuffs,2);

curTStat=repmat(0,nrecf,nInActPer);

ShuffAct1=repmat(0,[nInActPer, nrecf, nReps]);  %this matches the dims in the input TestStats, but is different form the dims in the within session stats code in LFP_LFPCoh, etc.
ShuffAct2=ShuffAct1;


tic

if useParallel
    parfor iS=1:nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmprand=rand( nReps,1 );
        KeepAct1=tmprand<0.5;
        %BaseWin=mod( ceil(tmprand/(0.5/nInActPer))-1,nInActPer )+1;     %this line of code is not needed for the comparison across conditions rather than the comparison to baseline
        
        ShuffAct1 = NaN(size(Act1All,1),size(Act1All,2),size(Act1All,3));
        ShuffAct2 = NaN(size(Act1All,1),size(Act1All,2),size(Act1All,3));
        
        curTStat = NaN(length(nrecf),length(nInActPer));
        %note- trial order doesn't matter... the only that matter is which period is considered base, and which is considered act
        for iR=1:nReps %nReps is # of sessions entered
            x = Act1All(:,:,iR);
            y = Act2All(:,:,iR);
            
            if KeepAct1(iR)
                X = x;
                Y = y;
                %ShuffAct1( :,:,iR )=x;
                
                %ShuffAct2( :,:,iR )=y;
            else
                X = y;
                Y = x;
                %ShuffAct1( :,:,iR )=y;
                
                %ShuffAct2( :,:,iR )=x;
            end
            ShuffAct1(:,:,iR) = X;
            ShuffAct2(:,:,iR) = Y;
        end
        %toc
        
        for iF=1:nrecf
            for iW=1:nInActPer
                %signrank (and my_signrank of course) will ignore NaN inputs if they exist
                %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
                [~, ~, stats]=my_signrank(squeeze( ShuffAct1(iW,iF,:) ),squeeze( ShuffAct2(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
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
     %   disp('Tick')
    end
else
    
    for iS=1:nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmprand=rand( nReps,1 );
        KeepAct1=tmprand<0.5;
        %BaseWin=mod( ceil(tmprand/(0.5/nInActPer))-1,nInActPer )+1;     %this line of code is not needed for the comparison across conditions rather than the comparison to baseline
        
        %note- trial order doesn't matter... the only that matter is which period is considered base, and which is considered act
        for iR=1:nReps %nReps is # of sessions entered
            if KeepAct1(iR)
                ShuffAct1( :,:,iR )=Act1All( :,:,iR );
                
                ShuffAct2( :,:,iR )=Act2All( :,:,iR );
            else
                ShuffAct1( :,:,iR )=Act2All( :,:,iR );
                
                ShuffAct2( :,:,iR )=Act1All( :,:,iR );
            end
        end
        %toc
        
        for iF=1:nrecf
            for iW=1:nInActPer
                %signrank (and my_signrank of course) will ignore NaN inputs if they exist
                %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
                [~, ~, stats]=my_signrank(squeeze( ShuffAct1(iW,iF,:) ),squeeze( ShuffAct2(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
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

%curTStat needs to have Freqs down dim 1 and win down dim 2
if useParallel
    parfor iF=1:nrecf
        for iW=1:nInActPer
            %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
            [~, ~, stats]=my_signrank(squeeze( Act1All(iW,iF,:) ),squeeze( Act2All(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
            curTStat(iF,iW)=stats.zval;
        end
    end
else
    parfor iF=1:nrecf
        for iW=1:nInActPer
            %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on the same scale as the other test stats (i.e. the Fisher transform, or zpf for coh.
            [~, ~, stats]=my_signrank(squeeze( Act1All(iW,iF,:) ),squeeze( Act2All(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
            curTStat(iF,iW)=stats.zval;
        end
    end
end
[err.Raw err.NormAboveThresh]=CalcClusSig( curTStat,MaxClusStat,Thresh,NClusCutOff,nShuffs,err.wintimes,f,pval );


