%create her distribution
VanZandtDist = [673;676;680;687;697;698;703;704;710;712;712;718;721;725;732;735;740;747;750;753;758;766;766;771;778;780;796;799;804;805;806;809;810;816;820;820;825;828;833;836;852;858;865;868;871;886;910;966;998;1016;];

%get the deciles, including 0 and 100
deciles = prctile(VanZandtDist,0:10:100);

%compute cumulative relative frequency
cumfreq = cumsum(histc(VanZandtDist,deciles) ./ length(VanZandtDist));

%plot her Figure 1
figure
plot(deciles,cumfreq,'bo')
ylim([0 1])

%note:  Her Figure 1 shows the first point (673) to have a CDF value of 0.  This does not seem right,
%since p(F(t) <= 673) = 1/50 == 0.20.
%
%But, to plot her actual Figure 1, you have:

figure
plot(prctile(VanZandtDist,0:10:100),0:.1:1,'bo')
ylim([0 1])