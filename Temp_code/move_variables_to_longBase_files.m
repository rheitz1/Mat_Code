% cd /volumes/Dump/Search_Data_SAT
% filelist = dir('*.mat');
% 
% for f = 1:length(filelist)
%     filelist(f).name
%     cd /volumes/Dump/Search_Data_SAT
%     load(filelist(f).name,'RFs','MFs','BestRF','BestMF','Hemi')
%     
%     cd /volumes/Dump/Search_Data_SAT_longBase
%     save(filelist(f).name,'RFs','MFs','BestRF','BestMF','Hemi','-append','-mat')
%     
%     keep filelist f
% end



cd /volumes/Dump/Search_Data_SAT
filelist = dir('S*.mat');

for f = 1:length(filelist)
    filelist(f).name
    cd /volumes/Dump/Search_Data_SAT
    load(filelist(f).name,'SRT')
    
    cd /volumes/Dump/Search_Data_SAT_longBase
    load(filelist(f).name,'Target_')
    
    if size(SRT,1) == size(Target_,1)
    
        save(filelist(f).name,'SRT','-append','-mat')
    else
        error('not same size')
    end
    
    
    keep filelist f
end