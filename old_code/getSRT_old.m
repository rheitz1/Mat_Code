function [SRT,saccLoc,saccDir,deltaX,deltaY,SRT_end] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey)


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
%
%   saccLoc = estimated saccade endpoint in screen position
%   saccDir = angle of saccade vector in polar angle
%   deltaX,deltaY = screen locations to use for plotting
%       actual saccade endpoint location.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

if nargin < 3 %if not specified, check back with caller
    newfile = evalin('caller','newfile');
    
    if newfile(1) == 'Q'
        monkey = 'Q';
        ASL_Delay = 0;
    elseif newfile(1) == 'S'
        
        monkey = 'S';
        %determine date recorded to set ASL_Delay
        mo = str2num(newfile(2:3));
        yr = str2num(newfile(6:7));
        
        if yr == 8 & mo < 4
            ASL_Delay = 1;
        elseif yr == 7
            ASL_Delay = 1;
        else
            ASL_Delay = 0;
        end
        
        clear mo yr newfile
    end
end

    
    

if ASL_Delay == 1
    ASL_DELAY_CORRECTION = 1;
else
    ASL_DELAY_CORRECTION = 0;
end


%11/5/2007 Legacy code: used to return only SRTs for correct trials.
%Removed due to related problems.
Trials = linspace(1,size(EyeX_,1),size(EyeX_,1))';


%At 240Hz, 3 frames (ASL lags 3 frames) = (1000/240)*3 = 12.5
ASL_DELAY = 12.5;

nTrials = length(Trials);

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


%use for checking if MStim_ exists in base workspace
varlist = evalin('caller','who');

if ASL_DELAY_CORRECTION == 0 & monkey == 'Q'
    thresh = .00008
elseif ASL_DELAY_CORRECTION == 1 & monkey == 'S'
    %Seymour w/ eye tracker
    thresh = .0006
    disp('ASL Delay correction active')
elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & isempty(strmatch('MStim_',varlist,'exact'))
    %thresh = .00001
    thresh = 7e-6
elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & ~isempty(strmatch('MStim_',varlist,'exact'))
    disp('uStim Data Set Detected')
    thresh = 5e-6
    %thresh = .00001
end



saccMat = zeros(size(absXY));
saccMat(find(absXY > thresh)) = 1;
%clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get saccade vector direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%alter Eye information based on TEMPO gain settings
%need to do this to compute saccade direction vectors
if ASL_DELAY_CORRECTION == 0
    EyeX_gain = EyeX_;%*14;
    EyeX_gain = EyeX_; %+ EyeY_*1;

    EyeY_gain = EyeY_;%*14;
    EyeY_gain = EyeY_;% + EyeX_*1;
elseif ASL_DELAY_CORRECTION == 1
    EyeX_gain = EyeX_ * 14;
    EyeY_gain = EyeY_ * 12;
end

for trl = 1:size(diff_saccMat,1)

    tempbegin = find(diff_saccMat(Trials(trl),530:end) == 1);
    tempend = find(diff_saccMat(Trials(trl),530:end) == -1);
    
    
    %find direction: take location 20 ms before eye movement start and 20 ms
    %after eye movement end. will give vector direction
    %seekWindow = 50;
    if ~isempty(tempbegin) && ~isempty(tempend) && tempbegin(1) > 0 && tempbegin(1) <= 2300 && tempend(1) > 0 && tempend(1) < 2300
        
% %changed 4/30/09 for better logic RPH
        loc_start_X = mean(EyeX_gain(Trials(trl),(400:500)));
        loc_end_X = mean(EyeX_gain(Trials(trl),(tempbegin(1)+500+100):(tempbegin(1)+500+200)));
        loc_start_Y = mean(EyeY_gain(Trials(trl),(400:500)));
        loc_end_Y = mean(EyeY_gain(Trials(trl),(tempbegin(1)+500+100):(tempbegin(1)+500+200)));

        %for start and end locations: mean of -20:10 before saccade onset ;
        % 10:20 ms after saccade onset.  Note adding 30 ms because started
        % search at 30 to account for initial saccades into fixation area
%         loc_start_X = mean(EyeX_gain(Trials(trl),tempbegin(1) - 20 + 30:tempbegin(1) - 10 + 30));
%         loc_end_X = mean(EyeX_gain(Trials(trl),tempend(1) + 10 + 30:tempend(1) + 20 + 30));
%         loc_start_Y = mean(EyeY_gain(Trials(trl),tempbegin(1) - 20 + 30:tempbegin(1) - 10 + 30));
%         loc_end_Y = mean(EyeY_gain(Trials(trl),tempend(1) + 10 + 30:tempend(1) + 20 + 30));

        
        deltaX(trl,1) = loc_end_X - loc_start_X;
        deltaY(trl,1) = loc_end_Y - loc_start_Y;
        
        
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
%     else
%         saccLoc(trl,1) = NaN;
%     end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Set actual SRT times, and correct if necessary
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %note: no need to subtract 500 ms because we begin our search at 500
        %add 30 because we start search at 530 to eliminate trials with
        %saccade artifacts near time 0.
        if ASL_DELAY_CORRECTION == 1
            % N O T E: removed ASL_Delay as of 4/2008 after Seymour's eye
            %coil implantation
            SRT(trl,1:length(tempbegin)) = tempbegin - ASL_DELAY + 30;
            SRT_end(trl,1:length(tempend)) = tempend - ASL_DELAY + 30;
        else
            SRT(trl,1:length(tempbegin)) = tempbegin + 30;
            SRT_end(trl,1:length(tempend)) = tempend + 30;
        end
    else
        SRT(trl,1) = NaN;
        SRT_end(trl,1) = NaN;
        saccLoc(trl,1) = NaN;
        deltaX(trl,1) = NaN;
        deltaY(trl,1) = NaN;
    end
end