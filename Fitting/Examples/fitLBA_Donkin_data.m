% Runs on LBA_example_data in tangent with fitLBA_example.m
% calculate the predictive defective CDFs for each condition.
%
% For reference, see 'Donkin_LBA.xls'.  There, the raw data is provided, along with Excel fits that are
% very close to what this routine will provide as output.

load Donkin_LBA_example_data.mat


A = 287.5479037;
v1=0.848617975;
v2=0.724705333;
v3=0.590370253;
b=386.2055439;
T0 = 191.1196855;
s = 0.216696528;



%% Get Observed RTs & Defective CDFs
SRT_correct1 = SRT(find(Correct_ == 1 & Target_ == 1));
SRT_correct2 = SRT(find(Correct_ == 1 & Target_ == 2));
SRT_correct3 = SRT(find(Correct_ == 1 & Target_ == 3));
SRT_err1 = SRT(find(Correct_ == 0 & Target_ == 1));
SRT_err2 = SRT(find(Correct_ == 0 & Target_ == 2));
SRT_err3 = SRT(find(Correct_ == 0 & Target_ == 3));

%re-sort. Don't want to sort above so can compare to Donkin's materials
src1 = sort(SRT_correct1);
src2 = sort(SRT_correct2);
src3 = sort(SRT_correct3);
sre1 = sort(SRT_err1);
sre2 = sort(SRT_err2);
sre3 = sort(SRT_err3);

%get observed, defective CDFs

prob_cond1_correct = length(src1) / ( length(src1) + length(sre1) );
prob_cond2_correct = length(src2) / ( length(src2) + length(sre2) );
prob_cond3_correct = length(src3) / ( length(src3) + length(sre3) );

prob_cond1_err = 1 - prob_cond1_correct;
prob_cond2_err = 1 - prob_cond2_correct;
prob_cond3_err = 1 - prob_cond3_correct;


indices_correct1 = ceil((.1:.1:.9) .* length(src1));
indices_correct2 = ceil((.1:.1:.9) .* length(src2));
indices_correct3 = ceil((.1:.1:.9) .* length(src3));

indices_err1 = ceil((.1:.1:.9) .* length(sre1));
indices_err2 = ceil((.1:.1:.9) .* length(sre2));
indices_err3 = ceil((.1:.1:.9) .* length(sre3));



bins_correct1 =  src1(indices_correct1) - T0;
bins_correct2 =  src2(indices_correct2) - T0;
bins_correct3 =  src3(indices_correct3) - T0;


bins_err1 = sre1(indices_err1) - T0;
bins_err2 = sre2(indices_err2) - T0;
bins_err3 = sre3(indices_err3) - T0;


% Accuracy rates are normalized to response probability

y_axis_correct1 = (.1:.1:.9) .* prob_cond1_correct;
y_axis_correct2 = (.1:.1:.9) .* prob_cond2_correct;
y_axis_correct3 = (.1:.1:.9) .* prob_cond3_correct;

y_axis_err1 = (.1:.1:.9) .* prob_cond1_err;
y_axis_err2 = (.1:.1:.9) .* prob_cond2_err;
y_axis_err3 = (.1:.1:.9) .* prob_cond3_err;
%%



param = [A,b,v1,v2,v3,s,T0];
% % %use fminsearch to minimize -LL (because we actually want to maximize LL)
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval exitflag output] = fminsearch(@(param) fitLBA_Donkin_data_calcLL(param,SRT,Correct_,Target_),[param],[options])

A = solution(1);
b = solution(2);
v1 = solution(3);
v2 = solution(4);
v3 = solution(5);
s = solution(6);
T0 = solution(7);
%==============================
%PREDICTED
%will integrate over the positive real line, which we will set to 1:1000


% % param =   [A,b,v1,v2,v3,  s,  T0];
% % %linconb = [0 A 1  v2 v3 .0001 0];
% % linconb = param;
% % linconA = zeros(length(linconb),length(param));
% % 
% % %set constraints
% % linconA(1,2) = 1;    % 1 * A <= b
% % linconA(3,4) = 1;    % 1 * v2 <= v1
% % linconA(4,5) = 1;    % 1 * v3 <= v2
% % 
% % % linconA(1,1) = -1;  % -1*A <= 0 is same as 1*A >= 0
% % % linconA(2,2) = -1;  % -1*b <= A is same as 1*b >= A
% % % linconA(3,3) = 1;   % 1*v1 <= 1
% % % linconA(3,4) = -1;  % -1*v1 <= v2 is same as 1*v1 >= v2
% % % linconA(4,5) = -1;  % -1*v2 <= v3 is same as 1*v2 >= v3
% % % %linconA(5,5) = -1;  % -1*v2 <= v3 is same as 1*v2 >= v3
% % % linconA(6,6) = -1;  % -1*s <= .0001 is same as 1*s >= .0001
% % % linconA(7,7) = -1;  % -1*T0 <= 0 is same as 1*T0 >= 0
% % 
% % lb = [0;0;0;0;0;.0001;0];
% % ub = [inf;inf;1;1;1;inf;inf];
% % options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000,'algorithm','interior-point');
% % [solution minval] = fmincon(@(param) tempLL(param,SRT_correct1,SRT_correct2,SRT_correct3, ...
% %     SRT_err1,SRT_err2,SRT_err3),param,linconA,linconb,[],[],lb,ub,[],options)
% % 
% % 
% % A = solution(1);
% % b = solution(2);
% % v1 = solution(3);
% % v2 = solution(4);
% % v3 = solution(5);
% % s = solution(6);
% % T0 = solution(7);


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