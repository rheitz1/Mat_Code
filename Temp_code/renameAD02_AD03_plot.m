%plots n2pc for SEARCH only and flips AD02/AD03 if upside down.  This does
%not correct MG or DET files.  Do not know how to deal with those right
%now.

cd /volumes/Dump/Search_Data/
batch_list = dir('*_SEARCH.mat');

for i = 1:length(batch_list)
    batch_list(i).name
    
    load(batch_list(i).name,'AD02','AD03','SRT','Target_','Errors_','Correct_')
    
    n2pc
    
    
    swap = input('Swap? ');
    
    if swap == 1
        
        temp02 = AD02;
        temp03 = AD03;
        
        clear AD02 AD03
        
        AD02 = temp03;
        AD03 = temp02;
        
        save(batch_list(i).name,'AD02','AD03','-append','-mat')
    end
    
    
    close all
    
    keep batch_list i
    
end