% Daniel Shima 9/20/2007
% For eall2.m port from Lab 030 OS9 Psychtoolbox-2 to Lab 023 OSX Psychtoolbox-3,
% made cosmetic modifications,
% cleaned up Screen-command style and overall case-sensitivity for current MATLAB and Psychtoolbox-3,

function eall2

global CUR_WINDOW SrcWindow Xmax Ymax Xc Yc
global DEBUG DOTS_CLUT
global Ymax

if DEBUG == 0
    for i = 1:9
        Screen('FillRect',SrcWindow(i),0);
    end
end

% Marker for photosensor
Screen('FillRect',SrcWindow(4),1,[0 Ymax-60 60 Ymax]);
Screen('FillRect',SrcWindow(9),1,[0 Ymax-60 60 Ymax]);
