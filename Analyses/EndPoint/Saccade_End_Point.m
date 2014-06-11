% Script to find endpoints of saccades during visual search

function [deltax, deltay] = Saccade_End_Point(EyeX_, EyeY_, Target_, Correct_, newfile)



    
   
   newEyeX_ = EyeX_(find(Target_(:,2)==7 & Correct_(:,2)==1),:); %Find correct trials with target at specified location
   newEyeY_ = EyeY_(find(Target_(:,2)==7 & Correct_(:,2)==1),:); %Find correct trials with target at specified location
   
   %newEyeX_ = EyeX_(find(Correct_(:,2)==1),:);
   %newEyeY_ = EyeY_(find(Correct_(:,2)==1),:);
   
   % Get ASL_Delay from getMonk script
   
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
    
    clear mo yr
   end
   % end of getMonk script
   
   %  Modified code from getSRT script
   
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
% 

if ASL_Delay == 1
    ASL_DELAY_CORRECTION = 1;
else
    ASL_DELAY_CORRECTION = 0;
end


%11/5/2007 Legacy code: used to return only SRTs for correct trials.
%Removed due to related problems.
Trials = linspace(1,size(newEyeX_,1),size(newEyeX_,1))';


%At 240Hz, 3 frames (ASL lags 3 frames) = (1000/240)*3 = 12.5
ASL_DELAY = 12.5;

nTrials = size(Trials,1);

SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial

smEyeX_= convn(newEyeX_',SMFilter,'same')';
% clear EyeX_

smEyeY_= convn(newEyeY_',SMFilter,'same')';
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
    thresh = .00001
elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & ~isempty(strmatch('MStim_',varlist,'exact'))
    thresh = 5e-6
    %thresh = .00001
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
if ASL_DELAY_CORRECTION == 0
    EyeX_gain = newEyeX_;%*14;
    EyeX_gain = newEyeX_; %+ EyeY_*1;

    EyeY_gain = newEyeY_;%*14;
    EyeY_gain = newEyeY_;% + EyeX_*1;
elseif ASL_DELAY_CORRECTION == 1
    EyeX_gain = newEyeX_ * 14;
    EyeY_gain = newEyeY_ * 12;
end

X_begin = [];
X_end = [];
Y_begin = [];
Y_end = [];

for trl = 1:size(diff_saccMat,1)

    tempbegin = find(diff_saccMat(Trials(trl),530:end) == 1);

    %find direction: take location 50 ms before eye movement and 50 ms
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

        X_begin(trl,:)= loc_start_X;
        X_end(trl,:) = loc_end_X;
        Y_begin(trl,:) = loc_start_Y;
        Y_end(trl,:) = loc_end_Y;
        
        
        
    end
end

deltax = X_end-X_begin;
deltay = Y_end-Y_begin;
figure
hold all
scatter(deltax,deltay)
%scatter(X_begin,Y_begin)
%scatter(X_end,Y_end)
xlim([-0.8, 0.8])
ylim([-0.8, 0.8])
origin = (0);
plot(origin,origin,'+k','MarkerSize',12)
title ('Target: All')
%legend('Start Location', 'End Location')
hold off



