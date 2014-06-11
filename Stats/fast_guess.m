%From Ollman, 1966

%Q = probability S makes a test (single dichotomization in a 2AFC situation)
%(1-Q) = probability S guesses (failure to test)

%if Q, then a_ij = p(respond j | stimulus i)
%   H_ij = mean RT of response j to stimulus i

%if ~Q, then subjects selects response j with probability b_j  [  p(respond j | stimulus i) = b_j  ]
%   K_j = mean "trigger" time (response time) with constraint that K < H (guesses are fast)

% Q = .9;
% a_ij = .8;
% H_ij = 300;
% K_j = 250;
% b_j = .5;
% 
% acc_ij = Q*a_ij + (1-Q)*b_j;
% 
% rt_ij = ( (Q*a_ij*H_ij) + ((1-Q)*b_j*K_j) ) / ...
%     (Q*a_ij) + (1-Q)*b_j;



%From Yellott (1971):  E1, Subject 1
p_C = [0.760000000000000;0.860000000000000;0.910000000000000;0.910000000000000;0.970000000000000;0.930000000000000;0.970000000000000;0.990000000000000;0.990000000000000;0.630000000000000];
mRT_C = [265;272;242;275;286;266;287;283;303;209];
mRT_E = [195;201;210;236;262;233;257;251;252;162];
mu_hat_s = [297;286;245;280;286;268;288;284;304;276];

pC_pE = p_C - (1-p_C);
pCmC_pEmE = (p_C.*mRT_C) - ( (1-p_C).*mRT_E);

figure

scatter(pC_pE,pCmC_pEmE)

[m b R] = linear_regression(pCmC_pEmE',pC_pE');

x = 0:.01:1;
Y = m.*x + b;

hold on
plot(x,Y,'r')
xlabel('p(Correct) - p(Error)')
ylabel('pCmC - pEmE')
title(['u_hat_stim_controlled = ' mat2str(m)])