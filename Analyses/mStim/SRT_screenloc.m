%plots CDFs for stim/nonstim by screen location
rtfig = figure;
accfig_all = figure;
accfig_ss2 = figure;
accfig_ss4 = figure;
accfig_ss8 = figure;

for j = 0:7
    switch j
        case 0
            screenloc = 6;
        case 1
            screenloc = 3;
        case 2
            screenloc = 2;
        case 3
            screenloc = 1;
        case 4
            screenloc = 4;
        case 5
            screenloc = 7;
        case 6
            screenloc = 8;
        case 7
            screenloc = 9;
    end
    
    correct_stim_all = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    errors_stim_all =  find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    correct_nostim_all = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    errors_nostim_all = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    
    correct_stim_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    errors_stim_ss2 =  find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    correct_nostim_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    errors_nostim_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    
    correct_stim_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    errors_stim_ss4 =  find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    correct_nostim_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    errors_nostim_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    
    
    correct_stim_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    errors_stim_ss8 =  find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & ~isnan(MStim_(:,1)));
    correct_nostim_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    errors_nostim_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) == j & isnan(MStim_(:,1)));
    
    acc.stim.all(j+1) = length(correct_stim_all) / (length(correct_stim_all) + length(errors_stim_all));
    acc.stim.ss2(j+1) = length(correct_stim_ss2) / (length(correct_stim_ss2) + length(errors_stim_ss2));
    acc.stim.ss4(j+1) = length(correct_stim_ss4) / (length(correct_stim_ss4) + length(errors_stim_ss4));
    acc.stim.ss8(j+1) = length(correct_stim_ss8) / (length(correct_stim_ss8) + length(errors_stim_ss8));
    
    acc.nostim.all(j+1) = length(correct_nostim_all) / (length(correct_nostim_all) + length(errors_nostim_all));
    acc.nostim.ss2(j+1) = length(correct_nostim_ss2) / (length(correct_nostim_ss2) + length(errors_nostim_ss2));
    acc.nostim.ss4(j+1) = length(correct_nostim_ss4) / (length(correct_nostim_ss4) + length(errors_nostim_ss4));
    acc.nostim.ss8(j+1) = length(correct_nostim_ss8) / (length(correct_nostim_ss8) + length(errors_nostim_ss8));
    
%     [bins_stim CDF_stim] = getCDF(SRT(correct_stim_all,1),30);
%     [bins_nostim CDF_nostim] = getCDF(SRT(correct_nostim_all,1),30);

    %try SS2 only
    [bins_stim CDF_stim] = getCDF(SRT(correct_stim_all,1),30);
    [bins_nostim CDF_nostim] = getCDF(SRT(correct_nostim_all,1),30);
    
    
    figure(rtfig)
    fon
    subplot(3,3,screenloc);
    plot(bins_nostim,CDF_nostim,'b',bins_stim,CDF_stim,'r')
    title(['mStim = ' mat2str(round(nanmean(SRT(correct_stim_all)))) '   mNoStim = ' mat2str(round(nanmean(SRT(correct_nostim_all))))],'fontweight','bold')
    
    figure(accfig_all)
    subplot(3,3,screenloc)
    bar([acc.stim.all(j+1) acc.nostim.all(j+1)])
    set(gca,'xticklabel',['  Stim';'NoStim'])
    xlim([0 3])
    ylim([0 1])
    
    figure(accfig_ss2)
    subplot(3,3,screenloc)
    bar([acc.stim.ss2(j+1) acc.nostim.ss2(j+1)])
    set(gca,'xticklabel',['  Stim';'NoStim'])
    xlim([0 3])
    ylim([0 1])
    
    figure(accfig_ss4)
    subplot(3,3,screenloc)
    bar([acc.stim.ss4(j+1) acc.nostim.ss4(j+1)])
    set(gca,'xticklabel',['  Stim';'NoStim'])
    xlim([0 3])
    ylim([0 1])
    
    figure(accfig_ss8)
    subplot(3,3,screenloc)
    bar([acc.stim.ss8(j+1) acc.nostim.ss8(j+1)])
    set(gca,'xticklabel',['  Stim';'NoStim'])
    xlim([0 3])
    ylim([0 1])
end


figure(accfig_all)
fw
[ax h] = suplabel('Collapsed on Set Size','t');
set(h,'fontsize',14,'fontweight','bold')

figure(accfig_ss2)
fw
[ax h] = suplabel('Set Size 2','t');
set(h,'fontsize',14,'fontweight','bold')

figure(accfig_ss4)
fw
[ax h] = suplabel('Set Size 4','t');
set(h,'fontsize',14,'fontweight','bold')

figure(accfig_ss8)
fw
[ax h] = suplabel('Set Size 8','t');
set(h,'fontsize',14,'fontweight','bold')