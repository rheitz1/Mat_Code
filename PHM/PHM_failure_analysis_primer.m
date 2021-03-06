
%make distribution
t = 0:1:2000;
mean_int = 1000;
st_dev = 300; %for use when distribution requires a standard dev

f = normpdf(t,mean_int,st_dev);
F = normcdf(t,mean_int,st_dev);
S = 1-F; %survivor function / reliability
h = f./S; %hazard RATE (instantaneous rate of incidence)
H = cumsum(h); %cumulative hazard rate (total accumulated risk)
% cumulative hazard is number of times we'd expect failure/death
% in given time interval if failure event were repeatable

%H = -log(S)
%S = exp(-H)
%F = 1 - exp(-H)
%f = h * exp(-H);