% Calculate parameter relative 'importance'
% From Posada & Buckley, 2004
%
% RPH

% runs on SESSION or POPULATION fits
%calculate sum of LL's of all models that allwed parameter to be free.  Not including fixNONE or fixALL
%because they will just add to all of the importance weights.

if max(structfun(@length,LL)) > 1 %session fits: sum LL's
    w.A = sum(LL.fixb) + sum(LL.fixv) + sum(LL.fixT0) + sum(LL.fixbv) + sum(LL.fixbT0) + sum(LL.fixvT0) + ...
        sum(LL.fixbvT0);
    
    w.b = sum(LL.fixA) + sum(LL.fixv) + sum(LL.fixT0) + sum(LL.fixAv) + sum(LL.fixAT0) + sum(LL.fixvT0) + ...
        sum(LL.fixAvT0);
    
    w.v = sum(LL.fixA) + sum(LL.fixb) + sum(LL.fixT0) + sum(LL.fixAb) + sum(LL.fixAT0) + sum(LL.fixbT0) + ...
        sum(LL.fixAbT0);
    
    w.T0 = sum(LL.fixA) + sum(LL.fixb) + sum(LL.fixv) + sum(LL.fixAb) + sum(LL.fixAv) + sum(LL.fixbv) + ...
        sum(LL.fixAbv);
    
else %are population fits.  No need to sum
    
    w.A = LL.fixb + LL.fixv + LL.fixT0 + LL.fixbv + LL.fixbT0 + LL.fixvT0 + ...
        LL.fixbvT0;
    
    w.b = LL.fixA + LL.fixv + LL.fixT0 + LL.fixAv + LL.fixAT0 + LL.fixvT0 + ...
        LL.fixAvT0;
    
    w.v = LL.fixA + LL.fixb + LL.fixT0 + LL.fixAb + LL.fixAT0 + LL.fixbT0 + ...
        LL.fixAbT0;
    
    w.T0 = LL.fixA + LL.fixb + LL.fixv + LL.fixAb + LL.fixAv + LL.fixbv + ...
        LL.fixAbv;
    
end