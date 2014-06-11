function [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials)
%EDIT CORRECT TRIALS - Filter SRT < 100 ms and those SRTs that differ from
%the TEMPO created "Decide_" variable by more than 45 ms

maxResid = 45;

ValidTrials = CorrectTrials(find(Decide_(CorrectTrials,1) >= 100 & Decide_(CorrectTrials,1) <= 2000 & abs(SRT(CorrectTrials,1) - Decide_(CorrectTrials,1)) <= maxResid));
NonValidTrials = CorrectTrials(find(Decide_(CorrectTrials,1) < 100 | Decide_(CorrectTrials,1) > 2000 | abs(SRT(CorrectTrials,1) - Decide_(CorrectTrials,1)) > maxResid));
resid = SRT(CorrectTrials,1) - Decide_(CorrectTrials,1);