%save RFs, MFs, and Hemi information in structs


clear all
close all
cd '/volumes/dump/Search_Data_uStim/'
f_path = '/volumes/dump/Search_Data_uStim/';
q = ''''; c = ','; qcq = [q c q];


batch_list = dir('*.mat');

for i = 1:length(batch_list)
    batch_list(i).name
    %load new (but incorrectly names RF and MF variables)
    eval(['load(' q batch_list(i).name qcq 'RF' qcq 'MF' qcq '-mat' q ')']);
    
    if exist('RF')
        
        %rename
        renvar RF RFs
        renvar MF MFs
        
        %save new variables
        save(batch_list(i).name,'RFs','MFs','-append','-mat')
        
        %remove extraneous variables
        rmvar(batch_list(i).name,'RF','MF')
    else
        continue
    end
    
    keep f_path q c qcq saveFlag batch_list i
end