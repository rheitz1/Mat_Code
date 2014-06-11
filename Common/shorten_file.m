if exist('nR')
    if isscalar(nR)
        nR = [1:nR];
    end
else
    nR = [1:200];
end

%removes specific trials from all critical variable in workspace
v_list = who;
Alist = v_list(strmatch('AD',v_list));
Dlist = v_list(strmatch('DSP',v_list));

for chan = 1:length(Alist)
    temp = eval(cell2mat(Alist(chan)));
    temp(nR,:) = [];
    eval([cell2mat(Alist(chan)) '= temp;'])
    clear temp
end

for chan = 1:length(Dlist)
    temp = eval(cell2mat(Dlist(chan)));
    temp(nR,:) = [];
    eval([cell2mat(Dlist(chan)) '= temp;'])
    clear temp
end

if exist('FixOn_')
    FixOn_(nR,:) = [];
end

if exist('JuiceOn_')
    JuiceOn_(nR,:) = [];
end

if exist('BellOn_')
    BellOn_(nR,:) = [];
end

if exist('MG_Hold_')
    MG_Hold_(nR,:) = [];
end

if exist('Pupil_')
    Pupil_(nR,:) = [];
end

if exist('saccLoc')
    saccLoc(nR,:) = [];
end

if exist('Correct_')
    Correct_(nR,:) = [];
end

if exist('Errors_')
    Errors_(nR,:) = [];
end

if exist('Target_')
    Target_(nR,:) = [];
end

if exist('Decide_')
    Decide_(nR,:) = [];
end

if exist('SaccDir_')
    SaccDir_(nR,:) = [];
end

if exist('Stimuli_')
    Stimuli_(nR,:) = [];
end

if exist('TrialStart_')
    TrialStart_(nR,:) = [];
end

if exist('SRT')
    SRT(nR,:) = [];
end

if exist('EyeX_')
    EyeX_(nR,:) = [];
end

if exist('EyeY_')
    EyeY_(nR,:) = [];
end

if exist('MStim_')
    MStim_(nR,:) = [];
end

if exist('SAT_')
    SAT_(nR,:) = [];
end

if exist('Gains_EyeX')
    Gains_EyeX(nR,:) = [];
end

if exist('Gains_EyeY')
    Gains_EyeY(nR,:) = [];
end

if exist('Gains_XYF')
    Gains_XYF(nR,:) = [];
end

if exist('Gains_YXF')
    Gains_YXF(nR,:) = [];
end

if exist('FixTime_Jit_')
    FixTime_Jit_(nR,:) = [];
end

if exist('FixAcqTime_')
    FixAcqTime_(nR,:) = [];
end

clear v_list chan Alist Dlist n