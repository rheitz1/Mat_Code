%calculates the probability from an odds ratio
function [odds] = prob2odds(prob)

odds = prob ./ (1-prob);