%get average parameter values for model #14, fix A,v,T0 (b is free)

cd /volumes/Dump/Analyses/SAT/Models/Med

load S_session_fits_Med
sol_Med_S = solution.fixAvT0;
keep sol_*

load Q_session_fits_Med
sol_Med_Q = solution.fixAvT0;
keep sol_*

cd /volumes/Dump/Analyses/SAT/Models/NoMed

load S_session_fits_NoMed
sol_NoMed_S = solution.fixAvT0;
keep sol_*

load Q_session_fits_NoMed
sol_NoMed_Q = solution.fixAvT0;
keep sol_*

A_S = [sol_NoMed_S(:,1) ; sol_Med_S(:,1)];
b1_S = [sol_NoMed_S(:,2) ; sol_Med_S(:,2)];
b2_S = [sol_Med_S(:,3)];
b3_S = [sol_NoMed_S(:,3) ; sol_Med_S(:,4)];
v_S = [sol_NoMed_S(:,4) ; sol_Med_S(:,5)];
T0_S = [sol_NoMed_S(:,5) ; sol_Med_S(:,6)];

A_Q = [sol_NoMed_Q(:,1) ; sol_Med_Q(:,1)];
b1_Q = [sol_NoMed_Q(:,2) ; sol_Med_Q(:,2)];
b2_Q = [sol_Med_Q(:,3)];
b3_Q = [sol_NoMed_Q(:,3) ; sol_Med_Q(:,4)];
v_Q = [sol_NoMed_Q(:,4) ; sol_Med_Q(:,5)];
T0_Q = [sol_NoMed_Q(:,5) ; sol_Med_Q(:,6)];


SEM.A_S = sem(A_S);
SEM.b1_S = sem(b1_S);
SEM.b2_S = sem(b2_S);
SEM.b3_S = sem(b3_S);
SEM.v_S = sem(v_S);
SEM.T0_S = sem(T0_S);

SEM.A_Q = sem(A_Q);
SEM.b1_Q = sem(b1_Q);
SEM.b2_Q = sem(b2_Q);
SEM.b3_Q = sem(b3_Q);
SEM.v_Q = sem(v_Q);
SEM.T0_Q = sem(T0_Q);


% means = [nanmean(A_S) nanmean(b1_S) nanmean(b2_S) nanmean(b3_S) nanmean(v_S) nanmean(T0_S) ; ...
%     nanmean(A_Q) nanmean(b1_Q) nanmean(b2_Q) nanmean(b3_Q) nanmean(v_Q) nanmean(T0_Q)];
% sems = [SEM.A_S SEM.b1_S SEM.b2_S SEM.b3_S SEM.v_S SEM.T0_S ; ...
%     SEM.A_Q SEM.b1_Q SEM.b2_Q SEM.b3_Q SEM.v_Q SEM.T0_Q];
% 
% 
% errorbar(means,sems)
% hold on
% bar(means)