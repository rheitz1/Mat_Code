RT = 150:1000;
D = 500;
k = .5;

crt = D - k.*RT;
err = -k.*RT;


figure
plot(RT,crt,'b',RT,err,'r')