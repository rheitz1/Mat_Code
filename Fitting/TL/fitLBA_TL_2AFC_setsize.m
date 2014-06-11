clear Trial_Mat remove*
%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition

tic
A = [10 10 10];
b = [50 50 50];
v = [.8 .8 .8];
s = [.1];
T0 = [60 60 60];

lb.A = [20 20 20];
lb.b = [20 20 20];
lb.v = [.51 .51 .51];
lb.T0 = [10 10 10];
lb.s = [.001];

ub.A = [500 500 500];
ub.b = [500 500 500];
ub.v = [.95 .95 .95];
ub.T0 = [500 500 500];
ub.s = [.5];

init.A = [lb.A ; ub.A];
init.b = [lb.b ; ub.b];
init.v = [lb.v ; ub.v];
init.T0 = [lb.T0 ; ub.T0];
init.s = [lb.s ; ub.s];

initRange = [init.A init.b init.v init.T0 init.s];

if ~exist('saccLoc')
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
end


%note: may want to use Target_(:,2) for correct trials to cut down on any mis-estimated saccLocs.

%FORMAT:
% TARGET LOC  |  ACTUAL LOC (WINNING UNIT)  |  CORRECT/ERR   |  RT | SetSize
Trial_Mat(:,1) = Target_(:,2);
Trial_Mat(:,2) = saccLoc;
Trial_Mat(:,3) = Correct_(:,2);
Trial_Mat(:,4) = SRT(:,1);
Trial_Mat(:,5) = Target_(:,5);


%eliminate error trials that were not saccade direction errors and get rid of catch trials
remove1 = find(nansum(Errors_(:,1:4),2));
remove2 = find(Target_(:,2) == 255);
remove3 = find(isnan(saccLoc));
remove = unique([remove1 ; remove2 ; remove3]);

Trial_Mat(remove,:) = [];



param = [A,b,v,T0,s];
lower = [lb.A,lb.b,lb.v,lb.T0,lb.s];
upper = [ub.A,ub.b,ub.v,ub.T0,ub.s];
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_TL_2AFC_setsize_calcLL(param,Trial_Mat),param,lower,upper,options);
   
% options = gaoptimset('PopulationSize',[ones(1,5)*30],...
%     'Generations',100,...
%     'Display','iter', ...
%     'UseParallel','always', ...
%     'HybridFcn',@fminsearch);
% 
% solution = ga(@(param) fitLBA_TL_2AFC_setsize_calcLL(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],options);

[A(1) A(2) A(3) b(1) b(2) b(3) v(1) v(2) v(3) T0(1) T0(2) T0(3) s(1)] = disperse(solution);
% A = solution(1:3);
% b = solution(4:6);
% v = solution(7:9);
% T0 = solution(10:12);
% s = solution(13);

s2.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2);
s2.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2);
s4.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 4);
s4.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 4);
s8.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 8);
s8.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 8);

CDF.ss2 = getDefectiveCDF(s2.correct,s2.err,Trial_Mat(:,4));
CDF.ss4 = getDefectiveCDF(s4.correct,s4.err,Trial_Mat(:,4));
CDF.ss8 = getDefectiveCDF(s8.correct,s8.err,Trial_Mat(:,4));

winner.ss2 = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s)));
loser.ss2 = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s)));
t.ss2 = (1:1000) + T0(1);    

winner.ss4 = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s)));
loser.ss4 = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s)));
t.ss4 = (1:1000) + T0(2);

winner.ss8 = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),s) .* (1-linearballisticCDF(1:1000,A(3),b(3),1-v(3),s)));
loser.ss8 = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),s) .* (1-linearballisticCDF(1:1000,A(3),b(3),v(3),s)));
t.ss8 = (1:1000) + T0(3);

figure
%fon

subplot(1,3,1)
plot(t.ss2,winner.ss2,'k',t.ss2,loser.ss2,'r')
hold on
plot(CDF.ss2.correct(:,1),CDF.ss2.correct(:,2),'ok',CDF.ss2.err(:,1),CDF.ss2.err(:,2),'or')
ylim([0 1])
xlim([0 1000])
text(500,.5,['A = ' mat2str(round(A(1)*100)/100)])
text(500,.45,['b = ' mat2str(round(b(1)*100)/100)])
text(500,.4,['v = ' mat2str(round(v(1)*100)/100)])
text(500,.35,['s = ' mat2str(round(s*100)/100)])
text(500,.3,['T0 = ' mat2str(round(T0(1)*100)/100)])
title('Set Size 2')
box off

subplot(1,3,2)
plot(t.ss4,winner.ss4,'k',t.ss4,loser.ss4,'r')
hold on
plot(CDF.ss4.correct(:,1),CDF.ss4.correct(:,2),'ok',CDF.ss4.err(:,1),CDF.ss4.err(:,2),'or')
ylim([0 1])
xlim([0 1000])
text(500,.5,['A = ' mat2str(round(A(2)*100)/100)])
text(500,.45,['b = ' mat2str(round(b(2)*100)/100)])
text(500,.4,['v = ' mat2str(round(v(2)*100)/100)])
text(500,.35,['s = ' mat2str(round(s*100)/100)])
text(500,.3,['T0 = ' mat2str(round(T0(2)*100)/100)])
title('Set Size 4')
box off

subplot(1,3,3)
plot(t.ss8,winner.ss8,'k',t.ss8,loser.ss8,'r')
ylim([0 1])
hold on
plot(CDF.ss8.correct(:,1),CDF.ss8.correct(:,2),'ok',CDF.ss8.err(:,1),CDF.ss8.err(:,2),'or')
ylim([0 1])
xlim([0 1000])
text(500,.5,['A = ' mat2str(round(A(3)*100)/100)])
text(500,.45,['b = ' mat2str(round(b(3)*100)/100)])
text(500,.4,['v = ' mat2str(round(v(3)*100)/100)])
text(500,.35,['s = ' mat2str(round(s*100)/100)])
text(500,.3,['T0 = ' mat2str(round(T0(3)*100)/100)])
title('Set Size 8')
box off

disp(['Optimization ran for ' mat2str(round((toc/60)*100)/100) ' minutes'])