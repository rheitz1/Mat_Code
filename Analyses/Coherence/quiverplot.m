x = rad2deg(angle(Pcoh_all.in.all(:,:,2)));
r = ones(size(x));

[u,v] = pol2cart(x,r);


figure
imagesc(tout,f,x')
hold on

quiver(tout,f,u',v',0,'k')
axis xy
xlim([-50 200])
ylim([50 70])
colorbar


% %[x,y] = meshgrid(-2:.2:2, -2:.2:2); 
% 
% [x,y] = pol2cart(x,r)
% z = x .* exp(-x.^2 - y.^2); 
% [px,py] = gradient(z,.2,.2); 
% sz = sqrt(px.^2 + py.^2); % The length of each arrow. 
% pxx = px./sz; 
% pyy = py./sz; 
% contour(z), hold on 
% quiver(pxx,pyy,.5)