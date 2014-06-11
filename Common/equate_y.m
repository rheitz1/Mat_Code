%equate Y-axis limits across all subplots
%
% RPH

%get handles of all figures.  Note that this DOES manipulate legends too,
%which has unpredictable results

hands = get(gcf,'Children');

%find the max and min of each
for hh = 1:length(hands)
    tt = get(hands(hh),'ylim');
    y_min(hh) = tt(1);
    y_max(hh) = tt(2);
end

%set max and min of each subplot to global max and min

for hh = 1:length(hands)
    set(hands(hh),'ylim',[min(y_min) max(y_max)])
end

clear hands hh tt