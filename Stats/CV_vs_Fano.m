%Generate Poisson neuron with n trials and given spike rate.  From
%Shadlen's CHSL demonstration code

nReps = 1000;

parfor rep = 1:nReps
    
    spike_rate = 130;
    nTrials = 1000;
    nSpikes = 1000; %number of spikes/trial before lopping off values larger than of interest
    max_spike_time = 2000;
    
    meanint = 1000 / spike_rate;     % mean interspike interval (ms)
    intervals = (exprnd(meanint,nTrials,nSpikes));  %use ceil to avoid intervals of 0
    
    % CV = std(intervals(:)) / mean(intervals(:))
    % CV2 = CV^2
    % Now we add up the interspike intervals to find the arrival time
    % of each spike.
    arrivals = (cumsum(intervals,2));
    arrivals(arrivals>max_spike_time) = NaN;
    
    arrivals(:,400:end) = [];
    
    
    window = [1 1200];
    arrivalcount = arrivals;
    arrivalcount(find(arrivalcount < window(1))) = 0;
    arrivalcount(find(arrivalcount > window(2))) = 0;
    
    
    
    counts = sum(arrivalcount > 0,2);
    
    FF(rep,1) = var(counts) / mean(counts)
    
    %now calculate CV and CV2 on same data used for FF
    arrivalcount(find(arrivalcount == 0)) = NaN;
    arrivalcount = diff(arrivalcount,[],2);
    arrivalcount = arrivalcount(find(arrivalcount > 0));
    
%     CV(rep,1) = std(arrivalcount) / mean(arrivalcount)
%     CV2(rep,1) = CV(rep,1)^2

    %try limiting calculation of CV to same number of points used in the FF; may appear to have lower
    %variance because significantly more observations?
    CV(rep,1) = std(intervals) / mean(intervals)
    CV2(rep,1) = CV(rep,1)^2

end
figure
scatter(FF,CV2)
dline



%
%
%
%
%
% nReps = 1000;
%
% parfor rep = 1:nReps
%     Hz = 100;
%     window = [300 700];
%
%     meanRate = 1000 / Hz;
%
%
%     intervals = ceil(exprnd(meanRate,1,100000));
%     intervals2 = reshape(intervals,100,1000);
%
%     arrivals = cumsum(intervals2,2);
%
%     %establish the window we are interested in.  Turn this into a logical matrix and then use to compute CV
%     %and FF on same data
%     spikeLogical = (arrivals > window(1) & arrivals < window(2));
%
%     intervalsRelevant = intervals2 .* spikeLogical;
%     arrivalsRelevant = arrivals .* spikeLogical;
%
%
%      CV(rep,1) = std(nonzeros(intervalsRelevant)) / mean(nonzeros(intervalsRelevant));
%      CV2(rep,1) = CV(rep,1)^2;
%
%
%     FF(rep,1) = var(sum(arrivalsRelevant > 0,2)) / mean(sum(arrivalsRelevant > 0,2));
%
% end
%
% figure
% scatter(FF,CV)
% dline