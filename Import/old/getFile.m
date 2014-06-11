function [ filename , filepath ] = getFile (searchpath)
% [ FILENAME , FILEPATH ] = getFile ( SEARCHPATH )
% Given A SEARCHPATH, 'c:\data\basic\*.*', returns 
% strings FILENAME and FILEPATH which can be used to 
% load variables into the workspace from the file of 
% interest.
% LOCATED: 
% C:\MATLAB7\MatCode\BasicModules
% CREATED BY: Erik.Emeric@vanderbilt.edu
% Thursday October 21st, 2004
% 
    [filename,filepath] = uigetfile( [searchpath,'*.*'] ,'Choose MATLAB File to Process');
    if isequal(filename,0)|isequal(filepath,0)
        disp('File not found')
    else
        disp(['File ', filepath, filename, ' found'])
    end

