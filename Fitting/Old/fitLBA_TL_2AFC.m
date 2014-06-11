clear Trial_Mat remove*
%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition


A=10;
b = 100;
v = .8;
s = .2;
T0 = 100;


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



param = [A,b,v,s,T0];
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
%options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000,'algorithm','interior-point');
[solution minval exitflag output] = fminsearch(@(param) fitLBA_TL_2AFC_calcLL(param,Trial_Mat),param,options)

A = solution(1);
b = solution(2);
v = solution(3);
s = solution(4);
T0 = solution(5);

SRT_corrected = Trial_Mat(:,4) - T0;
CDF = getDefectiveCDF(find(Trial_Mat(:,3) == 1),find(Trial_Mat(:,3) == 0),SRT_corrected);

figure
fon
winner = cumsum(linearballisticPDF(1:1000,A,b,v,s) .* (1-linearballisticCDF(1:1000,A,b,1-v,s)));
loser = cumsum(linearballisticPDF(1:1000,A,b,1-v,s) .* (1-linearballisticCDF(1:1000,A,b,v,s)));
    
plot(1:1000,winner,'k',1:1000,loser,'r')
hold on
plot(CDF.correct(:,1),CDF.correct(:,2),'ok',CDF.err(:,1),CDF.err(:,2),'or')

title(['A = ' mat2str(round(A*100)/100) ' b = ' mat2str(round(b*100)/100) ...
    ' v = ' mat2str(round(v*100)/100) ' s = ' mat2str(round(s*100)/100) ' T0 = ' mat2str(round(T0*100)/100)])
