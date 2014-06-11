function [LL] = fitLBA_TL_calcLL(param,Parameter_Mat)

%FOR RUNNING WITH 'fitLBA_example_defectiveCDFs'
A0 = param(1);
A1 = param(2);
A2 = param(3);
A3 = param(4);
A4 = param(5);
A5 = param(6);
A6 = param(7);
A7 = param(8);

b0 = param(9);
b1 = param(10);
b2 = param(11);
b3 = param(12);
b4 = param(13);
b5 = param(14);
b6 = param(15);
b7 = param(16);

v0c = param(17);
v1c = param(18);
v2c = param(19);
v3c = param(20);
v4c = param(21);
v5c = param(22);
v6c = param(23);
v7c = param(24);

v0e = param(25);
v1e = param(26);
v2e = param(27);
v3e = param(28);
v4e = param(29);
v5e = param(30);
v6e = param(31);
v7e = param(32);

s = param(33);

T0 = param(34);



correct0 = find(Parameter_Mat(:,1) == 0 & Parameter_Mat(:,2) == 1);
correct1 = find(Parameter_Mat(:,1) == 1 & Parameter_Mat(:,2) == 1);
correct2 = find(Parameter_Mat(:,1) == 2 & Parameter_Mat(:,2) == 1);
correct3 = find(Parameter_Mat(:,1) == 3 & Parameter_Mat(:,2) == 1);
correct4 = find(Parameter_Mat(:,1) == 4 & Parameter_Mat(:,2) == 1);
correct5 = find(Parameter_Mat(:,1) == 5 & Parameter_Mat(:,2) == 1);
correct6 = find(Parameter_Mat(:,1) == 6 & Parameter_Mat(:,2) == 1);
correct7 = find(Parameter_Mat(:,1) == 7 & Parameter_Mat(:,2) == 1);

err0 = find(Parameter_Mat(:,1) == 0 & Parameter_Mat(:,2) == 0);
err1 = find(Parameter_Mat(:,1) == 1 & Parameter_Mat(:,2) == 0);
err2 = find(Parameter_Mat(:,1) == 2 & Parameter_Mat(:,2) == 0);
err3 = find(Parameter_Mat(:,1) == 3 & Parameter_Mat(:,2) == 0);
err4 = find(Parameter_Mat(:,1) == 4 & Parameter_Mat(:,2) == 0);
err5 = find(Parameter_Mat(:,1) == 5 & Parameter_Mat(:,2) == 0);
err6 = find(Parameter_Mat(:,1) == 6 & Parameter_Mat(:,2) == 0);
err7 = find(Parameter_Mat(:,1) == 7 & Parameter_Mat(:,2) == 0);


%Format is:  Cond | Correct/Err | SRT | WinnerPDF | Loser1CDF | Loser2CDF ... | Loser7CDF
Parameter_Mat(:,4:10) = NaN;
 
Parameter_Mat(correct0,4) = linearballisticPDF(Parameter_Mat(correct0,3),A0,b0,v0c,s);
Parameter_Mat(correct0,5) = linearballisticCDF(Parameter_Mat(correct0,3),A1,b1,v1e,s);
Parameter_Mat(correct0,6) = linearballisticCDF(Parameter_Mat(correct0,3),A2,b2,v2e,s);
Parameter_Mat(correct0,7) = linearballisticCDF(Parameter_Mat(correct0,3),A3,b3,v3e,s);
Parameter_Mat(correct0,8) = linearballisticCDF(Parameter_Mat(correct0,3),A4,b4,v4e,s);
Parameter_Mat(correct0,9) = linearballisticCDF(Parameter_Mat(correct0,3),A5,b5,v5e,s);
Parameter_Mat(correct0,10) = linearballisticCDF(Parameter_Mat(correct0,3),A6,b6,v6e,s);
Parameter_Mat(correct0,11) = linearballisticCDF(Parameter_Mat(correct0,3),A7,b7,v7e,s);
 
