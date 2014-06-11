% Saves SRT into all .mat files in a directory
%
% RPH

function RFs = saveSRT()

%get RFs, save to file
clear all
close all
cd ~/desktop/t/;
f_path = '~/desktop/t/';
q = ''''; c = ','; qcq = [q c q];

saveFlag = 1;

batch_list = dir('*.mat');


%Leave this in for older files because we want to run fixErrors_CONTRAST.
%This will eliminate detection and search trials from the analyses.



for i = 1:length(batch_list)
    
    
    eval(['load(',q,f_path,batch_list(i).name,qcq,'Target_',qcq,'EyeX_',qcq,'EyeY_',qcq,'newfile',qcq,'-mat',q,')'])
    
    
    batch_list(i).name
    
    [SRT] = getSRT(EyeX_,EyeY_);
    
    
    if saveFlag == 1
        save([f_path batch_list(i).name],'SRT','-append','-mat')
    end
    
    keep batch_list f_path q c qcq saveFlag
    
    
end