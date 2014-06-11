function [err1 err2]=CalcClusSig(OTStat,MaxClusStat,Thresh,NClusCutOff,nShuffs,wintimes,f,pval)
%function [err1 err2]=CalcClusSig(OTStat,MaxClusStat,Thresh,NClusCutOff,nShuffs,wintimes,f,pval)
%
%MaxClusStat is now dims of [nShuffs x 2] (see FindStatClus.m)

%GetClustStats
[~,PosClusSums,PosClusAssign,NegClusSums,NegClusAssign]=FindStatClus(OTStat,Thresh,NClusCutOff);

%find sig Clus's and only report pvals for those
MaxClusStat=sort(MaxClusStat);
err1.NullTestStatDist=MaxClusStat(:,1);
err1.SigThresh= MaxClusStat( round((1-pval)*nShuffs),1 );

err1.Pos=CalcClusSig2(PosClusSums(:,1),PosClusAssign,MaxClusStat(:,1),err1.SigThresh,nShuffs,wintimes,f);
err1.Neg=CalcClusSig2(NegClusSums(:,1),NegClusAssign,MaxClusStat(:,1),err1.SigThresh,nShuffs,wintimes,f);

err2.NullTestStatDist=MaxClusStat(:,2);
err2.SigThresh= MaxClusStat( round((1-pval)*nShuffs),2 );

err2.Pos=CalcClusSig2(PosClusSums(:,2),PosClusAssign,MaxClusStat(:,2),err2.SigThresh,nShuffs,wintimes,f);
err2.Neg=CalcClusSig2(NegClusSums(:,2),NegClusAssign,MaxClusStat(:,2),err2.SigThresh,nShuffs,wintimes,f);

function err=CalcClusSig2(ClusSums,ClusAssign,MaxClusStat,SigThresh,nShuffs,wintimes,f)

SigClus=find( abs(ClusSums)>=SigThresh );
%NNSigClus=abs(ClusSums)<SigThresh;
err.NSigClus=length(SigClus);
err.SigClusSums=ClusSums(SigClus); %only keep the sums for the sig clus's

err.SigClusPVals=repmat(0,1,err.NSigClus);
err.SigClusTFCens=repmat(0,err.NSigClus,2);
err.SigClusAssign=repmat(0,size(ClusAssign));  %initilaize final ClusAssign

%get coords of all Cluster Locs
if length(wintimes)==1   && size(ClusAssign,1)==1   %the dimensions get screwed up if there's only one time window
    ClusAssign=ClusAssign';
end
[Cli,Clj,Cln] = find(ClusAssign);
for isc=1:err.NSigClus
    err.SigClusPVals(isc)=sum( MaxClusStat>=abs(err.SigClusSums(isc)) )/nShuffs;
    
    tmpInds=find( Cln==SigClus(isc) );
    %err.ClusAssign( Cli(tmpInds),Clj(tmpInds) )=isc;      %assign Locs to final ClusAssign
    for iI=1:length(tmpInds)
        err.SigClusAssign( Cli(tmpInds(iI)),Clj(tmpInds(iI)) )=isc;      %assign Locs to final ClusAssign
    end
    err.Clus(isc).RawCoords=[Clj(tmpInds) Cli(tmpInds)]; %Cli will be Freq inds, and Clj will be time Inds
    if length(wintimes)==1      %the dimensions get screwed up if there's only one time window
        err.Clus(isc).AllTFVals=[wintimes( Clj(tmpInds) ) f( Cli(tmpInds) )']; %Cli will be Freq inds, and Clj will be time Inds
    else
        err.Clus(isc).AllTFVals=[wintimes( Clj(tmpInds) )' f( Cli(tmpInds) )']; %Cli will be Freq inds, and Clj will be time Inds
    end
    err.Clus(isc).TFCen=mean(err.Clus(isc).AllTFVals,1);
    err.SigClusTFCens(isc,:)=err.Clus(isc).TFCen;
end
err.SigClusAssign=err.SigClusAssign'; %transpose this so it matches coh

%record non-sig clusters for inspection puposes later
err.AllClusSums=ClusSums;
err.AllClusAssign=ClusAssign';

err.AllPVals=repmat(0,length(ClusSums),1);
err.AllTFCens=repmat(0,length(ClusSums),2);
for isc=1:length(ClusSums)
    err.AllPVals(isc)=sum( MaxClusStat>=abs(ClusSums(isc)) )/nShuffs;
    
    tmpInds=find( Cln==isc );
    if length(wintimes)==1      %the dimensions get screwed up if there's only one time window
        err.AllTFCens(isc,:)=mean( [wintimes( Clj(tmpInds) ) f( Cli(tmpInds) )'],1 );
    else
        err.AllTFCens(isc,:)=mean( [wintimes( Clj(tmpInds) )' f( Cli(tmpInds) )'],1 );
    end
end