Parameter_Mat(correct1,4) = linearballisticPDF(Parameter_Mat(correct1,3),A2,b1,v1c,s);
Parameter_Mat(correct1,5) = linearballisticCDF(Parameter_Mat(correct1,3),A0,b0,v0e,s);
Parameter_Mat(correct1,6) = linearballisticCDF(Parameter_Mat(correct1,3),A2,b2,v2e,s);
Parameter_Mat(correct1,7) = linearballisticCDF(Parameter_Mat(correct1,3),A3,b3,v3e,s);
Parameter_Mat(correct1,8) = linearballisticCDF(Parameter_Mat(correct1,3),A4,b4,v4e,s);
Parameter_Mat(correct1,9) = linearballisticCDF(Parameter_Mat(correct1,3),A5,b5,v5e,s);
Parameter_Mat(correct1,10) = linearballisticCDF(Parameter_Mat(correct1,3),A6,b6,v6e,s);
Parameter_Mat(correct1,11) = linearballisticCDF(Parameter_Mat(correct1,3),A7,b7,v7e,s);
 
Parameter_Mat(correct2,4) = linearballisticPDF(Parameter_Mat(correct2,3),A2,b2,v2c,s);
Parameter_Mat(correct2,5) = linearballisticCDF(Parameter_Mat(correct2,3),A1,b1,v1e,s);
Parameter_Mat(correct2,6) = linearballisticCDF(Parameter_Mat(correct2,3),A0,b0,v0e,s);
Parameter_Mat(correct2,7) = linearballisticCDF(Parameter_Mat(correct2,3),A3,b3,v3e,s);
Parameter_Mat(correct2,8) = linearballisticCDF(Parameter_Mat(correct2,3),A4,b4,v4e,s);
Parameter_Mat(correct2,9) = linearballisticCDF(Parameter_Mat(correct2,3),A5,b5,v5e,s);
Parameter_Mat(correct2,10) = linearballisticCDF(Parameter_Mat(correct2,3),A6,b6,v6e,s);
Parameter_Mat(correct2,11) = linearballisticCDF(Parameter_Mat(correct2,3),A7,b7,v7e,s);
 
Parameter_Mat(correct3,4) = linearballisticPDF(Parameter_Mat(correct3,3),A3,b3,v3c,s);
Parameter_Mat(correct3,5) = linearballisticCDF(Parameter_Mat(correct3,3),A1,b1,v1e,s);
Parameter_Mat(correct3,6) = linearballisticCDF(Parameter_Mat(correct3,3),A2,b2,v2e,s);
Parameter_Mat(correct3,7) = linearballisticCDF(Parameter_Mat(correct3,3),A0,b0,v0e,s);
Parameter_Mat(correct3,8) = linearballisticCDF(Parameter_Mat(correct3,3),A4,b4,v4e,s);
Parameter_Mat(correct3,9) = linearballisticCDF(Parameter_Mat(correct3,3),A5,b5,v5e,s);
Parameter_Mat(correct3,10) = linearballisticCDF(Parameter_Mat(correct3,3),A6,b6,v6e,s);
Parameter_Mat(correct3,11) = linearballisticCDF(Parameter_Mat(correct3,3),A7,b7,v7e,s);
 
Parameter_Mat(correct4,4) = linearballisticPDF(Parameter_Mat(correct4,3),A4,b4,v4c,s);
Parameter_Mat(correct4,5) = linearballisticCDF(Parameter_Mat(correct4,3),A1,b1,v1e,s);
Parameter_Mat(correct4,6) = linearballisticCDF(Parameter_Mat(correct4,3),A2,b2,v2e,s);
Parameter_Mat(correct4,7) = linearballisticCDF(Parameter_Mat(correct4,3),A3,b3,v3e,s);
Parameter_Mat(correct4,8) = linearballisticCDF(Parameter_Mat(correct4,3),A0,b0,v0e,s);
Parameter_Mat(correct4,9) = linearballisticCDF(Parameter_Mat(correct4,3),A5,b5,v5e,s);
Parameter_Mat(correct4,10) = linearballisticCDF(Parameter_Mat(correct4,3),A6,b6,v6e,s);
Parameter_Mat(correct4,11) = linearballisticCDF(Parameter_Mat(correct4,3),A7,b7,v7e,s);
 
