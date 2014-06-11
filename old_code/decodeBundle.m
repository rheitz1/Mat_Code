%decodeBundle - takes 'Bundle' input and decodes them

Target_ = Bundle.Target_;
Correct_ = Bundle.Correct_;
Errors_ = Bundle.Errors_;
SRT = Bundle.SRT;
TrialStart_ = Bundle.TrialStart_;

vars = fieldnames(Bundle);


if ~isempty(strmatch('MStim_',vars,'exact'))
    MStim_ = Bundle.MStim_;
end

if ~isempty(strmatch('SaccDir_',vars,'exact'))
    SaccDir_ = Bundle.SaccDir_;
end

clear vars