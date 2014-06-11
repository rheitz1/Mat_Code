% filter parameters:
gauss_sigma = 0.1 * 1e-3;
filter_range = 5 * gauss_sigma;

% electrical parameters:
cond = 0.3;     %lower layer conductance
cond_top = 0.3; %upper layer conductance
dt = 1;       %diameter

% size, potential (m1 has to equal number of electrode contacts)
[m1 , m2] = size(signal);

% geometrical parameters:
diam = 0.5 * 1e-3;
%el_pos = 0.1:0.2:3.2;
el_pos = 0.1:0.2:1.4;
el_pos = el_pos .* 1e-3;

% compute spline iCSD:
Fcs = F_cubic_spline(el_pos,diam,cond,cond_top);
[zs,CSD_cs] = make_cubic_splines(el_pos,signal,Fcs);

%Gaussian_filtering
[zs,CSD_cs]=gaussian_filtering(zs,CSD_cs,gauss_sigma,filter_range);

% plot CSD
plot_CSD(CSD_cs,zs,dt,1,0) %length(el_pos) must equal rows of CSD! 




