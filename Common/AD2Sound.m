%turns AD channel into a sound that can be played

AD = baseline_correct(AD09,[400 500]);
AD = nanmean(AD);

%create a tone to integrate with AD
% wave = genSine(300,.1,1000,3001);
% 
% y = AD .* wave;
% 
% y = abs(y)*5000;
% 
% sound(y,1000)

wave = genSine(300,.1,1000,3001);

y = (abs(AD) .* abs(wave))*5000;
y = filtSig(y,100,'highpass');

sound(y,1000)


