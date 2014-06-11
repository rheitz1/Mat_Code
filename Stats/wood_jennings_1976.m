% compute conditional accuracy functions based on ex-gaussian RT distributions (correct vs error) of
% different separations and widths (standard deviations).
%
% see Wood & Jennings 1976 for general idea
%
% RPH

mu_correct = 300;
sd = 40;

correctDist = normrnd(mu_correct,sd,1000,1);
SlowErrorDist_25 = normrnd(mu_correct + 25,sd,1000,1);
FastErrorDist_25 = normrnd(mu_correct - 25,sd,1000,1);

%doesn't this lead to 50% errors overall?


dat_slow_errors = [correctDist ones(size(correctDist,1),1) ; SlowErrorDist_25 zeros(size(SlowErrorDist_25,1),1)];
dat_fast_errors = [correctDist ones(size(correctDist,1),1) ; FastErrorDist_25 zeros(size(FastErrorDist_25,1),1)];

Correct_ = [NaN(size(dat_fast_errors,1),1) dat_fast_errors(:,2)];
Errors_ = NaN(size(dat_fast_errors,1),7);
CAF(dat_fast_errors(:,1),dat_fast_errors(:,2),10,1)
