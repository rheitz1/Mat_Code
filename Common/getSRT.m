function [SRT,saccLoc,SRT_end] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey,thresh)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to return SRT values and saccade endpoint
% locations estimated from eye traces
%
% 9/27/07
%
% 2/29/08 added saccade direction calculation RPH
%
% 10/29/09 improved saccade direction calculation using getVec code, which
% in turn requires the circular statistics toolbox.
%
%
% Richard P. Heitz
% Vanderbilt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Target_ = evalin('caller','Target_');
if nargin < 3 %if not specified, check back with caller
    
    
    try
        newfile = evalin('base','newfile');
        Target_ = evalin('base','Target_');
    catch
        newfile = evalin('caller','newfile');
        Target_ = evalin('caller','Target_');
    end
    
    if length(newfile) == 23 %new naming convention: year/month/day
        mo = str2num(newfile(6:7));
        yr = str2num(newfile(4:5));
    else
        mo = str2num(newfile(2:3));
        yr = str2num(newfile(6:7));
    end
    
    monkey = newfile(1);
    ASL_Delay = 0;
    
    %determine date recorded to set ASL_Delay
    
    
    
    %Eye tracker was used with S from early 07 until 3/08.  Files older
    %than that and files newer than that used eye coil.
    if monkey == 'S' & yr == 8 & mo < 4
        ASL_Delay = 1;
    elseif monkey == 'S' & yr == 7
        ASL_Delay = 1;
    else
        ASL_Delay = 0;
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
    if ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr < 10
        thresh = 8e-5%.00008
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr <= 10 & mo < 8
        thresh = 8e-5%.00008
        %thresh = .000016 %use to pick up half-assed saccades
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr >= 10 & mo >= 8
        thresh = 5e-3%.005
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr >= 11
        thresh = 5e-3
    elseif ASL_DELAY_CORRECTION == 1 & monkey == 'S'
        %Seymour w/ eye tracker
        thresh = 6e-4%.0006
        disp('ASL Delay correction active')
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & yr > 5 & yr < 9
        disp('Seymour basic T/L task detected')
        thresh = 7e-6 %.000007
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & yr >= 9 & yr < 11
        disp('Seymour uStim Data Set Detected')
        thresh = 5e-6 %.000005
    elseif monkey == 'S' && yr == 5
        disp('Seymour Woodman EEG-only dataset detected')
        thresh = 4e-5
    elseif monkey == 'S' && yr >= 11
        thresh = 5e-3
        %thresh = 2e-3
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'P'
        thresh = 3e-5
        disp('Pep data set detected')
    elseif monkey=='F';
        nTrls=size(absXY,1);
        pct75=nan(nTrls,1);
        for trl=1:nTrls
            pct75(trl)=prctile(absXY(trl,:),75);
        end
        thresh=100*nanmedian(pct75)
    elseif monkey=='E';
        thresh = 2e-3
    elseif monkey=='D';
        thresh = 2e-3
    elseif monkey == 'Z';
        thresh = 2e-3
    end
else
    disp('Using manually set threshold...')
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
    
    tempbegin = find(diff_saccMat(Trials(trl),Target_(1,1)+30:end) == 1);
    tempend = find(diff_saccMat(Trials(trl),Target_(1,1)+30:end) == -1);
    
    if ~isempty(tempbegin) && ~isempty(tempend) && tempbegin(1) > 0 && tempbegin(1) <= 2300 && tempend(1) > 0 && tempend(1) < 2300
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Set actual SRT times, and correct if necessary
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %note: no need to subtract 500 ms because we begin our search at 500
        %add 30 because we start search at 530 to eliminate trials with
        %saccade artifacts near time 0.
        if ASL_DELAY_CORRECTION == 1
            SRT(trl,1:length(tempbegin)) = tempbegin - ASL_DELAY + 30;
            SRT_end(trl,1:length(tempend)) = tempend - ASL_DELAY + 30;
        else
            SRT(trl,1:length(tempbegin)) = tempbegin + 30;
            SRT_end(trl,1:length(tempend)) = tempend + 30;
        end
    else
        SRT(trl,1) = NaN;
        SRT_end(trl,1) = NaN;
        
    end
end


%======================================================================
% find saccade locations

% angles for a given screen location not constant between monkeys and
% even across days.  For each screen location, find mean angle using
% correct trials, then define a region that we will take as
% acceptable for all trials.
% Use this to determine saccade directions for the rest of
% the trials (e.g., errors)

