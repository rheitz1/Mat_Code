%saccade velocities
%
%RPH

function [X,Y] = saccade_velocity_SAT(plotFlag)

saccLoc = evalin('caller','saccLoc');
SRT = evalin('caller','SRT');
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
Correct_ = evalin('caller','Correct_');
SAT_ = evalin('caller','SAT_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');

if nargin < 1; plotFlag = 0; end

%limit to a particular screen location
trllist = find(saccLoc == 0);


%take 500 ms around each saccade (-250:250), save to new variable
for trl = 1:size(SRT,1)
    if ~isnan(SRT(trl,1))
        X(trl,1:401) = EyeX_(trl,SRT(trl,1)+Target_(1,1)-200:SRT(trl,1)+Target_(1,1)+200);
        Y(trl,1:401) = EyeY_(trl,SRT(trl,1)+Target_(1,1)-200:SRT(trl,1)+Target_(1,1)+200);
    else
        X(trl,1:401) = NaN;
        Y(trl,1:401) = NaN;
    end
end

x = abs(diff(X,1,2));
y = abs(diff(Y,1,2));

velocity.y = nanmean(y);
velocity.x = nanmean(x);

getTrials_SAT

X.slow = nanmean(x(intersect(trllist,slow_correct_made_dead),:));
X.med = nanmean(x(intersect(trllist,med_correct),:));
X.fast = nanmean(x(intersect(trllist,fast_correct_made_dead_withCleared),:));

Y.slow = nanmean(y(intersect(trllist,slow_correct_made_dead),:));
Y.med = nanmean(y(intersect(trllist,med_correct),:));
Y.fast = nanmean(y(intersect(trllist,fast_correct_made_dead_withCleared),:));



if plotFlag
    fig
    subplot(2,2,1)
    plot(-199:200,nanmean(x(slow_correct_made_dead,:)),'r',-199:200,nanmean(x(fast_correct_made_dead_withCleared,:)),'g')
    xlim([-100 100])
    
    subplot(2,2,2)
    plot(-199:200,nanmean(y(slow_correct_made_dead,:)),'r',-199:200,nanmean(y(fast_correct_made_dead_withCleared,:)),'g')
    xlim([-100 100])
end