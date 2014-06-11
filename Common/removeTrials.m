%Removes given vector of trial numbers from all relevant variables in
%workspace
function [] = removeTrials(trls)
q = '''';
c = ',';
qcq = [q c q];

varlist = evalin('caller','who');

for var = 1:length(varlist)
    eval([varlist{var} ' = evalin(' q 'caller' qcq varlist{var} q ');'])
end

clear varlist

varlist = who;

listAD = varlist(strmatch('AD',varlist));
listDSP = varlist(strmatch('DSP',varlist));

for currAD = 1:length(listAD)
    eval([listAD{currAD} '(trls,:) = [];'])
    assignin('caller',listAD{currAD},eval(listAD{currAD}));
end

for currDSP = 1:length(listDSP)
    eval([listDSP{currDSP} '(trls,:) = [];']);
    assignin('caller',listDSP{currDSP},eval(listDSP{currDSP}));
end

% Decide_ = evalin('caller','Decide_');
% Errors_ = evalin('caller','Errors_');
% EyeX_ = evalin('caller','EyeX_');
% EyeY_ = evalin('caller','EyeY_');
% SRT = evalin('caller','SRT');
% SaccDir_ = evalin('caller','SaccDir_');
% Stimuli_ = evalin('caller','Stimuli_');
% Target_ = evalin('caller','Target_');
% TrialStart_ = evalin('caller','TrialStart_');
% Correct_ = evalin('caller','Correct_');

try
    Reward_ = evalin('caller','Reward_');
end

try
    MStim_ = evalin('caller','MStim_');
end

Decide_(trls,:) = [];
Errors_(trls,:) = [];
EyeX_(trls,:) = [];
EyeY_(trls,:) = [];
SRT(trls,:) = [];
SaccDir_(trls,:) = [];
Stimuli_(trls,:) = [];
Target_(trls,:) = [];
TrialStart_(trls,:) = [];
Correct_(trls,:) = [];

assignin('caller','Decide_',Decide_);
assignin('caller','Errors_',Errors_);
assignin('caller','EyeX_',EyeX_);
assignin('caller','EyeY_',EyeY_);
assignin('caller','SRT',SRT);
assignin('caller','SaccDir_',SaccDir_);
assignin('caller','Stimuli_',Stimuli_);
assignin('caller','Target_',Target_);
assignin('caller','TrialStart_',TrialStart_);
assignin('caller','Correct_',Correct_);

try
    Reward_(trls,:) = [];
    assignin('caller','Reward_',Reward_);
end

try
    SAT_(trls,:) = [];
    assignin('caller','SAT_',SAT_);
end

try
    MStim_(trls,:) = [];
    assignin('caller','MStim_',MStim_);
end