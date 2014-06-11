% PDF of the diffusion model
% from VanZandt (2000) p.463
%
% T0 is non-decision time
% a = absorbing boundary
% z = start point
% xi = noise?
% drift parameter sigma^2 is set to 0.1

function [f] = diffusionPDF(t,a,z,xi)

sigma = .1;

P = (  (exp(-2*( (xi*a) / sigma^2))) - exp(-2*( (xi*z) / sigma^2))  ) / (1-exp(-2*( (xi*a) / sigma^2) ));

%k = -.001:.0001:.001; %actually -inf:inf but that's not possible.
k = -length(t)/2 : length(t)/2-1;
part1 = 1/P;
part2_numerator = ( exp(-(((t.*xi + 2*z) * xi) / 2*sigma^2)));
part2_denominator = sqrt(2*pi*sigma^2.*t.^3);
part3 = sum(z + 2 * k * a);
part4 = exp(-(  (z + 2 .* k .* a).^2 ./ (2 .* t .* sigma^2)  ));


f = part1 .* ( part2_numerator ./ part2_denominator ) .* part3 .* part4;