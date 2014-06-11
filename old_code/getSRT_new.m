function [SRT,saccLoc] = getSRT(EyeX_,EyeY_,ASL_Delay)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to return SRT values and saccade endpoint
% locations estimated from eye traces
%
% 9/27/07
%
% 2/29/08 added saccade direction calculation RPH
%
% Richard P. Heitz
% Vanderbilt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 3
    if ASL_Delay == 1
        ASL_DELAY_CORRECTION = 1;
    else
        ASL_DELAY_CORRECTION = 0;
    end
else
    ASL_DELAY_CORRECTION = 0;
end

%11/5/2007 Legacy code: used to return only SRTs for correct trials.
%Removed due to related problems.
Trials = linspace(1,size(EyeX_,1),size(EyeX_,1))';


%At 240Hz, 3 frames (ASL lags 3 frames) = (1000/240)*3 = 12.5
ASL_DELAY = 12.5;

nTrials = size(Trials,1);

SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial

smEyeX_= convn(EyeX_',SMFilter,'same')';
% clear EyeX_

smEyeY_= convn(EyeY_',SMFilter,'same')';
% clear EyeY_

Diff_XX=(diff(smEyeX_'))'; %Successive differences in X
clear smEyeX_

Diff_YY=(diff(smEyeY_'))'; %Successive differences in Y
clear smEyeY_

absXY = (Diff_XX.^2)+(Diff_YY.^2);
clear Diff_XX Diff_YY


if ASL_DELAY_CORRECTION == 1
    thresh = .0006
    disp('ASL Delay correction active')
else
    thresh = .00015
end

saccMat = zeros(size(absXY));
saccMat(find(absXY > thresh)) = 1;
clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get saccade vector direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%alter Eye information based on TEMPO gain settings
%need to do this to compute saccade direction vectors
monkey = 'S'
if monkey == 'Q'
    EyeX_gain = EyeX_*14;
    EyeX_gain = EyeX_ + EyeY_*1;

    EyeY_gain = EyeY_*14;
    EyeY_gain = EyeY_ + EyeX_*1;
elseif monkey == 'S'
    EyeX_gain = EyeX_ * 14;
    EyeY_gain = EyeY_ * 12;
end

for trl = 1:size(diff_saccMat,1)

    tempbegin = find(diff_saccMat(Trials(trl),500:end) == 1);

    %find direction: take location 30 ms before eye movement and 30 ms
    %after eye movement. will give vector direction
    seekWindow = 50;
    averageWindow = 0;
    if ~isempty(tempbegin) && tempbegin(1)-seekWindow-averageWindow > 0 && tempbegin(1)+seekWindow+averageWindow <= 2500
        %         loc_start_X = EyeX_gain(CorrectTrials(trl),tempbegin(1)-seekWindow);
        %         loc_end_X = EyeX_gain(CorrectTrials(trl),tempbegin(1)+seekWindow);
        %         loc_start_Y = EyeY_gain(CorrectTrials(trl),tempbegin(1)-seekWindow);
        %         loc_end_Y = EyeY_gain(CorrectTrials(trl),tempbegin(1)+seekWindow);
        loc_start_X = mean(EyeX_gain(Trials(trl),(tempbegin(1)-seekWindow-averageWindow)+500:(tempbegin(1)-seekWindow+averageWindow+500)));
        loc_end_X = mean(EyeX_gain(Trials(trl),(tempbegin(1)+seekWindow-averageWindow)+500:(tempbegin(1)+seekWindow+averageWindow+500)));
        loc_start_Y = mean(EyeY_gain(Trials(trl),(tempbegin(1)-seekWindow-averageWindow)+500:(tempbegin(1)-seekWindow+averageWindow+500)));
        loc_end_Y = mean(EyeY_gain(Trials(trl),(tempbegin(1)+seekWindow-averageWindow)+500:(tempbegin(1)+seekWindow+averageWindow+500)));

        %take 4-quadrant inverse tangent
        saccDir(trl,1) = mod((180/pi*atan2(loc_end_Y-loc_start_Y,loc_end_X-loc_start_X)),360);


        if saccDir(trl) > 337.5 || saccDir(trl) <= 22.5
            saccLoc(trl,1) = 0;
        elseif saccDir(trl) > 22.5 && saccDir(trl) <= 67.5
            saccLoc(trl,1) = 1;
        elseif saccDir(trl) > 67.5 && saccDir(trl) <= 112.5
            saccLoc(trl,1) = 2;
        elseif saccDir(trl) > 112.5 && saccDir(trl) <= 157.5
            saccLoc(trl,1) = 3;
        elseif saccDir(trl) > 157.5 && saccDir(trl) <= 202.5
            saccLoc(trl,1) = 4;
        elseif saccDir(trl) > 202.5 && saccDir(trl) <= 247.5
            saccLoc(trl,1) = 5;
        elseif saccDir(trl) > 247.5 && saccDir(trl) <= 292.5
            saccLoc(trl,1) = 6;
        elseif saccDir(trl) > 292.5 && saccDir(trl) <= 337.5
            saccLoc(trl,1) = 7;
        else
            saccLoc(trl,1) = NaN;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Set actual SRT times, and correct if necessary
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %note: no need to subtract 500 ms because we begin our search at 500
        if ASL_DELAY_CORRECTION == 1
            SRT(trl,1:length(tempbegin)) = tempbegin - ASL_DELAY;
        else
            SRT(trl,1:length(tempbegin)) = tempbegin;
        end
    end
end

