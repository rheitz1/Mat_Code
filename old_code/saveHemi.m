%saveHemi
%saves hemisphere information in file
%similar to RFs variable, each row lists hemisphere for associated AD
%channel

clear all
close all
cd '/volumes/dump/Search_Data_uStim/'
f_path = '/volumes/dump/Search_Data_uStim/';
q = ''''; c = ','; qcq = [q c q];

saveFlag = 1;

batch_list = dir('*.mat');

for i = 1:length(batch_list)
    %disp('Press key to begin next file...')
    %pause
    close all
    %ContrastFlag = 1;
    batch_list(i).name
    ChanStruct = loadChan(batch_list(i).name,'ALL')
    decodeChanStruct
    
    varlist = who;
    ADlist = cell2mat(varlist(strmatch('AD',varlist)));
    clear varlist
    
    for chan = 1:size(ADlist,1)
        Hemi{chan,1} = ADlist(chan,:);
        Hemi{chan,2} = input(['Enter Hemi for: ' ADlist(chan,:) '_'],'s');
    end
    
    if saveFlag == 1
        save([f_path batch_list(i).name],'Hemi','-append','-mat')
    end
    
    keep f_path q c qcq saveFlag batch_list i
end