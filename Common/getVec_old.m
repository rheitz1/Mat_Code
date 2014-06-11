function [stats,position,alpha] = getVec(EyeX_,EyeY_,SRT,plotFlag,removeOutliers,varargin)
% Returns and plots angular statistics
%
% pos.X, pos.Y:
% returns position information including the X/Y AD values (not
% normalized) from time 0 (target onset) to 100 ms after Saccade
% pos.deltaX, pos.deltaY:
% returns the change in eye position. Calculated as mean eye
% position -100:0 subtracted from mean eye position SRT+100:SRT+200
% that is, the eye position 100 ms after saccade to 200 ms after
% saccade (this makes sense since at SRT, the eye has not yet
% landed in its final location; as well, once it has, monkey must
% maintain fixation there for hundreds of ms).

% stats.mean, stats.median:
% average/median saccade vector in radians (not equivalent to algebraic mean
% because needs to be mod 360
% stats.var, stats.std, stats.std_mardia:
% variance and standard dev of angles in radians. variance of
% angles is monotonically related to the *length* of the average
% vector, which is given by stats.mean:  std = sqrt(2*(1-r))
% stats.r
% length of average vector in proportion of unit circle. Ranges
% from 0 to 1
% alpha
% actual angles for each trial in radians
%
% NOTE: if you send getVec a single vector of trial indices that COMBINES
% multiple screen locations, you also need to set 'removeOutliers' to 0.
% Otherwise, when it tries to eliminate outliers, it will remove most of the
% trials.
%
% RPH

    
%do not remove outliers if no extra arguments; assume just want to see
%distribution of all trials

if nargin < 6; varargin = {1:size(EyeX_,1)}; end
if nargin < 5; removeOutliers = 0; end
if nargin < 4; plotFlag = 0; end

Target_ = evalin('caller','Target_');

%try to get Gains variable, if it exists
try
    Gains_EyeX = evalin('base','Gains_EyeX');
    Gains_EyeY = evalin('base','Gains_EyeY');
end
try
    Gains_EyeX = evalin('caller','Gains_EyeX');
    Gains_EyeY = evalin('caller','Gains_EyeY');
end

%check to see if any eye signals need to be inverted
if exist('Gains_EyeX') == 1
    if Gains_EyeX(1) < 0
        %disp('Inverting X Eye channel')
        EyeX_ = -EyeX_;
    end
    
    if Gains_EyeY(1) < 0
        %disp('Inverting Y Eye channel')
        EyeY_ = -EyeY_;
    end
end

    
%make sure SRT variable doesn't contain any decimals
SRT = round(SRT);

nVar = length(varargin);

%initialize alpha.  set to NaNs so missing alpha values across variables is
%not 0.  Need to access length of each variable.
nMaxTrls = max(cellfun(@length,varargin));
alpha(1:nMaxTrls,1:nVar) = NaN;
position.deltaX(1:nMaxTrls,1:nVar) = NaN;
position.deltaY(1:nMaxTrls,1:nVar) = NaN;

%Preallocate
pos.X(1:size(EyeX_,1),1:151) = NaN;
pos.Y(1:size(EyeX_,1),1:151) = NaN;


%==========================================================
% Get eye movement information
%seekWindow = 50;
for trl = 1:size(EyeX_,1)
    if ~isnan(SRT(trl,1)) & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        pos.X(trl,1:151) = EyeX_(trl,SRT(trl,1) + Target_(1,1) - 50:SRT(trl,1) + Target_(1,1) + 100);
        pos.Y(trl,1:151) = EyeY_(trl,SRT(trl,1) + Target_(1,1) - 50:SRT(trl,1) + Target_(1,1) + 100);
        
        
        %NOTE: THIS SHOULD BE CHANGED TO A FEW MS BEFORE THE ACTUAL SACCADE
        loc_start_X = mean(EyeX_(trl,Target_(1,1)-100:Target_(1,1)));
        loc_start_Y = mean(EyeY_(trl,Target_(1,1)-100:Target_(1,1)));
        loc_end_X = mean(EyeX_(trl,SRT(trl,1)+Target_(1,1)+100:SRT(trl,1)+Target_(1,1)+200));
        loc_end_Y = mean(EyeY_(trl,SRT(trl,1)+Target_(1,1)+100:SRT(trl,1)+Target_(1,1)+200));
        
        pos.deltaX(trl,1) = loc_end_X - loc_start_X;
        pos.deltaY(trl,1) = loc_end_Y - loc_start_Y;
        
        angle_deg(trl,1) = mod((180/pi*atan2(loc_end_Y-loc_start_Y,loc_end_X-loc_start_X)),360);
        angle_rad(trl,1) = deg2rad(angle_deg(trl,1));
    else
        pos.X(trl,:) = NaN;
        pos.Y(trl,:) = NaN;
        pos.deltaX(trl,1) = NaN;
        pos.deltaY(trl,1) = NaN;
        angle_deg(trl,1) = NaN;
        angle_rad(trl,1) = NaN;
    end
end

alph = angle_rad;


%convert 0's (missing values) to NaN;
pos.X(find(pos.X == 0)) = NaN;
pos.Y(find(pos.Y == 0)) = NaN;

%remove extreme outliers from alpha and position values

for var = 1:nVar
    %================
    %for angles (alpha)
    temp = alph(varargin{var});
    temp_deg = rad2deg(temp);
    
    
    %alter any angle > 340 degrees to negative angles
    if ~isempty(find(temp_deg >= 340))
        disp('Found angles >= 340 degrees; changing to negative angles')
        temp_deg(find(temp_deg >= 340)) = -1*mod(360,temp_deg(find(temp_deg >= 340)));
        temp = deg2rad(temp_deg);
    end
    
    
    if removeOutliers
        %find mean & standard deviation of alpha value; remove those that are
        %> x degrees from mean angle
        
        % Changed to median instead of mean because a few values can skew data, resulting in too many
        % eliminated trials 3/7/11 RPH
        ub = nanmedian(temp_deg) + 15;%nanstd(temp)*2;
        lb = nanmedian(temp_deg) - 15;%nanstd(temp)*2;
        
        disp(['Removing ' mat2str(length(find(temp_deg < lb | temp_deg > ub))) ' trials'])
        temp_deg(find(temp_deg < lb | temp_deg > ub)) = NaN;
        temp = deg2rad(temp_deg);
    else
        disp('Not removing outliers')
    end
    
    alpha(1:length(alph(varargin{var})),var) = temp;
    clear ub lb temp
    %================
    
    
    %================
    % for deltaX and deltaY
    tempX = pos.deltaX(varargin{var});
    tempY = pos.deltaY(varargin{var});
    
    
    if removeOutliers
        %remove values > 3 sd from mean
        ub_X = nanmean(tempX) + nanstd(tempX)*3;
        lb_X = nanmean(tempX) - nanstd(tempX)*3;
        
        ub_Y = nanmean(tempY) + nanstd(tempY)*3;
        lb_Y = nanmean(tempY) - nanstd(tempY)*3;
        
        tempX(find(tempX < lb_X | tempX > ub_X)) = NaN;
        tempY(find(tempY < lb_Y | tempY > ub_Y)) = NaN;
    end
    
    
    position.deltaX(1:length(tempX),var) = tempX;
    position.deltaY(1:length(tempY),var) = tempY;
    
    
    %==========================================
    % calculate conversion factor.
    
    Target_ = evalin('caller','Target_');
    Correct_ = evalin('caller','Correct_');
    
    %if more than one eccentricity used during experiment, logic will fail
    % also, if there are too few trials in a condition, statistics will be
    % biased.
    
    
    if length(unique(Target_(:,12))) > 1
        disp('More than one eccentricity used in this file')
        stats.r(1,1:nVar) = NaN;
        stats.mean(1,1:nVar) = NaN;
        stats.median(1,1:nVar) = NaN;
        stats.var(1,1:nVar) = NaN;
        stats.std(1,1:nVar) = NaN;
        position.deltaX(1:length(tempX),1:nVar) = NaN;
        position.deltaY(1:length(tempY),1:nVar) = NaN;
        position.convX = NaN;
        position.convY = NaN;
        position.degX(1:length(position.deltaX),1:nVar) = NaN;
        position.degY(1:length(position.deltaY),1:nVar) = NaN;
        position.RT(1:length(position.deltaX),1:nVar) = NaN;
        return
    else
        ecc = Target_(1,12);
    end
    
    %to get conversion factors, we have to look at averages for positions 0
    % and 4 (X) and 2 and 6 (Y)
    
    p2_6 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[2 6]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    p0_4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[0 4]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    %use pos.deltaX and pos.deltaY because they contain values for ALL
    %trials, not just the condition(s) sent to varargin.  Use absolute
    %value because directions will be complementary.  Always results in
    %scalar so can probably be moved outside of loop
    position.convX = nanmean(abs(pos.deltaX(p0_4))) / ecc;
    position.convY = nanmean(abs(pos.deltaY(p2_6))) / ecc;
    
    %now convert to degrees
    position.degX(1:length(position.deltaX(:,var)),var) = position.deltaX(:,var) / position.convX;
    position.degY(1:length(position.deltaY(:,var)),var) = position.deltaY(:,var) / position.convY;
    
    
    position.RT(1:length(tempX),var) = SRT(varargin{var});
    
    clear ub_X ub_Y lb_X lb_Y tempX tempY
    
    %================
    
    
end

%==========================================================
% Get stats based on unit circle
for var = 1:nVar
    if ~isempty(alpha(~isnan(alpha(:,var)),var))
        temp = circ_stats(alpha(~isnan(alpha(:,var)),var));
        stats.r(1,var) = circ_r(alpha(~isnan(alpha(:,var)),var)); %extreme outliers already removed at this point
        
        stats.mean(1,var) = temp.mean;
        stats.median(1,var) = temp.median;
        stats.var(1,var) = temp.var;
        stats.std(1,var) = temp.std;
        
        %stats.angle_rad(1:length(angle_rad),var) = angle_rad(varargin{var});
        clear temp
    else
        stats.r(1,var) = NaN;
        stats.mean(1,var) = NaN;
        stats.median(1,var) = NaN;
        stats.var(1,var) = NaN;
        stats.std(1,var) = NaN;
        
    end
end
%=========================================================






%==========================================================
% PLOTTING

color = {'k','b','r','g','m','y','b','r','g','k','m','y'};
scattstyle = {'ko','bo','ro','go','mo','yo','bo','ro','go' 'ko','mo','yo'};
plotstyle = {'-k','-b','-r','-g','-m','-y','-b','-r','-g','-k','-m','-y'};

if plotFlag == 1
    %will fail if more than 12 conditions, so abort plotting in this case
    %even if plotFlag 1
    
    if nVar > 12
        disp('Witholding plots')
        return
    end
    
    figure
    
    subplot(2,2,1)
    fon

    for var = 1:nVar
        circ_plot(alpha(~isnan(alpha(:,var)),var),'pretty',scattstyle{var},true,'color',color{var});
        hold on
    end
    title('Saccade Angles on Unit Circle')
    
    
    subplot(2,2,2)
    fon
    hold
    for var = 1:nVar
        %scatter(position.deltaX(~isnan(alpha(:,var)),var),position.deltaY(~isnan(alpha(:,var)),var),'markeredgecolor',color{var})
        scatter(position.degX(~isnan(alpha(:,var)),var),position.degY(~isnan(alpha(:,var)),var),'markeredgecolor',color{var})
    end
    poslims = max([position.degX(:) ; position.degY(:)]);
    neglims = min([position.degX(:) ; position.degY(:)]);
    lims = max(abs(poslims),abs(neglims)) + 1;
    xlim([-lims lims])
    ylim([-lims lims])
    vline(0,'k')
    hline(0,'k')
    title('Endpoint Scatter')
    xlim([-10 10])
    ylim([-10 10])
    
    
    %to convert saccade trajectories to normalized scale, just baseline
    %correct.  Should tend to keep fixation position around 0
    x = baseline_correct(pos.X,[1 10]);
    y = baseline_correct(pos.Y,[1 10]);
    
    x = x ./ position.convX;
    y = y ./ position.convY;
    
    subplot(2,2,3)
    fon
    hold
    for var = 1:nVar
        alltrials = varargin{var};
        trials = alltrials(~isnan(alpha(:,var)));
        
        for trl = 1:length(trials)
            plot(x(trials(trl),:),y(trials(trl),:),plotstyle{var})
        end
        
        poslims = max([position.degX(:) ; position.degY(:)]);
        neglims = min([position.degX(:) ; position.degY(:)]);
        lims = max(abs(poslims),abs(neglims)) + 1;
        xlim([-lims lims])
        ylim([-lims lims])
        
        vline(0,'k')
        hline(0,'k')
        title('Corrected Saccade Trajectories')
        xlim([-10 10])
        ylim([-10 10])
    end
    
    
    subplot(2,2,4)
    fon
    hold
    for var = 1:nVar
        trials = varargin{var};
        %if there are NaNs in position vector, will fail.  Remove (paired
        %for X and Y)
        elip(:,1) = position.degX(~isnan(alpha(:,var)),var);
        elip(:,2) = position.degY(~isnan(alpha(:,var)),var);
        elip = removeNaN(elip);
        [ellipse_x ellipse_y] = plotEllipse(elip(:,1),elip(:,2));
        scatter(position.degX(~isnan(alpha(:,var)),var),position.degY(~isnan(alpha(:,var)),var),'markeredgecolor',color{var})
        scatter(ellipse_x,ellipse_y,color{var})
        clear elip
        xlim([-10 10])
        ylim([-10 10])
    end
    
end