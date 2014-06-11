cd '/volumes/Dump/Search_Data/'

batch_list = dir('*SEARCH.mat');

for i = 1:length(batch_list)
    
    batch_list(i).name
    
    Search_Errors_n2pc_subsample(batch_list(i).name);
    
end