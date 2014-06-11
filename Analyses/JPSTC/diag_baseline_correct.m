function [base_corrected] = diag_baseline_correction(JPSTC_matrix)
%baseline correct each diagonal in JPSTC matrix
%for now, use 1st 1 ms of each diagonal.  Later, should use some average
%over time.

for d = -450:450
    temp =  diag(JPSTC_matrix,d);
    base(d + 451) = temp(1);
end

for d = -450:450
    %get new diagonal
    temp = diag(JPSTC_matrix,d);
    temp = temp - base(d + 451);

   JPSTC_matrix(diagind(length(JPSTC_matrix),d))= temp;
   base_corrected = JPSTC_matrix;
end