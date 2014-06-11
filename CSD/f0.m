function out0 = f0(zeta,zj,diam,cond)
  out0 = 1./(2.*cond).*(sqrt((diam/2)^2+((zj-zeta)).^2)-abs(zj-zeta));
return;

