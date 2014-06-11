function [LL] = fitLBA_SAT_free_s_calcLL(param,Trial_Mat)

plotFlag = 0;

FreeFix = evalin('caller','FreeFix');
A = param(evalin('caller','1:length(A)'));
b = param(evalin('caller','length(A)+1:length(A)+length(b)'));
v = param(evalin('caller','length(A)+length(b)+1:length(A)+length(b)+length(v)'));
T0 = param(evalin('caller','length(A)+length(b)+length(v)+1:length(A)+length(b)+length(v)+length(T0)'));
s = param(evalin('caller','length(A)+length(b)+length(v)+length(T0)+1:length(param)'));

n_free = numel(param);
n_obs = size(Trial_Mat,1);


Parameter_Mat.A(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.b(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.v(size(Trial_Mat,1),1:2) = NaN;
Parameter_Mat.T0(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.s(size(Trial_Mat,1),1) = NaN;


%Parameterized based on what is free/fixed
if FreeFix(1) == 1
    Parameter_Mat.A(1:size(Trial_Mat,1)) = A;
elseif FreeFix(1) == 2
    Parameter_Mat.A(find(Trial_Mat(:,5) == 1),1) = A(1);
    Parameter_Mat.A(find(Trial_Mat(:,5) == 3),1) = A(2);
elseif FreeFix(1) == 3
    Parameter_Mat.A(find(Trial_Mat(:,5) == 1),1) = A(1);
    Parameter_Mat.A(find(Trial_Mat(:,5) == 2),1) = A(2);
    Parameter_Mat.A(find(Trial_Mat(:,5) == 3),1) = A(3);
end

if FreeFix(2) == 1
    Parameter_Mat.b(1:size(Trial_Mat,1)) = b;
elseif FreeFix(2) == 2
    Parameter_Mat.b(find(Trial_Mat(:,5) == 1),1) = b(1);
    Parameter_Mat.b(find(Trial_Mat(:,5) == 3),1) = b(2);
elseif FreeFix(2) == 3
    Parameter_Mat.b(find(Trial_Mat(:,5) == 1),1) = b(1);
    Parameter_Mat.b(find(Trial_Mat(:,5) == 2),1) = b(2);
    Parameter_Mat.b(find(Trial_Mat(:,5) == 3),1) = b(3);
end

if FreeFix(3) == 1
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1),1) = v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1),2) = 1-v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0),1) = 1-v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0),2) = v(1);
elseif FreeFix(3) == 2
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),1) = v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),2) = 1-v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),1) = 1-v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),2) = v(1);
    
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),1) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),2) = 1-v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),1) = 1-v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),2) = v(2);
elseif FreeFix(3) == 3
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),1) = v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),2) = 1-v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),1) = 1-v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),2) = v(1);
    
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),1) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),2) = 1-v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),1) = 1-v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),2) = v(2);
    
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),1) = v(3);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),2) = 1-v(3);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),1) = 1-v(3);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),2) = v(3);
end

if FreeFix(4) == 1
    Parameter_Mat.T0(1:size(Trial_Mat,1)) = T0;
elseif FreeFix(4) == 2
    Parameter_Mat.T0(find(Trial_Mat(:,5) == 1),1) = T0(1);
    Parameter_Mat.T0(find(Trial_Mat(:,5) == 3),1) = T0(2);
elseif FreeFix(4) == 3
    Parameter_Mat.T0(find(Trial_Mat(:,5) == 1),1) = T0(1);
    Parameter_Mat.T0(find(Trial_Mat(:,5) == 2),1) = T0(2);
    Parameter_Mat.T0(find(Trial_Mat(:,5) == 3),1) = T0(3);
end


if FreeFix(5) == 1
    Parameter_Mat.s(1:size(Trial_Mat,1)) = s;
elseif FreeFix(5) == 2
    Parameter_Mat.s(find(Trial_Mat(:,5) == 1),1) = s(1);
    Parameter_Mat.s(find(Trial_Mat(:,5) == 3),1) = s(2);
elseif FreeFix(5) == 3
    Parameter_Mat.s(find(Trial_Mat(:,5) == 1),1) = s(1);
    Parameter_Mat.s(find(Trial_Mat(:,5) == 2),1) = s(2);
    Parameter_Mat.s(find(Trial_Mat(:,5) == 3),1) = s(3);
