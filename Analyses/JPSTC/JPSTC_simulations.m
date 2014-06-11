%JPSTC simulation

%generate 401 ms of a 4Hz sine wave and cosine wave
t = 0:.0025:1;
s1 = sin(2*pi*5*t);
s2 = cos(2*pi*5*t);


noise1(1:300,1:401) = NaN;
noise2(1:300,1:401) = NaN;
sig1(1:300,1:401) = NaN;
sig2(1:300,1:401) = NaN;
%generate 300 trials
for trl = 1:300
    trl
    %generate correlated noise
    noise1(trl,1) = random('norm',0,.1);
    for noisetime = 2:401
        noise1(trl,noisetime) = noise1(trl,noisetime-1) + random('norm',0,.1);
    end
    
    noise2(trl,1:401) = noise1(trl,1:401) + random('norm',0,.1,1,401);

    sig1(trl,1:401) = s1 + noise1(trl,1:401);
    sig2(trl,1:401) = s2 + noise2(trl,1:401);
end


%

%correlogram
for trl = 1:size(sig1,1)
    cor(trl,1:401) = xcorr(sig1(trl,:),sig2(trl,:),200,'coeff');
end
% 
% %JPSTC
% JPSTC = corr(sig1,sig2);

plot(-200:200,nanmean(cor))