if nargout > 1 %do only if output is requested
    try
        Target_ = evalin('base','Target_');
        Correct_ = evalin('base','Correct_');
    catch
        Target_ = evalin('caller','Target_');
        Correct_ = evalin('caller','Correct_');
    end
    
    %find relevant CORRECT trials
    pos0 = find(Correct_(:,2) ==1 & Target_(:,2) == 0 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos1 = find(Correct_(:,2) ==1 & Target_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos2 = find(Correct_(:,2) ==1 & Target_(:,2) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos3 = find(Correct_(:,2) ==1 & Target_(:,2) == 3 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos4 = find(Correct_(:,2) ==1 & Target_(:,2) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos5 = find(Correct_(:,2) ==1 & Target_(:,2) == 5 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos6 = find(Correct_(:,2) ==1 & Target_(:,2) == 6 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    pos7 = find(Correct_(:,2) ==1 & Target_(:,2) == 7 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    % get mean and variability of angles.  note: these measurements
    % disregard extreme outliers
    [stats.pos0 pos.pos0 alpha.pos0] = getVec(EyeX_,EyeY_,SRT,0,1,pos0);
    [stats.pos1 pos.pos1 alpha.pos1] = getVec(EyeX_,EyeY_,SRT,0,1,pos1);
    [stats.pos2 pos.pos2 alpha.pos2] = getVec(EyeX_,EyeY_,SRT,0,1,pos2);
    [stats.pos3 pos.pos3 alpha.pos3] = getVec(EyeX_,EyeY_,SRT,0,1,pos3);
    [stats.pos4 pos.pos4 alpha.pos4] = getVec(EyeX_,EyeY_,SRT,0,1,pos4);
    [stats.pos5 pos.pos5 alpha.pos5] = getVec(EyeX_,EyeY_,SRT,0,1,pos5);
    [stats.pos6 pos.pos6 alpha.pos6] = getVec(EyeX_,EyeY_,SRT,0,1,pos6);
    [stats.pos7 pos.pos7 alpha.pos7] = getVec(EyeX_,EyeY_,SRT,0,1,pos7);
    
    %now get vector of alpha values for ALL TRIALS.  note that these do NOT
    %eliminate extreme outliers; here we just want the angle for each
    %trial.
    [stats.all pos.all alpha.all] = getVec(EyeX_,EyeY_,SRT,0);
    
    % define window of x degrees around mean to define angles.  Anything
    % outside of this (falling in an undefined area) will be NaN
    tol = deg2rad(10);
    
    
    %don't use stats.mean because will represent some angles as negative.
    %use alpha values
    ub.pos0 = nanmean(alpha.pos0) + tol;
    ub.pos1 = nanmean(alpha.pos1) + tol;
    ub.pos2 = nanmean(alpha.pos2) + tol;
    ub.pos3 = nanmean(alpha.pos3) + tol;
    ub.pos4 = nanmean(alpha.pos4) + tol;
    ub.pos5 = nanmean(alpha.pos5) + tol;
    ub.pos6 = nanmean(alpha.pos6) + tol;
    ub.pos7 = nanmean(alpha.pos7) + tol;
    
    lb.pos0 = nanmean(alpha.pos0) - tol;
    lb.pos1 = nanmean(alpha.pos1) - tol;
    lb.pos2 = nanmean(alpha.pos2) - tol;
    lb.pos3 = nanmean(alpha.pos3) - tol;
    lb.pos4 = nanmean(alpha.pos4) - tol;
    lb.pos5 = nanmean(alpha.pos5) - tol;
    lb.pos6 = nanmean(alpha.pos6) - tol;
    lb.pos7 = nanmean(alpha.pos7) - tol;
    
    
    %Preallocate
    saccLoc(1:size(EyeX_,1),1) = NaN;
    
    saccLoc(find(alpha.all >= lb.pos0 & alpha.all <= ub.pos0)) = 0;
    saccLoc(find(alpha.all >= lb.pos1 & alpha.all <= ub.pos1)) = 1;
    saccLoc(find(alpha.all >= lb.pos2 & alpha.all <= ub.pos2)) = 2;
    saccLoc(find(alpha.all >= lb.pos3 & alpha.all <= ub.pos3)) = 3;
    saccLoc(find(alpha.all >= lb.pos4 & alpha.all <= ub.pos4)) = 4;
    saccLoc(find(alpha.all >= lb.pos5 & alpha.all <= ub.pos5)) = 5;
    saccLoc(find(alpha.all >= lb.pos6 & alpha.all <= ub.pos6)) = 6;
    saccLoc(find(alpha.all >= lb.pos7 & alpha.all <= ub.pos7)) = 7;
    
    
end
