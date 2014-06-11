%equate clim-axis limits across all specified subplots
%
% NOTE: THIS WILL NOT WORK IF COLORBARS ARE ALREADY IN FIGURE!
%
% RPH
function [] = equate_clim(whichHands)

hands = get(gcf,'Children'); %find all handles
hands = flipud(hands); %handles are in reverse order, so reverse them back

if nargin < 1;    whichHands = hands; end %do all

for hh = 1:length(whichHands)
    x = get(hands(whichHands(hh)),'clim');
    low(hh) = x(1);
    high(hh) = x(2);
end




%set max and min of each subplot to global max and min

for hh = 1:length(whichHands)
    set(hands(whichHands(hh)),'clim',[min(low) max(high)])
end

