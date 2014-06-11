%bar chart w/ SEM of across-session parameter values

cd /volumes/Dump/Analyses/SAT/Models

load Q_session_fits_MedNoMed

%model 14: fix A,v,T0
A_Q = solution.fixAvT0(:,1);
b1_Q = solution.fixAvT0(:,2);
b2_Q = solution.fixAvT0(:,3);
v_Q = solution.fixAvT0(:,4);
T0_Q = solution.fixAvT0(:,5);

keep A* b* v* T0*

load S_session_fits_MedNoMed

A_S = solution.fixAvT0(:,1);
b1_S = solution.fixAvT0(:,2);
b2_S = solution.fixAvT0(:,3);
v_S = solution.fixAvT0(:,4);
T0_S = solution.fixAvT0(:,5);

meanA_s = mean(A_S);
meanb1_s = mean(b1_S);
meanb2_s = mean(b2_S);
meanv_s = mean(v_S);
meanT0_s = mean(T0_S);
meanA_q = mean(A_Q);
meanb1_q = mean(b1_Q);
meanb2_q = mean(b2_Q);
meanv_q = mean(v_Q);
meanT0_q = mean(T0_Q);

param = [meanA_s meanA_q ; meanb1_s meanb1_q ; meanb2_s meanb2_q ; meanv_s meanv_q ; meanT0_s meanT0_q];

semA_Q = nanstd(A_Q) / sqrt(length(A_Q));
semA_S = nanstd(A_S) / sqrt(length(A_S));

semb1_S = nanstd(b1_S) / sqrt(length(b1_S));
semb2_S = nanstd(b2_S) / sqrt(length(b2_S));

semb1_Q = nanstd(b1_Q) / sqrt(length(b1_Q));
semb2_Q = nanstd(b2_Q) / sqrt(length(b2_Q));

semv_S = nanstd(v_S) / sqrt(length(v_S));
semv_Q = nanstd(v_Q) / sqrt(length(v_Q));

semT0_S = nanstd(T0_S) / sqrt(length(T0_S));
semT0_Q = nanstd(T0_Q) / sqrt(length(T0_Q));


errorbar(param,[semA_S semA_Q ; semb1_S semb1_Q ; semb2_S semb2_Q ; semv_S semv_Q ; semT0_S semT0_Q],'x')
hold on
bar(param)