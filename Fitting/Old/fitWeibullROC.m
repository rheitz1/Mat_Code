function BestWFit=fitWeibullROC(Xval,Yval)

% p_mglobs
% RTglobs


ROCDummy(:,1) = Xval(:);
ROCDummy(:,2) = Yval(:);

% remove NaN's
NaNROC = isnan(ROCDummy); N = find(NaNROC==1);
if ~isempty(N)
   ROCDummy(N,:)=[];
end

vlb=[nanmin(Xval)+1 0.1 nanmin(Yval) nanmin(Yval)];
vub=[nanmax(Xval) 50 1.0 nanmax(Yval)];
lam(1) = (0.6*(nanmax(Xval)-nanmin(Xval))+nanmin(Xval));
%lam(2) = 10; lam(3) = 0.05; lam(4) = 1;
lam(2) = 10; lam(3) = .5; lam(4) = 1;
% optimize
%options=optimset('LargeScale','off');
out_param=fmincon('fitroc',lam,[],[],[],[],vlb,vub,[],[],ROCDummy(:,1),ROCDummy(:,2));

Params = out_param;

Time(1,:) = [round(min(ROCDummy(:,1)):1:round(max(ROCDummy(:,1))))]; Time=Time';

BestWFit=Params(3)-((exp(-((Time./Params(1)).^Params(2)))).*(Params(3)-Params(4)));