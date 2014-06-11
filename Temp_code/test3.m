p=0.5;  
n = 1000;
y=[0 cumsum(2.*(rand(1,n-1)<=p)-1)]; % n steps
plot([0:n-1],y); 