function [LL] = fitLBA_TL_2AFC_calcLL(param,Trial_Mat)

plotFlag = 0;

A = param(1);
b = param(2);
v = param(3);
s = param(4);
T0 = param(5);



Parameter_Mat(size(Trial_Mat,1),1:2) = NaN;

%===== Current Unit ====
%set appropriate drift rates for correct trials based on winning accumulators
Parameter_Mat(find(Trial_Mat(:,3) == 1),1) = v;
Parameter_Mat(find(Trial_Mat(:,3) == 1),2) = 1-v;
%For error trials, set to 1-v except for the actual winning unit
Parameter_Mat(find(Trial_Mat(:,3) == 0),1) = 1-v;
Parameter_Mat(find(Trial_Mat(:,3) == 0),2) = v;

%===== Other Units ====
% on error trials, find the unit that actually won.

SRT_corrected = Trial_Mat(:,4) - T0;

fF(:,1) = linearballisticPDF(SRT_corrected,A,b,Parameter_Mat(:,1),s);
fF(:,2) = linearballisticCDF(SRT_corrected,A,b,Parameter_Mat(:,2),s);

Likelihood = fF(:,1) .* (1-fF(:,2));

%set lower bounds
%Likelihood(find(Likelihood < 1e-5)) = 1e-5;

LL = -sum(log(Likelihood));

CDF = getDefectiveCDF(find(Trial_Mat(:,3) == 1),find(Trial_Mat(:,3) == 0),SRT_corrected);

if plotFlag == 1
    winner = cumsum(linearballisticPDF(1:1000,A,b,v,s) .* (1-linearballisticCDF(1:1000,A,b,1-v,s)));
    loser = cumsum(linearballisticPDF(1:1000,A,b,1-v,s) .* (1-linearballisticCDF(1:1000,A,b,v,s)));
    
    plot(1:1000,winner,'k',1:1000,loser,'r')
    hold on
    plot(CDF.correct(:,1),CDF.correct(:,2),'ok',CDF.err(:,1),CDF.err(:,2),'or')
    pause(.001)
    cla
end