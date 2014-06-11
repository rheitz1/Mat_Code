% Runs on T/L Visual Search Data



%starting values
A0 = 1;
A1 = 1;
A2 = 1;
A3 = 1;
A4 = 1;
A5 = 1;
A6 = 1;
A7 = 1;

v0c=0.7;
v1c=0.7;
v2c=0.7;
v3c=0.7;
v4c=0.7;
v5c=0.7;
v6c=0.7;
v7c=0.7;

v0e=1-v0c;
v1e=1-v1c;
v2e=1-v2c;
v3e=1-v3c;
v4e=1-v4c;
v5e=1-v5c;
v6e=1-v6c;
v7e=1-v7c;


b0=100;
b1=100;
b2=100;
b3=100;
b4=100;
b5=100;
b6=100;
b7=100;

T0 = 100;

s = 0.1;

fixErrors
if ~exist('saccLoc')
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
end

%% Get Observed RTs & Defective CDFs
correct0 = find(Correct_(:,2) == 1 & Target_(:,2) == 0);
correct1 = find(Correct_(:,2) == 1 & Target_(:,2) == 1);
correct2 = find(Correct_(:,2) == 1 & Target_(:,2) == 2);
correct3 = find(Correct_(:,2) == 1 & Target_(:,2) == 3);
correct4 = find(Correct_(:,2) == 1 & Target_(:,2) == 4);
correct5 = find(Correct_(:,2) == 1 & Target_(:,2) == 5);
correct6 = find(Correct_(:,2) == 1 & Target_(:,2) == 6);
correct7 = find(Correct_(:,2) == 1 & Target_(:,2) == 7);

err0 = find(Errors_(:,5) == 1 & saccLoc == 0);
err1 = find(Errors_(:,5) == 1 & saccLoc == 1);
err2 = find(Errors_(:,5) == 1 & saccLoc == 2);
err3 = find(Errors_(:,5) == 1 & saccLoc == 3);
err4 = find(Errors_(:,5) == 1 & saccLoc == 4);
err5 = find(Errors_(:,5) == 1 & saccLoc == 5);
err6 = find(Errors_(:,5) == 1 & saccLoc == 6);
err7 = find(Errors_(:,5) == 1 & saccLoc == 7);


SRT_correct0 = sort(SRT(correct0,1));
SRT_correct1 = sort(SRT(correct1,1));
SRT_correct2 = sort(SRT(correct2,1));
SRT_correct3 = sort(SRT(correct3,1));
SRT_correct4 = sort(SRT(correct4,1));
SRT_correct5 = sort(SRT(correct5,1));
SRT_correct6 = sort(SRT(correct6,1));
SRT_correct7 = sort(SRT(correct7,1));

SRT_err0 = sort(SRT(err0,1));
SRT_err1 = sort(SRT(err1,1));
SRT_err2 = sort(SRT(err2,1));
SRT_err3 = sort(SRT(err3,1));
SRT_err4 = sort(SRT(err4,1));
SRT_err5 = sort(SRT(err5,1));
SRT_err6 = sort(SRT(err6,1));
SRT_err7 = sort(SRT(err7,1));

ALL_SRT = [SRT_correct0 ; SRT_correct1 ; SRT_correct2 ; SRT_correct3 ; ...
    SRT_correct4 ; SRT_correct5 ; SRT_correct6 ; SRT_correct7 ; ...
    SRT_err1 ; SRT_err2 ; SRT_err3 ; SRT_err4 ; SRT_err5 ; SRT_err6 ; SRT_err7];

%Structure Parameter Matrix.  Format is:  screen position/accumulator  |  Corect/Error    | RT
Parameter_Mat_a(1:length(correct0),1) = 0;
Parameter_Mat_a(1:length(correct0),2) = 1;
Parameter_Mat_a(1:length(correct0),3) = SRT_correct0;

Parameter_Mat_b(1:length(correct1),1) = 1;
Parameter_Mat_b(1:length(correct1),2) = 1;
Parameter_Mat_b(1:length(correct1),3) = SRT_correct1;

