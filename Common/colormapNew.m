%makes a colormap with black in the middle and red and green on either side.
%
% for green = positive, send 'gkr'
% for red = positive, send 'rkg')

function [map] = colormapNew(redgreen)

if nargin < 1; error('No map selected...gkr...rkg...kg...kr...kb'); end
map = zeros(127,3);

switch redgreen
    case 'gkr'
        disp('Works best for centered clim')
        %make maps slightly overlap so that true ZERO values have only one row
        map(1:64,1) = linspace(1,0,64);
        map(64:127,2) = linspace(0,1,64);
    case 'rkg'
        disp('Works best for centered clim')
        map(1:64,2) = linspace(1,0,64);
        map(64:127,1) = linspace(0,1,64);
    case 'kr'
        disp('Works best for 0-bounded data')
        map(1:127,2:3) = 0;
        map(1:127,1) = linspace(0,1,127);
    case 'kg'
        disp('Works best for centered clim')
        map(1:127,[1 3]) = 0;
        map(1:127,2) = linspace(0,1,127);
    case 'kb'
        disp('Works best for centered clim')
        map(1:127,[1 2]) = 0;
        map(1:127,3) = linspace(0,1,127);
end

%engage
colormap(map)

%bound at 0
% c = get(gca,'clim');
% set(gca,'clim',[0 max(c)])
end