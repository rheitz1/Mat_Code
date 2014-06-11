function [SRT] = getFIXtime(EyeX_,EyeY_,ASL_Delay,monkey,thresh)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This attempts to figure out when fixation was achieved
% using 'LongBase' files (has a 3500 ms baseline period).
% Will attempt to localize bg saccades before target onset.
% On those trials at least, we will know when fixation was
% approximately achieved.
%
% Richard P. Heitz
% Vanderbilt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin < 3 %if not specified, check back with caller
    
    
    try
        newfile = evalin('base','newfile');
    catch
        newfile = evalin('caller','newfile');
    end
    
    mo = str2num(newfile(2:3));
    yr = str2num(newfile(6:7));
    
    
    if newfile(1) == 'F'
        monkey = 'F';
        ASL_Delay = 0;
    elseif newfile(1) == 'Q'
        monkey = 'Q';
        ASL_Delay = 0;
    elseif newfile(1) == 'P'
        monkey = 'P';
        ASL_Delay = 0;
    elseif newfile(1) == 'S'
        
        monkey = 'S';
        %determine date recorded to set ASL_Delay
        
        
        
        %Eye tracker was used with S from early 07 until 3/08.  Files older
        %than that and files newer than that used eye coil.
        if yr == 8 & mo < 4
            ASL_Delay = 1;
        elseif yr == 7
            ASL_Delay = 1;
        else
            ASL_Delay = 0;
        end
    end
end

if ASL_Delay == 1
    ASL_DELAY_CORRECTION = 1;
else
    ASL_DELAY_CORRECTION = 0;
end


Trials = 1:size(EyeX_,1);

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
varlist = evalin('base','who');

if nargin < 5
    if monkey == 'Q'
        thresh = .003
    end
end


saccMat = zeros(size(absXY));
saccMat(find(absXY > thresh)) = 1;
%clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get saccade vector direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for trl = 1:size(diff_saccMat,1)
    
    tempbegin = find(diff_saccMat(Trials(trl),1:end) == 1);
    tempend = find(diff_saccMat(Trials(trl),1:end) == -1);
    
    if ~isempty(tempbegin)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Set actual SRT times, and correct if necessary
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        
        SRT(trl,1:length(tempbegin)) = tempbegin;
        
        
    else
        SRT(trl,1) = NaN;
        
        
    end
end



end
