function [Start_Time] = aggregate_Pburst(Spikes)

catvar = [];

for i = 1:size(Spikes)
catvar = cat(1,catvar,Spikes(i,:)');
%remove 0's
catvar = nonzeros(catvar);
end

catvar = sort(catvar);

%remove repeated elements
catvar = unique(catvar);

[BOB,EOB,SOB] = P_BURST(catvar,min(catvar(:,1)),max(catvar(:,1)));

%link cell references from P_BURST to actual spike times
start_Times_low = catvar(BOB')-500;
start_time_low = start_Times_low(find(start_Times_low(:,1) > 50,1));