Parameter_Mat_c(1:length(correct2),1) = 2;
Parameter_Mat_c(1:length(correct2),2) = 1;
Parameter_Mat_c(1:length(correct2),3) = SRT_correct2;

Parameter_Mat_d(1:length(correct3),1) = 3;
Parameter_Mat_d(1:length(correct3),2) = 1;
Parameter_Mat_d(1:length(correct3),3) = SRT_correct3;

Parameter_Mat_e(1:length(correct4),1) = 4;
Parameter_Mat_e(1:length(correct4),2) = 1;
Parameter_Mat_e(1:length(correct4),3) = SRT_correct4;

Parameter_Mat_f(1:length(correct5),1) = 5;
Parameter_Mat_f(1:length(correct5),2) = 1;
Parameter_Mat_f(1:length(correct5),3) = SRT_correct5;

Parameter_Mat_g(1:length(correct6),1) = 6;
Parameter_Mat_g(1:length(correct6),2) = 1;
Parameter_Mat_g(1:length(correct6),3) = SRT_correct6;

Parameter_Mat_h(1:length(correct7),1) = 7;
Parameter_Mat_h(1:length(correct7),2) = 1;
Parameter_Mat_h(1:length(correct7),3) = SRT_correct7;


Parameter_Mat_i(1:length(err0),1) = 0;
Parameter_Mat_i(1:length(err0),2) = 0;
Parameter_Mat_i(1:length(err0),3) = SRT_err0;
 
Parameter_Mat_j(1:length(err1),1) = 1;
Parameter_Mat_j(1:length(err1),2) = 0;
Parameter_Mat_j(1:length(err1),3) = SRT_err1;
 
Parameter_Mat_k(1:length(err2),1) = 2;
Parameter_Mat_k(1:length(err2),2) = 0;
Parameter_Mat_k(1:length(err2),3) = SRT_err2;
 
Parameter_Mat_l(1:length(err3),1) = 3;
Parameter_Mat_l(1:length(err3),2) = 0;
Parameter_Mat_l(1:length(err3),3) = SRT_err3;
 
Parameter_Mat_m(1:length(err4),1) = 4;
Parameter_Mat_m(1:length(err4),2) = 0;
Parameter_Mat_m(1:length(err4),3) = SRT_err4;
 
Parameter_Mat_n(1:length(err5),1) = 5;
Parameter_Mat_n(1:length(err5),2) = 0;
Parameter_Mat_n(1:length(err5),3) = SRT_err5;
 
Parameter_Mat_o(1:length(err6),1) = 6;
Parameter_Mat_o(1:length(err6),2) = 0;
Parameter_Mat_o(1:length(err6),3) = SRT_err6;
 
Parameter_Mat_p(1:length(err7),1) = 7;
Parameter_Mat_p(1:length(err7),2) = 0;
Parameter_Mat_p(1:length(err7),3) = SRT_err7;

Parameter_Mat = [Parameter_Mat_a ; Parameter_Mat_b ; Parameter_Mat_c ; Parameter_Mat_d ; ...
    Parameter_Mat_e ; Parameter_Mat_f ; Parameter_Mat_g ; Parameter_Mat_h ; Parameter_Mat_i ; ...
    Parameter_Mat_j ; Parameter_Mat_k ; Parameter_Mat_l ; Parameter_Mat_m ; Parameter_Mat_n ; ...
    Parameter_Mat_o ; Parameter_Mat_p];

%get observed, defective CDFs

prob_correct0 = length(correct0) / ( length(correct0) + length(err0) );
prob_correct1 = length(correct1) / ( length(correct1) + length(err1) );
prob_correct2 = length(correct2) / ( length(correct2) + length(err2) );
prob_correct3 = length(correct3) / ( length(correct3) + length(err3) );
prob_correct4 = length(correct4) / ( length(correct4) + length(err4) );
prob_correct5 = length(correct5) / ( length(correct5) + length(err5) );
prob_correct6 = length(correct6) / ( length(correct6) + length(err6) );
prob_correct7 = length(correct7) / ( length(correct7) + length(err7) );

