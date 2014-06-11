function TDA = findROC(dist1,dist2,SOA,peaktime_dist1,plotto,prealign,varargin)  % TDA: Time of differential activity
temp(1) = ceil(max(max(dist1)));
temp(2) = ceil(max(max(dist2)));
MaxHz = max(temp);
isplot=0;
TDA=[];
n1=size(dist1,1);
n2=size(dist2,1);
num1 = n1(1);
num2 = n2(1);

if(~exist('plotto'))
    plotto = 1;
    dist1=dist1(1:n1,1);
    dist2=dist2(1:n2,1);
end

for ii=1:plotto
    for jj=1:MaxHz
        drop1=0;drop2=0;
        %this is for activity == 0 when jj == 1
        %if(jj==1)
        %    drop1 = num1-n1(ii);
        %    drop2 = num2-n2(ii);
        %end
        p1(jj)=(length(find(dist1(:,ii)>=(jj-1)))-drop1)/n1;
        p2(jj)=(length(find(dist2(:,ii)>=(jj-1)))-drop2)/n2;
    end
    p2=[p2 1];
    p1=[p1 0];    
    ROC(ii)=polyarea(p2,p1);
end

if ~isempty(peaktime_dist1)
    maxROC_index=peaktime_dist1;
else
    maxROC_index=min(find(ROC==max(ROC)));
end
if ~isempty(SOA)
    minROC_index=SOA;
else
    minROC_index=min(find(ROC>=0.5));
end

if isfinite(minROC_index) & isfinite(maxROC_index)& (minROC_index<maxROC_index) & ~isempty(ROC)
    fittedROC=fitWeibullROC(minROC_index:maxROC_index,ROC(minROC_index:maxROC_index));
    if nargin>6
        conflevel=varargin{1};
    else
        conflevel=0.6;          % Default criterion
    end
    if max(fittedROC)>=conflevel
        TDA=min(find(fittedROC>=conflevel))+prealign+(minROC_index-1);
    elseif max(ROC)>=conflevel
        TDA=min(find(ROC>=conflevel))+prealign+(minROC_index-1);    %If fit does not reach to criterion level
    else
        TDA=NaN;
    end
else
    TDA=NaN;
end