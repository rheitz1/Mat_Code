% PDF of the diffusion model
% from VanZandt (2000) p.463
%
% T0 is non-decision time
% a = absorbing boundary
% z = start point
% xi = noise?
% drift parameter sigma^2 is set to 0.1



function [F] = diffusionCDF(t,a,z,xi)

sigma = .1;

P = (  (exp(-2*( (xi*a) / sigma^2))) - exp(-2*( (xi*z) / sigma^2))  ) / (1-exp(-2*( (xi*a) / sigma^2) ));
k = -length(t)/2 : length(t)/2-1;


part1 = ( -exp( (-z * xi) / sigma^2)) / 2 * P;

part2 = sign(k) .* exp((  abs(xi) .* (z + 2 .* k .* a)  ) ./ sigma^2);

part3 = erf( (z + 2 .* k .* a + abs(xi) .* t) ./ ( sqrt(2 .* t .* sigma^2))) - 1;

part4 = sign(k) .* exp( (-abs(xi) .* ( z + 2 .* k .* a)) ./ sigma^2);

part5 = erf( ( (z + 2 .* k .* a) - (abs(xi) .* t) ) ./ ( sqrt(2 .* t .* sigma^2) ) ) - 1;


F = part1 .* ( (part2 .* part3) + (part4 .* part5)  );


error('Function not tested')