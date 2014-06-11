function [] = ProcessFile(file_path,filename)
%begin conversion
%clear all;
%close all;
q='''';c=',';qcq=[q c q];

if nargin < 2
file_path = 'D:\Data\ToTranslate';
[filename,file_path] = uigetfile([file_path,'*.plx'],'Choose MATLAB File to Process');
end

%outfile = Translate(file_path,filename);
Translate(file_path,filename);


%call p_sacdet_contrast
%p_sacdet_contrast(file_path,outfile)

