function [ang dist size] = getVisAngle(ang,dist,size)

% Returns the unknown value: 
% ang = visual angle (size of objective stimulus on retina)
% dist = stimulus-to-eye distance
% size = size of physical stimulus in x or y dimension

% Enter '?' for the unknown value


error('Script not correct yet')

if ang == '?'
    ang = rad2deg( 2 * atan( (size / (2*dist)) ));
    disp(['Objective Size: ' mat2str(roundoff(size,2)) ' cm'])
    disp(['Distance: ' mat2str(roundoff(dist,2)) ' cm'])
    disp(['Retinal Size: ' mat2str(roundoff(ang,2)) ' degrees'])
    
elseif dist == '?'
    %dist = (size*.5) / tan(deg2rad(ang));
    dist = (size/2) / (tan(deg2rad(ang) / 2));
    
    disp(['Objective Size: ' mat2str(roundoff(size,2)) ' cm'])
    disp(['Distance: ' mat2str(roundoff(dist,2)) ' cm'])
    disp(['Retinal Size: ' mat2str(roundoff(ang,2)) ' degrees'])
    
elseif size == '?'
    size = tan(deg2rad(ang) / 2) * (dist*2);
    
    %size = 2 * atan(   tan(deg2rad(ang)) * dist;
    disp(['Objective Size: ' mat2str(roundoff(size,2)) ' cm'])
    disp(['Distance: ' mat2str(roundoff(dist,2)) ' cm'])
    disp(['Retinal Size: ' mat2str(roundoff(ang,2)) ' degrees'])
else
    error('Invalid or missing inputs.')
end

