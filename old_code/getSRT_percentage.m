function [SRT] = getSRT(EyeX_,EyeY_)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to return SRT values estimated from eye traces
% 2 args returns all SRTs
% 3 args will limit to trials in "CorrectTrials"
%
% 9/27/07
% Richard P. Heitz
% Vanderbilt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%manually set delay correction
ASL_DELAY_CORRECTION = 0;

%11/5/2007 Legacy code: used to return only SRTs for correct trials.
%Removed due to related problems.
CorrectTrials = linspace(1,size(EyeX_,1),size(EyeX_,1))';


%At 240Hz, 3 frames (ASL lags 3 frames) = (1000/240)*3 = 12.5
ASL_DELAY = 12.5;

nTrials = size(CorrectTrials,1);

SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial

%NOTE: originally tried to do SRT detection twice, then concatenate 2
%files; something seems to be wrong; check before using

smEyeX_= convn(EyeX_',SMFilter,'same')';
clear EyeX_

smEyeY_= convn(EyeY_',SMFilter,'same')';
clear EyeY_

Diff_XX=(diff(smEyeX_'))'; %Successive differences in X
clear smEyeX_

Diff_YY=(diff(smEyeY_'))'; %Successive differences in Y
clear smEyeY_

absXY = (Diff_XX.^2)+(Diff_YY.^2);
clear Diff_XX Diff_YY




%check variances to see if using eye tracker or eye coil
%%%%%%%%%
% If using the ASL eye tracker, there is a 12.5 ms delay
% as the system transmits data.  So, check to see if
% tracker used; if so, make correction
%%%%%%%%%

if mean(sqrt(var(absXY))) > .01
    %      thresh = .1
    thresh = .0015
    ASL_DELAY_CORRECTION = 1
else
    %    thresh = .0025
    thresh = .0015
end

saccMat = zeros(size(absXY));





saccMat(find(absXY > thresh)) = 1;
% clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

for trl = 1:size(diff_saccMat,1)
    
    %find max voltage difference on the combined derivatives channel.  Will use
%percentage of this max as criterion.  Note that am calculating this WITHIN
%A TIME WINDOW.  Due to downsampling, interval 101 - 2001 ms will be cells
%26 - 501 [old 751] ( = 2000 actual ms)
maxVolt = max(absXY(trl,26:501));

%criterion will be % of maxVolt, to accomodate fluctuations across
%trials/sessions/subjects
criterion = .5*maxVolt;%*.5;

%find index OF WINDOW where absXY crosses percentage criterion
temp_SRT = find(absXY(trl,26:501) >= criterion,1);


%account for: search window (26 cells, downsampling of eye traces (*4-3),
%and 500 ms baseline (-500ms)

temp_SRT = (temp_SRT + 26)*4 - 3 - 500;
    %correct for ASL_Delay (-12.5)
    if ASL_DELAY_CORRECTION == 1
        SRT(trl,1) = temp_SRT - ASL_DELAY;
    else
        SRT(trl,1) = temp_SRT;
    end
end
