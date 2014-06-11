% Transpose each level of a 3-d matrix (i.e., transposes each n x m matrix
% in the 3rd dimension)
% RPH

function [signal_out] = transpose3(signal_in)

if ndims(signal_in) ~= 3
    error('Matrix does not have 3 dimensions')
else

% NEW METHOD
    signal_out = permute(signal_in,[2 1 3]);
    
% OLD METHOD    
%     %transpose each level of the 3rd dimension
%     for level = 1:size(signal_in,3)
%         signal_out2(1:size(signal_in,2),1:size(signal_in,1),level) = signal_in(:,:,level)';
%     end
end