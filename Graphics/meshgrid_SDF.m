if isempty(who)
    load S032511001-RH_SEARCH
end

allpos = plotSDF_screenloc('DSP11a');
sig = eval('DSP11a');
Plot_Time = [-100 800];
t_to_test = 750;


SDF = sSDF(sig,Target_(:,1),[Plot_Time(1) Plot_Time(2)]);

p0 = (nanmean(SDF(allpos.pos0,:)))';
p1 = (nanmean(SDF(allpos.pos1,:)))';
p2 = (nanmean(SDF(allpos.pos2,:)))';
p3 = (nanmean(SDF(allpos.pos3,:)))';
p4 = (nanmean(SDF(allpos.pos4,:)))';
p5 = (nanmean(SDF(allpos.pos5,:)))';
p6 = (nanmean(SDF(allpos.pos6,:)))';
p7 = (nanmean(SDF(allpos.pos7,:)))';


fig1
[X,Y] = meshgrid(Plot_Time(1):Plot_Time(2),1:8);
%Z = [p0 p1 p2 p3 p4 p5 p6 p7];
Z = [p0 p1 p2 p3 p4 p5 p6 p7];
Z = Z';
%surf(X,Y,Z,'edgecolor','none')
surf(X,Y,Z)

xlim([Plot_Time(1) Plot_Time(2)])
set(gca,'ytick',1:8)
set(gca,'yticklabel',0:7)
set(gca,'clim',[0 120])
shading interp
view(-36,56)
%colorbar 
zlim([0 120])



t.p0 = p0(abs(Plot_Time(1)) + t_to_test);
t.p1 = p1(abs(Plot_Time(1)) + t_to_test);
t.p2 = p2(abs(Plot_Time(1)) + t_to_test);
t.p3 = p3(abs(Plot_Time(1)) + t_to_test);
t.p4 = p4(abs(Plot_Time(1)) + t_to_test);
t.p5 = p5(abs(Plot_Time(1)) + t_to_test);
t.p6 = p6(abs(Plot_Time(1)) + t_to_test);
t.p7 = p7(abs(Plot_Time(1)) + t_to_test);


fig2
[X, Y] = meshgrid(-2:.01:2, -2:.01:2);
Z = exp(-X.^2-Y.^2);

Z0 = Z .* t.p0;
Z1 = Z .* t.p1;
Z2 = Z .* t.p2;
Z3 = Z .* t.p3;
Z4 = Z .* t.p4;
Z5 = Z .* t.p5;
Z6 = Z .* t.p6;
Z7 = Z .* t.p7;

fig2

surf([X-10 X-8 X X+8 X+10 X+8 X X-8],[Y Y+8 Y+10 Y+8 Y Y-8 Y-10 Y-8],[Z4 Z3 Z2 Z1 Z0 Z7 Z6 Z5])
shading interp;
view(-36,56)


[XX YY] = meshgrid(-20:20,-20:20);
ZZ = zeros(size(XX));
hold on;
surf(XX,YY,ZZ,'edgecolor','none')
%colorbar
set(gca,'clim',[0 120])
zlim([0 120])