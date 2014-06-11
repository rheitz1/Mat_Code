%transfer RF variables and Hemi to corrected data (i.e., corrected using
%Matt's correction code for AD channels

cd('/volumes/Dump/Search_Data/')

batch_list = dir('*.mat');

for i = 1:length(batch_list)
    batch_list(i).name
    
    try
        load(['/volumes/Dump/Search_Data/' batch_list(i).name],'RFs','MFs','BestRF','BestMF','Hemi','-mat')
        save(['/volumes/Dump/Search_Data_Corrected/c' batch_list(i).name],'RFs','MFs','BestRF','BestMF','Hemi','-append','-mat')
    catch
        disp('Fail!')
        continue
    end
end