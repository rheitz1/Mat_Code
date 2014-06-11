%parametric test to determine if variance of angles is different between
%two samples.  Just a variance ratio F test.
%
% RPH (1/6/2010)

function [pval F] = circ_disptest(ang1,ang2)

% R1 = circ_r(ang1);
% R2 = circ_r(ang2);
n1 = length(ang1);
n2 = length(ang2);
% 
% r = (R1 + R2) / (n1 + n2);
% 
% F = ( (n2-1)*(n1-R1) )  /  ( (n1-1)*(n2-R2) );

%can just make this a variance ratio test

var1 = circ_var(ang1);
var2 = circ_var(ang2);
vars = [var1 var2];

F = min(vars) / max(vars);

pval = 1 - fpdf(F,(n1-1),(n2-1));