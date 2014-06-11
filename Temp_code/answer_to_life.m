x = rand(1000);
x(200:800,300:400) = x(200:800,300:400) * 2;
x(200:800,600:700) = x(200:800,600:700) * 2;
x(450:550,401:599) = x(450:550,401:599) * 2;

figure
imagesc(x)
axis off
set(gca,'clim',[0 2])
title('The Heitz Shall Inheret the Earth','fontsize',12,'fontweight','bold')