end



Trial_Mat(:,4) = Trial_Mat(:,4) - Parameter_Mat.T0;
%===== Other Units ====
% on error trials, find the unit that actually won.

fF(:,1) = linearballisticPDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,1),Parameter_Mat.s);
fF(:,2) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,2),Parameter_Mat.s);

Likelihood = fF(:,1) .* (1-fF(:,2));

%set lower bounds
Likelihood(find(Likelihood < 1e-5)) = 1e-5;

%Note: log(1) = 0, and probabilities are bounded at 1, so a higher
%likelihood will push you closer and closer to 0, which is a larger and
%larger log(likelihood), where larger = closer to or greater than 0.  I.e., a REALLY well fitting model would have
%a likelihood of p = .99, and log(.99) = -.01. However, because log values between 0 and 1 are
%negative, to find the greatest log(likelihood) you have to negate it.
LL = -sum(log(Likelihood));

[AIC BIC] = aicbic(-LL,n_free,n_obs); %be sure to negate LL because we were minimizing the negative to maximize the positive

slow.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1);
slow.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1);
med.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2);
med.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2);
fast.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3);
fast.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3);

%re-correct SRTs to take into account T0
CDF.slow = getDefectiveCDF(slow.correct,slow.err,Trial_Mat(:,4)+Parameter_Mat.T0);
CDF.fast = getDefectiveCDF(fast.correct,fast.err,Trial_Mat(:,4)+Parameter_Mat.T0);

if max(FreeFix) == 3
    CDF.med = getDefectiveCDF(med.correct,med.err,Trial_Mat(:,4)+Parameter_Mat.T0);
else
    CDF.med.correct = NaN;
    CDF.med.err = NaN;
end

%this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
%those that are fixed
if FreeFix(1) == 1; A = repmat(A,1,max(FreeFix)); end
if FreeFix(2) == 1; b = repmat(b,1,max(FreeFix)); end
if FreeFix(3) == 1; v = repmat(v,1,max(FreeFix)); end
if FreeFix(4) == 1; T0 = repmat(T0,1,max(FreeFix)); end
if FreeFix(5) == 1; s = repmat(s,1,max(FreeFix)); end

if plotFlag == 1
    
    if max(FreeFix) == 2 %gives the number of conditions entered into model
        winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
        loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
        t.slow = (1:1000) + T0(1);
        
        winner.fast = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(2))));
        loser.fast = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s(2))));
        t.fast = (1:1000) + T0(2);
        
    elseif max(FreeFix) == 3
        winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
        loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
        t.slow = (1:1000) + T0(1);
        
        winner.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(2))));
        loser.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s(2))));
        t.med = (1:1000) + T0(2);
        
        winner.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),s(3)) .* (1-linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(3))));
        loser.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),s(3)) .* (1-linearballisticCDF(1:1000,A(3),b(3),v(3),s(3))));
        t.fast = (1:1000) + T0(3);
    end
    
    
    subplot(1,3,1)
    plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')
    hold on
    plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or')
    ylim([0 1])
    xlim([0 1000])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
    title('SLOW/ACCURATE')
    box off
    
    
    if max(FreeFix) == 2
        
        subplot(1,3,3)
        plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
        ylim([0 1])
        xlim([0 1000])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
        title(['FAST   LL = ' mat2str(round(-LL*1000)/1000) ' BIC = ' mat2str(round(BIC*1000)/1000)])
        box off
        
    elseif max(FreeFix) == 3
        subplot(1,3,2)
        plot(t.med,winner.med,'k',t.med,loser.med,'r')
        hold on
        plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or')
        ylim([0 1])
        xlim([0 1000])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
        title(['MED'])
        box off
        
        
        subplot(1,3,3)
        plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
        ylim([0 1])
        xlim([0 1000])
        text(100,.95,['A = ' mat2str(round(A(3)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(3)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(3)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(3)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(3)*100)/100)])
        title(['FAST   LL = ' mat2str(round(-LL*1000)/1000) ' BIC = ' mat2str(round(BIC*1000)/1000)])
        box off
    end
        
        pause(.001)
        cla
        subplot(1,2,1)
        cla
        
    end