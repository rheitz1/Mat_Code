%save RFs, MFs, and Hemi information in structs


clear all
close all
%cd '/Search_Data_SAT/New/'
%f_path = '/Search_Data_SAT/New/';

cd '/volumes/Dump/Search_Data_SAT_longBase/New/';
f_path = '/volumes/Dump/Search_Data_SAT_longBase/New/';
q = ''''; c = ','; qcq = [q c q];

saveFlag = 1;

batch_list = dir('*.mat');

for i = 1:length(batch_list)
    %disp('Press key to begin next file...')
    %pause
    close all
    %ContrastFlag = 1;
    batch_list(i).name
    loadChan(batch_list(i).name,'ALL')
    
    
    varlist = who;
    ADlist = cell2mat(varlist(strmatch('AD',varlist)));
    DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
    
    clear varlist
    
    for ADchan = 1:size(ADlist,1)
        BrainID.(ADlist(ADchan,:)) = input(['Enter brain area for: ' ADlist(ADchan,:) '_'],'s');
    end
    
    if ~isempty(DSPlist)
        for DSPchan = 1:size(DSPlist,1)
            BrainID.(DSPlist(DSPchan,:)) = input(['Enter brain area for: ' DSPlist(DSPchan,:) '_'],'s');
        end
    end
    
    for ADchan = 1:size(ADlist,1)
        Hemi.(ADlist(ADchan,:)) = input(['Enter Hemi for: ' ADlist(ADchan,:) '_'],'s');
    end
    
    if ~isempty(DSPlist)
        for DSPchan = 1:size(DSPlist,1)
            Hemi.(DSPlist(DSPchan,:)) = input(['Enter Hemi for: ' DSPlist(DSPchan,:) '_'],'s');
        end
    end
    
    if ~isempty(DSPlist)
        for chan = 1:size(DSPlist,1)
            RFs.(DSPlist(chan,:)) = input(['Enter RF for: ' DSPlist(chan,:) '_']);
            %            BestRF.(DSPlist(chan,:)) = input(['Enter BestRF for: ' DSPlist(chan,:) '_']);
            MFs.(DSPlist(chan,:)) = input(['Enter MF for: ' DSPlist(chan,:) '_']);
            %           BestMF.(DSPlist(chan,:)) = input(['Enter BestMF for: ' DSPlist(chan,:) '_']);
        end
    end
    
    if saveFlag == 1
        
        if ~isempty(DSPlist)
            %           save([f_path batch_list(i).name],'Hemi','RFs','MFs','BestRF','BestMF','-append','-mat')
            save([f_path batch_list(i).name],'BrainID','Hemi','RFs','MFs','-append','-mat')
        else
            save([f_path batch_list(i).name],'BrainID','Hemi','-append','-mat')
        end
    end
    
    keep f_path q c qcq saveFlag batch_list i
end

c_