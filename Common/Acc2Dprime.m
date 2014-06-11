%compute 'equivalent' accuracy rate from d-prime
function [Dprime] = Acc2Dprime(Acc)

%Dprime is z-score difference between 2 normal distributions centered on z(hits) and z(false alarms).
%Dprime = z(hits) - z(false alarms).
%
%If there is *always* a signal present, then we can regard hit = respond correctly to target, and 
%false alarm = response incorrectly (i.e., you "detected" signal X at location Y when it was not present there)
%
% RPH

if Acc > 1; error('Enter accuracy rate in decimal'); end

Dprime = norminv(Acc,0,1) - norminv(1-Acc,0,1);