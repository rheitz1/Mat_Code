function [BurstBegin,BurstEnd,BurstSurprise,BurstStartTimes] = getBurst(TotalSpikes)
%Poisson Burst test script
%Calls P_BURST
%Called by Contrast_sensitivity_batch_allTrials

%Richard P. Heitz
%10/31/07

Target_ = evalin('caller','Target_');

%%%%%%%%%%
% Can we use parallel toolbox?
if usejava('desktop')
    if matlabpool('size') > 1
        useParallel = 1;
    else
        useParallel = 0;
    end
else
    useParallel = 0;
end

maxBurstSearchWindow = 200;

BurstBegin = zeros(size(TotalSpikes,1),1000);
BurstEnd = zeros(size(TotalSpikes,1),1000);
BurstSurprise = zeros(size(TotalSpikes,1),1000);

disp(['Total number of trials: ' mat2str(size(TotalSpikes,1))])
tic


%useParallel = 0;

if useParallel
    parfor n = 1:size(TotalSpikes,1)
        %Note: sending min and max of entire spike train per Hanes et al.
        %(1995); want to calculate MU from entire train
        
        %[BOB,EOB,SOB] = P_BURST(nonzeros(TotalSpikes(n,:)),min(nonzeros(TotalSpikes(n,:))),max(nonzeros(TotalSpikes(n,:))));
        
        %Use spikes from -100 to end of train
        [BOB,EOB,SOB] = P_BURST(nonzeros(TotalSpikes(n,:)),0,6000);
        
        BurstBegin(n,:) = zpad(BOB);

    end
else
    for n = 1:size(TotalSpikes,1)
        %Note: sending min and max of entire spike train per Hanes et al.
        %(1995); want to calculate MU from entire train

        %[BOB,EOB,SOB] = P_BURST(nonzeros(TotalSpikes(n,:)),min(nonzeros(TotalSpikes(n,:))),max(nonzeros(TotalSpikes(n,:))));
        [BOB,EOB,SOB] = P_BURST(nonzeros(TotalSpikes(n,:)),0,max(TotalSpikes(n,:)));
        
        if mod(n,100) == 0;
            n
        end
        
        BurstBegin(n,1:length(BOB)) = BOB;
        BurstEnd(n,1:length(EOB)) = EOB;
        BurstSurprise(n,1:length(SOB)) = SOB;
    end
end
toc

%===========================
%Convert to real spike times
for n = 1:size(TotalSpikes,1)
    if ~isnan(BurstBegin(n,1))
        temp = TotalSpikes(n,BurstBegin(n,~isnan(BurstBegin(n,:)))) - Target_(1,1);
        if ~isempty(find(temp > 0 & temp <= maxBurstSearchWindow))
            BurstStartTimes(n,1:length(find(temp > 0 & temp <= maxBurstSearchWindow))) = temp(find(temp > 0 & temp <= maxBurstSearchWindow));
        else
            BurstStartTimes(n,1) = NaN;
            
        end
    else
        %correction for low firing rate cells: final index will fail
        if n == size(TotalSpikes,1)
            BurstStartTimes(n,1) = NaN;
        end
    end
end

%change all 0 values to NaN
BurstStartTimes(find(BurstStartTimes == 0)) = NaN;

end


%====================================
% Local function for parallel toolbox
function [padded] = zpad(BOB)
%parfor is very sensitive to vector lengths.  Seems to like it best when an external function returns a
%vector of specific length
padded = BOB;
padded = [padded zeros(1,1000-length(BOB))]; %zero pad to length
padded(find(padded == 0)) = NaN;
end