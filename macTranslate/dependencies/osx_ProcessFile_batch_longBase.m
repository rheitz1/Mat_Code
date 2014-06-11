function ProcessFile_batch_longBase

close all;

% LOCAL FILES
file_path = 'C:\Data\ToTranslate\';
q='''';c=',';qcq=[q c q];
plx_list=[]; conv_list=[];
eval(['cd ' file_path])
plx_list = dir('C:\Data\ToTranslate\*.plx');

%make a list of plx files in need of conversion
for i=1:length(plx_list)
    i
    ifile = (plx_list(i).name);
        
    %Translate_SAT_longBase(file_path,ifile)
    Translate_SAT_behavior_only(file_path,ifile);
    
    plx_list(i).name
    
end

% 
% % REMOTE FILES
% file_path = 'Z:\Dump2\PLX_SAT_SEF\';
% %file_path = 'Y:\PLX_SAT\';
% q='''';c=',';qcq=[q c q];
% plx_list=[]; conv_list=[];
% eval(['cd ' file_path])
% plx_list = dir('Z:\Dump2\PLX_SAT_SEF\*.plx');
% %plx_list = dir('Y:\PLX_TL_EEG_Only\*.plx*');
% %plx_list = dir('Z:\Dump2\PLX_TL\*.plx');
% 
% %make a list of plx files in need of conversion
% for i=1:length(plx_list)
%     i
%     ifile = (plx_list(i).name);
%     %processFile(file_path,ifile);
%     %Translate_withCorrection(file_path,ifile)
%     Translate_SAT_longBase(file_path,ifile)
%     %Translate_getWaves(file_path,ifile);
%     plx_list(i).name
%     
% end

