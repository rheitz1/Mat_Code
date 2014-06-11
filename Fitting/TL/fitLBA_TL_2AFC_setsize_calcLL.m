function [LL] = fitLBA_TL_2AFC_setsize_calcLL(param,Trial_Mat)

plotFlag = 1;

[A(1) A(2) A(3) b(1) b(2) b(3) v(1) v(2) v(3) T0(1) T0(2) T0(3) s(1)] = disperse(param);
% A = param(1:3);
% b = param(4:6);
% v = param(7:9);
% T0 = param(10:12);
% s = param(13);

Parameter_Mat.A(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.b(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.v(size(Trial_Mat,1),1:2) = NaN;
Parameter_Mat.s(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.T0(size(Trial_Mat,1),1) = NaN;

%===== Current Unit ====
%set appropriate drift rates for correct trials based on winning accumulators


Parameter_Mat.A(find(Trial_Mat(:,5) == 2),1) = A(1);
Parameter_Mat.A(find(Trial_Mat(:,5) == 4),1) = A(2);
Parameter_Mat.A(find(Trial_Mat(:,5) == 8),1) = A(3);

Parameter_Mat.b(find(Trial_Mat(:,5) == 2),1) = b(1);
Parameter_Mat.b(find(Trial_Mat(:,5) == 4),1) = b(2);
Parameter_Mat.b(find(Trial_Mat(:,5) == 8),1) = b(3);

Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),1) = v(1);
Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),2) = 1-v(1);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),1) = 1-v(1);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),2) = v(1);

Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 4),1) = v(2);
Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 4),2) = 1-v(2);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 4),1) = 1-v(2);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 4),2) = v(2);

Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 8),1) = v(3);
Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 8),2) = 1-v(3);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 8),1) = 1-v(3);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 8),2) = v(3);

Parameter_Mat.s(find(Trial_Mat(:,5) == 2),1) = s;
Parameter_Mat.s(find(Trial_Mat(:,5) == 4),1) = s;
Parameter_Mat.s(find(Trial_Mat(:,5) == 8),1) = s;

Parameter_Mat.T0(find(Trial_Mat(:,5) == 2),1) = T0(1);
Parameter_Mat.T0(find(Trial_Mat(:,5) == 4),1) = T0(2);
Parameter_Mat.T0(find(Trial_Mat(:,5) == 8),1) = T0(3);





%===== Other Units ====
% on error trials, find the unit that actually won.

SRT_corrected = Trial_Mat(:,4) - Parameter_Mat.T0;

fF(:,1) = linearballisticPDF(SRT_corrected,Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,1),Parameter_Mat.s);
fF(:,2) = linearballisticCDF(SRT_corrected,Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,2),Parameter_Mat.s);

Likelihood = fF(:,1) .* (1-fF(:,2));

%set lower bounds
Likelihood(find(Likelihood < 1e-5)) = 1e-5;

LL = -nansum(log(Likelihood));

s2.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2);
s2.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2);
s4.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 4);
s4.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 4);
s8.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 8);
s8.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 8);

CDF.ss2 = getDefectiveCDF(s2.correct,s2.err,Trial_Mat(:,4));
CDF.ss4 = getDefectiveCDF(s4.correct,s4.err,Trial_Mat(:,4));
CDF.ss8 = getDefectiveCDF(s8.correct,s8.err,Trial_Mat(:,4));

if plotFlag == 1
    winner.ss2 = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s)));
    loser.ss2 = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s)));
    t.ss2 = (1:1000) + T0(1);
    
    winner.ss4 = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s)));
    loser.ss4 = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s)));
    t.ss4 = (1:1000) + T0(2);
    
    winner.ss8 = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),s) .* (1-linearballisticCDF(1:1000,A(3),b(3),1-v(3),s)));
    loser.ss8 = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),s) .* (1-linearballisticCDF(1:1000,A(3),b(3),v(3),s)));
    t.ss8 = (1:1000) + T0(3);
    
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
    
    
    subplot(1,3,3)
    plot(t.ss8,winner.ss8,'k',t.ss8,loser.ss8,'r')
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
    
    pause(.001)
    cla
    subplot(1,3,1)
    cla
    subplot(1,3,2)
    cla
    
end