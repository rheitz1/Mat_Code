%calculates the probability from an odds ratio
function [prob] = odds2prob(successes,failures)

prob = successes ./ (successes+failures);

disp([mat2str(successes) ' successes and ' mat2str(failures) ' failures is a probability of ' mat2str(prob)])