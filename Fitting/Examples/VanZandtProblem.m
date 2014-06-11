VanZandtDist = [673;676;680;687;697;698;703;704;710;712;712;718;721;725;732;735;740;747;750;753;758;766;766;771;778;780;796;799;804;805;806;809;810;816;820;820;825;828;833;836;852;858;865;868;871;886;910;966;998;1016;];


%She plots it as:

deciles = prctile(VanZandtDist,[0:10:100]);

figure
plot(deciles,0:.1:1,'r')
ylim([0 1])
title('Van Zandt Plotting')

%Matlab agrees:
figure
cdfplot(VanZandtDist)


% What I have been doing:

%Given the definition of a CDF as P(X <= x), I have been plotting differently, since by definition the
%first observed value (here, 673) does not have a cumulative probability of 0, but rather 1/50 (there are
%50 data points in this distribution).

[counts,bins] = hist(VanZandtDist,11);

cdf = cumsum(counts) ./ length(VanZandtDist);
figure
plot(bins,cdf)
ylim([0 1])
title('My Way')


%%Plot together

figure
plot(deciles,0:.1:1,'r',bins,cdf,'b')