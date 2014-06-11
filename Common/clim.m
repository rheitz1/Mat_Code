% script to change color limits on surf, image, imagesc, contour, contourf plots.
% operates just like 'xlim' or 'ylim'
%
% RPH

function [c] = clim(lims)


if nargin == 0
    c = get(gca,'clim');
else
    set(gca,'clim',[lims(1) lims(2)])
end