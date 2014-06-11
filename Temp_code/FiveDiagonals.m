%create average of 20 diagonals (every other one inclusive of main
%diagonal)
diagonals(1:length(diag(JPSTC_correct,0)),1:21) = NaN;
start = -10;
i = 1;

for lag = -20:2:20
    
    diagonals(abs(start)+1:length(diagonals)-abs(start),i) = diag(JPSTC_correct,lag);
    start = start + 1;
    i = i + 1;
end

diag_avg = mean(diagonals(11:441,:),2);
%     
% %Main diagonal (place 0)
% c(:,3) = diag(JPSTC_correct,0);
% 
% %negative diagonal 2 lower from main
% c(2:length(c)-1,2) = diag(JPSTC_correct,-2);
% 
% %negative diagonal 4 lower from main
% c(3:length(c)-2,1) = diag(JPSTC_correct,-4);
% 
% %positive diagonal 2 above main
% c(2:length(c)-1,4) = diag(JPSTC_correct,2);
% 
% %positive diagonal 4 above main
% c(3:length(c)-2,5) = diag(JPSTC_correct,4);
% 
% %cut matrix to exclude time points that have no values
% 
% diagonals = c(3:length(c)-2,1:5);
% diag_avg = mean(diagonals,2);