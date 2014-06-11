%converts angles to approximate screen positions
%alpha should be input as angle in degrees, not radians.
function [pos] = ang2pos(alpha)

for trl = 1:length(alpha)
    
    if alpha(trl) > 337.5 || alpha(trl) <= 22.5
        pos(trl,1) = 0;
    elseif alpha(trl) > 22.5 && alpha(trl) <= 67.5
        pos(trl,1) = 1;
    elseif alpha(trl) > 67.5 && alpha(trl) <= 112.5
        pos(trl,1) = 2;
    elseif alpha(trl) > 112.5 && alpha(trl) <= 157.5
        pos(trl,1) = 3;
    elseif alpha(trl) > 157.5 && alpha(trl) <= 202.5
        pos(trl,1) = 4;
    elseif alpha(trl) > 202.5 && alpha(trl) <= 247.5
        pos(trl,1) = 5;
    elseif alpha(trl) > 247.5 && alpha(trl) <= 292.5
        pos(trl,1) = 6;
    elseif alpha(trl) > 292.5 && alpha(trl) <= 337.5
        pos(trl,1) = 7;
    else
        pos(trl,1) = NaN;
    end
end