Parameter_Mat(correct5,4) = linearballisticPDF(Parameter_Mat(correct5,3),A5,b5,v5c,s);
Parameter_Mat(correct5,5) = linearballisticCDF(Parameter_Mat(correct5,3),A1,b1,v1e,s);
Parameter_Mat(correct5,6) = linearballisticCDF(Parameter_Mat(correct5,3),A2,b2,v2e,s);
Parameter_Mat(correct5,7) = linearballisticCDF(Parameter_Mat(correct5,3),A3,b3,v3e,s);
Parameter_Mat(correct5,8) = linearballisticCDF(Parameter_Mat(correct5,3),A4,b4,v4e,s);
Parameter_Mat(correct5,9) = linearballisticCDF(Parameter_Mat(correct5,3),A0,b0,v0e,s);
Parameter_Mat(correct5,10) = linearballisticCDF(Parameter_Mat(correct5,3),A6,b6,v6e,s);
Parameter_Mat(correct5,11) = linearballisticCDF(Parameter_Mat(correct5,3),A7,b7,v7e,s);
 
Parameter_Mat(correct6,4) = linearballisticPDF(Parameter_Mat(correct6,3),A6,b6,v6c,s);
Parameter_Mat(correct6,5) = linearballisticCDF(Parameter_Mat(correct6,3),A1,b1,v1e,s);
Parameter_Mat(correct6,6) = linearballisticCDF(Parameter_Mat(correct6,3),A2,b2,v2e,s);
Parameter_Mat(correct6,7) = linearballisticCDF(Parameter_Mat(correct6,3),A3,b3,v3e,s);
Parameter_Mat(correct6,8) = linearballisticCDF(Parameter_Mat(correct6,3),A4,b4,v4e,s);
Parameter_Mat(correct6,9) = linearballisticCDF(Parameter_Mat(correct6,3),A5,b5,v5e,s);
Parameter_Mat(correct6,10) = linearballisticCDF(Parameter_Mat(correct6,3),A0,b0,v0e,s);
Parameter_Mat(correct6,11) = linearballisticCDF(Parameter_Mat(correct6,3),A7,b7,v7e,s);
 
Parameter_Mat(correct7,4) = linearballisticPDF(Parameter_Mat(correct7,3),A7,b7,v7c,s);
Parameter_Mat(correct7,5) = linearballisticCDF(Parameter_Mat(correct7,3),A1,b1,v1e,s);
Parameter_Mat(correct7,6) = linearballisticCDF(Parameter_Mat(correct7,3),A2,b2,v2e,s);
Parameter_Mat(correct7,7) = linearballisticCDF(Parameter_Mat(correct7,3),A3,b3,v3e,s);
Parameter_Mat(correct7,8) = linearballisticCDF(Parameter_Mat(correct7,3),A4,b4,v4e,s);
Parameter_Mat(correct7,9) = linearballisticCDF(Parameter_Mat(correct7,3),A5,b5,v5e,s);
Parameter_Mat(correct7,10) = linearballisticCDF(Parameter_Mat(correct7,3),A6,b6,v6e,s);
Parameter_Mat(correct7,11) = linearballisticCDF(Parameter_Mat(correct7,3),A0,b0,v0e,s);
 
 
%Note:  May need to figure out where error went to and set the accumulator of ALL OTHERS to 1-v, leaving
%only 1 accumulator with original value.
Parameter_Mat(err0,4) = linearballisticPDF(Parameter_Mat(err0,3),A0,b0,v0c,s);
Parameter_Mat(err0,5) = linearballisticCDF(Parameter_Mat(err0,3),A1,b1,v1e,s);
Parameter_Mat(err0,6) = linearballisticCDF(Parameter_Mat(err0,3),A2,b2,v2e,s);
Parameter_Mat(err0,7) = linearballisticCDF(Parameter_Mat(err0,3),A3,b3,v3e,s);
Parameter_Mat(err0,8) = linearballisticCDF(Parameter_Mat(err0,3),A4,b4,v4e,s);
Parameter_Mat(err0,9) = linearballisticCDF(Parameter_Mat(err0,3),A5,b5,v5e,s);
Parameter_Mat(err0,10) = linearballisticCDF(Parameter_Mat(err0,3),A6,b6,v6e,s);
Parameter_Mat(err0,11) = linearballisticCDF(Parameter_Mat(err0,3),A7,b7,v7e,s);
 
