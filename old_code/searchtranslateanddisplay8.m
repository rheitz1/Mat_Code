function searchtranslateanddisplay8
%FILE: SEARCHTRANSLATEANDDISPLAY8.M
%Translation, merging and analysis of files 
% CALLS: CONVERT.M
%        BAT_PROCESS.M
%Edit the first portion only of this  file
%Translates and merges pdp and Mnap file also find the trues...
%All routines are done if convert is called with 2 arguments
%Paths and files must exist
Note_path='g:\MatlabTest\DataFile\Notes';%'g:\fechner\fecfef\notes';
PDP_Basefile='g:\MatlabTest\DataFile\fecfef';%'g:\fechner\fecfef\fecfef';
MNAP_Basefile='g:\MatlabTest\DataFile\f_fef';%'g:\fechner\fecfef\f_fef';
Analysis_Basefile='g:\MatlabTest\DataFile\fecfef_m';%'g:\fechner\fecfef\fecfef_m';
transdiarypath='\trans';%Screen output for translation is stored in this file
analdiarypath='\anal';%Screen output for analysis is stored in this file
% min and max file no that make file extensions...
%LIST=[183 184 185 189 190 191 196 197 198];
LIST=[272];
%TRANSLATION
Notes_path=[Note_path,transdiarypath];
%COMMENT the line below for only ANALYSIS of a list of files
%call_convert(LIST,Notes_path,PDP_Basefile,MNAP_Basefile,Analysis_Basefile);
%ANALYSIS
Notes_path=[Note_path,analdiarypath];
%COMMENT the line below for only TRANSLATION
call_analyze(LIST,Notes_path,PDP_Basefile,MNAP_Basefile,Analysis_Basefile);

%*********************************************************************************
function call_convert(LIST,Notes_path,PDP_Basefile,MNAP_Basefile,Analysis_Basefile);
%Main Routine for Translation
diary ([Notes_path,num2str(min(LIST)),'-',num2str(max(LIST)),'.txt'])
for jj1=1:length(LIST)
   jj=LIST(jj1)
   F1=[PDP_Basefile,'.',num2str(jj)];
   F2=[MNAP_Basefile,num2str(jj),'.str'];
   convert(F1,F2);
   F1=[];F2=[];
end
diary off
%**********************************************************************************
function call_analyze(LIST,Notes_path,PDP_Basefile,MNAP_Basefile,Analysis_Basefile);
%MAIN ROUTINE FOR ANALYSIS
disp(['Analysing files  ',Analysis_Basefile,'.',num2str(min(LIST)),' to *.',num2str(max(LIST))])
diary ([Notes_path,num2str(min(LIST)),'-',num2str(min(LIST)),'.txt'])
for NN=1:length(LIST),
   ext=LIST(NN);
   temp=[Analysis_Basefile,'.',num2str(ext)];
   FF(NN,1:length(temp))=temp;
   temp='';
end
bat_process(FF)
diary off
