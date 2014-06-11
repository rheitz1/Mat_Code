acc = [];
nACC = [];
rt = [];
nRT = [];

x = isnan(Errors_);
for loc = 0:7
    acc(1,loc+1) = nanmean(x(find(Errors_(:,1) ~= 1 & Target_(:,2) ~= 255 & Target_(:,2) == loc),6));
    nACC(1,loc+1) = length(x(find(Errors_(:,1) ~= 1 & Target_(:,2) ~= 255 & Target_(:,2) == loc),6));
    rt(1,loc+1) = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & Errors_(:,5) ~= 1 & Errors_(:,6) ~= 1 & Target_(:,2) ~= 255 & Target_(:,2) == loc),1));
    nRT(1,loc+1) = length(find(Errors_(:,1) ~= 1 & Errors_(:,2) ~= 0 & Errors_(:,3) ~= 0 & Errors_(:,4) ~=0 & Errors_(:,5) ~= 0 & Target_(:,2) ~=255 & Target_(:,2) == loc));
end

figure
subplot(3,3,6)
bar(acc(1))
title(['n = ' mat2str(nACC(1))]);

subplot(3,3,3)
bar(acc(2))
title(['n = ' mat2str(nACC(2))]);

subplot(3,3,2)
bar(acc(3))
title(['n = ' mat2str(nACC(3))]);

subplot(3,3,1)
bar(acc(4))
title(['n = ' mat2str(nACC(4))]);

subplot(3,3,4)
bar(acc(5))
title(['n = ' mat2str(nACC(5))]);

subplot(3,3,7)
bar(acc(6))
title(['n = ' mat2str(nACC(6))]);

subplot(3,3,8)
bar(acc(7))
title(['n = ' mat2str(nACC(7))]);

subplot(3,3,9)
bar(acc(8))
title(['n = ' mat2str(nACC(8))]);

set(gcf,'Color','white');


set2acc = nanmean(Correct_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255),2))
set4acc = nanmean(Correct_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255),2))
set8acc = nanmean(Correct_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255),2))

set2rt = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 2 & Correct_(:,2) == 1 & Target_(:,2) ~= 255),1))
set4rt = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 4 & Correct_(:,2) == 1 & Target_(:,2) ~= 255),1))
set8rt = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 8 & Correct_(:,2) == 1 & Target_(:,2) ~= 255),1))