Parameter_Mat(err1,4) = linearballisticPDF(Parameter_Mat(err1,3),A1,b1,v1c,s);
Parameter_Mat(err1,5) = linearballisticCDF(Parameter_Mat(err1,3),A0,b0,v0e,s);
Parameter_Mat(err1,6) = linearballisticCDF(Parameter_Mat(err1,3),A2,b2,v2e,s);
Parameter_Mat(err1,7) = linearballisticCDF(Parameter_Mat(err1,3),A3,b3,v3e,s);
Parameter_Mat(err1,8) = linearballisticCDF(Parameter_Mat(err1,3),A4,b4,v4e,s);
Parameter_Mat(err1,9) = linearballisticCDF(Parameter_Mat(err1,3),A5,b5,v5e,s);
Parameter_Mat(err1,10) = linearballisticCDF(Parameter_Mat(err1,3),A6,b6,v6e,s);
Parameter_Mat(err1,11) = linearballisticCDF(Parameter_Mat(err1,3),A7,b7,v7e,s);
 
Parameter_Mat(err2,4) = linearballisticPDF(Parameter_Mat(err2,3),A2,b2,v2c,s);
Parameter_Mat(err2,5) = linearballisticCDF(Parameter_Mat(err2,3),A1,b1,v1e,s);
Parameter_Mat(err2,6) = linearballisticCDF(Parameter_Mat(err2,3),A0,b0,v0e,s);
Parameter_Mat(err2,7) = linearballisticCDF(Parameter_Mat(err2,3),A3,b3,v3e,s);
Parameter_Mat(err2,8) = linearballisticCDF(Parameter_Mat(err2,3),A4,b4,v4e,s);
Parameter_Mat(err2,9) = linearballisticCDF(Parameter_Mat(err2,3),A5,b5,v5e,s);
Parameter_Mat(err2,10) = linearballisticCDF(Parameter_Mat(err2,3),A6,b6,v6e,s);
Parameter_Mat(err2,11) = linearballisticCDF(Parameter_Mat(err2,3),A7,b7,v7e,s);
 
Parameter_Mat(err3,4) = linearballisticPDF(Parameter_Mat(err3,3),A3,b3,v3c,s);
Parameter_Mat(err3,5) = linearballisticCDF(Parameter_Mat(err3,3),A1,b1,v1e,s);
Parameter_Mat(err3,6) = linearballisticCDF(Parameter_Mat(err3,3),A2,b2,v2e,s);
Parameter_Mat(err3,7) = linearballisticCDF(Parameter_Mat(err3,3),A0,b0,v0e,s);
Parameter_Mat(err3,8) = linearballisticCDF(Parameter_Mat(err3,3),A4,b4,v4e,s);
Parameter_Mat(err3,9) = linearballisticCDF(Parameter_Mat(err3,3),A5,b5,v5e,s);
Parameter_Mat(err3,10) = linearballisticCDF(Parameter_Mat(err3,3),A6,b6,v6e,s);
Parameter_Mat(err3,11) = linearballisticCDF(Parameter_Mat(err3,3),A7,b7,v7e,s);
 
Parameter_Mat(err4,4) = linearballisticPDF(Parameter_Mat(err4,3),A4,b4,v4c,s);
Parameter_Mat(err4,5) = linearballisticCDF(Parameter_Mat(err4,3),A1,b1,v1e,s);
Parameter_Mat(err4,6) = linearballisticCDF(Parameter_Mat(err4,3),A2,b2,v2e,s);
Parameter_Mat(err4,7) = linearballisticCDF(Parameter_Mat(err4,3),A3,b3,v3e,s);
Parameter_Mat(err4,8) = linearballisticCDF(Parameter_Mat(err4,3),A0,b0,v0e,s);
Parameter_Mat(err4,9) = linearballisticCDF(Parameter_Mat(err4,3),A5,b5,v5e,s);
Parameter_Mat(err4,10) = linearballisticCDF(Parameter_Mat(err4,3),A6,b6,v6e,s);
Parameter_Mat(err4,11) = linearballisticCDF(Parameter_Mat(err4,3),A7,b7,v7e,s);
 
