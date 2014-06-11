% Function to return trial numbers for n quantiles (ntiles)
% Assumes vector input (could be SRTs, mean SDFs over trials, etc.)
%
% RPH

function [ntiles] = getQuantiles(var,numQuantiles)

if isempty(var) || nargin < 1; error('Input expected...'); end
if isempty(numQuantiles) || nargin < 2; numQuantiles = 4; end

base = 100 / numQuantiles;

p_tiles = base:base:100;


prctiles = prctile(var,p_tiles);

ntiles.n1 = find(var <= prctiles(1));

for n = 2:numQuantiles-1
    eval(['ntiles.n' num2str(n) '= find(var > prctiles(n-1) & var <= prctiles(n));'])
end

eval(['ntiles.n' num2str(numQuantiles) '= find(var > prctiles(numQuantiles-1));'])