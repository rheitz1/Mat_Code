% Binomial probabilities of making DIRECTION errors over time using window (# of trials to collapse over) 
% of specified size.  Note that this is not truly a *time* variable but
% rather trials
%
% RPH

function [prob] = getBinomialErrors(window,plotFlag)

if nargin < 1 || isempty(window); window = 100; end
if nargin < 2; plotFlag = 0; end

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');




baseProbErr = length(find(Errors_(:,5) == 1)) / size(Correct_,1);
s = 1;

for seq = 1:window:size(Errors_,1)-window
    sequence = Errors_(seq:seq+window-1,5);
    numErr = length(find(sequence == 1));
    
    prob(s) = 1 - binocdf(numErr,window,baseProbErr);
    clear sequence
    s = s + 1;
end

if plotFlag == 1
    figure
    plot(prob)
end