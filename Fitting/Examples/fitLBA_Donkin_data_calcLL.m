function [LL] = fitLBA_Donkin_data_calcLL(param,SRT,Correct_,Target_)

%FOR RUNNING WITH 'fitLBA_example_defectiveCDFs'
A = param(1);
b = param(2);
v1 = param(3);
v2 = param(4);
v3 = param(5);
s = param(6);
T0 = param(7);

SRT_correct1 = SRT(find(Correct_ == 1 & Target_ == 1)) - T0;
SRT_correct2 = SRT(find(Correct_ == 1 & Target_ == 2)) - T0;
SRT_correct3 = SRT(find(Correct_ == 1 & Target_ == 3)) - T0;
SRT_err1 = SRT(find(Correct_ == 0 & Target_ == 1)) - T0;
SRT_err2 = SRT(find(Correct_ == 0 & Target_ == 2)) - T0;
SRT_err3 = SRT(find(Correct_ == 0 & Target_ == 3)) - T0;

%=====================
% NEW NEW
% SRT_correct1(find(SRT_correct1) < 200) = [];
% SRT_correct2(find(SRT_correct2) < 200) = [];
% SRT_correct3(find(SRT_correct3) < 200) = [];
% 
% SRT_err1(find(SRT_err1) < 200) = [];
% SRT_err2(find(SRT_err2) < 200) = [];
% SRT_err3(find(SRT_err3) < 200) = [];
%=====================

Parameter_Mat = [Target_ Correct_ SRT];

%Get f for winners and F for losers based on condition
correct1 = find(Correct_ == 1 & Target_ == 1);
correct2 = find(Correct_ == 1 & Target_ == 2);
correct3 = find(Correct_ == 1 & Target_ == 3);
error1 = find(Correct_ == 0 & Target_ == 1);
error2 = find(Correct_ == 0 & Target_ == 2);
error3 = find(Correct_ == 0 & Target_ == 3);

Parameter_Mat(:,3:4) = NaN;
Parameter_Mat(correct1,3) = linearballisticPDF(SRT_correct1,A,b,v1,s);
Parameter_Mat(correct1,4) = linearballisticCDF(SRT_correct1,A,b,1-v1,s);

Parameter_Mat(error1,3) = linearballisticPDF(SRT_err1,A,b,1-v1,s);
Parameter_Mat(error1,4) = linearballisticCDF(SRT_err1,A,b,v1,s);

Parameter_Mat(correct2,3) = linearballisticPDF(SRT_correct2,A,b,v2,s);
Parameter_Mat(correct2,4) = linearballisticCDF(SRT_correct2,A,b,1-v2,s);

Parameter_Mat(error2,3) = linearballisticPDF(SRT_err2,A,b,1-v2,s);
Parameter_Mat(error2,4) = linearballisticCDF(SRT_err2,A,b,v2,s);

Parameter_Mat(correct3,3) = linearballisticPDF(SRT_correct3,A,b,v3,s);
Parameter_Mat(correct3,4) = linearballisticCDF(SRT_correct3,A,b,1-v3,s);

Parameter_Mat(error3,3) = linearballisticPDF(SRT_err3,A,b,1-v3,s);
Parameter_Mat(error3,4) = linearballisticCDF(SRT_err3,A,b,v3,s);


%Get likelihoods
Parameter_Mat(:,5) = Parameter_Mat(:,3) .* (1-Parameter_Mat(:,4));

%set lower bounds
Parameter_Mat(find(Parameter_Mat(:,5) < 1e-5),5) = 1e-5;

%compute log
Parameter_Mat(:,6) = log(Parameter_Mat(:,5));


LL = -sum(Parameter_Mat(:,6));






%% PREDICTED VALUES
F_correct1(:,1) = linearballisticCDF(1:1000,A,b,v1,s);
F_correct2(:,1) = linearballisticCDF(1:1000,A,b,v2,s);
F_correct3(:,1) = linearballisticCDF(1:1000,A,b,v3,s);

