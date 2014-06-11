%MTShuffTestInit_S.m
%
% called by LFP_LFPCoh, etc. before calling dmtUbiq_S.m

%Find wins that are in BasePer and ActPer
tst=tout-Nms/2;
te=tout+Nms/2;
InBasePer=isbetween(tst,ClusShuffOpts.BasePer) & isbetween(te,ClusShuffOpts.BasePer); %T or F based on whether a given window is completely within the baseline window
InActPer=isbetween(tst,ClusShuffOpts.ActPer) & isbetween(te,ClusShuffOpts.ActPer); %T or F based on whether a given window is completely within the baseline window

%InitBaseXko and BaseYko
nInBasePer=sum(InBasePer);
nInActPer=sum(InActPer);
if ClusShuffOpts.TestType==1
    BaseXkoAll=repmat( 0,[nch*K, diff(nfk)+1, nInBasePer] );
    ActXkoAll=repmat( 0,[nch*K, diff(nfk)+1, nInActPer] );
elseif ClusShuffOpts.TestType==2
    %For the CondShuffClustering, "Base" will refer to TrType 2 trials
    nReps=sum(ClusShuffOpts.TrType==1);
    nReps2=sum(ClusShuffOpts.TrType==2);
    BaseXkoAll=repmat( 0,[nReps2, diff(nfk)+1, nInActPer] );
    ActXkoAll=repmat( 0,[nReps, diff(nfk)+1, nInActPer] );        
end

if TwoSigsFlag  %this code works whether we're splitting trials or not
    BaseYkoAll=BaseXkoAll;
    ActYkoAll=ActXkoAll;
end

