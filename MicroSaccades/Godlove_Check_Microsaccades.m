function Check_Microsaccades(TrialStart_,EyeX_,EyeY_,SaccBegin,SaccEnd,SaccAmplitude,SaccVelocity,radial_vel,micro_logic,vel_x,vel_y,thresh_x,thresh_y,thresh_cross)

% must transpose so that adjacent saccades end up next to each other.
TrialStart_   = TrialStart_';
SaccBegin     = SaccBegin';
SaccEnd       = SaccEnd';
SaccAmplitude = SaccAmplitude';
SaccVelocity  = SaccVelocity';
radial_vel    = radial_vel';
micro_logic   = micro_logic';
vel_x         = vel_x';
vel_y         = vel_y';
thresh_x      = thresh_x';
thresh_y      = thresh_y';
thresh_cross  = thresh_cross';

all_thetas = 0:.01:2*pi;




tstart_array = repmat(TrialStart_,length(SaccBegin(:,1)),1);

sacc_starts = SaccBegin + tstart_array;
sacc_ends   = SaccEnd   + tstart_array;


[sacc_nums trials] = find(micro_logic);

figure('color',[1 1 1])
maximize

for ii = 1:length(sacc_nums)
    
    curr_sacc = sacc_nums(ii);
    curr_trl = trials(ii);
    
    %----------------------------------------------------------------------
    % Main Sequence
    subplot(2,2,1)
    hold off
    plot(SaccAmplitude,SaccVelocity,'ko','markersize',2)
    set(gca,'xscale','log','yscale','log','box','off')
    hold on
    plot(SaccAmplitude(curr_sacc,curr_trl),SaccVelocity(curr_sacc,curr_trl),...
        'ro','markersize',6,'markerfacecolor','r')
    
    
    %----------------------------------------------------------------------
    % Trajectory
    subplot(2,2,2)
    start  = sacc_starts(curr_sacc,curr_trl);
    end_   = sacc_ends(curr_sacc,curr_trl);
    sacc_x = EyeX_(start-50:start+50);
    sacc_y = EyeY_(start-50:start+50);
    hold off
    plot(sacc_x,sacc_y,...
        'ko','markersize',6)
    hold on
    plot_scale = 1; %MAY CHANGE TO DYNAMICALY RESCALE
    x_zero = EyeX_(start);
    y_zero = EyeY_(start);
    xlim([x_zero - plot_scale x_zero + plot_scale])
    ylim([y_zero - plot_scale y_zero + plot_scale])
    plot([x_zero x_zero],ylim,'k')
    plot(xlim,[y_zero y_zero],'k')
    sacc_x = EyeX_(start:end_);
    sacc_y = EyeY_(start:end_);
    plot(sacc_x,sacc_y,...
        'ro','markersize',6)
    set(gca,'box','off')    
    
    
    %----------------------------------------------------------------------
    % Horizontal
    time = -50:50;
    subplot(6,2,8)
    sacc_x = EyeX_(start-50:start+50);
    hold off
    plot(time,sacc_x,'k','linewidth',2)
    hold on
    sacc_x = EyeX_(start:end_);
    time = 0:length(sacc_x)-1;
    plot(time,sacc_x,'r','linewidth',2)
    xlim([-50 50])
    set(gca,'box','off')
    
    
    
    %----------------------------------------------------------------------
    % Vertical
    time = -50:50;
    subplot(6,2,10)
    sacc_y = EyeY_(start-50:start+50);
    hold off
    plot(time,sacc_y,'k','linewidth',2)
    hold on
    sacc_y = EyeY_(start:end_);
    time = 0:length(sacc_y)-1;
    plot(time,sacc_y,'r','linewidth',2)
    xlim([-50 50])
    set(gca,'box','off')
    
    
    
    %----------------------------------------------------------------------
    % Velocity
    time = -50:50;
    subplot(6,2,12)
    curr_array_start = SaccBegin(curr_sacc,curr_trl);
    curr_array_end = SaccEnd(curr_sacc,curr_trl);
    if curr_array_start > 50
        vel_xy = radial_vel(curr_array_start-50:curr_array_start+50,curr_trl);
        hold off
        plot(time,vel_xy,'k','linewidth',2)
        hold on
        vel_xy = radial_vel(curr_array_start:curr_array_end,curr_trl);
        time = 0:length(vel_xy)-1;
        plot(time,vel_xy,'r','linewidth',2)
        xlim([-50 50])
        set(gca,'box','off')
    end
    
        
    
    %----------------------------------------------------------------------
    % Furball
    subplot(2,2,3)
    curr_thresh_x = thresh_x(1,curr_trl);
    curr_thresh_y = thresh_y(1,curr_trl);
    all_rhos = ellipse_rho(curr_thresh_x,curr_thresh_y,all_thetas);
    [x y] = pol2cart(all_thetas,all_rhos);
    curr_cross = thresh_cross(:,curr_trl);
    curr_x = vel_x(:,curr_trl);
    curr_y = vel_y(:,curr_trl);
    hold off
    plot(x,y,'k:')
    hold on
    plot(curr_x,curr_y,'color',[.5 .5 .5])
    curr_x(~curr_cross) = nan;
    curr_y(~curr_cross) = nan;
    plot(curr_x,curr_y,'k','linewidth',2)
    curr_x(1:curr_array_start-1) = nan;
    curr_x(curr_array_end+1:end) = nan;
    curr_y(1:curr_array_start-1) = nan;
    curr_y(curr_array_end+1:end) = nan;
    plot(curr_x,curr_y,'r','linewidth',2)
    xlim([-15 15])
    ylim([-15 15])
    set(gca,'box','off')
    
     
    
%     y_n = input('Is it a saccade? Y/N [Y]:\n','s');
%     
%     if isempty(y_n)
%         y_n = 'y';
%     end

    pause
    
end