Parameter_Mat(err5,4) = linearballisticPDF(Parameter_Mat(err5,3),A5,b5,v5c,s);
Parameter_Mat(err5,5) = linearballisticCDF(Parameter_Mat(err5,3),A1,b1,v1e,s);
Parameter_Mat(err5,6) = linearballisticCDF(Parameter_Mat(err5,3),A2,b2,v2e,s);
Parameter_Mat(err5,7) = linearballisticCDF(Parameter_Mat(err5,3),A3,b3,v3e,s);
Parameter_Mat(err5,8) = linearballisticCDF(Parameter_Mat(err5,3),A4,b4,v4e,s);
Parameter_Mat(err5,9) = linearballisticCDF(Parameter_Mat(err5,3),A0,b0,v0e,s);
Parameter_Mat(err5,10) = linearballisticCDF(Parameter_Mat(err5,3),A6,b6,v6e,s);
Parameter_Mat(err5,11) = linearballisticCDF(Parameter_Mat(err5,3),A7,b7,v7e,s);
 
Parameter_Mat(err6,4) = linearballisticPDF(Parameter_Mat(err6,3),A6,b6,v6c,s);
Parameter_Mat(err6,5) = linearballisticCDF(Parameter_Mat(err6,3),A1,b1,v1e,s);
Parameter_Mat(err6,6) = linearballisticCDF(Parameter_Mat(err6,3),A2,b2,v2e,s);
Parameter_Mat(err6,7) = linearballisticCDF(Parameter_Mat(err6,3),A3,b3,v3e,s);
Parameter_Mat(err6,8) = linearballisticCDF(Parameter_Mat(err6,3),A4,b4,v4e,s);
Parameter_Mat(err6,9) = linearballisticCDF(Parameter_Mat(err6,3),A5,b5,v5e,s);
Parameter_Mat(err6,10) = linearballisticCDF(Parameter_Mat(err6,3),A6,b0,v0e,s);
Parameter_Mat(err6,11) = linearballisticCDF(Parameter_Mat(err6,3),A7,b7,v7e,s);
 
Parameter_Mat(err7,4) = linearballisticPDF(Parameter_Mat(err7,3),A7,b7,v7c,s);
Parameter_Mat(err7,5) = linearballisticCDF(Parameter_Mat(err7,3),A2,b1,v1e,s);
Parameter_Mat(err7,6) = linearballisticCDF(Parameter_Mat(err7,3),A3,b2,v2e,s);
Parameter_Mat(err7,7) = linearballisticCDF(Parameter_Mat(err7,3),A4,b3,v3e,s);
Parameter_Mat(err7,8) = linearballisticCDF(Parameter_Mat(err7,3),A5,b4,v4e,s);
Parameter_Mat(err7,9) = linearballisticCDF(Parameter_Mat(err7,3),A6,b5,v5e,s);
Parameter_Mat(err7,10) = linearballisticCDF(Parameter_Mat(err7,3),A7,b6,v6e,s);
Parameter_Mat(err7,11) = linearballisticCDF(Parameter_Mat(err7,3),A0,b0,v0e,s);




%Get likelihoods
Parameter_Mat(:,12) = Parameter_Mat(:,4) .* prod(Parameter_Mat(:,5:11),2);

%set lower bounds
Parameter_Mat(find(Parameter_Mat(:,12) < 1e-5),5) = 1e-5;

%compute log
Parameter_Mat(:,13) = log(Parameter_Mat(:,12));


LL = -sum(Parameter_Mat(:,13));






%% PREDICTED VALUES

