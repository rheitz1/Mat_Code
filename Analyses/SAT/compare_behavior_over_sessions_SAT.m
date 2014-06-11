cd /volumes/Dump/Search_Data_SAT_longBase/

file_list = dir('*SEARCH.mat');

ws 1 d Slow
ws 2 d Fast
ws 1
ws send [2] file_list

for fi = 1:length(file_list) 
    fi
    file_list(fi).name
    
    ws 1
    ws send [2] fi
    load(file_list(fi).name,'Correct_','Target_','SAT_','Errors_','SRT','Stimuli_','newfile')
    
    nR = find(SAT_(:,1) ~= 1);
    shorten_file
    beh
    set(gcf,'position',[38         222        1033         635])
    
    
    ws 2 d Fast
    load(file_list(fi).name,'Correct_','Target_','SAT_','Errors_','SRT','Stimuli_','newfile')
    
    nR = find(SAT_(:,1) ~= 3);
    shorten_file
    beh
    set(gcf,'position',[1308         188        1033         635])
    
    
    
    pause
    keep file_list
    ws 1
    keep file_list fi
    f_
end