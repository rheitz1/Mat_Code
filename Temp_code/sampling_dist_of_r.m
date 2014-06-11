nSamps = 1000;
sampSize = 10;


for samp = 1:nSamps
    x = rand(1,sampSize);
    y = rand(1,sampSize);
    
    x = x';
    y = y';
    
    r(samp,1) = corr(x,y);
    
    clear x y
end


figure
hist(r,20)
mean(r)
clear r



% for samp = 1:nSamps
%     x = rand(1,sampSize);
%     y = rand(1,sampSize);
%     
%     x = x';
%     y = y';
%     
%     
%     covariance = cov(x,y,1);
%     covar = covariance(2,1);
%     std_x = std(x,1);
%     std_y = std(y,1);
%     
%     r_nocorrection(samp,1) = covar / (std_x * std_y);
% end
% 
% figure
% hist(r_nocorrection,20)
%mean(r)
%clear r