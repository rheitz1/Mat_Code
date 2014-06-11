function CohZPF=CalcCohZPF(BaseXk,BaseYk,ActXk,ActYk,CX1Y1,CX2Y2)
% function CohZPF=CalcCohZPF(BaseXk,BaseYk,ActXk,ActYk,CX1Y1,CX2Y2)
%
% Returns the ZPF stat for all times and freqs in ActXk,ActYk vs the freqs 
% in a single time win at BaseXk,BaseYk. The ZPF stat is a meaure of a
% copmairons of corrleation strengths at different time points in the same
% subjects (or trials)

if nargin<7 || isempty(PartFlag);       PartFlag=0;         end

nwin=size(ActXk,3);
nBwin=size(BaseXk,3);
m=size(BaseXk,1);

if nargin>4 && ~isempty(CX1Y1);
    NeedBaseCoh=false;
    nBwin2=size(CX1Y1,2);
    %adjust the size of BaseCoh if needed
    if nBwin2<nwin   %nBwin should be either 1 or the same as nwin...
        %if mod(nwin,nBwin2)~=0
        %    error(['In CalcCohZPF number of CX1Y1 wins is: ' num2str(nBwin2) '... should be either 1 or the same as nwin, which is: ' num2str(nwin)])
        %else
            nBwin2=nBwin2-mod(nwin,nBwin2);
        
            CX1Y1=repmat(CX1Y1(:,1:nBwin2),[1 nwin/nBwin2]);            
        %end
    elseif nBwin2>nwin
        CX1Y1=CX1Y1(:,1:nwin);
    end
else        NeedBaseCoh=true;        end
if nargin>5 && ~isempty(CX2Y2);   NeedActCoh=false;      else        NeedActCoh=true;        end

%adjust the size of BaseXk if needed
if nBwin<nwin   %nBwin should be either 1 or the same as nwin...        
    %if mod(nwin,nBwin)~=0
    %    error(['In CalcCohZPF number of BaseWins is: ' num2str(nBwin) '... should be either 1 or the same as nwin, which is: ' num2str(nwin)])
    %else
        nBwin=nBwin-mod(nwin,nBwin);
    
        BaseXk=repmat(BaseXk(:,:,1:nBwin),[1 1 nwin/nBwin]);
        BaseYk=repmat(BaseYk(:,:,1:nBwin),[1 1 nwin/nBwin]);
    %end
elseif nBwin>nwin
    BaseXk=BaseXk(:,:,1:nwin);
    BaseYk=BaseYk(:,:,1:nwin);
end
    
% if PartFlag
%     %just change the Xks and Ykx to their Resid Vals
%     BaseXk=BaseXk-repmat( mean(BaseXk),m,1 );
%     BaseYk=BaseYk-repmat( mean(BaseYk),m,1 );
%     ActXk=ActXk-repmat( mean(ActXk),m,1 );
%     ActYk=ActYk-repmat( mean(ActYk),m,1 );
% end
    
%by this point, BaseXk,Yk and ActXk,Yk will be the same (3d if more than one win long) size
SX1=squeeze( mean(BaseXk.*conj(BaseXk)) );
SY1=squeeze( mean(BaseYk.*conj(BaseYk)) );
SX2=squeeze( mean(ActXk.*conj(ActXk)) );
SY2=squeeze( mean(ActYk.*conj(ActYk)) );

if NeedBaseCoh    
    CX1Y1=abs( squeeze( mean(BaseXk.*conj(BaseYk)) )./sqrt( SX1 .* SY1 ) );
end
CX1Y2=abs( squeeze( mean(BaseXk.*conj(ActYk)) )./sqrt( SX1 .* SY2 ) );
CY1X2=abs( squeeze( mean(ActXk.*conj(BaseYk)) )./sqrt( SX2 .* SY1 ) );
if NeedActCoh
    CX2Y2=abs( squeeze( mean(ActXk.*conj(ActYk)) )./sqrt( SX2 .* SY2 ) );
end

CX1X2=abs( squeeze( mean(BaseXk.*conj(ActXk)) )./sqrt( SX1 .* SX2 ) );
CY1Y2=abs( squeeze( mean(BaseYk.*conj(ActYk)) )./sqrt( SY1 .* SY2 ) );

k=(CX1X2-CY1X2.*CX1Y1).*(CY1Y2-CY1X2.*CX2Y2) + ...
  (CX1Y2-CX1X2.*CX2Y2).*(CY1X2-CX1X2.*CX1Y1) + ...
  (CX1X2-CX1Y2.*CX2Y2).*(CY1Y2-CX1Y2.*CX1Y1) + ...
  (CX1Y2-CX1Y1.*CY1Y2).*(CY1X2-CY1Y2.*CX2Y2);

Z1=atanh(CX1Y1);
Z2=atanh(CX2Y2);

CohZPF=sqrt( (2*m-2)/2 )*(Z2-Z1)./( sqrt(1- k./( 2*(1- CX1Y1.^2).*(1- CX2Y2.^2) )) );



