% Computes correlation after removing NaNs from both vectors
%
% RPH

function [r p] = nancorr(array1,array2)

r_mat = [array1 array2];

r_mat = removeNaN(r_mat);

[r p] = corr(r_mat(:,1),r_mat(:,2));