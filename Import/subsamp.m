function out =subsamp(X,n)
% function out =subsamp(X,n)
%
% Subsamples a given time series vector (or array). Keeps every nth sample of the
% vector (or array) X, starting over with teh first sample of each row of X
% if X is an array

[r c]=size(X);
rowsamps=ceil(c/n);
rowinds=[1:n:(rowsamps-1)*n+1];
out=zeros(r,rowsamps);
for irow=1:r
    out(irow,:)=X(irow,rowinds);
end