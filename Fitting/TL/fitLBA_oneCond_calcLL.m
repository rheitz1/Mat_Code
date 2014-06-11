function [LL] = fitLBA_oneCond_calcLL(param,Trial_Mat)

plotFlag = 1;

%if not minimizing, don't make a plot no matter what (code is executed one
%time to get LL value
minimize = evalin('caller','minimize');
s_is_free = evalin('caller','s_is_free');

if minimize == 0; plotFlag = 0; end


if ~s_is_free
    [A b v T0 s] = disperse(param);
else
    [A b v T0] = disperse(param);
    s = evalin('caller','s');
end

FreeFix = evalin('caller','FreeFix');
% A = param(evalin('caller','1:length(A)'));
% b = param(evalin('caller','length(A)+1:length(A)+length(b)'));
% v = param(evalin('caller','length(A)+length(b)+1:length(A)+length(b)+length(v)'));
% T0 = param(evalin('caller','length(A)+length(b)+length(v)+1:length(param)'));
% s = param(evalin('caller',(.1,1,max(FreeFix));
% include_med = evalin('caller','include_med');

n_free = numel(param);
n_obs = size(Trial_Mat,1);


Parameter_Mat.A(1:size(Trial_Mat,1),1) = NaN;
Parameter_Mat.b(1:size(Trial_Mat,1),1) = NaN;
Parameter_Mat.v(1:size(Trial_Mat,1),1:2) = NaN;
Parameter_Mat.T0(1:size(Trial_Mat,1),1) = NaN;
Parameter_Mat.s(1:size(Trial_Mat,1),1) = NaN;



%Parameterized based on what is free/fixed

Parameter_Mat.A(1:size(Trial_Mat,1)) = A;
Parameter_Mat.b(1:size(Trial_Mat,1)) = b;
Parameter_Mat.v(find(Trial_Mat(:,3) == 1),1) = v(1);
Parameter_Mat.v(find(Trial_Mat(:,3) == 1),2) = 1-v(1);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0),1) = 1-v(1);
Parameter_Mat.v(find(Trial_Mat(:,3) == 0),2) = v(1);
Parameter_Mat.T0(1:size(Trial_Mat,1)) = T0;
Parameter_Mat.s(1:size(Trial_Mat,1)) = s(1);


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

trls.err = find(Trial_Mat(:,3) == 0);
trls.correct = find(Trial_Mat(:,3) == 1);

%re-correct SRTs to take into account T0 (we subtracted it before sending RTs into LBA)
CDFs = getDefectiveCDF(trls.correct,trls.err,Trial_Mat(:,4)+Parameter_Mat.T0);



%this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
%those that are fixed
% if all(FreeFix == 1) %for ALL FIXED condition
%     if ~include_med
%         A = repmat(A,1,2);
%         b = repmat(b,1,2);
%         v = repmat(v,1,2);
%         T0 = repmat(T0,1,2);
%         s = repmat(s,1,2);
%     elseif include_med
%         A = repmat(A,1,3);
%         b = repmat(b,1,3);
%         v = repmat(v,1,3);
%         T0 = repmat(T0,1,3);
%         s = repmat(s,1,3);
%     end
% elseif ~all(FreeFix == 1)
%     if FreeFix(1) == 1; A = repmat(A,1,max(FreeFix)); end
%     if FreeFix(2) == 1; b = repmat(b,1,max(FreeFix)); end
%     if FreeFix(3) == 1; v = repmat(v,1,max(FreeFix)); end
%     if FreeFix(4) == 1; T0 = repmat(T0,1,max(FreeFix)); end
% end

if plotFlag == 1
    
 %gives the number of conditions entered into model
        winner = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
        loser = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
        t = (1:1000) + T0(1);
%         
%     elseif max(FreeFix) == 3
%         winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
%         loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
%         t.slow = (1:1000) + T0(1);
%         
%         winner.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(2))));
%         loser.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s(2))));
%         t.med = (1:1000) + T0(2);
%         
%         winner.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),s(3)) .* (1-linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(3))));
%         loser.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),s(3)) .* (1-linearballisticCDF(1:1000,A(3),b(3),v(3),s(3))));
%         t.fast = (1:1000) + T0(3);
%     else %all Fixed
%         if ~include_med
%             winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
%             loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
%             t.slow = (1:1000) + T0(1);
%             
%             winner.fast = winner.slow;
%             loser.fast = loser.slow;
%             t.fast = t.slow;
%         elseif include_med
%             winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
%             loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
%             t.slow = (1:1000) + T0(1);
%             
%             winner.med = winner.slow;
%             loser.med = loser.slow;
%             t.med = t.slow;
%             
%             winner.fast = winner.slow;
%             loser.fast = loser.slow;
%             t.fast = t.slow;
%         else
%             error('Something Wrong')
%         end
%     end
%     
%     
    
    
    plot(t,winner,'k',t,loser,'r')
    hold on
    plot(CDFs.correct(:,1),CDFs.correct(:,2),'ok',CDFs.err(:,1),CDFs.err(:,2),'or')
    ylim([0 1])
    xlim([0 1000])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
    title('SLOW/ACCURATE')
    box off
    
%     
%     %if max(FreeFix) == 2
%     if ~include_med
%         subplot(1,3,3)
%         plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
%         hold on
%         plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
%         ylim([0 1])
%         xlim([0 1000])
%         text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
%         text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
%         text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
%         text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
%         text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
%         title(['FAST   LL = ' mat2str(round(-LL*1000)/1000) ' BIC = ' mat2str(round(BIC*1000)/1000)])
%         box off
%         
%         %elseif max(FreeFix) == 3
%     elseif include_med
%         subplot(1,3,2)
%         plot(t.med,winner.med,'k',t.med,loser.med,'r')
%         hold on
%         plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or')
%         ylim([0 1])
%         xlim([0 1000])
%         text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
%         text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
%         text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
%         text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
%         text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
%         title(['MED'])
%         box off
%         
%         
%         subplot(1,3,3)
%         plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
%         hold on
%         plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
%         ylim([0 1])
%         xlim([0 1000])
%         text(100,.95,['A = ' mat2str(round(A(3)*100)/100)])
%         text(100,.90,['b = ' mat2str(round(b(3)*100)/100)])
%         text(100,.85,['v = ' mat2str(round(v(3)*100)/100)])
%         text(100,.80,['s = ' mat2str(round(s(3)*100)/100)])
%         text(100,.75,['T0 = ' mat2str(round(T0(3)*100)/100)])
%         title(['FAST   LL = ' mat2str(round(-LL*1000)/1000) ' BIC = ' mat2str(round(BIC*1000)/1000)])
%         box off
%     end
%     
    pause(.001)
    cla
    
end