% winner0(:,1) = linearballisticPDF(1:1000,A,b0,v0,s);
% winner0(:,2) = linearballisticCDF(1:1000,A,b1,1-v1,s);
% winner0(:,3) = linearballisticCDF(1:1000,A,b2,1-v2,s);
% winner0(:,4) = linearballisticCDF(1:1000,A,b3,1-v3,s);
% winner0(:,5) = linearballisticCDF(1:1000,A,b4,1-v4,s);
% winner0(:,6) = linearballisticCDF(1:1000,A,b5,1-v5,s);
% winner0(:,7) = linearballisticCDF(1:1000,A,b6,1-v6,s);
% winner0(:,8) = linearballisticCDF(1:1000,A,b7,1-v7,s);
% 
% winner0(:,9) = cumsum(winner0(:,1) .* prod(1-winner0(:,2:8),2));
% 
% loser0(:,1) = linearballisticPDF(1:1000,A,b0,.79,s);
% loser0(:,2) = linearballisticCDF(1:1000,A,b1,.8,s);
% loser0(:,3) = linearballisticCDF(1:1000,A,b2,.8,s);
% loser0(:,4) = linearballisticCDF(1:1000,A,b3,.8,s);
% loser0(:,5) = linearballisticCDF(1:1000,A,b4,.8,s);
% loser0(:,6) = linearballisticCDF(1:1000,A,b5,.8,s);
% loser0(:,7) = linearballisticCDF(1:1000,A,b6,.8,s);
% loser0(:,8) = linearballisticCDF(1:1000,A,b7,.8,s);
% 
% loser0(:,9) = cumsum(loser0(:,1) .* prod(1-loser0(:,2:8),2));
% f_
% plot(1:1000,winner0(:,9),'k',1:1000,loser0(:,9),'r')
% 

F_correct0(:,1) = linearballisticCDF(1:1000,A0,b0,v0c,s);
F_correct1(:,1) = linearballisticCDF(1:1000,A1,b1,v1c,s);
F_correct2(:,1) = linearballisticCDF(1:1000,A2,b2,v2c,s);
F_correct3(:,1) = linearballisticCDF(1:1000,A3,b3,v3c,s);
F_correct4(:,1) = linearballisticCDF(1:1000,A4,b4,v4c,s);
F_correct5(:,1) = linearballisticCDF(1:1000,A5,b5,v5c,s);
F_correct6(:,1) = linearballisticCDF(1:1000,A6,b6,v6c,s);
F_correct7(:,1) = linearballisticCDF(1:1000,A7,b7,v7c,s);

F_err0(:,1) = linearballisticCDF(1:1000,A0,b0,v0e,s);
F_err1(:,1) = linearballisticCDF(1:1000,A1,b1,v1e,s);
F_err2(:,1) = linearballisticCDF(1:1000,A2,b2,v2e,s);
F_err3(:,1) = linearballisticCDF(1:1000,A3,b3,v3e,s);
F_err4(:,1) = linearballisticCDF(1:1000,A4,b4,v4e,s);
F_err5(:,1) = linearballisticCDF(1:1000,A5,b5,v5e,s);
F_err6(:,1) = linearballisticCDF(1:1000,A6,b6,v6e,s);
F_err7(:,1) = linearballisticCDF(1:1000,A7,b7,v7e,s);

f_correct0(:,1) = linearballisticPDF(1:1000,A0,b0,v0c,s);
f_correct1(:,1) = linearballisticPDF(1:1000,A1,b1,v1c,s);
f_correct2(:,1) = linearballisticPDF(1:1000,A2,b2,v2c,s);
f_correct3(:,1) = linearballisticPDF(1:1000,A3,b3,v3c,s);
f_correct4(:,1) = linearballisticPDF(1:1000,A4,b4,v4c,s);
f_correct5(:,1) = linearballisticPDF(1:1000,A5,b5,v5c,s);
f_correct6(:,1) = linearballisticPDF(1:1000,A6,b6,v6c,s);
f_correct7(:,1) = linearballisticPDF(1:1000,A7,b7,v7c,s);
 
f_err0(:,1) = linearballisticPDF(1:1000,A0,b0,v0e,s);
f_err1(:,1) = linearballisticPDF(1:1000,A1,b1,v1e,s);
f_err2(:,1) = linearballisticPDF(1:1000,A2,b2,v2e,s);
f_err3(:,1) = linearballisticPDF(1:1000,A3,b3,v3e,s);
f_err4(:,1) = linearballisticPDF(1:1000,A4,b4,v4e,s);
f_err5(:,1) = linearballisticPDF(1:1000,A5,b5,v5e,s);
f_err6(:,1) = linearballisticPDF(1:1000,A6,b6,v6e,s);
f_err7(:,1) = linearballisticPDF(1:1000,A7,b7,v7e,s);


