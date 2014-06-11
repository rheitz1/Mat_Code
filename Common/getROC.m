function [ROCarea] = getROC(SDF_all,inTrials,outTrials,window)
%====================================================================
%COMPUTES ROC CURVE

%at each time bin, find proportion T_in greater than criterion & proportion
%D_in greater than criterion, then incrememnt criterion from 0 to maximum
%Firing%rate

%SDF_all is matrix of trial-by-trial SDFs or all *baseline-corrected* AD values

%max criterion is maximum firing rate obtained on a single trial (Thompson
%et al., 1996, p. 4043.

%window = total averaging window size. To increase speed, I use the tsmovavg function
%to make a moving average before hand.  As a consequence, ROC area will be
%shifted later by 1 ms when window > 1.  The reason for this is that
%tsmovavg considers n *previous* points. So if you want a 10 ms window
%you'd input 10, then shift the moving average matrix back 5.  Note
%that it should actually be 5.5, but you can't index fractions.  Can
%probably fix this by altering window to be odd.

%========================================================================

if nargin < 4
    window = 1;
else
    %window is total window size.  divide by half for easier implementation
    window = window / 2;
end


%figure out if AD channel
if length(find(SDF_all < 0)) > 0
    isAD = 1;
    ADStepSize = .01;
else
    isAD = 0;
end


%get range of values to use as criterion
if isAD == 0
    maxFire_in = max(max(SDF_all(inTrials,:)));
    maxFire_out = max(max(SDF_all(outTrials,:)));
    maxFire = ceil(max(maxFire_in,maxFire_out));
    
    minFire_in = min(min(SDF_all(inTrials,:)));
    minFire_out = min(min(SDF_all(outTrials,:)));
    minFire = floor(min(minFire_in,minFire_out));
    
elseif isAD == 1 %we don't want to round for AD channels: would always make min -1 and max 1
    maxFire_in = max(max(SDF_all(inTrials,:)));
    maxFire_out = max(max(SDF_all(outTrials,:)));
    maxFire = max(maxFire_in,maxFire_out);
    
    minFire_in = min(min(SDF_all(inTrials,:)));
    minFire_out = min(min(SDF_all(outTrials,:)));
    minFire = min(minFire_in,minFire_out);
end



%preallocate ROCarea
ROCarea(1:size(SDF_all,2)) = NaN;

%preallocate
if isAD == 1
    num_Tin_greater = NaN(length(minFire:ADStepSize:maxFire),size(SDF_all,2));
    num_Din_greater = NaN(length(minFire:ADStepSize:maxFire),size(SDF_all,2));
elseif ~isAD
    num_Tin_greater = NaN(length(0:maxFire),size(SDF_all,2));
    num_Din_greater = NaN(length(0:maxFire),size(SDF_all,2));
end

clear maxFire_in maxFire_out


%create moving average.  tsmovavg function only considers n points prior
%to current position so we will have to shift the matrix
if window > 1
    SDF_all = tsmovavg(SDF_all,'s',window*2);
    SDF_all = circshift(SDF_all,[0 -window]);
end

if isAD == 0
    for criterion = 0:maxFire
        num_Tin_greater(criterion+1,1:size(SDF_all,2)) = sum(double(SDF_all(inTrials,:) >= criterion)) ./ sum(double(~isnan(SDF_all(inTrials,:))));
        num_Din_greater(criterion+1,1:size(SDF_all,2)) = sum(double(SDF_all(outTrials,:) >= criterion)) ./ sum(double(~isnan(SDF_all(outTrials,:))));
    end
    ROCarea = polyarea([ones(1,size(SDF_all,2)) ; num_Din_greater],[zeros(1,size(SDF_all,2)) ; num_Tin_greater]);

elseif isAD == 1
    iter = 1;
    for criterion = minFire:ADStepSize:maxFire
        num_Tin_greater(iter,1:size(SDF_all,2)) = sum(double(SDF_all(inTrials,:) >= criterion)) ./ sum(double(~isnan(SDF_all(inTrials,:))));
        num_Din_greater(iter,1:size(SDF_all,2)) = sum(double(SDF_all(outTrials,:) >= criterion)) ./ sum(double(~isnan(SDF_all(outTrials,:))));
        iter = iter + 1;
    end
    ROCarea = polyarea([ones(1,size(SDF_all,2)) ; num_Din_greater],[zeros(1,size(SDF_all,2)) ; num_Tin_greater]);
end

%calculate ROC areas over time

% warning off
% if ~isempty(inTrials) & ~isempty(outTrials)
%     for ms = 1:size(SDF_all,2)
%         if isAD == 0
%             for criterion = 0:maxFire
%                 %num_Tin_greater(criterion + 1,ms) = length(find(SDF_all(inTrials,ms) >= criterion)) / sum(~isnan(SDF_all(inTrials,ms)));
%                 
%                 num_Tin_greater(criterion + 1,ms) = sum(SDF_all(inTrials,ms) >= criterion) / sum(~isnan(SDF_all(inTrials,ms)));
%                 
%                 %num_Din_greater(criterion + 1,ms) = length(find(SDF_all(outTrials,ms) >= criterion)) / sum(~isnan(SDF_all(outTrials,ms)));
%                 num_Din_greater(criterion + 1,ms) = sum(SDF_all(outTrials,ms) >= criterion) / sum(~isnan(SDF_all(outTrials,ms)));
%             end
%         elseif isAD == 1
%             crit_count = 0;
%             
%             for criterion = minFire:ADStepSize:maxFire %must increment with smaller values when AD channel (corresponds to 1 uV at a time)
%                 num_Tin_greater(crit_count + 1,ms) = length(find(SDF_all(inTrials,ms) >= criterion)) / sum(~isnan(SDF_all(inTrials,ms)));
%                 
%                 num_Din_greater(crit_count + 1,ms) = length(find(SDF_all(outTrials,ms) >= criterion)) / sum(~isnan(SDF_all(outTrials,ms)));
%                 crit_count = crit_count + 1;
%             end
%             
%         end
%         
%         ROCarea(ms) = polyarea([1 num_Din_greater(:,ms)'],[0 num_Tin_greater(:,ms)']);
%     end
% else
%     disp('ROC: No Trials! Returning NaN')
%     ROCarea(1,1:size(SDF_all,2)) = NaN;
%     return
% end
% 
% warning on
