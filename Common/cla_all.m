% Clears axes of all children in a plot
%
% RPH

hands = get(gcf,'Children');

%find the max and min of each
for hh = 1:length(hands)
    cla(hands(hh))
end
clear hands hh