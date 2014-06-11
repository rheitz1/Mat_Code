%sampling dist of log-normal
nSamps = 1000; %number of samples to draw from the population
N = 1000; %number of items per sample
Population_Size = 10000;

mu = .2;
sigma = 1;
x = 0:.01:10;

pop = lognrnd(mu,sigma,[Population_Size 1]);
lPDF = lognpdf(x,mu,sigma);
lPDF = logPDF / 100;

sample_space = 1:Population_Size;

for samp = 1:nSamps
    sample_space = shake(sample_space); %randomize indices
    sample = sample_space(1:N); %sample N cases
    
    samp_means(samp,1) = mean(pop(sample));
end


fig
subplot(2,1,1)
hist(pop,1000)
title(['Actual Population of N = ' mat2str(Population_Size)])
xlim([0 10])
newax
plot(x,lPDF,'r','linewidth',5)
xlim([0 10])
set(gca,'xtick',[])
set(gca,'ytick',[])
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])

subplot(2,1,2)

hist(samp_means,20)
title(['Sampling Distribution of ' mat2str(nSamps) 'means of N = ' mat2str(N)])
fon