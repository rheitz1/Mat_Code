%t_original = 1:1000;
fixErrors
t_correct = SRT(correct,1);
t_err = SRT(errors,1);

A = 10;
v = .72;



b = 300;
T0 = 200;
s = .4;


% f_err = linearballisticPDF(t,A,b,vE,s);
% f_correct = linearballisticPDF(t,A,b,vC,s);
% 
% F_correct = linearballisticCDF(t,A,b,vC,s);
% F_err = linearballisticCDF(t,A,b,vE,s);
% 
% dCDF_cor = cumsum(f_correct .* (1-F_err));
% dCDF_err = cumsum(f_err .* (1-F_correct));

% figure
% plot(t,dCDF_cor,'k',t,dCDF_err,'r')
% 
% 

param = [A,b,v,s];
% % %use fminsearch to minimize -LL (because we actually want to maximize LL)
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval] = fminsearch(@(param) tempLL(param,t_correct,t_err,T0),[param],[options])
% 
% 
% 

t = 1:1000;
fitted.A = solution(1);
fitted.b = solution(2);
fitted.v = solution(3);
fitted.s = solution(4);

f_pred_correct = linearballisticPDF(t,fitted.A,fitted.b,fitted.v,fitted.s);
F_pred_correct = linearballisticCDF(t,fitted.A,fitted.b,fitted.v,fitted.s);

f_pred_err = linearballisticPDF(t,fitted.A,fitted.b,1-fitted.v,fitted.s);
F_pred_err = linearballisticCDF(t,fitted.A,fitted.b,1-fitted.v,fitted.s);

defectiveWinner = cumsum(f_pred_correct .* (1-F_pred_err));
defectiveLoser = cumsum(f_pred_err .* (1-F_pred_correct));

defective_obs = getDefectiveCDF(correct,errors,1);
hold on
%figure
plot(t,defectiveWinner,'k',t,defectiveLoser,'r')
