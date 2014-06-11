function ProcessFileBatch

close all;

%file_path = 'C:\data\ToTranslate\';
file_path = 'Y:\PLX\';
q='''';c=',';qcq=[q c q];
plx_list=[]; conv_list=[];
%plx_list = dir('C:\data\ToTranslate\*.plx*');
plx_list = dir('Y:\PLX\*.plx*');

%make a list of plx files in need of conversion
for i=1:length(plx_list)
    ifile = (plx_list(i).name);
    %processFile(file_path,ifile);
    Translate_withCorrection(file_path,ifile)
end

