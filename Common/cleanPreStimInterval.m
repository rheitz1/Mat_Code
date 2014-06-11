% finds how much pre-stimulus interval we are working with that do NOT contain saccades.
% uses a  deg/sec criterion for a saccade
%
% Then cleans in the input signal by setting those time points to NaN
%
%
% Must be TARGET ALIGNED when called
% For Spikes, send RAW SPIKE TIMES, not SDF 
%
% RPH


function [sig cutoff] = cleanPreStimInterval(sig)

disp('Removing prestimulus regions with saccades...')

saccLoc = evalin('caller','saccLoc');
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');

%is it an AD signal?
if size(sig,2) == 3001 || size(sig,2) == 6001
    isAD = 1;
else
    isAD = 0;
end

plotEveryTrl = 0;

saccThresh = 70;

velocityXY = getSaccVelocity;

%take the prestimulus interval

preStim = velocityXY(:,1:Target_(1,1));

%flip it left to right so we can more easily find runs

preStim = fliplr(preStim);


logicalPreStim = preStim < saccThresh;


for trl = 1:size(velocityXY,1)
    if ~isempty(find(~logicalPreStim(trl,:),1,'first'))
        cutoff(trl,1) = find(~logicalPreStim(trl,:),1,'first');
    else
        cutoff(trl,1) = Target_(1,1);
    end
    
end

cutoff = -cutoff;



%Now set those time points to NaN

if isAD
    for trl = 1:size(sig,1)
        sig(trl,1:Target_(1,1)+cutoff(trl)) = NaN; % add cutoff time because we set it to negative above
    end
else
    for trl = 1:size(sig,1)
        %if a spike channel, have to index slightly differently.  2nd portion of code makes sure we are
        %not considering non-spike events, which are coded as 0's (or, = -Target_(1,1))
        
        sig(trl,find(sig(trl,:)-Target_(1,1) < cutoff(trl) & sig(trl,:)-Target_(1,1) > -Target_(1,1))) = NaN;
    end
end


if plotEveryTrl
    t = -Target_(1,1):(size(EyeX_,2)-Target_(1,1)-1);
    
    figure
    for trl = 1:size(EyeX_,1)
        plot(t,EyeX_(trl,:),'r',t,EyeY_(trl,:))
        vline(cutoff(trl))
        pause
        cla
    end
end


%clear plotEveryTrl saccThresh velocityXY preStim logicalPreStim trl t