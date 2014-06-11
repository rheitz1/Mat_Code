cd /volumes/Dump/Search_Data_longBase/

batch_list = dir('*.mat');

for sess = 1:length(batch_list)
    cd /volumes/Dump/Search_Data/
    load(batch_list(sess).name,'Hemi','RFs','MFs')
    
    cd /volumes/Dump/Search_Data_longBase/
    save(batch_list(sess).name,'RFs','MFs','Hemi','-append','-mat')
end