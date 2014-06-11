% PDF of the linear ballistic accumulator model
% from Brown & Heathcote (2008) p.159
%
% t is vector of x-values
% A is upper limit on starting point of evidence accumulation. Will be
%   drawing from a uniform distribution [0,A]
% b is threshold
% s is standard deviation of the drift rate, set to 0.1
% v is the mean of the normal distribution from which drift rates d are
%   sampled

function [solution] = fitLBA_example(cond1,cond2,cond3)
%linearballisticPDF(1:.01:100,.01,20,.4,1)
%%
plotFlag = 1;
A = 287.5479037;
v1=0.848617975;
v2=0.724705333;
v3=0.590370253;
b1=300;
b2=300;
b3=300;
T0 = 191.1196855;
s = 0.216696528;


SRT_correct1 = sort(cond1(find(cond1(:,2) == 1),3));
SRT_correct2 = sort(cond1(find(cond2(:,2) == 1),3));
SRT_correct3 = sort(cond1(find(cond3(:,2) == 1),3));

SRT_err1 = sort(cond1(find(cond1(:,2) == 0),3));
SRT_err2 = sort(cond1(find(cond2(:,2) == 0),3));
SRT_err3 = sort(cond1(find(cond3(:,2) == 0),3));


% param = [A b v s T0]; 
param = [A b1 b2 b3 v1 v2 v3 s T0]; 


%create linear inequalities:
% A > 0
% b > A
% v1 >= v2
% v2 >= v3
% s > .0001
% T0 > 0
% VARIABLE:A v1 v2 v3 b T0 s
linconb = [0 A 1 v2 v3 .0001 0];
linconA = zeros(length(linconb),length(param));

%set constraints
linconA(1,1) = -1;  % -1*A <= 0 is same as 1*A >= 0
linconA(2,2) = -1;  % -1*b <= A is same as 1*b >= A
linconA(3,3) = 1;  % 1*v1 <= 1
linconA(4,4) = -1; % -1*v1 <= v2 is same as 1*v1 >= v2
linconA(5,5) = -1;  % -1*v2 <= v3 is same as 1*v2 >= v3
linconA(6,6) = -1;  % -1*s <= .0001 is same as 1*s >= .0001
linconA(7,7) = -1;  % -1*T0 <= 0 is same as 1*T0 >= 0

% lb = [0;0;0;0;0;.0001;0];
% ub = [inf;inf;1;1;1;inf;inf];
 options = optimset('MaxIter', 100000,'MaxFunEvals', 100000,'algorithm','interior-point');
% [solution minval] = fmincon(@(param) cLL(param,cond1,cond2,cond3),param,linconA,linconb,[],[],lb,ub,[],options);
[solution minval] = fminsearch(@(param) cLL(param,cond1,cond2,cond3),param,options);
A = solution(1); 
b1 = solution(2);
b2 = solution(3);
b3 = solution(4);
v1 = solution(5);
v2 = solution(6);
v3 = solution(7);
s = solution(8);
T0 = solution(9);


SRT_correct1 = SRT_correct1 - T0;
SRT_correct2 = SRT_correct2 - T0;
SRT_correct3 = SRT_correct3 - T0;
SRT_err1 = SRT_err1 - T0;
SRT_err2 = SRT_err2 - T0;
SRT_err3 = SRT_err3 - T0;


F_correct1(:,1) = linearballisticCDF(SRT_correct1,A,b1,v1,s);
F_correct2(:,1) = linearballisticCDF(SRT_correct2,A,b2,v2,s);
F_correct3(:,1) = linearballisticCDF(SRT_correct3,A,b3,v3,s);

F_err1(:,1) = linearballisticCDF(SRT_err1,A,b1,1-v1,s);
F_err2(:,1) = linearballisticCDF(SRT_err2,A,b2,1-v2,s);
F_err3(:,1) = linearballisticCDF(SRT_err3,A,b3,1-v3,s);

f_correct1(:,1) = linearballisticPDF(SRT_correct1,A,b1,v1,s);
f_correct2(:,1) = linearballisticPDF(SRT_correct2,A,b2,v2,s);
f_correct3(:,1) = linearballisticPDF(SRT_correct3,A,b3,v3,s);

f_err1(:,1) = linearballisticPDF(SRT_err1,A,b1,1-v1,s);
f_err2(:,1) = linearballisticPDF(SRT_err2,A,b2,1-v2,s);
f_err3(:,1) = linearballisticPDF(SRT_err3,A,b3,1-v3,s);


% defectivePDF_correct1_predicted = linearballisticPDF(0:1000,A,b,v1,s) .* ( ...
%     linearballisticCDF(0:1000,A,b,v2,s) .* ...
%     linearballisticCDF(0:1000,A,b,v3,s) .* ...
%     linearballisticCDF(0:1000,A,-b,1-v1,s) .* ...
%     linearballisticCDF(0:1000,A,-b,1-v2,s) .* ...
%     linearballisticCDF(0:1000,A,-b,1-v3,s) );

