% Usage: lsl 
%        lsl(n), where n = number of files to display.  Default is 20.
%
% Lists the most recently modified files/dirs (and their accompanying
% details) in the current directory.
%
% More detail: Provides the equivalent of Unix's "ls -lt | head" from
% within Matlab on Linux or Windows.  I can't use Matlab w/o this
% anymore.
%
% This only displays *.m, *.mat, *.fig, *.txt, and directories, other
% than those in dirExclude, such as .cvs, .svn, etc.  Modify indicated
% variables to change this.

function lsl (varargin)

% Slapped together by Michael Coen (mhcoen@cs.wisc.edu)
% Yeah, yeah, you could tighten the code.  But could you write it from
% scratch in 12 minutes?  :P
%
% If you want this to return the files, use this line instead:
% function filesSorted = lsl (varargin) 

% Sufixes to include
  searchStrings = {'*.m', '*.mat', '*.fig', '*.txt'};

% Don't bother listing these directories
  dirExclude = {'.','..','.cvs','.svn'};

  % How many files should be listed?
  switch length(varargin)
   case 1
    headLength = varargin{1};
   otherwise
    headLength = 20;
  end

  current = pwd;

  % Initialize the files array
  files = [];
  for i = 1:length(searchStrings)
    searchString = searchStrings{i};
    f = dir(searchString);
    files = [files; f];
  end

  % Now, we'll find the directories 
  fileList = dir;

  directories = [fileList.isdir];
  indices = find(directories);
  % Only include directories in the list
  dirList = fileList(indices);
  directoryNames = {dirList.name};


  % Keep track of indices for directories to be excluded
  directoryIndices = [];
  % Remove excluded directories
  for i = 1:length(dirExclude)
    d = dirExclude{i};
    index = find(strcmp(d, directoryNames));
    % If match, remove directory from dirList
    if index
        directoryIndices = [directoryIndices, index];
    end
  end
  
  dirList(directoryIndices) = [];
  
  files = [files; dirList];

  headLength = min(headLength, length(files));
  dates = zeros(1,length(files));
  
  for i = 1:length(files)
    dates(i) = datenum(files(i).date);
  end
  
  [Y, I] = sort(dates, 2, 'descend');

  filesSorted = files(I);
  filesSorted = filesSorted(1:headLength);
  
  fprintf('Current directory: %s\n', current);

  % Determine field lengths for proper spacing

  % Use this anonymous function to calculate the length of the numeric
  % field containing the number of bytes for the file.
  NumLength = @(x) length(num2str(x));

  bytes = {filesSorted.bytes};
  maxByte = max(cellfun(NumLength, bytes)) + 1;
  
  date = {filesSorted.date};
  maxDate = max(cellfun('length', date)) + 1;
  
  name = {filesSorted.name};
  maxName = max(cellfun('length', name)) + 1;


  for i = 1:headLength
    f = filesSorted(i);
    byteLength = length(num2str(f.bytes));
    dateLength = length(f.date);
    nameLength = length(f.name);
    b = blanks(maxByte - byteLength);
    d = blanks(maxDate - dateLength);
    n = blanks(maxName - nameLength);
    b = strjust([b, num2str(filesSorted(i).bytes)], 'right');
    d = strjust([d, filesSorted(i).date], 'right');
    n = strjust([n, filesSorted(i).name], 'left');
    fprintf('%s %s %s\n', b, d, n);
  end