prob_err0 = 1 - prob_correct0;
prob_err1 = 1 - prob_correct1;
prob_err2 = 1 - prob_correct2;
prob_err3 = 1 - prob_correct3;
prob_err4 = 1 - prob_correct4;
prob_err5 = 1 - prob_correct5;
prob_err6 = 1 - prob_correct6;
prob_err7 = 1 - prob_correct7;


indices_correct0 = ceil((.1:.1:.9) .* length(SRT_correct0));
indices_correct1 = ceil((.1:.1:.9) .* length(SRT_correct1));
indices_correct2 = ceil((.1:.1:.9) .* length(SRT_correct2));
indices_correct3 = ceil((.1:.1:.9) .* length(SRT_correct3));
indices_correct4 = ceil((.1:.1:.9) .* length(SRT_correct4));
indices_correct5 = ceil((.1:.1:.9) .* length(SRT_correct5));
indices_correct6 = ceil((.1:.1:.9) .* length(SRT_correct6));
indices_correct7 = ceil((.1:.1:.9) .* length(SRT_correct7));

indices_err0 = ceil((.1:.1:.9) .* length(SRT_err0));
indices_err1 = ceil((.1:.1:.9) .* length(SRT_err1));
indices_err2 = ceil((.1:.1:.9) .* length(SRT_err2));
indices_err3 = ceil((.1:.1:.9) .* length(SRT_err3));
indices_err4 = ceil((.1:.1:.9) .* length(SRT_err4));
indices_err5 = ceil((.1:.1:.9) .* length(SRT_err5));
indices_err6 = ceil((.1:.1:.9) .* length(SRT_err6));
indices_err7 = ceil((.1:.1:.9) .* length(SRT_err7));


bins_correct0 = SRT_correct0(indices_correct0) - T0;
bins_correct1 = SRT_correct1(indices_correct1) - T0;
bins_correct2 = SRT_correct2(indices_correct2) - T0;
bins_correct3 = SRT_correct3(indices_correct3) - T0;
bins_correct4 = SRT_correct4(indices_correct4) - T0;
bins_correct5 = SRT_correct5(indices_correct5) - T0;
bins_correct6 = SRT_correct6(indices_correct6) - T0;
bins_correct7 = SRT_correct7(indices_correct7) - T0;

bins_err0 = SRT_err0(indices_err0) - T0;
bins_err1 = SRT_err1(indices_err1) - T0;
bins_err2 = SRT_err2(indices_err2) - T0;
bins_err3 = SRT_err3(indices_err3) - T0;
bins_err4 = SRT_err4(indices_err4) - T0;
bins_err5 = SRT_err5(indices_err5) - T0;
bins_err6 = SRT_err6(indices_err6) - T0;
bins_err7 = SRT_err7(indices_err7) - T0;


% Accuracy rates are normalized to response probability

y_axis_correct0 = (.1:.1:.9) .* prob_correct0;
y_axis_correct1 = (.1:.1:.9) .* prob_correct1;
y_axis_correct2 = (.1:.1:.9) .* prob_correct2;
y_axis_correct3 = (.1:.1:.9) .* prob_correct3;
y_axis_correct4 = (.1:.1:.9) .* prob_correct4;
y_axis_correct5 = (.1:.1:.9) .* prob_correct5;
y_axis_correct6 = (.1:.1:.9) .* prob_correct6;
y_axis_correct7 = (.1:.1:.9) .* prob_correct7;

y_axis_err0 = (.1:.1:.9) .* prob_err0;
y_axis_err1 = (.1:.1:.9) .* prob_err1;
y_axis_err2 = (.1:.1:.9) .* prob_err2;
y_axis_err3 = (.1:.1:.9) .* prob_err3;
y_axis_err4 = (.1:.1:.9) .* prob_err4;
y_axis_err5 = (.1:.1:.9) .* prob_err5;
y_axis_err6 = (.1:.1:.9) .* prob_err6;
y_axis_err7 = (.1:.1:.9) .* prob_err7;

