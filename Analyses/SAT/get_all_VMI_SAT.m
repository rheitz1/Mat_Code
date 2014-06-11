%Get VMI's for SAT analysis

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');

filename = [filename5 ; filename6 ; filename7 ; filename8];
unit = [unit5 ; unit6 ; unit7 ; unit8];
% filename = [filename1 ; filename2 ; filename3 ; filename4];
% unit = [unit1 ; unit2 ; unit3 ; unit4];

%On MG trials
% for file = 1:length(filename)
%     fi = filename{file};
%     fil = [fi(1:10) '-RH_MG'];
%     
%     % stupid fix for single file
%     if strfind(fil,'Q102210')
%         fil = 'Q102210001_MG';
%     end
%     
%     load(fil,unit{file},'Target_','SRT','SAT_','Correct_','Errors_','TrialStart_','RFs','MFs')
%     
%     
%     VMI(file,1) = getVMI(unit{file},0);
%     
%      currfile{file,1} = filename{file};
%      currunit{file,1} = unit{file};
% 
%     keep filename unit file VMI
% end

%On SEARCH trials
for file = 1:length(filename)
    fi = filename{file}
    load(filename{file},unit{file},'Target_','SRT','SAT_','Correct_','Errors_','TrialStart_','RFs','MFs')
    
    
    VMI(file,1) = getVMI(unit{file},0);

    
    currfile{file,1} = filename{file};
    currunit{file,1} = unit{file};
    
    keep filename unit file VMI currfile currunit
end



figure
hist(VMI,50)