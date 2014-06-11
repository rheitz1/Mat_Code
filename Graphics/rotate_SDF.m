writeVid = 1;

if writeVid
    V = VideoWriter('~/desktop/test.avi');
    open(V);
end

if isempty(who)
    load S032511001-RH_SEARCH
end

meshgrid_SDF

f_

bigfig
[X,Y] = meshgrid(Plot_Time(1):Plot_Time(2),1:8);

x = -100:800;
x = repmat(x,8,1);
y = (1:8)';
y = repmat(y,1,901);


Z = [p0 p1 p2 p3 p4 p5 p6 p7];
Z = Z';
z = Z;


plot3(x',y',z','k')
grid on
view(0,0)
xlim([-100 800])
zlim([0 120])
set(gca,'ytick',[0:7])
set(gca,'yticklabel',[0:7])
view(0,0)

%put a few frames in so the thumbnail will show first frame (hopefully)
if writeVid
    writeVideo(V,getframe(gcf));
    writeVideo(V,getframe(gcf));
    writeVideo(V,getframe(gcf));
end

a = linspace(0,-36,100);
b = linspace(0,56,100);

for rot = 1:100
    view(a(rot),b(rot))
    set(gca,'ytick',[0:7])
    set(gca,'yticklabel',[0:7])
    if writeVid
        writeVideo(V,getframe(gcf));
    end
end

%repeate a few times to make a 'pause'
for repeate = 1:25
    if writeVid
        writeVideo(V,getframe(gcf));
    end
end

surf(X,Y,Z,'edgecolor','none')
shading interp
xlim([-100 800])
zlim([0 120])

view(-36,56)

if writeVid
    writeVideo(V,getframe(gcf))
    writeVideo(V,getframe(gcf))
    writeVideo(V,getframe(gcf))
    close(V);
end