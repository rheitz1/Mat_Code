function [MaxClusSum,PosClusSums,PosClusAssign,NegClusSums,NegClusAssign]=FindStatClus(TStat,Thresh,NClusCutOff)
%function [MaxClusSum,PosClusSums,PosClusAssign,NegClusSums,NegClusAssign]=FindStatClus(TStat,Thresh,NClusCutOff)
%
% NormAboveThreshStats no longer accepted as an input b/c this
% automatically calculates the cluster statistics BOTH ways, outputting the
% value with NormAboveThreshStats as 0 in the first column of the stats
% above, and outputting the value with NormAboveThreshStats as 1 in the 
% second column of the stats above. This applies to MaxClusSum, PosClusSums
% and NegClusSums, but note that it doesn't not apply o PosClusAssign or
% NegClusAssign, both of which are the same for either values of
% NormAboveThreshStats

%set below to 1 to emphasize highly sig ind vals within a cluster, set to 0
%to emphasize the number of sig points within a cluster, i.e. cluster size
%I need to test each with large numbers of shuffles later...
if nargin<4  || isempty(NormAboveThreshStats);      NormAboveThreshStats=0;     end

%you have to go through this once to get pos clus's and once more to get
%neg clus's... if not, then if an above thresh pos postion is adjacent to a
%belwo thresh neg position, they would be put into teh same cluster and the
%resulting sum of the cluster test stat would be degraded as they cancel

[PosClusAssign,NClusPos] = bwlabeln(TStat>=Thresh,4);
[NegClusAssign,NClusNeg] = bwlabeln(TStat<=-Thresh,4);

%find non-zeros vals and position for both pos and neg clus's
%alternate option done in a few lines- this should be the fastest way to do it...   
[Cli,Clj,Cln] = find(PosClusAssign);
[CliNeg,CljNeg,ClnNeg] = find(NegClusAssign);


PosClusSums=repmat(0,NClusPos,2);
NegClusSums=repmat(0,NClusNeg,2);

%fir Pos Clus's
if NClusPos<NClusCutOff
    for iCl=1:NClusPos     %for smaller numbers of cluster, this should be faster
        tmpInds=Cln==iCl;  
        PosClusSums(iCl,1)=sum(sum( MultiDimSelect(TStat, Cli(tmpInds),Clj(tmpInds) ) ));
    end
else
    for iv=1:length(Cli)
        PosClusSums( Cln(iv),1 )= PosClusSums( Cln(iv) ) + TStat(Cli(iv),Clj(iv));     
    end
end

%same for Neg Clus's
if NClusNeg<NClusCutOff
    for iCl=1:NClusNeg     %for smaller numbers of cluster, this should be faster
        tmpInds=ClnNeg==iCl;  
        NegClusSums(iCl,1)=sum(sum( MultiDimSelect(TStat, CliNeg(tmpInds),CljNeg(tmpInds) ) ));
    end
else
    for iv=1:length(CliNeg)
        NegClusSums( ClnNeg(iv),1 )= NegClusSums( ClnNeg(iv) ) + TStat(CliNeg(iv),CljNeg(iv));     
    end
end

%normalize the significance for a continuous transition to a given timepoint being above thresh    
%if NormAboveThreshStats
    for iCl=1:NClusPos
        PosClusSums(iCl,2)=PosClusSums(iCl)-Thresh*sum(Cln==iCl);
    end
    for iCl=1:NClusNeg
        NegClusSums(iCl,2)=NegClusSums(iCl)+Thresh*sum(ClnNeg==iCl);
    end
%end

if NClusPos+NClusNeg==0;        MaxClusSum=[0 0];       else        MaxClusSum=max([PosClusSums; abs(NegClusSums)]);      end