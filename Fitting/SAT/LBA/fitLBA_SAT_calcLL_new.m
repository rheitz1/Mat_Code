function [LL] = fitLBA_SAT_calcLL(param,Trial_Mat)

show_minimization = evalin('caller','show_minimization'); %do you want to view the minimization? (takes longer)

FreeFix = evalin('caller','FreeFix');
A = param(evalin('caller','1:length(A)'));
b = param(evalin('caller','length(A)+1:length(A)+length(b)'));
v = param(evalin('caller','length(A)+length(b)+1:length(A)+length(b)+length(v)'));
T0 = param(evalin('caller','length(A)+length(b)+length(v)+1:length(A)+length(b)+length(v)+length(T0)'));
s = param(evalin('caller','length(A)+length(b)+length(v)+length(T0)+1:length(param)'));
include_med = evalin('caller','include_med');

s_fixed_value = evalin('caller','s_fixed_value'); %what is the fixed value 1st s should be

n_free = numel(param);
n_obs = size(Trial_Mat,1);


Parameter_Mat.A(1:size(Trial_Mat,1),1) = NaN;
Parameter_Mat.b(1:size(Trial_Mat,1),1) = NaN;
Parameter_Mat.v(1:size(Trial_Mat,1),1:2) = NaN;
Parameter_Mat.T0(1:size(Trial_Mat,1),1) = NaN;
Parameter_Mat.s(1:size(Trial_Mat,1),1) = NaN;


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
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1),2) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0),1) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0),2) = v(1);
elseif FreeFix(3) == 2
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),1) = v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),2) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),1) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),2) = v(1);
    
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),1) = v(3);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),2) = v(4);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),1) = v(4);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),2) = v(3);
elseif FreeFix(3) == 3
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),1) = v(1);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),2) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),1) = v(2);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),2) = v(1);
    
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),1) = v(3);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),2) = v(4);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),1) = v(4);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),2) = v(3);
    
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),1) = v(5);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),2) = v(6);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),1) = v(6);
    Parameter_Mat.v(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),2) = v(5);
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
    Parameter_Mat.s(1:size(Trial_Mat,1)) = s_fixed_value;
elseif FreeFix(5) == 2
    Parameter_Mat.s(find(Trial_Mat(:,5) == 1),1) = s_fixed_value;
    Parameter_Mat.s(find(Trial_Mat(:,5) == 3),1) = s(1);
elseif FreeFix(5) == 3
    Parameter_Mat.s(find(Trial_Mat(:,5) == 1),1) = s_fixed_value;
    Parameter_Mat.s(find(Trial_Mat(:,5) == 2),1) = s(1);
    Parameter_Mat.s(find(Trial_Mat(:,5) == 3),1) = s(2);
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

%re-correct SRTs to take into account T0 (we subtracted it before sending RTs into LBA)
CDF.slow = getDefectiveCDF(slow.correct,slow.err,Trial_Mat(:,4)+Parameter_Mat.T0);
CDF.fast = getDefectiveCDF(fast.correct,fast.err,Trial_Mat(:,4)+Parameter_Mat.T0);

if include_med
    CDF.med = getDefectiveCDF(med.correct,med.err,Trial_Mat(:,4)+Parameter_Mat.T0);
elseif ~include_med
    CDF.med.correct = NaN;
    CDF.med.err = NaN;
end

%this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
%those that are fixed
if all(FreeFix == 1) %for ALL FIXED condition
    if ~include_med
        A = repmat(A,1,2);
        b = repmat(b,1,2);
        v = repmat(v,1,2);
        T0 = repmat(T0,1,2);
        s = repmat(s_fixed_value,1,1); %note: s indexing appears off because 1st value is fixed
    elseif include_med
        A = repmat(A,1,3);
        b = repmat(b,1,3);
        v = repmat(v,1,3);
        T0 = repmat(T0,1,3);
        s = repmat(s_fixed_value,1,2);
    end
elseif ~all(FreeFix == 1)
    if FreeFix(1) == 1; A = repmat(A,1,max(FreeFix)); end
    if FreeFix(2) == 1; b = repmat(b,1,max(FreeFix)); end
    if FreeFix(3) == 1; v = repmat(v,1,max(FreeFix)); end
    if FreeFix(4) == 1; T0 = repmat(T0,1,max(FreeFix)); end
    if FreeFix(5) == 1; s = repmat(s_fixed_value,1,max(FreeFix)); end
