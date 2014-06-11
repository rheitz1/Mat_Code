function [Cv,Lv] = getCVLV(spikes,TrialStart_)

%Compute CV & LV for each neuron.  Per Shinomoto et al. (2003), take median
%for each cell for each session.  Record to external file for analysis

%convert spike times into real time by adding TrialStart_ values
for i = 1:size(spikes,1)
    spikes(i,find(nonzeros(spikes(i,:)))) = spikes(i,find(nonzeros(spikes(i,:)))) + TrialStart_(i,1);
end

%concatenate nonzero elements into 1 x n vector
%catvar = nonzeros(spikes(1,:));
catvar = [];
for i = 1:size(spikes,1)
    catvar = cat(1,catvar,nonzeros(spikes(i,:)));
end
%
% spikes_clean(1:size(spikes,1),1:size(spikes,2)) = NaN;
% %change spike 0's to NaN's
% for i = 1:size(DSP04a,1)
%     spikes(i,1:length(find(nonzeros(spikes(i,:))))) = spikes(i,find(nonzeros(spikes(i,:))));
% end


%Create ISIs
spikes_diff = diff(catvar')';
clear spikes TrialStart_ catvar
%find number of consecutive 100 ISIs we can use
numRuns = floor(length(spikes_diff) / 100);

%if there are too few spikes, abort
if numRuns < 10
    Cv = NaN;
    Lv = NaN;
    return
end


%create matrix of each individual sequence of 100, leaving off tail end as
%residual
sequenceStart = 1;
for runs = 1:numRuns
    ISI(runs,1:100) = spikes_diff(sequenceStart:sequenceStart + 99)';
    sequenceStart = sequenceStart + 100;
end
clear spikes_diff



%compute coefficient of variation for each trial
for i = 1:size(ISI,1)
    Cv(i,1) = nanstd(ISI(i,:)) / nanmean(ISI(i,:));
end

%compute local variation of inter-spike intervals for each trial


for i = 1:size(ISI,1)
    for j = 1:size(ISI,2)-1
        temp(j) = (3*(ISI(i,j) - ISI(i,j+1))^2) / (ISI(i,j) + ISI(i,j+1))^2;
    end
    Lv(i,1) = nansum(temp) / (size(ISI,2) - 1);
end

% hist(Cv)
% title('Coefficient of Variation')
%
% figure
% hist(Lv)
% title('Local Variation (Lv)')