%%



param = [A0,A1,A2,A3,A4,A5,A6,A7,b0,b1,b2,b3,b4,b5,b6,b7,v0c,v1c,v2c,v3c,v4c,v5c,v6c,v7c, ...
    v0e,v1e,v2e,v3e,v4e,v5e,v6e,v7e,s,T0];
% % %use fminsearch to minimize -LL (because we actually want to maximize LL)
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval] = fminsearch(@(param) fitLBA_TL_calcLL(param,Parameter_Mat),[param],[options])


A0 = solution(1);
A1 = solution(2);
A2 = solution(3);
A3 = solution(4);
A4 = solution(5);
A5 = solution(6);
A6 = solution(7);
A7 = solution(8);
 
b0 = solution(9);
b1 = solution(10);
b2 = solution(11);
b3 = solution(12);
b4 = solution(13);
b5 = solution(14);
b6 = solution(15);
b7 = solution(16);
 
v0c = solution(17);
v1c = solution(18);
v2c = solution(19);
v3c = solution(20);
v4c = solution(21);
v5c = solution(22);
v6c = solution(23);
v7c = solution(24);
 
v0e = solution(25);
v1e = solution(26);
v2e = solution(27);
v3e = solution(28);
v4e = solution(29);
v5e = solution(30);
v6e = solution(31);
v7e = solution(32);
 
s = solution(33);
 
T0 = solution(34);



F_correct1(:,1) = linearballisticCDF(1:1000,A,b,v1c,s);
F_correct2(:,1) = linearballisticCDF(1:1000,A,b,v2c,s);
F_correct3(:,1) = linearballisticCDF(1:1000,A,b,v3c,s);

F_err1(:,1) = linearballisticCDF(1:1000,A,b,v1e,s);
F_err2(:,1) = linearballisticCDF(1:1000,A,b,v2e,s);
F_err3(:,1) = linearballisticCDF(1:1000,A,b,v3e,s);

f_correct1(:,1) = linearballisticPDF(1:1000,A,b,v1c,s);
f_correct2(:,1) = linearballisticPDF(1:1000,A,b,v2c,s);
f_correct3(:,1) = linearballisticPDF(1:1000,A,b,v3c,s);

f_err1(:,1) = linearballisticPDF(1:1000,A,b,v1e,s);
f_err2(:,1) = linearballisticPDF(1:1000,A,b,v2e,s);
f_err3(:,1) = linearballisticPDF(1:1000,A,b,v3e,s);



winnerA = cumsum(f_correct1 .* ( (1-F_err1)));
loserA1 = cumsum(f_err1 .* ( (1-F_correct1)));

winnerB = cumsum(f_correct2 .* ( (1-F_err2)));
loserB1 = cumsum(f_err2 .* ( (1-F_correct2)));

winnerC = cumsum(f_correct3 .* ( (1-F_err3)));
loserC1 = cumsum(f_err3 .* ( (1-F_correct3)));


SRT_correct1 = SRT_correct1 - T0;
SRT_correct2 = SRT_correct2 - T0;
SRT_correct3 = SRT_correct3 - T0;
SRT_err1 = SRT_err1 - T0;
SRT_err2 = SRT_err2 - T0;
SRT_err3 = SRT_err3 - T0;
figure
subplot(2,2,1)
plot(1:1000,winnerA,'k',1:1000,loserA1)
hold on
plot(bins_correct1,y_axis_correct1,'ok')
plot(bins_err1,y_axis_err1,'or')
title('Condition 1')

subplot(2,2,2)
plot(1:1000,winnerB,'k',1:1000,loserB1)
hold on
plot(bins_correct2,y_axis_correct2,'ok')
plot(bins_err2,y_axis_err2,'or')
title('Condition 2')

subplot(2,2,3)
plot(1:1000,winnerC,'k',1:1000,loserC1)
hold on
plot(bins_correct3,y_axis_correct3,'ok')
plot(bins_err3,y_axis_err3,'or')
title('Condition 3')