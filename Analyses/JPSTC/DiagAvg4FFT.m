%create average of 20 diagonals (every other one inclusive of main
%diagonal)
function [diag_avg] = DiagAvg4FFT(JPSTC)
diagonals(1:length(diag(JPSTC,0)),1:21) = NaN;
start = -10;
i = 1;

for lag = -20:2:20
    
    diagonals(abs(start)+1:length(diagonals)-abs(start),i) = diag(JPSTC,lag);
    start = start + 1;
    i = i + 1;
end

diag_avg = mean(diagonals(11:441,:),2);
