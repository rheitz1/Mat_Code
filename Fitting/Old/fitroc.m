%Function fitroc(Params,varargin)
%This program returns error in fit to modified Wiebull function to the data.
%Constrained fit.
%Called by CALL_FITROC (backup file)
%Function:
%     [err]=FITROC(Params,XData,YData,PlotHandle)
%     Fun(gama,XData,alpha,beta,delta) = gama-((exp(-((XData./alpha).^beta))).*(gama-delta))
%     Params: Initial Guess [alpha beta gamma delta];

%Author: chenchal.subraveti@vanderbilt.edu May/04/1998
%HISTORY:
% small changes at APR-06-99
% by veit.stuphorn@vanderbilt.edu

function [err, g]=fitroc(Params,varargin)

XData=varargin{1};
YData=varargin{2};
if nargin>4
   if varargin{4}==2
      Params(3)=1; Params(4)=0;
   elseif varargin{4}==3
      Params(4)=0;
   end
end
if nargin>5
   PlotHandle=varargin{3};
end

PredY=Params(3)-((exp(-((XData./Params(1)).^Params(2)))).*(Params(3)-Params(4)));
%PredY=1-((exp(-((XData./Params(1)).^Params(2)))));

INDfinite=[];
INDfinite=find(PredY >=0 & PredY<=100.0);
err=PredY(INDfinite)-YData(INDfinite);
err=sum(err.^2);
if err==0
   err=1e-5;
elseif isnan(err)
   disp('ERR is nan')
elseif ~isfinite(err)
   disp('Err is infinite')
else
end
%Constraints
g(1,1)=nanmax(YData)-Params(3);
g(1,2)=nanmin(YData)-Params(4);
if nargin>5
   set(PlotHandle,'ydata',PredY);
   drawnow
end   

%%%%%%%%%%%%%%%%%%%%OLDER FITTING PROCEDURE WITHOUT CONSTRAINTS%%%%%%%%%%%%%%%%%%%%%%%
%function err=fitroc(Params,XData,YData,PlotHandle)
%alpha=Params(1);
%beta=Params(2);
%gama=Params(3);
%delta=Params(4);
%PredY=zeros(length(XData));
%fun_tofit=inline('gama-((exp(-((XData./alpha).^beta))).*(gama-delta))',...
%   'gama','XData','alpha','beta','delta');
%PredY=fun_tofit(gama,XData,alpha,beta,delta);
%err=sum((PredY-YData).^2);
%set(PlotHandle,'ydata',PredY)
%drawnow
%NOTES FOR CALLING DIRECTLY FROM MATLAB COMMAND WINDOW
%PlotHandle= plot(XData,YData,'b-','EraseMode','xor');
% axis([0 1 0.4 1.]);
% hold on
% plot(XData,YData,'ro','erasemode','none');
%Calling....
%outs=fmins('fitroc',lam,[trace tol],[],tim_,roc_,h)