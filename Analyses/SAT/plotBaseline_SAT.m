%baseline-RT correlation w/i session
function [baselineSDF] = plotBaseline_SAT(unitname,win,plotFlag)

if nargin < 3; plotFlag = 0; end
if nargin < 2 || isempty(win); win = [-400 200]; end

% Options
normSDF = 1; %normalization won't matter for individual session; but if you want to run correlation across the population, best to normalize



if normSDF == 0; disp('Not Normalizing SDF'); end
if normSDF == 1; disp('Normalizing SDF'); end

sig = evalin('caller',unitname);
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SRT = evalin('caller','SRT');
SAT_ = evalin('caller','SAT_');
Target_ = evalin('caller','Target_');


getTrials_SAT

SDF = sSDF(sig,Target_(:,1),[-400 2500]);

%normalize to max firing rate; note we normalize using a constant window size irrespective of the window
%size requested by the user
if normSDF
    SDF = normalize_SP(SDF);
end

%limit to window.
base = SDF(:,400+win(1)+1 : 400+win(2)+1);

%base = nanmean(base,2);

%remove 0's, because cells didn't fire
%base(find(base == 0)) = NaN;
baselineSDF.slow = nanmean(base(slow_all,:));
baselineSDF.fast = nanmean(base(fast_all_withCleared,:));

figure
plot(win(1):win(2),baselineSDF.slow,'r', ...
    win(1):win(2),baselineSDF.fast,'g')
box off

end