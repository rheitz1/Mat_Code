%PCA on continuous data example

%load example file (if not already loaded)

if size(who,1) < 1
%     cd /volumes/Dump/Search_Data_SAT/Waves/
%     load Q110910001-RH_SEARCH_waves
%     load Q110910001-RH_SEARCH

    cd /volumes/Dump2/PLX_for_PCA_testing/
    
    load Q110910001-RH_SEARCH
    load('D20130822001-RH_ALL_INCLUSIVE_SORT_all','-mat')
end

%PCA (unlike SVD?) wants centered data, so center
sig1 = [waves_DSP09a]; %note: first column is trial number; disregard it; Combine 2 units for proof-of-principle

sig1_centered = sig1 - repmat(mean(sig1,2),1,size(sig1,2)); %Make sure data is centered

[V, pcscores, pcvar] = princomp(sig1_centered);

fig1
plot(sqrt(pcvar),'-ok')
box off
title('Scree Plot')

fig2
scatter(pcscores(:,1),pcscores(:,2),'sizedata',2)
box off
xlabel('PC 1')
ylabel('PC 2')
vline(0,'k')
hline(0,'k')