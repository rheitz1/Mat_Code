%Returns summed BIC values across a population for a given LBA model
cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_NoMed_Q.txt','%s');
[filename2] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename2];

fx = 1;

% For population, compile all data into one huge dataset
allTarget_ = [];
allCorrect_ = [];
allSRT = [];
allSAT_ = [];
allErrors_ = [];

for file = 1:length(filename)
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
    filename{file}
    
    allTarget_ = [allTarget_ ; Target_];
    allCorrect_ = [allCorrect_ ; Correct_];
    allSRT = [allSRT ; SRT(:,1)];
    allSAT_ = [allSAT_ ; SAT_];
    allErrors_ = [allErrors_ ; Errors_];
    
    clear Correct_ Target_ SRT SAT_ Errors_
end

%rename files back to what scripts want
Target_ = allTarget_;
Correct_ = allCorrect_;
SRT = allSRT;
SAT_ = allSAT_;
Errors_ = allErrors_;

clear all*

%ALL FIX
disp('Running ALL FREE')
Model = [fx fx fx fx];
[solution LL CDF] = fitLBA_SAT_block_switch(Model,0); %only need to get CDF once for population


figure
subplot(2,2,1)
plot(-2:2,solution.A.slow_to_fast,'r',-2:2,solution.A.fast_to_slow,'g')
box off
title('A')

subplot(2,2,2)
plot(-2:2,solution.b.slow_to_fast,'r',-2:2,solution.b.fast_to_slow,'g')
box off
title('b')

subplot(2,2,3)
plot(-2:2,solution.v.slow_to_fast,'r',-2:2,solution.v.fast_to_slow,'g')
box off
title('v')

subplot(2,2,4)
plot(-2:2,solution.T0.slow_to_fast,'r',-2:2,solution.T0.fast_to_slow,'g')
box off
title('T0')