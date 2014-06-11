%plot similey (load from *_optimality)

x = devFire_all.in(find(devFire_all.in));
y = RTs_all.in(find(devFire_all.in));


%keep only firing rate deviations in some window
xbound = 75;
ybound = 700;

x = x(find(x >= -xbound | x <= xbound));
y = y(find(x >= -xbound | x <= xbound));

%keep only RTs < 600 ms
y = y(find(y <= ybound));
x = x(find(y <= ybound));

%fit 2nd order (quadratic) polynomial

[p S] = polyfit(x,y,2);

%get estimated Y values
est_times = -xbound:xbound;
[Y] = polyval(p,est_times,S);

figure
scatter(x,y)
hold
plot(est_times,Y,'k','linewidth',2)