function [SRT,saccDir] = getSRT_direction(EyeX_,EyeY_,Target_)


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
% clear EyeX_

smEyeY_= convn(EyeY_',SMFilter,'same')';
% clear EyeY_

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
    thresh = .0006
    ASL_DELAY_CORRECTION = 1
else
    %    thresh = .0025
    thresh = .00015
end

saccMat = zeros(size(absXY));
saccMat(find(absXY > thresh)) = 1;
% clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

%alter EyeX_ and EyeY_ based on Tempo Gain/interaction settings

monkey = 'S';
if monkey == 'Q'
    EyeX_gain = EyeX_*14;
    EyeX_gain = EyeX_ + EyeY_*1;

    EyeY_gain = EyeY_*14;
    EyeY_gain = EyeY_ + EyeX_*1;
elseif monkey == 'S'
    EyeX_gain = EyeX_* 14;
    EyeY_gain = EyeY_* 12;
end
for trl = 1:size(diff_saccMat,1)



    %        trl
    tempbegin = find(diff_saccMat(CorrectTrials(trl),500:end) == 1);
    % tempend = find(diff_saccMat(trl,:) == -1)*4-3;
    %determine eye position before and after saccade; 30 cells = 120 ms


    %        seekWindow = 30;
    %         if ~isempty(tempbegin) && tempbegin(1)-seekWindow > 0 && tempbegin(1) + seekWindow <= 2500
    %             loc_start_X = EyeX_(CorrectTrials(trl),tempbegin(1)-seekWindow);
    %             loc_end_X = EyeX_(CorrectTrials(trl),tempbegin(1)+seekWindow);
    %             loc_start_Y = EyeY_(CorrectTrials(trl),tempbegin(1)-seekWindow);
    %             loc_end_Y = EyeY_(CorrectTrials(trl),tempbegin(1)+seekWindow);

    seekWindow = 50;
    averageWindow = 0;
    if ~isempty(tempbegin) && tempbegin(1)-seekWindow-averageWindow > 0 && tempbegin(1)+seekWindow+averageWindow <= 2500
%         loc_start_X = EyeX_gain(CorrectTrials(trl),tempbegin(1)-seekWindow);
%         loc_end_X = EyeX_gain(CorrectTrials(trl),tempbegin(1)+seekWindow);
%         loc_start_Y = EyeY_gain(CorrectTrials(trl),tempbegin(1)-seekWindow);
%         loc_end_Y = EyeY_gain(CorrectTrials(trl),tempbegin(1)+seekWindow);
        loc_start_X = mean(EyeX_gain(CorrectTrials(trl),(tempbegin(1)-seekWindow-averageWindow)+500:(tempbegin(1)-seekWindow+averageWindow+500)));
        loc_end_X = mean(EyeX_gain(CorrectTrials(trl),(tempbegin(1)+seekWindow-averageWindow)+500:(tempbegin(1)+seekWindow+averageWindow+500)));
        loc_start_Y = mean(EyeY_gain(CorrectTrials(trl),(tempbegin(1)-seekWindow-averageWindow)+500:(tempbegin(1)-seekWindow+averageWindow+500)));
        loc_end_Y = mean(EyeY_gain(CorrectTrials(trl),(tempbegin(1)+seekWindow-averageWindow)+500:(tempbegin(1)+seekWindow+averageWindow+500)));

        %        seekWindow = 30;
        %         if ~isem pty(tempbegin) && tempbegin(1)-seekWindow > 0 && tempbegin(1) + seekWindow <= 2500
        %             loc_start_X = EyeX_(CorrectTrials(trl),tempbegin(1)-seekWindow);
        %             if loc_start_X < 0
        %                 loc_start_X = loc_start_X * -1;
        %             end
        %
        %             loc_end_X = EyeX_(CorrectTrials(trl),tempbegin(1)+seekWindow);
        %             if loc_start_X < 0
        %                 loc_end_X = loc_end_X * -1;
        %             end
        %
        %             loc_start_Y = EyeY_(CorrectTrials(trl),tempbegin(1)-seekWindow);
        %             if loc_start_Y < 0
        %                 loc_start_Y = loc_start_Y * -1;
        %             end
        %             loc_end_Y = EyeY_(CorrectTrials(trl),tempbegin(1)+seekWindow);
        %             if loc_start_Y < 0
        %                 loc_end_Y = loc_end_Y * -1;
        %             end

        %scale by Tempo Gain
        %SEYMOUR
        %             loc_start_X = loc_start_X * 14;
        %             loc_end_X = loc_end_X * 14;
        %             loc_start_Y = loc_start_Y * 12;
        %             loc_end_Y = loc_end_Y * 12;
        %




        saccDir(trl,1) = mod((180/pi*atan2(loc_end_Y-loc_start_Y,loc_end_X-loc_start_X)),360);
        %saccDir(trl,1) = mod((180/pi*atan2(loc_start_Y-loc_end_Y,loc_start_X-loc_end_X)),360);
    else
        saccDir(trl,1) = NaN;
    end

%                             subplot(2,1,1)
%         plot(EyeX_(trl,:))
%         hold
%         plot(EyeY_(trl,:))
%         subplot(2,1,2)
%         line([loc_start_X,loc_end_X],[loc_start_Y,loc_end_Y])
%         title(['actual loc: ' mat2str(Target_(trl,2)) '  Deg:' mat2str(saccDir(trl,1))])
%                 pause
    %correct for downsampling to 250Hz
    if ASL_DELAY_CORRECTION == 1
        SRT(trl,1:length(tempbegin)) = tempbegin -  ASL_DELAY;
    else
        SRT(trl,1:length(tempbegin)) = tempbegin ;
    end
end
