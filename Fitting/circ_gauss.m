% fits circular gaussian to firing rate data over angular positions and returns best parameters for:
% B = baseline
% A = height (peak firing?)
% psi = preferred target location
% sigma = tuning width
%
% mean_firing should be mean firing across 8 angular positions (also input to objective function)
%
% from Treue & Martinez-Trujillo, 1999

function [solution] = circ_gauss(mean_firing)


%starting points
B = 1;
A = 20;
theta = 0;
psi = 0;
sigma = 10;

param = [B A theta psi sigma];

[solution minval] = fminsearch(@(param) getObjective(mean_firing,param),param);


[B A theta psi sigma] = disperse(solution);

%get predicted firing rates
for t = 1:size(mean_firing,1)
    pred(t) = B + A * (sum(exp((-(mean_firing(t,1)- psi - (-2:2)*360).^2) / sigma^2)));
end

figure
plot(0:7,mean_firing(:,1),'or',0:7,pred,'-k')


end


function dev = getObjective(mean_firing,param)
[B A theta psi sigma] = disperse(param);
theta = mean_firing(:,2);

for t = 1:length(theta)
    R(t) = B + A * (sum(exp((-(theta(t)- psi - (-2:2)*360).^2) / sigma^2)));
end

dev = sum((R' - mean_firing(:,1)).^2)
end
