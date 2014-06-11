%analysis script to do latency covariation within one data file

NeuronList = fields(BurstStartTimes);
dex = 1;


for neuron = 1:length(NeuronList)
    if size(BurstStartTimes.(NeuronList{neuron}),1) > 5 %this also ensures that it is not a single NaN value
        temp = BurstStartTimes.(NeuronList{neuron});
        validTimes(:,dex) = temp(in,1);
        dex = dex + 1;
        clear temp
    end
end

%get rid of all 0 values
validTimes(find(validTimes == 0)) = NaN;

pairings = nchoosek(1:size(validTimes,2),2);


if size(pairings,1) == 1; plotsize = [1 1];
elseif size(pairings,1) == 2; plotsize = [1 2];
elseif size(pairings,1) > 2 & size(pairings,1) <= 4; plotsize = [2 2];
elseif size(pairings,1) > 4 & size(pairings,1) <= 6; plotsize = [2 3];
elseif size(pairings,1) > 6 & size(pairings,1) <= 9; plotsize = [3 3];
elseif size(pairings,1) > 9 & size(pairings,1) <= 12; plotsize = [3 4];
elseif size(pairings,1) > 12 & size(pairings,1) <= 16; plotsize = [4 4];
else
    error('Not enough subplots. Edit script')
end



figure
for pair = 1:size(pairings,1)
    times = [validTimes(:,pairings(pair,1)) validTimes(:,pairings(pair,2))];
    
    %remove non-nan entries and pair variables
    times = removeNaN(times);
    
    subplot(plotsize(1),plotsize(2),pair)
    scatter(times(:,1),times(:,2))
    dline
    %     xlim([-10 500])
    %     ylim([-10 500])
    title([' r = ' mat2str(roundoff(corr(times(:,1),times(:,2)),4))])
    
end