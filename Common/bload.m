%function to load just the behavioral variables of a file to save time/memory

function [] = bload(name)

load(name,'EyeX_','EyeY_','Correct_','Errors_','Decide_','MStim_','SAT_','SRT','Stimuli_','Target_', ...
    'TrialStart_','newfile','saccLoc')

assignin('caller','EyeX_',EyeX_)
assignin('caller','EyeY_',EyeY_)
assignin('caller','Correct_',Correct_)
assignin('caller','Errors_',Errors_)
assignin('caller','Decide_',Decide_)
assignin('caller','MStim_',MStim_)
assignin('caller','SAT_',SAT_)
assignin('caller','SRT',SRT)
assignin('caller','Stimuli_',Stimuli_)
assignin('caller','Target_',Target_)
assignin('caller','TrialStart_',TrialStart_)
assignin('caller','newfile',newfile)
assignin('caller','saccLoc',saccLoc)