F_err1(:,1) = linearballisticCDF(1:1000,A,b,1-v1,s);
F_err2(:,1) = linearballisticCDF(1:1000,A,b,1-v2,s);
F_err3(:,1) = linearballisticCDF(1:1000,A,b,1-v3,s);

f_correct1(:,1) = linearballisticPDF(1:1000,A,b,v1,s);
f_correct2(:,1) = linearballisticPDF(1:1000,A,b,v2,s);
f_correct3(:,1) = linearballisticPDF(1:1000,A,b,v3,s);

f_err1(:,1) = linearballisticPDF(1:1000,A,b,1-v1,s);
f_err2(:,1) = linearballisticPDF(1:1000,A,b,1-v2,s);
f_err3(:,1) = linearballisticPDF(1:1000,A,b,1-v3,s);

bins_correct1 = evalin('base','bins_correct1');
bins_correct2 = evalin('base','bins_correct2');
bins_correct3 = evalin('base','bins_correct3');
bins_err1 = evalin('base','bins_err1');
bins_err2 = evalin('base','bins_err2');
bins_err3 = evalin('base','bins_err3');
y_axis_correct1 = evalin('base','y_axis_correct1');
y_axis_correct2 = evalin('base','y_axis_correct2');
y_axis_correct3 = evalin('base','y_axis_correct3');
y_axis_err1 = evalin('base','y_axis_err1');
y_axis_err2 = evalin('base','y_axis_err2');
y_axis_err3 = evalin('base','y_axis_err3');

winnerA = cumsum(f_correct1 .* ( (1-F_err1)));
loserA1 = cumsum(f_err1 .* ( (1-F_correct1)));
%loserA2 = cumsum(f_err3 .* ( (1-F_correct1) .* (1-F_err2) ));


winnerB = cumsum(f_correct2 .* ( (1-F_err2)));
loserB1 = cumsum(f_err2 .* ( (1-F_correct2)));
%loserB2 = cumsum(f_err3 .* ( (1-F_correct2) .* (1-F_err1) ));


winnerC = cumsum(f_correct3 .* ( (1-F_err3)));
loserC1 = cumsum(f_err3 .* ( (1-F_correct3)));
%loserC2 = cumsum(f_err2 .* ( (1-F_correct3) .* (1-F_err1) ));


% 
% 
% subplot(2,2,1)
% plot(1:1000,winnerA,'k',1:1000,loserA1)
% hold on
% plot(bins_correct1,y_axis_correct1,'ok')
% plot(bins_err1,y_axis_err1,'or')
% title('Condition 1')
% 
% subplot(2,2,2)
% plot(1:1000,winnerB,'k',1:1000,loserB1)
% hold on
% plot(bins_correct2,y_axis_correct2,'ok')
% plot(bins_err2,y_axis_err2,'or')
% title('Condition 2')
% 
% subplot(2,2,3)
% plot(1:1000,winnerC,'k',1:1000,loserC1)
% hold on
% plot(bins_correct3,y_axis_correct3,'ok')
% plot(bins_err3,y_axis_err3,'or')
% title('Condition 3')
% pause
% 
% subplot(2,2,1)
% cla
% subplot(2,2,2)
% cla
% subplot(2,2,3)
% cla
% %%








% FOR RUNNING ON QLOAD
%function [LL] = tempLL(param,t_correct,t_err,T0)
% t_correct = sort(t_correct) - T0;
% t_err = sort(t_err) - T0;
% 
% A = param(1);
% b = param(2);
% v = param(3);
% s = param(4);
% 
% vC = v;
% vE = 1-v;
% 
% f_cor = linearballisticPDF(t_correct,A,b,vC,s);
% f_err = linearballisticPDF(t_err,A,b,vE,s);
% 
% LL = -(sum(log(f_cor)) + sum(log(f_err)));
end