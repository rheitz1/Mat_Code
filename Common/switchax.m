% Switches axes (runs after script 'newax' which defines ax1 and ax2)
% RPH

function [] = switchax(ax)

if ax == 1
    ax1 = evalin('caller','ax1');
    set(gcf,'CurrentAxes',ax1)
elseif ax == 2
    ax2 = evalin('caller','ax2');
    set(gcf,'CurrentAxes',ax2)
else
    disp('Invalid axis handle')
end

