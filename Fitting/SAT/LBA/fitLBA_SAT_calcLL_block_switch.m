function [LL] = fitLBA_SAT_calcLL_block_switch(param,Trial_Mat)

plotFlag = 0;

FreeFix = evalin('caller','FreeFix');
A = param(evalin('caller','1:length(A)'));
b = param(evalin('caller','length(A)+1:length(A)+length(b)'));
v = param(evalin('caller','length(A)+length(b)+1:length(A)+length(b)+length(v)'));
T0 = param(evalin('caller','length(A)+length(b)+length(v)+1:length(param)'));
s = repmat(.1,1,max(FreeFix));

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

%[AIC BIC] = aicbic(-LL,n_free,n_obs); %be sure to negate LL because we were minimizing the negative to maximize the positive

err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1);
correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1);


%re-correct SRTs to take into account T0
CDF = getDefectiveCDF(correct,err,Trial_Mat(:,4)+Parameter_Mat.T0);

%this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
%those that are fixed
if FreeFix(1) == 1; A = repmat(A,1,max(FreeFix)); end
if FreeFix(2) == 1; b = repmat(b,1,max(FreeFix)); end
if FreeFix(3) == 1; v = repmat(v,1,max(FreeFix)); end
if FreeFix(4) == 1; T0 = repmat(T0,1,max(FreeFix)); end

if plotFlag == 1
    
    
    winner = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
    loser = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
    t = (1:1000) + T0(1);
    
    
    plot(t,winner,'k',t,loser,'r')
    hold on
    plot(CDF.correct(:,1),CDF.correct(:,2),'ok',CDF.err(:,1),CDF.err(:,2),'or')
    ylim([0 1])
    xlim([0 1000])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
    box off
    
    pause(.001)
    cla
end