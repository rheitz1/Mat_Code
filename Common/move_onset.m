function [onset] = move_onset(SDF,Plot_Time,p_crit,windowSize)
% find movement cell onset time through Spearman rank-order correlation
% requires 3rd party function 'spear'
% starts at saccade onset and moves backwards until correlation no longer
% significant at p < p using window size win

if nargin < 4
    windowSize = 40;
end

if nargin < 3
    windowSize = 40;
    p_crit = .05;
end


% onsetDetect = 0;
% step = 0;
% 
% %start at peak of SDF
% [peak peakind] = max(SDF);
% 
% %adjust so END of window is peak
% peakind = peakind - windowSize/2;

% while(~onsetDetect)
%     
%     cur_SDF = SDF(peakind - windowSize/2 + step:peakind + windowSize/2 + step);
%     [rval tval pval] = spear((1:length(cur_SDF))',cur_SDF');
%     
%     if pval > p_crit
%         onsetDetect = 1;
%     end
%     
%     step = step - 1;
% end

%we subtracted windowSize above to make end of window @ peak value
%here the beginning of the window is at the onset time.  Thus, they cancel
%out.
%onset = step;


% for windowLeftEdge = 1:1:length(SDF)-windowSize
%     [r(windowLeftEdge) t(windowLeftEdge) p(windowLeftEdge)] = spear((1:windowSize)',SDF(windowLeftEdge:windowLeftEdge+windowSize-1)');
% end
% 
% onset = min(findRuns(p > p_crit,10));
% 
% if isempty(onset)
%     onset = NaN;
% end

[peak peakind] = max(SDF);
peakind = peakind - windowSize/2;

p = ones(1000,1);
for windowRightEdge = peakind:-1:windowSize
    cur_SDF = SDF(windowRightEdge-windowSize+1:windowRightEdge);
    %[r(windowRightEdge,1) p(windowRightEdge,1)] = corr((1:windowSize)',cur_SDF');
    [r(windowRightEdge,1) t(windowRightEdge,1) p(windowRightEdge,1)] = spear((1:windowSize)',cur_SDF');
    
    %check for criterion # of sig bins
    h = p < p_crit;
    
    if ~isempty(min(findRuns(h)))
        onset = min(findRuns(h));
        disp(onset)
    end
end
disp('hi')