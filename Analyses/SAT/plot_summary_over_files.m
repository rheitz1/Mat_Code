%plots plotSAT_summary over specified files.

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_VisMove_Med_Q.txt','%s %s');
%[filename2 unit2] = textread('SAT_VisMove_Med_S.txt','%s %s');
%[filename3 unit3] = textread('SAT_Move_NoMed_Q.txt','%s %s');
%[filename4 unit4] = textread('SAT_Move_NoMed_S.txt','%s %s');


filename = [filename1];
unit = [unit1];

for file = 1:length(filename)
    
    cd /Volumes/Dump/Search_Data_SAT_longBase/
    load(filename{file},unit{file},'TrialStart_','Hemi','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
    filename{file}
    unit{file}
    
    RFs = MFs;
    plotSAT_summary(unit{file})
    
    
    pause
    
    keep filename unit file
    f_
end