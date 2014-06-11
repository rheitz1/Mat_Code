%just a simiple script to clear all variables and close all figures
%if run w/ variable in workspace, Retains all breakpoints
%if run w/o variable in workspace, clears breakpoints too

if isempty(who)
    clear all
    close all
else
    keep 0
    close all
end