cd '/volumes/Dump/Search_Data/'
batch_list = dir('*SEARCH.mat');

for file = 1:length(batch_list)
    batch_list(file).name
    Search_Errors_Uber_amplitude_correlations(batch_list(file).name)
end