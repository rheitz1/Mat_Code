% Renames variable name in workspace
%
% RPH

function [] = renvar(oldname,newname)


data = evalin('caller',oldname);

assignin('base',newname,data)

evalin('caller',['clear ' oldname])
