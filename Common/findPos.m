%quick script to find all correct trials at all screen locations

pos0 = find(Correct_(:,2) & Target_(:,2) == 0 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos1 = find(Correct_(:,2) & Target_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos2 = find(Correct_(:,2) & Target_(:,2) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos3 = find(Correct_(:,2) & Target_(:,2) == 3 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos4 = find(Correct_(:,2) & Target_(:,2) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos5 = find(Correct_(:,2) & Target_(:,2) == 5 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos6 = find(Correct_(:,2) & Target_(:,2) == 6 & SRT(:,1) < 2000 & SRT(:,1) > 50);
pos7 = find(Correct_(:,2) & Target_(:,2) == 7 & SRT(:,1) < 2000 & SRT(:,1) > 50);