%Compute predicted values
% defectivePDF_correct1_predicted = f_correct1 .* ( ...
%     linearballisticCDF(SRT_correct1,A,b,v2,s) .* ...
%     linearballisticCDF(SRT_correct1,A,b,v3,s) .* ...
%     linearballisticCDF(SRT_correct1,A,b,1-v1,s) .* ...
%     linearballisticCDF(SRT_correct1,A,b,1-v2,s) .* ...
%     linearballisticCDF(SRT_correct1,A,b,1-v3,s) );
% 
% defectivePDF_correct2_predicted = f_correct2 .* ( ...
%     linearballisticCDF(SRT_correct2,A,b,v1,s) .* ...
%     linearballisticCDF(SRT_correct2,A,b,v3,s) .* ...
%     linearballisticCDF(SRT_correct2,A,b,1-v1,s) .* ...
%     linearballisticCDF(SRT_correct2,A,b,1-v2,s) .* ...
%     linearballisticCDF(SRT_correct2,A,b,1-v3,s) );
% 
% defectivePDF_correct3_predicted = f_correct3 .* ( ...
%     linearballisticCDF(SRT_correct3,A,b,v1,s) .* ...
%     linearballisticCDF(SRT_correct3,A,b,v2,s) .* ...
%     linearballisticCDF(SRT_correct3,A,b,1-v1,s) .* ...
%     linearballisticCDF(SRT_correct3,A,b,1-v2,s) .* ...
%     linearballisticCDF(SRT_correct3,A,b,1-v3,s) );
% 
% defectivePDF_err1_predicted = f_err1 .* ( ...
%     linearballisticCDF(SRT_err1,A,b,v1,s) .* ...
%     linearballisticCDF(SRT_err1,A,b,v2,s) .* ...
%     linearballisticCDF(SRT_err1,A,b,v3,s) .* ...
%     linearballisticCDF(SRT_err1,A,b,1-v2,s) .* ...
%     linearballisticCDF(SRT_err1,A,b,1-v3,s) );
% 
% defectivePDF_err2_predicted = f_err2 .* ( ...
%     linearballisticCDF(SRT_err2,A,b,v1,s) .* ...
%     linearballisticCDF(SRT_err2,A,b,v2,s) .* ...
%     linearballisticCDF(SRT_err2,A,b,v3,s) .* ...
%     linearballisticCDF(SRT_err2,A,b,1-v1,s) .* ...
%     linearballisticCDF(SRT_err2,A,b,1-v3,s) );
% 
% defectivePDF_err3_predicted = f_err3 .* ( ...
%     linearballisticCDF(SRT_err3,A,b,v1,s) .* ...
%     linearballisticCDF(SRT_err3,A,b,v2,s) .* ...
%     linearballisticCDF(SRT_err3,A,b,v3,s) .* ...
%     linearballisticCDF(SRT_err3,A,b,1-v1,s) .* ...
%     linearballisticCDF(SRT_err3,A,b,1-v2,s) );


disp([v1 v2 v3 A b1 b2 b3 T0 s])
% 
% if plotFlag
%     figure
%     plot(defectiveCDF_observed.correct(:,1),defectiveCDF_observed.correct(:,2),'ok', ...
%         defectiveCDF_observed.err(:,1),defectiveCDF_observed.err(:,2),'ok')
%     hold on
%     plot(SRT_correct,defectiveCDF_correct_predicted,'k',SRT_err,defectiveCDF_err_predicted,'k')
% end

function [LL] = cLL(param,cond1,cond2,cond3)

A = param(1);
b1 = param(2);
b2 = param(3);
b3 = param(4);
v1 = param(5);
v2 = param(6);
v3 = param(7);
s = param(8);
T0 = param(9);
% T0 = param(5);

SRT_correct1 = sort(cond1(find(cond1(:,2) == 1),3));
SRT_correct2 = sort(cond2(find(cond2(:,2) == 1),3));
SRT_correct3 = sort(cond3(find(cond3(:,2) == 1),3));

SRT_err1 = sort(cond1(find(cond1(:,2) == 0),3));
SRT_err2 = sort(cond2(find(cond2(:,2) == 0),3));
SRT_err3 = sort(cond3(find(cond3(:,2) == 0),3));

% %CDF
SRT_correct1 = SRT_correct1 - T0;
SRT_correct2 = SRT_correct2 - T0;
SRT_correct3 = SRT_correct3 - T0;
SRT_err1 = SRT_err1 - T0;
SRT_err2 = SRT_err2 - T0;
SRT_err3 = SRT_err3 - T0;


% A = rand * A;
% drift1 = normrnd(v,s);
% drift2 = normrnd(v,s);
v1_correct = v1;
v1_err = 1-v1;

v2_correct = v2;
v2_err = 1-v2;

v3_correct = v3;
v3_err = 1-v3;


LL_correct1 = -sum(log(linearballisticPDF(SRT_correct1,A,b1,v1_correct,s)));
LL_correct2 = -sum(log(linearballisticPDF(SRT_correct2,A,b2,v2_correct,s)));
LL_correct3 = -sum(log(linearballisticPDF(SRT_correct3,A,b3,v3_correct,s)));


LL_err1 = -sum(log(linearballisticPDF(SRT_err1,A,b1,v1_err,s)));
LL_err2 = -sum(log(linearballisticPDF(SRT_err2,A,b2,v2_err,s)));
LL_err3 = -sum(log(linearballisticPDF(SRT_err3,A,b3,v3_err,s)));

LL = LL_correct1 + LL_correct2 + LL_correct3 + LL_err1 + LL_err2 + LL_err3;