end

if show_minimization
    
    if max(FreeFix) == 2 %gives the number of conditions entered into model
        winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
        loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
        t.slow = (1:2000) + T0(1);
        
        winner.fast = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(3),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(4),s(1)))); %note: s indexing appears off because 1st value is actually fixed
        loser.fast = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(4),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(3),s(1))));
        t.fast = (1:2000) + T0(2);
        
    elseif max(FreeFix) == 3
        winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
        loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
        t.slow = (1:2000) + T0(1);
        
        winner.med = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(3),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(4),s(1))));
        loser.med = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(4),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(3),s(1))));
        t.med = (1:2000) + T0(2);
        
        winner.fast = cumsum(linearballisticPDF(1:2000,A(3),b(3),v(5),s(2)) .* (1-linearballisticCDF(1:2000,A(3),b(3),v(6),s(2))));
        loser.fast = cumsum(linearballisticPDF(1:2000,A(3),b(3),v(6),s(2)) .* (1-linearballisticCDF(1:2000,A(3),b(3),v(5),s(2))));
        t.fast = (1:2000) + T0(3);
    else %all Fixed
        if ~include_med
            winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
            loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
            t.slow = (1:2000) + T0(1);
            
            winner.fast = winner.slow;
            loser.fast = loser.slow;
            t.fast = t.slow;
        elseif include_med
            winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
            loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
            t.slow = (1:2000) + T0(1);
            
            winner.med = winner.slow;
            loser.med = loser.slow;
            t.med = t.slow;
            
            winner.fast = winner.slow;
            loser.fast = loser.slow;
            t.fast = t.slow;
        else
            error('Something Wrong')
        end
    end
    
    
    
    
    subplot(1,3,1)
    plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')
    hold on
    plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or')
    ylim([0 1])
    xlim([0 1600])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.85,['vC = ' mat2str(round(v(1)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.80,['vE = ' mat2str(round(v(2)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.75,['s = ' mat2str(round(s_fixed_value*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.70,['T0 = ' mat2str(round(T0(1)*100)/100)],'fontweight','bold','fontsize',16)
    title('ACCURATE','fontsize',16,'fontweight','bold')
    box off
    set(gca,'xminortick','on')
    
    %if max(FreeFix) == 2
    if ~include_med
        subplot(1,3,3)
        plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.85,['vC = ' mat2str(round(v(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.80,['vE = ' mat2str(round(v(4)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.75,['s = ' mat2str(round(s(1)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.70,['T0 = ' mat2str(round(T0(2)*100)/100)],'fontweight','bold','fontsize',16)
        title(['FAST   LL = ' mat2str(round(-LL*1000)/1000) ' BIC = ' mat2str(round(BIC*1000)/1000)],'fontsize',16,'fontweight','bold')
        box off
        set(gca,'xminortick','on')
        
        %elseif max(FreeFix) == 3
    elseif include_med
        subplot(1,3,2)
        plot(t.med,winner.med,'k',t.med,loser.med,'r')
        hold on
        plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or')
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.85,['vC = ' mat2str(round(v(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.80,['vE = ' mat2str(round(v(4)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.75,['s = ' mat2str(round(s(1)*100)/100)],'fontweight','bold','fontsize',16) %note: s indexing appears off because 1st value is actually fixed
        text(100,.70,['T0 = ' mat2str(round(T0(2)*100)/100)],'fontweight','bold','fontsize',16)
        title('NEUTRAL','fontsize',16,'fontweight','bold')
        box off
        set(gca,'xminortick','on')
        
        subplot(1,3,3)
        plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.90,['b = ' mat2str(round(b(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.85,['vC = ' mat2str(round(v(5)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.80,['vE = ' mat2str(round(v(6)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.75,['s = ' mat2str(round(s(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.70,['T0 = ' mat2str(round(T0(3)*100)/100)],'fontweight','bold','fontsize',16)
        title(['FAST   LL = ' mat2str(round(-LL*1000)/1000) ' BIC = ' mat2str(round(BIC*1000)/1000)],'fontsize',16,'fontweight','bold')
        box off
        set(gca,'xminortick','on')
        
    end
    
    pause(.001)
    cla
    subplot(3,1,1)
    cla
    
end