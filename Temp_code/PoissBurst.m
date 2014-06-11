function [BOB] = PoissBurst(Spike)


Spike = nonzeros(Spike);
%compute MU
MU = length(Spike) / (max(Spike) - min(Spike));

%create ISI distribution
ISI = diff(Spike);

for j = 1:length(ISI)-2
    BOB(j) = poisspdf(3/(ISI(j+2) - ISI(j)),MU);
end
disp('hi')
