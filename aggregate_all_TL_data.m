% script to go through all files in a directory and aggregate the behavioral
% data using the getBEH function
% RPH

cd '/volumes/Dump/Search_Data_longBase/'

batch_list = dir('S*SEARCH.mat');

allTarget_ = [];
allCorrect_ = [];
allErrors_ = [];
allSRT = [];
allSRT_end = [];

for sess = 1:length(batch_list)
    
    batch_list(sess).name
    
    load(batch_list(sess).name,'Target_','Correct_','Errors_','SRT','EyeX_','EyeY_','newfile')
    
    [SRT saccLoc SRT_end] = getSRT(EyeX_,EyeY_);
    
    allTarget_ = [allTarget_ ; Target_];
    allCorrect_ = [allCorrect_ ; Correct_];
    allErrors_ = [allErrors_ ; Errors_];
    allSRT = [allSRT ; SRT(:,1)];
    allSRT_end = [allSRT_end ; SRT_end(:,1)];
    
    keep batch_list sess allTarget_ allCorrect_ allErrors_ allSRT allSRT_end
    
end

