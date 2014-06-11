function [] = rescale_subplots(figure_handle,subplot_arrangement,axis_to_scale,exceptions)
%=======================================================================
% Rescales all subplots in figure specified in figure_handle (e.g.,
% figure(1)
%
% subplot_arrangement is the matrix of subplots used in the figure (e.g.,
% [2 2] for a 2 x 2 subplot
%
% axis_to_scale specifies which axes you want to scale: takes xy, y, x, and
% c.  To do xy & c, have to use separate calls (default is to scale both x
% and y)
%
% exceptions is a vector of subplot positions to exclude.  For instance, if
% you have a 3 x 3 grid with the center (position 5) empty, everything will
% be rescaled to [0 1].  We can exclude consideration of that position by
% giving [5] to exceptions (default is no exceptions).
%========================================================================

if nargin < 3
    axis_to_scale = 'xy'; %scale both x and y axes
    exceptions = [99999]; %just set it to strange number
end

if nargin < 4
    exceptions = [99999];
end


%activate current figure

figure_handle;

if axis_to_scale == 'xy'
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            ax_y(curPlot,1:2) = get(gca,'ylim');
            ax_x(curPlot,1:2) = get(gca,'xlim');
        end
    end
    
    %rescale based on min and max
    
    newmin_y = min(ax_y(:,1));
    newmax_y = max(ax_y(:,2));
    newmin_x = min(ax_x(:,1));
    newmax_x = max(ax_x(:,2));
    
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            set(gca,'xlim',[newmin_x newmax_x])
            set(gca,'ylim',[newmin_y newmax_y])
        end
    end
    
    
    
elseif axis_to_scale == 'x'
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            ax_x(curPlot,1:2) = get(gca,'xlim');
        end
    end
    
    
    newmin_x = min(ax_x(:,1));
    newmax_x = max(ax_x(:,2));
    
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            set(gca,'xlim',[newmin_x newmax_x])
        end
    end
    
    
elseif axis_to_scale == 'y'
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            ax_y(curPlot,1:2) = get(gca,'ylim');
        end
    end
    
    newmin_y = min(ax_y(:,1));
    newmax_y = max(ax_y(:,2));
    
    
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            set(gca,'ylim',[newmin_y newmax_y])
        end
    end
    
    
    
elseif axis_to_scale == 'c'
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            ax_c(curPlot,1:2) = get(gca,'clim');
        end
    end
    
    newmin_c = min(ax_c(:,1));
    newmax_c = max(ax_c(:,2));
    
    
    for curPlot = 1:(subplot_arrangement(1)*subplot_arrangement(2))
        if ~ismember(exceptions,curPlot)
            subplot(subplot_arrangement(1),subplot_arrangement(2),curPlot)
            set(gca,'clim',[newmin_c newmax_c])
        end
    end
    
    
end