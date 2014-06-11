function [LL] = fitLBA_TL_multiLBA_calcLL(param,Trial_Mat)

plotFlag = 1;

A = param(1:8);
b = param(9:16);
v = param(17:24);
T0 = param(25:32);

s(1:8) = .1;

Parameter_Mat.A(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.b(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.v(size(Trial_Mat,1),1:8) = NaN;
Parameter_Mat.s(size(Trial_Mat,1),1) = NaN;
Parameter_Mat.T0(size(Trial_Mat,1),1) = NaN;


Parameter_Mat.A(find(Trial_Mat(:,1) == 0),1) = A(1);
Parameter_Mat.A(find(Trial_Mat(:,1) == 1),1) = A(2);
Parameter_Mat.A(find(Trial_Mat(:,1) == 2),1) = A(3);
Parameter_Mat.A(find(Trial_Mat(:,1) == 3),1) = A(4);
Parameter_Mat.A(find(Trial_Mat(:,1) == 4),1) = A(5);
Parameter_Mat.A(find(Trial_Mat(:,1) == 5),1) = A(6);
Parameter_Mat.A(find(Trial_Mat(:,1) == 6),1) = A(7);
Parameter_Mat.A(find(Trial_Mat(:,1) == 7),1) = A(8);

Parameter_Mat.b(find(Trial_Mat(:,1) == 0),1) = b(1);
Parameter_Mat.b(find(Trial_Mat(:,1) == 1),1) = b(2);
Parameter_Mat.b(find(Trial_Mat(:,1) == 2),1) = b(3);
Parameter_Mat.b(find(Trial_Mat(:,1) == 3),1) = b(4);
Parameter_Mat.b(find(Trial_Mat(:,1) == 4),1) = b(5);
Parameter_Mat.b(find(Trial_Mat(:,1) == 5),1) = b(6);
Parameter_Mat.b(find(Trial_Mat(:,1) == 6),1) = b(7);
Parameter_Mat.b(find(Trial_Mat(:,1) == 7),1) = b(8);

%===== Current Unit ====
%set appropriate drift rates for correct trials based on winning accumulators
Parameter_Mat.v(find(Trial_Mat(:,3) == 1),1) = v(Trial_Mat(find(Trial_Mat(:,3) == 1),1)+1);

%For error trials, set to 1-v except for the actual winning unit
Parameter_Mat.v(find(Trial_Mat(:,3) == 0),1) = 1-v(Trial_Mat(find(Trial_Mat(:,3) == 0),1)+1);

%===== Other Units ====
% on error trials, find the unit that actually won.
for trl=1:size(Parameter_Mat.v,1)
    Parameter_Mat.v(trl,2:8) = setdiff([0:7],Trial_Mat(trl,1));
    if Trial_Mat(trl,3) == 0
        Parameter_Mat.v(trl,find(Parameter_Mat.v(trl,2:8) == Trial_Mat(trl,2))+1) = v(Trial_Mat(trl,2)+1);
    end
end

%set appropriate drift rates for all other losing units
Parameter_Mat.v(find(Parameter_Mat.v == 0)) = 1-v(1);
Parameter_Mat.v(find(Parameter_Mat.v == 1)) = 1-v(2);
Parameter_Mat.v(find(Parameter_Mat.v == 2)) = 1-v(3);
Parameter_Mat.v(find(Parameter_Mat.v == 3)) = 1-v(4);
Parameter_Mat.v(find(Parameter_Mat.v == 4)) = 1-v(5);
Parameter_Mat.v(find(Parameter_Mat.v == 5)) = 1-v(6);
Parameter_Mat.v(find(Parameter_Mat.v == 6)) = 1-v(7);
Parameter_Mat.v(find(Parameter_Mat.v == 7)) = 1-v(8);


Parameter_Mat.s(find(Trial_Mat(:,1) == 0),1) = s(1);
Parameter_Mat.s(find(Trial_Mat(:,1) == 1),1) = s(2);
Parameter_Mat.s(find(Trial_Mat(:,1) == 2),1) = s(3);
Parameter_Mat.s(find(Trial_Mat(:,1) == 3),1) = s(4);
Parameter_Mat.s(find(Trial_Mat(:,1) == 4),1) = s(5);
Parameter_Mat.s(find(Trial_Mat(:,1) == 5),1) = s(6);
Parameter_Mat.s(find(Trial_Mat(:,1) == 6),1) = s(7);
Parameter_Mat.s(find(Trial_Mat(:,1) == 7),1) = s(8);

Parameter_Mat.T0(find(Trial_Mat(:,1) == 0),1) = T0(1);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 1),1) = T0(2);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 2),1) = T0(3);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 3),1) = T0(4);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 4),1) = T0(5);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 5),1) = T0(6);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 6),1) = T0(7);
Parameter_Mat.T0(find(Trial_Mat(:,1) == 7),1) = T0(8);

