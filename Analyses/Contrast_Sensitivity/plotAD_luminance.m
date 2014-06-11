function [ADchan_low,ADchan_mid,ADchan_high] = plotAD_luminance(ADchan,Target_,Correct_)

%LFP analysis
%Done only 1 time for each file because LFPs do not discriminate
%multiunits (1 LFP regardless of # of isolated cells)
%set all 0's to NaN so means do not reflect them
for a = 1:size(ADchan,1)
    for b = 1:size(ADchan,2)
        if ADchan(a,b) == 0
            ADchan(a,b) = nan;
        end
    end
end

lum_spacing = round((max(Target_(find(Target_(:,3) > 1),3)) - min(Target_(find(Target_(:,3) > 1),3)))/3);
cut1 = min(Target_(find(Target_(:,3) > 1),3)) + lum_spacing;
cut2 = max(Target_(find(Target_(:,3) > 1),3)) - lum_spacing;

Lows = find(Target_(:,3) < cut1 & Correct_(:,2) == 1 & Target_(:,3) > 1);
Mids = find(Target_(:,3) >= cut1 & Target_(:,3) < cut2 & Correct_(:,2) == 1 & Target_(:,3) > 1);
Highs = find(Target_(:,3) >= cut2 & Correct_(:,2) == 1 & Target_(:,3) > 1);

%Baseline correction
%observations 101-125 corresponds to the 100 ms prior to target onset
low_base = mean(ADchan(Lows,101:125),2);
mid_base = mean(ADchan(Mids,101:125),2);
high_base = mean(ADchan(Highs,101:125),2);


low_corrected = ADchan(Lows,:) - repmat(low_base,1,length(ADchan));
mid_corrected = ADchan(Mids,:) - repmat(mid_base,1,length(ADchan));
high_corrected = ADchan(Highs,:) - repmat(high_base,1,length(ADchan));


ADchan_low = nanmean(low_corrected);
ADchan_mid = nanmean(mid_corrected);
ADchan_high = nanmean(high_corrected);
