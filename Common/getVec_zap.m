function [stats,pos,alpha] = getVec_zap(EyeX_,EyeY_)

%USE FOR MICROSTIM 'ZAP' FILES, SACCADES ELICITED IN THE DARK

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
        % maintain fixation there for hundreds of ms.

% stats.mean, stats.median:
        %average/median saccade vector in radians (not equivalent to algebraic mean
        %because needs to be mod 360
% stats.var, stats.std, stats.std_mardia:
        % variance and standard dev of angles in radians. variance of
        % angles is monotonically related to the *length* of the average
        % vector, which is given by stats.mean:  std = sqrt(2*(1-r))
% stats.r
        % length of average vector in proportion of unit circle. Ranges
        % from 0 to 1
% alpha
        %actual angles for each trial in radians

%HARD CODING TARGET_
Target_(1:size(EyeX_,1),1) = 200; %200 ms baseline from Translate_zap.m

%HARD CODING SRT THRESHOLD
%SRT = getSRT(EyeX_,EyeY_,0,'XXX',2e-3);
SRT = evalin('caller','SRT')
SRT(:,1)
        
EyeY_ = -EyeY_;

%make sure SRT variable doesn't contain any decimals
SRT = round(SRT);

if nargin < 4
    varargin = {1:size(EyeX_,1)};
end

plotFlag = 1;
nVar = length(varargin);



%alter Eye information based on TEMPO gain settings
%need to do this to compute saccade direction vectors
% if ASL_Delay == 0
%     EyeX_gain = EyeX_;%*14;
%     EyeX_gain = EyeX_; %+ EyeY_*1;
%
%     EyeY_gain = EyeY_;%*14;
%     EyeY_gain = EyeY_;% + EyeX_*1;
% elseif ASL_Delay == 1
%     EyeX_gain = EyeX_ * 14;
%     EyeY_gain = EyeY_ * 12;
% end



%Preallocate
pos.X(1:size(EyeX_,1),1:max(SRT(:,1))+10) = NaN;
pos.Y(1:size(EyeX_,1),1:max(SRT(:,1))+10) = NaN;


%==========================================================
% Get eye movement information
seekWindow = 10;
for trl = 1:size(EyeX_,1)
    if ~isnan(SRT(trl,1)) 
        pos.X(trl,1:length(EyeX_(trl,SRT(trl,1) + Target_(1,1) - 10:SRT(trl,1) + Target_(1,1)  + seekWindow))) = EyeX_(trl,SRT(trl,1) + Target_(1,1) - 10:SRT(trl,1) + Target_(1,1)  + seekWindow);
        pos.Y(trl,1:length(EyeY_(trl,SRT(trl,1) + Target_(1,1) - 10:SRT(trl,1) + Target_(1,1)  + seekWindow))) = EyeY_(trl,SRT(trl,1) + Target_(1,1) - 10:SRT(trl,1) + Target_(1,1)  + seekWindow);
        
        loc_start_X = mean(EyeX_(trl,1:10));
        loc_start_Y = mean(EyeY_(trl,1:10));
        loc_end_X = mean(EyeX_(trl,SRT(trl,1) + Target_(1,1):SRT(trl,1) + Target_(1,1) + seekWindow));
        loc_end_Y = mean(EyeY_(trl,SRT(trl,1) + Target_(1,1):SRT(trl,1) + Target_(1,1) + seekWindow));
        
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

alpha = angle_rad;
%==========================================================


%=========================================================
% Find maximum curvature (deviation of angles) by sequentially stepping
% through the saccade, using each successive location as the starting
% point, and the average of the endpoints as the endpoint.  Each angle
% (based on unit circle) is then a measure of the deviation.
% for trl = 1:size(EyeX_,1)
%     x = baseline_correct(pos.X(trl,:),[1 10]);
%     y = baseline_correct(pos.Y(trl,:),[1 10]);
%     
%     if ~isnan(SRT(trl,1))
%         for time = 1:length(SRT(trl,1)-5:SRT(trl,1)+20)
%             dx = x(SRT(trl,1)+20) - x(SRT(trl,1)-5 + time);
%             dy = y(SRT(trl,1)+20) - y(SRT(trl,1)-5 + time);
%             dev_ang(trl,time) = mod((180/pi*atan2(dy,dx)),360);
%         end
%     else
%         dx = NaN;
%         dy = NaN;
%         dev_ang(trl,time) = NaN;
%     end
% end


%convert 0's (missing values) to NaN;
pos.X(find(pos.X == 0)) = NaN;
pos.Y(find(pos.Y == 0)) = NaN;


%==========================================================
% Get stats based on unit circle
for var = 1:nVar
    
    temp = circ_stats(removeNaN(angle_rad));
    
    stats.mean(1,var) = temp.mean;
    stats.median(1,var) = temp.median;
    stats.var(1,var) = temp.var;
    stats.std(1,var) = temp.var;
   % stats.std_mardia(1,var) = temp.std_mardia;
    stats.r(1,var) = circ_r(angle_rad(varargin{var}));
    %stats.angle_rad(1:length(angle_rad),var) = angle_rad(varargin{var});
    clear temp
end
%=========================================================






%==========================================================
% PLOTTING

color = {'b','r','g','k','m'};
scattstyle = {'bo','ro','go' 'ko','mo'};
plotstyle = {'-b','-r','-g','-k','-m'};

if plotFlag == 1
    figure
    
    subplot(2,2,1)
    fon
    hold
    for var = 1:nVar
        circ_plot(removeNaN(angle_rad),'pretty',scattstyle{var},true,'color',color{var})
    end
    title('Saccade End Points on Unit Circle')
    
    
    subplot(2,2,2)
    fon
    hold
    k = [pos.deltaX pos.deltaY];
    k = removeNaN(k);
    for var = 1:nVar
        scatter(k(:,1),k(:,2),'markeredgecolor',color{var})
    end
    %         poslims = max([position.degX(:) ; position.degY(:)]);
    %         neglims = min([position.degX(:) ; position.degY(:)]);
%     lims = max(abs(poslims),abs(neglims)) + .1;
%     xlim([-lims lims])
%     ylim([-lims lims])
    vline(0,'k')
    hline(0,'k')
    title('Endpoint Scatter')
    
    
    
    %to convert saccade trajectories to normalized scale, just baseline
    %correct.  Should tend to keep fixation positino around 0
    x = baseline_correct(pos.X,[1 10]);
    y = baseline_correct(pos.Y,[1 10]);
    
    subplot(2,2,3)
    fon
    hold
    for var = 1:nVar
        trials = varargin{var};
        for trl = 1:length(trials)
            plot(x(trials(trl),:),y(trials(trl),:),plotstyle{var})
        end
        
        %in raw voltages.  EyeX_ and EyeY_ seem to be bounded at +/- 2.5V
%         xlim([-3 3])
%         ylim([-3 3])
        
        vline(0,'k')
        hline(0,'k')
        title('Corrected Saccade Trajectories')
    end
    
    
    subplot(2,2,4)
    fon
    hold
    for var = 1:nVar
        trials = varargin{var};
        [ellipse_x ellipse_y] = plotEllipse(pos.deltaX(varargin{var}),pos.deltaY(varargin{var}));
        scatter(pos.deltaX(varargin{var}),pos.deltaY(varargin{var}),'markeredgecolor',color{var})
        scatter(ellipse_x,ellipse_y,color{var})
    end

end