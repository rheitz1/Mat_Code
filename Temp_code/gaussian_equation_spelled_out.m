%equation for gaussian distribution

x = -10:.01:10; mu = 0; sigma = 1;


% from wikipedia
f = (1 / (sigma * sqrt(2*pi))) .* exp(-(  (x - mu).^2 ./ (2 * sigma^2)));

figure
plot(x,f,'r')
hold on

% from Matlab
y = exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
plot(x,y,'b')

