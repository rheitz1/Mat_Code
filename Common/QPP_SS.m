% Generates the Quantile Probability plot for set-size
% simply sets up the variables and calls quantile_prob.m

ss2_correct = find(Target_(:,5) == 2 & Correct_(:,2) == 1 & Target_(:,2) ~= 255);
ss4_correct = find(Target_(:,5) == 4 & Correct_(:,2) == 1 & Target_(:,2) ~= 255);
ss8_correct = find(Target_(:,5) == 8 & Correct_(:,2) == 1 & Target_(:,2) ~= 255);

ss2_errors = find(Target_(:,5) == 2 & Correct_(:,2) == 0 & Target_(:,2) ~= 255);
ss4_errors = find(Target_(:,5) == 4 & Correct_(:,2) == 0 & Target_(:,2) ~= 255);
ss8_errors = find(Target_(:,5) == 8 & Correct_(:,2) == 0 & Target_(:,2) ~= 255);

x = [ [SRT(ss2_correct,1) ; SRT(ss2_errors,1)] [ones(length(ss2_correct),1) ; zeros(length(ss2_errors),1)] ];
y = [ [SRT(ss4_correct,1) ; SRT(ss4_errors,1)] [ones(length(ss4_correct),1) ; zeros(length(ss4_errors),1)] ];
z = [ [SRT(ss8_correct,1) ; SRT(ss8_errors,1)] [ones(length(ss8_correct),1) ; zeros(length(ss8_errors),1)] ];


quantile_prob(x,y,z)