bins_correct0 = evalin('base','bins_correct0');
bins_correct1 = evalin('base','bins_correct1');
bins_correct2 = evalin('base','bins_correct2');
bins_correct3 = evalin('base','bins_correct3');
bins_correct4 = evalin('base','bins_correct4');
bins_correct5 = evalin('base','bins_correct5');
bins_correct6 = evalin('base','bins_correct6');
bins_correct7 = evalin('base','bins_correct7');

bins_err0 = evalin('base','bins_err0');
bins_err1 = evalin('base','bins_err1');
bins_err2 = evalin('base','bins_err2');
bins_err3 = evalin('base','bins_err3');
bins_err4 = evalin('base','bins_err4');
bins_err5 = evalin('base','bins_err5');
bins_err6 = evalin('base','bins_err6');
bins_err7 = evalin('base','bins_err7');

y_axis_correct0 = evalin('base','y_axis_correct0');
y_axis_correct1 = evalin('base','y_axis_correct1');
y_axis_correct2 = evalin('base','y_axis_correct2');
y_axis_correct3 = evalin('base','y_axis_correct3');
y_axis_correct4 = evalin('base','y_axis_correct4');
y_axis_correct5 = evalin('base','y_axis_correct5');
y_axis_correct6 = evalin('base','y_axis_correct6');
y_axis_correct7 = evalin('base','y_axis_correct7');
 
y_axis_err0 = evalin('base','y_axis_err0');
y_axis_err1 = evalin('base','y_axis_err1');
y_axis_err2 = evalin('base','y_axis_err2');
y_axis_err3 = evalin('base','y_axis_err3');
y_axis_err4 = evalin('base','y_axis_err4');
y_axis_err5 = evalin('base','y_axis_err5');
y_axis_err6 = evalin('base','y_axis_err6');
y_axis_err7 = evalin('base','y_axis_err7');



winner0 = cumsum(f_correct0 .* prod([1-F_err1 1-F_err2 1-F_err3 1-F_err4 1-F_err5 1-F_err6 1-F_err7],2));
loser0_win1 = cumsum(f_err0 .* prod([1-F_correct1 1-F_err2 1-F_err3 1-F_err4 1-F_err5 1-F_err6 1-F_err7],2));
loser0_win2 = cumsum(f_err0 .* prod([1-F_err1 1-F_correct2 1-F_err3 1-F_err4 1-F_err5 1-F_err6 1-F_err7],2));
loser0_win3 = cumsum(f_err0 .* prod([1-F_err1 1-F_err2 1-F_correct3 1-F_err4 1-F_err5 1-F_err6 1-F_err7],2));
loser0_win4 = cumsum(f_err0 .* prod([1-F_err1 1-F_err2 1-F_err3 1-F_correct4 1-F_err5 1-F_err6 1-F_err7],2));
loser0_win5 = cumsum(f_err0 .* prod([1-F_err1 1-F_err2 1-F_err3 1-F_err4 1-F_correct5 1-F_err6 1-F_err7],2));
loser0_win6 = cumsum(f_err0 .* prod([1-F_err1 1-F_err2 1-F_err3 1-F_err4 1-F_err5 1-F_correct6 1-F_err7],2));
loser0_win7 = cumsum(f_err0 .* prod([1-F_err1 1-F_err2 1-F_err3 1-F_err4 1-F_err5 1-F_err6 1-F_correct7],2));
loser0 = nanmean([loser0_win1 loser0_win2 loser0_win3 loser0_win4 loser0_win5 loser0_win6 loser0_win7],2);

winner1 = cumsum(f_correct1 .* prod([1-F_err0 1-F_err2 1-F_err3 1-F_err4 1-F_err5 1-F_err6 1-F_err7],2));
loser1 = cumsum(f_err1 .* prod([1-F_correct0 1-F_correct2 1-F_correct3 1-F_correct4 1-F_correct5 1-F_correct6 1-F_correct7],2));

%loserA2 = cumsum(f_err3 .* ( (1-F_correct1) .* (1-F_err2) ));


plot(1:1000,winner1,'k',1:1000,loser1,'r')
hold on
plot(bins_correct1,y_axis_correct1,'ok',bins_err1,y_axis_err1,'or')
pause(.01)
cla

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