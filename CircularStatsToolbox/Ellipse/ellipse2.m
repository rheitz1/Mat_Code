function h = ellipse(varargin)
% ELLIPSE - draw and ellipse on specified or current axis
%
% ELLIPSE(X,Y,RX,RY) draws an ellipse at (X,Y) with radii RX and RY on the
% current axes.
% 
% ELLIPSE(AX,...) draws on the axes AX
%
% RY can be omitted in the above two cases, in which case RX is used (thus
% a circle is drawn)
%
% ELLIPSE(...,TILT) tilts the x axis of the ellipse be TILT, in radians
%
% ELLIPSE(...,TILT,N), where N is a scalar uses N points to draw the ellipse.
%
% ELLIPSE(...,TILT,THETA), where THETA is a two-element vector, draws the
% arc from angle THETA(1) to THETA(2), relative to the ellipse's x axis, in radians
%
% ELLIPSE(...,TILT,N,THETA) or ELLIPSE(...,TILT,THETA,N) are equivalent.
%
% Ellipse(...,NAME1,VALUE1,NAME2,VALUE2,...), where NAME1 is a string,
% passes the NAME/VALUE parameter pairs to the PLOT function.
%
% H = ELLIPSE(...) returns a handle to the plotted ellipse / arc.

%% parse input
a = varargin{1};
if ishandle(a) && isfield(get(a),'Type') && isequal(get(a,'Type'),'axes')
    ax = a;
    varargin(1) = [];
else
    ax = gca;
end

if length(varargin)<3, error('Not enough input arguments'); end
if length(varargin)==3, varargin{4} = varargin{3}; end
[x y rx ry] = deal(varargin{1:4});
varargin(1:4) = [];

t = 0;
if ~isempty(varargin) && isnumeric(varargin{1})
    t = varargin{1};
    varargin(1)=[];
end

N = 100;
th = [0 2*pi];
while ~isempty(varargin) && isnumeric(varargin{1})
    a = varargin{1};
    if length(a)==1
        N = a;
    else
        th = a;
    end
    varargin(1) = [];
end

th = linspace(th(1),th(2),N);
x = x + rx*cos(th)*cos(t) - ry*sin(th)*sin(t);
y = y + ry*cos(th)*sin(t) + ry*sin(th)*cos(t);

h = plot(ax,x,y,varargin{:});