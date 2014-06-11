% Merges selected variables from one reference file to a target file. Typically used to update new files
% with variables hard-coded into old files (e.g., RF variables)
%
% RPH

function [] = mergeFiles()

%get RFs, save to file
clear all
close all
refdir = '/volumes/Dump2/PLX_SAT_SEF/';
targetdir = '/volumes/Dump/Search_Data_SAT_SEF_longBase/';

q = ''''; c = ','; qcq = [q c q];

%populate file list based on TARGET directory
eval(['cd ' targetdir])
batch_list = dir('*.mat');

saveFlag = 1;

for fi = 1:length(batch_list)
    fi
    eval(['cd ' refdir])
    eval(['load(',q,batch_list(fi).name,qcq,'FixTime_Jit_',qcq,'-mat',q,')'])
        
    batch_list(fi).name
    
   % [SRT saccLoc] = getSRT(EyeX_,EyeY_);
    
    
    if saveFlag == 1
        eval(['cd ' targetdir])
        eval(['save(',q,batch_list(fi).name,qcq,'FixTime_Jit_',qcq,'-append',qcq,'-mat',q,')'])
    else
        disp(['save(',q,batch_list(fi).name,qcq,'FixTime_Jit_',qcq,'-append',qcq,'-mat',q,')'])
    end
    
    keep batch_list refdir targetdir fi q c qcq saveFlag
    
    
end