%VAMPIRE test script
function [out] = vampTestScript(file)

%cd Data
load(file)
varlist = who;
if exist('SRT') == 1
    out = SRT(1,1);
end