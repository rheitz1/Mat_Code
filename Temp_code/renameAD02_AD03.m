%renames AD02 and AD03 for Quincy files that were hooked up wrong

cd /volumes/Dump/Search_Data/tmp_move
batch_list = dir('*.mat');

for i = 1:length(batch_list)
    batch_list(i).name
    
    load(batch_list(i).name,'AD02','AD03')
    
    temp02 = AD02;
    temp03 = AD03;
    
    clear AD02 AD03
    
    AD02 = temp03;
    AD03 = temp02;
    
    save(batch_list(i).name,'AD02','AD03','-append','-mat')
end