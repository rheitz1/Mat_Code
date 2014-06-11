%script to draw the line of unity on a scatter plot.  If not a scatter,
%just a diagonal line from minx/miny to maxx/maxy

function [] = dline(col)
q = '''';

if nargin < 1; col = 'k'; end

y = get(gca,'ylim');
x = get(gca,'xlim');

%make sure axes are equal before drawing line so we ensure that line is
%actually one of unity.
mins = min([x(1) y(1)]);
maxs = max([x(2) y(2)]);

hold on
eval(['line([mins maxs],[mins maxs],' q 'color' q ',' q col q ')'])
