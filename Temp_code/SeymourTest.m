%Seymour test script

set2acc = nanmean(Correct_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255),2))
set4acc = nanmean(Correct_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255),2))
set8acc = nanmean(Correct_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255),2))

set2rt = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 2 & Correct_(:,2) == 1 & Target_(:,2) ~= 255),1))
set4rt = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 4 & Correct_(:,2) == 1 & Target_(:,2) ~= 255),1))
set8rt = nanmean(Decide_(find(Errors_(:,1) ~= 1 & Target_(:,5) == 8 & Correct_(:,2) == 1 & Target_(:,2) ~= 255),1))