%Fix RTs by T0
Trial_Mat(:,4) = Trial_Mat(:,4) - Parameter_Mat.T0;

fF(:,1) = linearballisticPDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,1),Parameter_Mat.s);
fF(:,2) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,2),Parameter_Mat.s);
fF(:,3) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,3),Parameter_Mat.s);
fF(:,4) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,4),Parameter_Mat.s);
fF(:,5) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,5),Parameter_Mat.s);
fF(:,6) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,6),Parameter_Mat.s);
fF(:,7) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,7),Parameter_Mat.s);
fF(:,8) = linearballisticCDF(Trial_Mat(:,4),Parameter_Mat.A,Parameter_Mat.b,Parameter_Mat.v(:,8),Parameter_Mat.s);

Likelihood = fF(:,1) .* prod(1-fF(:,2:8),2);

%set lower bounds
Likelihood(find(Likelihood < 1e-5)) = 1e-5;

LL = -sum(log(Likelihood));


if plotFlag == 1
    %To create predictions for the CDFs of the losers, we need to know which unit actually won.  That is, assuming
    %unit 0 lost, it is not the case that units 1-7 won -- only 1 unit actually won.  This is
    %difficult in principle because of the number of combinations that would produce (i.e., what if
    %unit 0 lost and unit 1 won...unit 2 won...unit 3 won...  Instead, what we will do is use the
    %PDF of the fitted drift rate for each winner, then find the conditional probability that the other
    %units won when it lost.  We will then assume that when unit 0 lost, unit x probably lost too (given
    %there are other potential winners).  So we will say that when unit 0 lost, unit x also lost (in
    %terms of drift rate) but then add back unit x's winner drift rate weighted by the proportion of
    %trials in which unit x actually did win WHEN UNIT 0 LOST.  i.e., p(pos1_win | pos0_lost)
    
    
    base = 1; %use to make easier to directly see which unit we are working with
    weights.lose = NaN(8,8);
    
    %perhaps want to simply weight by 1/7 instead of actual proportions --
    %lots of room for small observation numbers to affect results.
    
    weights.lose(0+base,0+base) = NaN; %implicit
    weights.lose(0+base,1+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    weights.lose(0+base,2+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    weights.lose(0+base,3+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    weights.lose(0+base,4+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    weights.lose(0+base,5+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    weights.lose(0+base,6+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    weights.lose(0+base,7+base) = length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,3) == 0));
    
    weights.lose(1+base,0+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    weights.lose(1+base,1+base) = NaN; %implicit
    weights.lose(1+base,2+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    weights.lose(1+base,3+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    weights.lose(1+base,4+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    weights.lose(1+base,5+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    weights.lose(1+base,6+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    weights.lose(1+base,7+base) = length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 0));
    
    weights.lose(2+base,0+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    weights.lose(2+base,1+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    weights.lose(2+base,2+base) = NaN; %implicit
    weights.lose(2+base,3+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    weights.lose(2+base,4+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    weights.lose(2+base,5+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    weights.lose(2+base,6+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    weights.lose(2+base,7+base) = length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 0));
    
    weights.lose(3+base,0+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    weights.lose(3+base,1+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    weights.lose(3+base,2+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    weights.lose(3+base,3+base) = NaN; %implicit
    weights.lose(3+base,4+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    weights.lose(3+base,5+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    weights.lose(3+base,6+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    weights.lose(3+base,7+base) = length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,3) == 0));
    
    weights.lose(4+base,0+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    weights.lose(4+base,1+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    weights.lose(4+base,2+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    weights.lose(4+base,3+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    weights.lose(4+base,4+base) = NaN; %implicit
    weights.lose(4+base,5+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    weights.lose(4+base,6+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    weights.lose(4+base,7+base) = length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,3) == 0));
    
    weights.lose(5+base,0+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    weights.lose(5+base,1+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    weights.lose(5+base,2+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    weights.lose(5+base,3+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    weights.lose(5+base,4+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    weights.lose(5+base,5+base) = NaN; %implicit
    weights.lose(5+base,6+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    weights.lose(5+base,7+base) = length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,3) == 0));
    
    weights.lose(6+base,0+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    weights.lose(6+base,1+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    weights.lose(6+base,2+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    weights.lose(6+base,3+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    weights.lose(6+base,4+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    weights.lose(6+base,5+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    weights.lose(6+base,6+base) = NaN; %implicit
    weights.lose(6+base,7+base) = length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 7)) / length(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,3) == 0));
    
    weights.lose(7+base,0+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 0)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,1+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 1)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,2+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 2)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,3+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 3)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,4+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 4)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,5+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 5)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,6+base) = length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 6)) / length(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,3) == 0));
    weights.lose(7+base,7+base) = NaN; %implicit
    
    w1 = 1- repmat(v,8,1);
    %w2 = weights.lose .* repmat(v,8,1);
    w2 = repmat((1/7),8,8);
    weighted_drift = w1 + w2;
    
    
    %=================
    win0(:,1) = linearballisticPDF(1:1000,A(1),b(1),v(1),s(1));
    win0(:,2) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win0(:,3) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win0(:,4) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win0(:,5) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win0(:,6) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win0(:,7) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    win0(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win1(:,1) = linearballisticPDF(1:1000,A(2),b(2),v(2),s(1));
    win1(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win1(:,3) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win1(:,4) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win1(:,5) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win1(:,6) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win1(:,7) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    win1(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win2(:,1) = linearballisticPDF(1:1000,A(3),b(3),v(3),s(1));
    win2(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win2(:,3) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win2(:,4) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win2(:,5) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win2(:,6) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win2(:,7) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    win2(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win3(:,1) = linearballisticPDF(1:1000,A(4),b(4),v(4),s(1));
    win3(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win3(:,3) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win3(:,4) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win3(:,5) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win3(:,6) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win3(:,7) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    win3(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win4(:,1) = linearballisticPDF(1:1000,A(5),b(5),v(5),s(1));
    win4(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win4(:,3) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win4(:,4) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win4(:,5) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win4(:,6) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win4(:,7) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    win4(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win5(:,1) = linearballisticPDF(1:1000,A(6),b(6),v(6),s(1));
    win5(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win5(:,3) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win5(:,4) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win5(:,5) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win5(:,6) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win5(:,7) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    win5(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win6(:,1) = linearballisticPDF(1:1000,A(7),b(7),v(7),s(1));
    win6(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win6(:,3) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win6(:,4) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win6(:,5) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win6(:,6) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win6(:,7) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win6(:,8) = linearballisticCDF(1:1000,A(8),b(8),1-v(8),s(1));
    
    win7(:,1) = linearballisticPDF(1:1000,A(8),b(8),v(8),s(1));
    win7(:,2) = linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1));
    win7(:,3) = linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(1));
    win7(:,4) = linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(1));
    win7(:,5) = linearballisticCDF(1:1000,A(4),b(4),1-v(4),s(1));
    win7(:,6) = linearballisticCDF(1:1000,A(5),b(5),1-v(5),s(1));
    win7(:,7) = linearballisticCDF(1:1000,A(6),b(6),1-v(6),s(1));
    win7(:,8) = linearballisticCDF(1:1000,A(7),b(7),1-v(7),s(1));
    
    
    lose0(:,1) = linearballisticPDF(1:1000,A(0+base),b(0+base),1-v(0+base),s(1));
    lose0(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(0+base,1+base),s(1));
    lose0(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(0+base,2+base),s(1));
    lose0(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(0+base,3+base),s(1));
    lose0(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(0+base,4+base),s(1));
    lose0(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(0+base,5+base),s(1));
    lose0(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(0+base,6+base),s(1));
    lose0(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(0+base,7+base),s(1));
    
    lose1(:,1) = linearballisticPDF(1:1000,A(1+base),b(1+base),1-v(1+base),s(1));
    lose1(:,2) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(1+base,0+base),s(1));
    lose1(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(1+base,2+base),s(1));
    lose1(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(1+base,3+base),s(1));
    lose1(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(1+base,4+base),s(1));
    lose1(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(1+base,5+base),s(1));
    lose1(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(1+base,6+base),s(1));
    lose1(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(1+base,7+base),s(1));
    
    lose2(:,1) = linearballisticPDF(1:1000,A(2+base),b(2+base),1-v(2+base),s(1));
    lose2(:,3) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(2+base,0+base),s(1));
    lose2(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(2+base,1+base),s(1));
    lose2(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(2+base,3+base),s(1));
    lose2(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(2+base,4+base),s(1));
    lose2(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(2+base,5+base),s(1));
    lose2(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(2+base,6+base),s(1));
    lose2(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(2+base,7+base),s(1));
    
    lose3(:,1) = linearballisticPDF(1:1000,A(3+base),b(3+base),1-v(3+base),s(1));
    lose3(:,4) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(3+base,0+base),s(1));
    lose3(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(3+base,1+base),s(1));
    lose3(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(3+base,2+base),s(1));
    lose3(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(3+base,4+base),s(1));
    lose3(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(3+base,5+base),s(1));
    lose3(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(3+base,6+base),s(1));
    lose3(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(3+base,7+base),s(1));
    
    lose4(:,1) = linearballisticPDF(1:1000,A(4+base),b(4+base),1-v(4+base),s(1));
    lose4(:,5) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(4+base,0+base),s(1));
    lose4(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(4+base,1+base),s(1));
    lose4(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(4+base,2+base),s(1));
    lose4(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(4+base,3+base),s(1));
    lose4(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(4+base,5+base),s(1));
    lose4(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(4+base,6+base),s(1));
    lose4(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(4+base,7+base),s(1));
    
    lose5(:,1) = linearballisticPDF(1:1000,A(5+base),b(5+base),1-v(5+base),s(1));
    lose5(:,6) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(5+base,0+base),s(1));
    lose5(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(5+base,1+base),s(1));
    lose5(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(5+base,2+base),s(1));
    lose5(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(5+base,3+base),s(1));
    lose5(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(5+base,4+base),s(1));
    lose5(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(5+base,6+base),s(1));
    lose5(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(5+base,7+base),s(1));
    
    lose6(:,1) = linearballisticPDF(1:1000,A(6+base),b(6+base),1-v(6+base),s(1));
    lose6(:,7) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(6+base,0+base),s(1));
    lose6(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(6+base,1+base),s(1));
    lose6(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(6+base,2+base),s(1));
    lose6(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(6+base,3+base),s(1));
    lose6(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(6+base,4+base),s(1));
    lose6(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(6+base,5+base),s(1));
    lose6(:,8) = linearballisticCDF(1:1000,A(7+base),b(7+base),weighted_drift(6+base,7+base),s(1));
    
    lose7(:,1) = linearballisticPDF(1:1000,A(7+base),b(7+base),1-v(7+base),s(1));
    lose7(:,8) = linearballisticCDF(1:1000,A(0+base),b(0+base),weighted_drift(7+base,0+base),s(1));
    lose7(:,2) = linearballisticCDF(1:1000,A(1+base),b(1+base),weighted_drift(7+base,1+base),s(1));
    lose7(:,3) = linearballisticCDF(1:1000,A(2+base),b(2+base),weighted_drift(7+base,2+base),s(1));
    lose7(:,4) = linearballisticCDF(1:1000,A(3+base),b(3+base),weighted_drift(7+base,3+base),s(1));
    lose7(:,5) = linearballisticCDF(1:1000,A(4+base),b(4+base),weighted_drift(7+base,4+base),s(1));
    lose7(:,6) = linearballisticCDF(1:1000,A(5+base),b(5+base),weighted_drift(7+base,5+base),s(1));
    lose7(:,7) = linearballisticCDF(1:1000,A(6+base),b(6+base),weighted_drift(7+base,6+base),s(1));
    
    
    
    
    winner0 = cumsum(win0(:,1) .* prod((1-win0(:,2:8)),2));
    winner1 = cumsum(win1(:,1) .* prod((1-win1(:,2:8)),2));
    winner2 = cumsum(win2(:,1) .* prod((1-win2(:,2:8)),2));
    winner3 = cumsum(win3(:,1) .* prod((1-win3(:,2:8)),2));
    winner4 = cumsum(win4(:,1) .* prod((1-win4(:,2:8)),2));
    winner5 = cumsum(win5(:,1) .* prod((1-win5(:,2:8)),2));
    winner6 = cumsum(win6(:,1) .* prod((1-win6(:,2:8)),2));
    winner7 = cumsum(win7(:,1) .* prod((1-win7(:,2:8)),2));
    
    
    loser0 = cumsum(lose0(:,1) .* prod((1-lose0(:,2:8)),2));
    loser1 = cumsum(lose1(:,1) .* prod((1-lose1(:,2:8)),2));
    loser2 = cumsum(lose2(:,1) .* prod((1-lose2(:,2:8)),2));
    loser3 = cumsum(lose3(:,1) .* prod((1-lose3(:,2:8)),2));
    loser4 = cumsum(lose4(:,1) .* prod((1-lose4(:,2:8)),2));
    loser5 = cumsum(lose5(:,1) .* prod((1-lose5(:,2:8)),2));
    loser6 = cumsum(lose6(:,1) .* prod((1-lose6(:,2:8)),2));
    loser7 = cumsum(lose7(:,1) .* prod((1-lose7(:,2:8)),2));
    
    
    
    CDF.pos0 = getDefectiveCDF(find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) == 0),find(Trial_Mat(:,1) == 0 & Trial_Mat(:,2) ~= 0),Trial_Mat(:,4) + T0(1));
    CDF.pos1 = getDefectiveCDF(find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) == 1),find(Trial_Mat(:,1) == 1 & Trial_Mat(:,2) ~= 1),Trial_Mat(:,4) + T0(2));
    CDF.pos2 = getDefectiveCDF(find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) == 2),find(Trial_Mat(:,1) == 2 & Trial_Mat(:,2) ~= 2),Trial_Mat(:,4) + T0(3));
    CDF.pos3 = getDefectiveCDF(find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) == 3),find(Trial_Mat(:,1) == 3 & Trial_Mat(:,2) ~= 3),Trial_Mat(:,4) + T0(4));
    CDF.pos4 = getDefectiveCDF(find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) == 4),find(Trial_Mat(:,1) == 4 & Trial_Mat(:,2) ~= 4),Trial_Mat(:,4) + T0(5));
    CDF.pos5 = getDefectiveCDF(find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) == 5),find(Trial_Mat(:,1) == 5 & Trial_Mat(:,2) ~= 5),Trial_Mat(:,4) + T0(6));
    CDF.pos6 = getDefectiveCDF(find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) == 6),find(Trial_Mat(:,1) == 6 & Trial_Mat(:,2) ~= 6),Trial_Mat(:,4) + T0(7));
    CDF.pos7 = getDefectiveCDF(find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) == 7),find(Trial_Mat(:,1) == 7 & Trial_Mat(:,2) ~= 7),Trial_Mat(:,4) + T0(8));
    
    t.pos0 = (1:1000) + T0(1);
    t.pos1 = (1:1000) + T0(2);
    t.pos2 = (1:1000) + T0(3);
    t.pos3 = (1:1000) + T0(4);
    t.pos4 = (1:1000) + T0(5);
    t.pos5 = (1:1000) + T0(6);
    t.pos6 = (1:1000) + T0(7);
    t.pos7 = (1:1000) + T0(8);
    
    subplot(3,3,6)
    plot(t.pos0,winner0,'k',t.pos0,loser0,'r')
    hold on
    plot(CDF.pos0.correct(:,1),CDF.pos0.correct(:,2),'ok',CDF.pos0.err(:,1),CDF.pos0.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,3)
    plot(t.pos1,winner1,'k',t.pos1,loser1,'r')
    hold on
    plot(CDF.pos1.correct(:,1),CDF.pos1.correct(:,2),'ok',CDF.pos1.err(:,1),CDF.pos1.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,2)
    plot(t.pos2,winner2,'k',t.pos2,loser2,'r')
    hold on
    plot(CDF.pos2.correct(:,1),CDF.pos2.correct(:,2),'ok',CDF.pos2.err(:,1),CDF.pos2.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,1)
    plot(t.pos3,winner3,'k',t.pos3,loser3,'r')
    hold on
    plot(CDF.pos3.correct(:,1),CDF.pos3.correct(:,2),'ok',CDF.pos3.err(:,1),CDF.pos3.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,4)
    plot(t.pos4,winner4,'k',t.pos4,loser4,'r')
    hold on
    plot(CDF.pos4.correct(:,1),CDF.pos4.correct(:,2),'ok',CDF.pos4.err(:,1),CDF.pos4.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,7)
    plot(t.pos5,winner5,'k',t.pos5,loser5,'r')
    hold on
    plot(CDF.pos5.correct(:,1),CDF.pos5.correct(:,2),'ok',CDF.pos5.err(:,1),CDF.pos5.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,8)
    plot(t.pos6,winner6,'k',t.pos6,loser6,'r')
    hold on
    plot(CDF.pos6.correct(:,1),CDF.pos6.correct(:,2),'ok',CDF.pos6.err(:,1),CDF.pos6.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    subplot(3,3,9)
    plot(t.pos7,winner7,'k',t.pos7,loser7,'r')
    hold on
    plot(CDF.pos7.correct(:,1),CDF.pos7.correct(:,2),'ok',CDF.pos7.err(:,1),CDF.pos7.err(:,2),'or')
    xlim([0 1000])
    ylim([0 1])
    
    pause(.001)
    cla
    
    subplot(3,3,1)
    cla
    subplot(3,3,2)
    cla
    subplot(3,3,3)
    cla
    subplot(3,3,4)
    cla
    subplot(3,3,6)
    cla
    subplot(3,3,7)
    cla
    subplot(3,3,8)
    cla
    
end