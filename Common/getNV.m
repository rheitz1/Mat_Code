% from Churchland et al. (2006).  NV is a type of Fano Factor computed on
% spike rates.  Scaling factor determined through simulations: calculated
% by generating a poisson spike train, convolving it with out PSP filter,
% and trying to find a scaling factor value that returns an NV of about 1.
% RPH

function [NV] = getNV(Spike,trls)

if nargin < 2; trls = 1:size(Spike,1); end

Target_ = evalin('caller','Target_');

scale_factor = .035; 
SDF = sSDF(Spike(trls,:),Target_(trls,1),[-500 2500]);

for time = 1:size(SDF,2)
    NV(time) = scale_factor * (var(SDF(:,time)) / nanmean(SDF(:,time)));
end