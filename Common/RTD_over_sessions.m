cd /volumes/Dump/Search_Data_EEG_Only/
%cd ~/desktop/T/


batch_list = dir('S*SEARCH.mat');

for file = 1:length(batch_list)
    batch_list(file).name
    load(batch_list(file).name,'SRT','Correct_','Target_')
    
    crt = find(Correct_(:,2) == 1 & Target_(:,2) ~=255);
    fitModel(SRT(crt,1),nanmean(SRT(crt,1)),nanstd(SRT(crt,1)),nanstd(SRT(crt,1)),'exGauss')
    disp(mat2str(length(find(Target_(:,2) == 255))))
    pause
    keep batch_list file
end
