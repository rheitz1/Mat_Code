function [r]=exgrnd(m,s,t,c,l)
%
% Usage: DATA=EXGRND(MU,SIGMA,TAU,COLS,ROWS)
%
% MU    = Mean of Gaussian component
% SIGMA = S.D. of Gaussian component
% TAU   = Mean of Exponential component
% COLS  = Number of columns of resulting matrix
% ROWS  = Number of rows of resulting matrix
%
% Generates ex-Gaussian random numbers
% by summing numbers sampled from an exponential and Gaussian PDFs
% All arguments are scalars. 
%
%   See also EXGCDF, EXGPDF, EXGRND, EXGINV and EXGLIKE.


% Version 2.2 12/09/04
% Revised by Evan M. Palmer
%            BWH Visual Attention Laboratory
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu
%
% version 2.0 21/01/03
% (c) Yves Lacouture, Universit« Laval

if (t==0)           % Case of a normal variate
r=normrnd(m,s,c,l);
else
r=normrnd(m,s,c,l)+exprnd(t,c,l);
end
