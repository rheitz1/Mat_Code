%save saccLoc into files

cd /volumes/Dump/Search_Data


batch_list = dir('*.mat');

for i = 1:length(batch_list)

    batch_list(i).name
    load(batch_list(i).name,'Target_','SRT','Correct_','Errors_','EyeX_','EyeY_','newfile')

    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    
       
    save([batch_list(i).name],'saccLoc','-append','-mat')

    
    keep batch_list i
end
