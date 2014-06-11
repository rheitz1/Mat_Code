%plot reaction time distribution by screen location for CORRECT, NON-CATCH
%trials

if exist('SRT') == 0
    SRT = getSRT(EyeX_,EyeY_);
end

%if is memory guided task, subtract Target Hold Time
if Target_(1,10) > 0
    disp('Correcting SRT by HOLD TIME')
    %make a backup
    SRT_backup = SRT;
    SRT = SRT(:,1) - MG_Hold_;
end

nBins = 10;

pos0 = find(Correct_(:,2) == 1 & Target_(:,2) == 0);
pos1 = find(Correct_(:,2) == 1 & Target_(:,2) == 1);
pos2 = find(Correct_(:,2) == 1 & Target_(:,2) == 2);
pos3 = find(Correct_(:,2) == 1 & Target_(:,2) == 3);
pos4 = find(Correct_(:,2) == 1 & Target_(:,2) == 4);
pos5 = find(Correct_(:,2) == 1 & Target_(:,2) == 5);
pos6 = find(Correct_(:,2) == 1 & Target_(:,2) == 6);
pos7 = find(Correct_(:,2) == 1 & Target_(:,2) == 7);
allCorrect = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255);

figure

%collapsed over screen position
subplot(335)
hist(SRT(allCorrect,1),nBins)
xl = xlim;
box off


subplot(336)
hist(SRT(pos0,1),nBins)
xlim(xl);
box off

subplot(333)
hist(SRT(pos1,1),nBins)
xlim(xl);
box off

subplot(332)
hist(SRT(pos2,1),nBins)
xlim(xl);
box off

subplot(331)
hist(SRT(pos3,1),nBins)
xlim(xl);
box off

subplot(334)
hist(SRT(pos4,1),nBins)
xlim(xl);
box off

subplot(337)
hist(SRT(pos5,1),nBins)
xlim(xl);
box off

subplot(338)
hist(SRT(pos6,1),nBins)
xlim(xl);
box off

subplot(339)
hist(SRT(pos7,1),nBins)
xlim(xl);
box off


[ax h] = suplabel(newfile);
set(h,'fontsize',16,'fontweight','bold','interpreter','none');


%return SRT to original variable if MG task
if Target_(1,10) > 0
    SRT = SRT_backup;
    clear SRT_backup
end

if printFlag
    orient landscape
    eval(['print -dpdf ' pwd '/Plots/' newfile '_RTD.pdf'])
end