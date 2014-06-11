% call to "sphere" generates unit sphere (radius == 1; diameter == 2) centered at 0
% sphere(n) specified how many points within (resolution)
% Format: (view brain from overhead)
%   X = Medial-Lateral
%   Y = Dorsal-Ventral
%   Z = Anterior-Posterior
function [] = brain_sphere()


a =     [0 3   14 15  -1 0]; %p. 229
b =     [0 5   13 16   0 0]; %p. 228
c =     [0 6   13 17   1 0]; %p. 227
d =     [0 6   16 18   2 0]; %p. 226
e =     [3 6   13 16   3 0]; %p. 225

align_slice(a);
align_slice(b);
align_slice(c);
align_slice(d);
align_slice(e);



    function [X,Y,Z] = align_slice(coord)
        [ML(1) ML(2) DV(1) DV(2) AP(1) AP(2)] = disperse(coord);
        %ML DV are approximate coordinate extents estimated from macaque atlas. AP is a scalar indicating the A-P
        %slice from the coronal sections
        %
        %E.g., if the ML coordinate of a region range from ~0-5, enter [0 5].
        
        %create unit cylinder. Default is 20 unit resolution
        [x y z] = cylinder;
        
        %what is ML size?
        sizeML = abs(max(ML) - min(ML));
        sizeDV = abs(max(DV) - min(DV));
        
        X = x .* sizeML/2 + sizeML/2;
        Y = y .* sizeDV/2 + sizeDV/2;
        
        Z(1,1:length(z)) = AP(1)-.5;
        Z(2,1:length(z)) = AP(1)+.5;
        
        
        %Note: am switching these up for plotting purposes.
        hold on
        surf(X,Z,Y)
        xlabel('ML')
        ylabel('AP')
        zlabel('DV')
    end

end

[x,y,z] = ellipsoid(0,0,0,36,16+60,49+25)

fig
surf(x,y-16,z-25)