function RFs = saveRFs()

%get RFs, save to file
clear all
close all
cd '/volumes/Dump/Search_Data_uStim/new/'
f_path = '/volumes/Dump/Search_Data_uStim/new/';
q = ''''; c = ','; qcq = [q c q];

saveFlag = 1;
printFlag = 0;

batch_list = dir('*.mat');


%Leave this in for older files because we want to run fixErrors_CONTRAST.
%This will eliminate detection and search trials from the analyses.



for i = 1:length(batch_list)
    disp('Press key to begin next file...')
    pause
    close all
    %ContrastFlag = 1;
    eval(['load(',q,f_path,batch_list(i).name,qcq,'-mat',q,')'])
    batch_list(i).name


    %DRAW RASTER script
if printFlag == 1
    eval('printPlots')
end

    eval('getCellnames')


     if exist('RFs') == 1 
       clear RFs MFs BestRF BestMF
    end
    

    for c = 1:length(CellNames)
        RFs{c} = input(['Enter RFs: ' cell2mat(CellNames(c)) ': ']);
        BestRF{c} = input(['Enter Best RF: ' cell2mat(CellNames(c)) ': ']);
        MFs{c} = input(['Enter MFs: ' cell2mat(CellNames(c)) ': ']);        
        BestMF{c} = input(['Enter Best MF: ' cell2mat(CellNames(c)) ': ']);        
    end   
        
    

    if saveFlag == 1
        save([f_path batch_list(i).name],'RFs','BestRF','MFs','BestMF','-append','-mat')

%         %if SEARCH and DET trials exist, save RFs to them
%         stub = batch_list(i).name(1:end-6);
%         if exist([stub 'SEARCH.mat'])
%             save([f_path stub 'SEARCH.mat'],'RFs','BestRF','MFs','BestMF','-append','-mat')
%         end
%         if exist([stub 'DET.mat'])
%             save([f_path stub 'DET.mat'],'RFs','BestRF','MFs','BestMF','-append','-mat')
%         end
    end
    keep batch_list f_path q c qcq printFlag saveFlag
end