function Contrast_batch

close all;

file_path = 'C:\Data\Search_Data\';
q='''';c=',';qcq=[q c q];
MG_list=[]; conv_list=[];
MG_list = dir('C:\Data\Search_Data\*MG.mat');

%make a list of plx files in need of conversion
for i=1:length(MG_list)
    ifile = (MG_list(i).name);
    Contrast_2008(file_path, ifile)
end