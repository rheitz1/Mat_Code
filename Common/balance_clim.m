%script to quickly balance the clim for a difference plot, so that the color spans equally negative and
%equally positive

cl = get(gca,'clim');
mx = max(abs(cl));

set(gca,'clim',[-mx mx])

clear cl mx