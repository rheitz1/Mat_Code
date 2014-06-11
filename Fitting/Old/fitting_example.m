%EXAMPLE 1: normal distribution

%this will be a simulated RT dataset that is distributed normally with mean
%u = 300 and sd = 80, and n = 1000.
RTs = normrnd(300,80,1000,1);




%Here is what the data look like
figure
hist(RTs,100)


%and the real mean is:
mean(RTs)

%and the real sd is:
std(RTs)


%Now lets fit it to the normal:

solution = fitModel(RTs,mean(RTs),std(RTs),'norm')

%Notice that the solution has two estimates, and they should be really
%close to the real values.






%Example 2:  Ex-gaussian

%First make an ex-gaussian that looks like a real RT distribution by adding
%together a normal distribution (u=800, sd = 80) and an exponential
%distribution (u = 150)

RT_normal = normrnd(300,80,1000,1);
RT_exponential = exprnd(150,1000,1);

RT_exGauss = RT_normal + RT_exponential;


%Here is what the data look like:

figure
hist(RT_exGauss,50);


%Now lets fit it to the ex-Gauss
solution = fitModel(RT_exGauss,mean(RT_exGauss),std(RT_exGauss),std(RT_exGauss),'exGauss')


%NOT BAD!  Now lets see that trying to fit a normal distribution to
%ex-Gauss data leads to poor fit:

solution_bad = fitModel(RT_exGauss,mean(RT_exGauss),std(RT_exGauss),'norm')

%It is obvious it doesn't fit well from both the CDF and PDF, and as well,
%the log liklihood value (LL) is larger from the normal distribution fit,
%which is bad.