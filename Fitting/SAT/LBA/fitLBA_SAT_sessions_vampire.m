function [] = fitLBA_SAT_sessions_vampire(filename)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')
load(filename,'SRT','SAT_','Correct_','Errors_','Target_')
filename

fx = 1;
if length(find(SAT_(:,1) == 2)) < 100
    fr = 2;
    inc_med = 0;
elseif length(find(SAT_(:,1) == 2)) >= 100
    fr = 3;
    inc_med = 1;
end

%MODEL 1
%ALL FREE
disp('Running ALL FREE')
Model = [fr fr fr fr];
[solution.fixNONE(1,:) LL.fixNONE(1,1) AIC.fixNONE(1,1) BIC.fixNONE(1,1) CDF] = fitLBA_SAT(Model,0);

%only need to get CDFs once for current 1.
allCDF.slow.correct(:,1:2,1) = CDF.slow.correct;
allCDF.slow.err(:,1:2,1) = CDF.slow.err;
allCDF.med.correct(:,1:2,1) = CDF.med.correct;
allCDF.med.err(:,1:2,1) = CDF.med.err;
allCDF.fast.correct(:,1:2,1) = CDF.fast.correct;
allCDF.fast.err(:,1:2,1) = CDF.fast.err;

clear CDF

% ONE CONSTRAINT
%MODEL 2
%Fix A
disp('Running FIX A')
Model = [fx fr fr fr];
[solution.fixA(1,:) LL.fixA(1,1) AIC.fixA(1,1) BIC.fixA(1,1)] = fitLBA_SAT(Model,0);


%MODEL 3
%Fix b
disp('Running FIX b')
Model = [fr fx fr fr];
[solution.fixb(1,:) LL.fixb(1,1) AIC.fixb(1,1) BIC.fixb(1,1)] = fitLBA_SAT(Model,0);

%MODEL 4
%Fix v
disp('Running FIX v')
Model = [fr fr fx fr];
[solution.fixv(1,:) LL.fixv(1,1) AIC.fixv(1,1) BIC.fixv(1,1)] = fitLBA_SAT(Model,0);

%MODEL 5
%Fix T0
disp('Running FIX T0')
Model = [fr fr fr fx];
[solution.fixT0(1,:) LL.fixT0(1,1) AIC.fixT0(1,1) BIC.fixT0(1,1)] = fitLBA_SAT(Model,0);


% TWO CONSTRAINTS
%MODEL 6
%Fix A,b
disp('Running FIX A,b')
Model = [fx fx fr fr];
[solution.fixAb(1,:) LL.fixAb(1,1) AIC.fixAb(1,1) BIC.fixAb(1,1)] = fitLBA_SAT(Model,0);

%MODEL 7
%Fix A,v
disp('Running FIX A,v')
Model = [fx fr fx fr];
[solution.fixAv(1,:) LL.fixAv(1,1) AIC.fixAv(1,1) BIC.fixAv(1,1)] = fitLBA_SAT(Model,0);

%MODEL 8
%Fix A,T0
disp('Running FIX A,T0')
Model = [fx fr fr fx];
[solution.fixAT0(1,:) LL.fixAT0(1,1) AIC.fixAT0(1,1) BIC.fixAT0(1,1)] = fitLBA_SAT(Model,0);


%MODEL 9
%Fix b,v
disp('Running FIX b,v')
Model = [fr fx fx fr];
[solution.fixbv(1,:) LL.fixbv(1,1) AIC.fixbv(1,1) BIC.fixbv(1,1)] = fitLBA_SAT(Model,0);


%MODEL 10
%Fix b,T0
disp('Running FIX b,T0')
Model = [fr fx fr fx];
[solution.fixbT0(1,:) LL.fixbT0(1,1) AIC.fixbT0(1,1) BIC.fixbT0(1,1)] = fitLBA_SAT(Model,0);

%MODEL 11
%Fix v,T0
disp('Running FIX v,T0')
Model = [fr fr fx fx];
[solution.fixvT0(1,:) LL.fixvT0(1,1) AIC.fixvT0(1,1) BIC.fixvT0(1,1)] = fitLBA_SAT(Model,0);


% THREE CONSTRAINTS
%MODEL 12
%Fix A,b,v
disp('Running FIX A,b,v')
Model = [fx fx fx fr];
[solution.fixAbv(1,:) LL.fixAbv(1,1) AIC.fixAbv(1,1) BIC.fixAbv(1,1)] = fitLBA_SAT(Model,0);

%MODEL 13
%Fix A,b,T0
disp('Running FIX A,b,T0')
Model = [fx fx fr fx];
[solution.fixAbT0(1,:) LL.fixAbT0(1,1) AIC.fixAbT0(1,1) BIC.fixAbT0(1,1)] = fitLBA_SAT(Model,0);

%MODEL 14
%Fix A,v,T0
disp('Running FIX A,v,T0')
Model = [fx fr fx fx];
[solution.fixAvT0(1,:) LL.fixAvT0(1,1) AIC.fixAvT0(1,1) BIC.fixAvT0(1,1)] = fitLBA_SAT(Model,0);

%MODEL 15
%Fix b,v,T0
disp('Running FIX b,v,T0')
Model = [fr fx fx fx];
[solution.fixbvT0(1,:) LL.fixbvT0(1,1) AIC.fixbvT0(1,1) BIC.fixbvT0(1,1)] = fitLBA_SAT(Model,0);


% ALL FIXED
%MODEL 16
disp('Running FIX ALL')
Model = [fx fx fx fx];
[solution.fixALL(1,:) LL.fixALL(1,1) AIC.fixALL(1,1) BIC.fixALL(1,1)] = fitLBA_SAT(Model,0);

%for given session, what are all the BIC values (useful for comparing models)
allBIC(1,:) = [BIC.fixNONE(1) BIC.fixA(1) BIC.fixb(1) BIC.fixv(1) BIC.fixT0(1) ...
    BIC.fixAb(1) BIC.fixAv(1) BIC.fixAT0(1) BIC.fixbv(1) BIC.fixbT0(1) BIC.fixvT0(1) ...
    BIC.fixAbv(1) BIC.fixAbT0(1) BIC.fixAvT0(1) BIC.fixbvT0(1) BIC.fixALL(1)];


allAIC(1,:) = [AIC.fixNONE(1) AIC.fixA(1) AIC.fixb(1) AIC.fixv(1) AIC.fixT0(1) ...
    AIC.fixAb(1) AIC.fixAv(1) AIC.fixAT0(1) AIC.fixbv(1) AIC.fixbT0(1) AIC.fixvT0(1) ...
    AIC.fixAbv(1) AIC.fixAbT0(1) AIC.fixAvT0(1) AIC.fixbvT0(1) AIC.fixALL(1)];

if inc_med
    save(['//scratch/heitzrp/Output/LBA/Med/' filename '.mat'],'-mat')
elseif ~inc_med
    save(['//scratch/heitzrp/Output/LBA/NoMed/' filename '.mat'],'-mat')
end
