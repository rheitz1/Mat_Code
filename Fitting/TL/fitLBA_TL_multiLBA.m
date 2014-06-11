clear Trial_Mat remove*
%starting values
A(1:8) = .1;
b(1:8) = 100;
v(1:8) = .8;
s(1:8) = .23;
T0(1:8) = 50;

lb.A(1:8) = .01;
lb.b(1:8) = 0;
lb.v(1:8) = .5;
lb.s(1:8) = .01;
lb.T0(1:8) = 30;

ub.A(1:8) = 500;
ub.b(1:8) = 500;
ub.v(1:8) = 1;
ub.s(1:8) = 1;
ub.T0(1:8) = 300;


if ~exist('saccLoc')
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
end


%note: may want to use Target_(:,2) for correct trials to cut down on any mis-estimated saccLocs.

%FORMAT:
% TARGET LOC  |  ACTUAL LOC (WINNING UNIT)  |  CORRECT/ERR   |  RT | drift rates
Trial_Mat(:,1) = Target_(:,2);
Trial_Mat(:,2) = saccLoc;
Trial_Mat(:,3) = Correct_(:,2);
Trial_Mat(:,4) = SRT(:,1);

% Parameter_Mat(:,5:11) = NaN;

%eliminate error trials that were not saccade direction errors and get rid of catch trials
remove1 = find(nansum(Errors_(:,1:4),2));
remove2 = find(Target_(:,2) == 255);
remove3 = find(isnan(saccLoc));
remove = unique([remove1 ; remove2 ; remove3]);

Trial_Mat(remove,:) = [];



param = [A,b,v,T0];
lower = [lb.A,lb.b,lb.v,lb.T0];
upper = [ub.A,ub.b,ub.v,ub.T0];
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_TL_multiLBA_calcLL(param,Trial_Mat),param,lower,upper,options)

A = solution(1);
b = solution(2);
v = solution(3:10);
s = solution(11);
T0 = solution(12);