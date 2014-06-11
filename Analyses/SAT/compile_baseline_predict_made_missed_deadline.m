cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Vis_Med_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Vis_Med_S.txt','%s %s');
[filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
filename = [filename1 ; filename2 ; filename3 ; filename4 ; filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];


win = [-200 0];


for file = 1:length(filename)
    
    load(filename{file},'SRT','Target_','Correct_','Errors_','SAT_','RFs','Hemi')
    eval(['load(' '''' filename{file} '''' ',' '''' unit{file} '''' ')'])
    filename{file}
    
    sig = eval(unit{file});
    
    SRT = evalin('caller','SRT');
    Target_ = evalin('caller','Target_');
    Correct_ = evalin('caller','Correct_');
    Errors_ = evalin('caller','Errors_');
    SAT_ = evalin('caller','SAT_');
    RFs = evalin('caller','RFs');
    Hemi = evalin('caller','Hemi');
    
    RFs = evalin('caller','RFs');
    
    [acc_r(file,1) acc_p(file,1) speed_r(file,1) speed_p(file,1)] = baseline_predict_made_missed_deadline(unit{file},win);
    
    keep acc_r acc_p speed_r speed_p filename unit file win
end