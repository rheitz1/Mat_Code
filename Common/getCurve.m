function [deviation] = getCurve(EyeX_,EyeY_,SRT,plotFlag)

% gets saccade curvature in a number of different ways:
%   deviation.eachstep is the ms-by-ms angle considering only the portion
%       of the eye trace in which the eye is moving
%   deviation.maximim is the maximal deviation from a straight line
%   deviation.area = area under the curve in reference to a straight line,
%       calculated by making trace a polygon


%get Ending times of each saccade
[SRT saccLoc SRT_end] = getSRT(EyeX_,EyeY_);

%=========================================================
% Find maximum curvature (deviation of angles) by sequentially stepping
% through the saccade, using each successive location as the starting
% point, and the average of the endpoints as the endpoint.  Each angle
% (based on unit circle) is then a measure of the deviation.  Note that the
% 'x' and 'y' variable below is just the segment when eye is moving

%preallocate variable that will store the deviation angles for each step
deviation.eachstep(1:size(EyeX_,1),1:100) = NaN;

for trl = 1:size(EyeX_,1)
    if ~isnan(SRT(trl,1)) & ~isnan(SRT_end(trl,1))
        
        x = EyeX_(trl,SRT(trl,1)+500:SRT_end(trl,1)+500);
        y = EyeY_(trl,SRT(trl,1)+500:SRT_end(trl,1)+500);

        %get angle of each step in sequence
        for time = 1:length(x)-1
                   
            deviation.eachstep(trl,time) = mod((180/pi*atan2(y(time+1)-y(time),x(time+1)-x(time))),360);
        end         
    else
        deviation.eachstep(trl,:) = NaN;
    end
    
    %now determine straight line angle using first and last points
    straight_line = mod((180/pi*atan2(y(end)-y(1),x(end)-x(1))),360);
    
    %correct deviations based on calculated straight line
    deviation.eachstep(trl,:) = deviation.eachstep(trl,:) - straight_line;
    deviation.maximum(trl,1) = nanmax(deviation.eachstep(trl,:));
    deviation.area(trl,1) = polyarea(x,y);
end

%alter angles > 340 to negative or positive angles
deviation.eachstep(find(deviation.eachstep < 340)) = mod(360,deviation.eachstep(find(deviation.eachstep < 340)));
