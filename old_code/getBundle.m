%script 'Bundle' creates a struct holding commonly needed variables
%Target_, Correct_, Errors_, SRT

Bundle.Target_ = Target_;
Bundle.Correct_ = Correct_;
Bundle.Errors_ = Errors_;
Bundle.SRT = SRT;
Bundle.TrialStart_ = TrialStart_;

if exist('SaccDir_') == 1 & length(find(~isnan(SaccDir_))) > 5 %sometimes there are stray numbers even when SaccDir_ is not actually encoded.
    Bundle.SaccDir_ = SaccDir_;
else
    getMonk
    [x Bundle.SaccDir_] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
    clear x
end

if exist('MStim_') == 1
    Bundle.MStim_ = MStim_;
end

