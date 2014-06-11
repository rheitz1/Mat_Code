%contrast - get mean accuracy rates
%read in files and neurons

[file_name cell_name] = textread('Contrast_Quincy.txt', '%s %s');

plotFlag = 1;

RTs_low = [];
RTs_mid = [];
RTs_high = [];

ACCs_low = [];
ACCs_mid = [];
ACCs_high = [];

for file = 1:size(file_name,1)
    disp([file_name(file) cell_name(file)])

    load([cell2mat(file_name(file))],'Correct_','Errors_','Target_','SRT')



    %set up lumininace properties
    Target_(find(Target_(:,3) >= 140 & Target_(:,3) < 160),13) = 1;
    Target_(find(Target_(:,3) >= 160 & Target_(:,3) < 190),13) = 2;
    Target_(find(Target_(:,3) >= 190),13) = 3;

    %correct RTs by hold time
    SRT(find(nonzeros(SRT(:,1)))) = SRT(find(nonzeros(SRT(:,1)))) - Target_(find(nonzeros(SRT(:,1))),10);
    
    
    %use correct RT distribution only and filter out RT < 100 ms
    temp_RT_low = SRT(find(Target_(:,13) == 1 & Correct_(:,2) == 1 & SRT(:,1) >= 100),1);
    temp_RT_mid = SRT(find(Target_(:,13) == 2 & Correct_(:,2) == 1 & SRT(:,1) >= 100),1);
    temp_RT_high = SRT(find(Target_(:,13) == 3 & Correct_(:,2) == 1 & SRT(:,1) >= 100),1);

    temp_acc_low = Correct_(find(Target_(:,13) == 1),2);
    temp_acc_mid = Correct_(find(Target_(:,13) == 2),2);
    temp_acc_high = Correct_(find(Target_(:,13) == 3),2);


    RTs_low(length(RTs_low) + 1:(length(RTs_low) + length(temp_RT_low)),1) = temp_RT_low;
    RTs_mid(length(RTs_mid) + 1:(length(RTs_mid) + length(temp_RT_mid)),1) = temp_RT_mid;
    RTs_high(length(RTs_high) + 1:(length(RTs_high) + length(temp_RT_high)),1) = temp_RT_high;

    ACCs_low(length(ACCs_low) + 1:(length(ACCs_low) + length(temp_acc_low)),1) = temp_acc_low;
    ACCs_mid(length(ACCs_mid) + 1:(length(ACCs_mid) + length(temp_acc_mid)),1) = temp_acc_mid;
    ACCs_high(length(ACCs_high) + 1:(length(ACCs_high) + length(temp_acc_high)),1) = temp_acc_high;

    keep file_name cell_name file RTs_low RTs_mid RTs_high ACCs_low ACCs_mid ACCs_high plotFlag
end

[CDF_low bins_low] = getCDF(RTs_low,100);
[CDF_mid bins_mid] = getCDF(RTs_mid,100);
[CDF_high bins_high] = getCDF(RTs_high,100);

acc(1) = nanmean(ACCs_low);
acc(2) = nanmean(ACCs_mid);
acc(3) = nanmean(ACCs_high);

if plotFlag == 1
    figure
    subplot(1,2,1)
    plot(bins_low,CDF_low,'r',bins_mid,CDF_mid,'b',bins_high,CDF_high,'k')
    xlim([0 2000])
    subplot(1,2,2)
    bar(acc,.5)
    ylim([.25 1])
    set(gca,'xticklabel',{'Low Contrast';'Medium Contrast'; 'High Contrast'})
    maximize
end