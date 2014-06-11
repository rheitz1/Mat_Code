% Daniel Shima 9/20/2007
% For f6.m port from Lab 030 OS9 Psychtoolbox-2 to Lab 023 OSX Psychtoolbox-3,
% made cosmetic modifications,
% added DEBUG 2,
% make modifications in make_f_command_files.m and run, not in this file itself,

function f6

global CUR_WINDOW SrcWindow
global DEBUG DOTS_CLUT

if (DEBUG == 0 || DEBUG == 2)
    Screen('CopyWindow',SrcWindow(6),CUR_WINDOW);
end
