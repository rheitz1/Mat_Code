nTr = 1000;
sig_burst1 = zeros(nTr,1001);
sig_burst2 = zeros(nTr,1001);
anchor_time = 300; %where to start your jittering from
jit_range = 50; %what is the range -x:x of the jitter times



s40_1 = genSine(40);
s40_2 = genSine(40);

s40_1 = repmat(s40_1,nTr,1);
s40_2 = repmat(s40_2,nTr,1);

gamma = genSine(80);
gamma = gamma(1:200);

noise1 = rand(nTr,1001);
noise2 = rand(nTr,1001);

% amp1 = .5;
% amp2 = .5%.65;
% amp3 = .5%.32;
% amp4 = .5%.73;
% amp5 = .5%.46;




for trl = 1:nTr
    gamma_time = myrandint(1,1,[-jit_range:jit_range]);
   
    sig_burst1(trl,anchor_time + gamma_time : anchor_time + length(gamma)+gamma_time-1) = gamma;
    sig_burst2(trl,anchor_time + gamma_time : anchor_time + length(gamma)+gamma_time-1) = gamma;
end

%across signals add same amount of constant to create amplitude
%correlation and random jitter
% sig_burst1 = zeros(4,1001);
% sig_burst1(1,300:499) = gamma + amp1;
% sig_burst1(2,320:519) = gamma + amp2;
% sig_burst1(3,315:514) = gamma + amp3;
% sig_burst1(4,345:544) = gamma + amp4;
% sig_burst1(5,337:536) = gamma + amp5;
% sig_burst1(6,300:499) = gamma + amp1;
% sig_burst1(7,350:549) = gamma + amp2;
% sig_burst1(8,305:504) = gamma + amp3;
% sig_burst1(9,315:514) = gamma + amp4;
% sig_burst1(10,317:516) = gamma + amp5;
% 
% 
% sig_burst2 = zeros(4,1001);
% sig_burst2(1,304:503) = gamma + amp1;
% sig_burst2(2,312:511) = gamma + amp2;
% sig_burst2(3,324:523) = gamma + amp3;
% sig_burst2(4,325:524) = gamma + amp4;
% sig_burst2(5,300:499) = gamma + amp5;
% sig_burst2(6,354:553) = gamma + amp1;
% sig_burst2(7,312:511) = gamma + amp2;
% sig_burst2(8,324:523) = gamma + amp3;
% sig_burst2(9,325:524) = gamma + amp4;
% sig_burst2(10,300:499) = gamma + amp5;

sig1 = s40_1 + noise1 + sig_burst1;
sig2 = s40_2 + noise2 + sig_burst2;

tapers = PreGenTapers([.2 5]);

[coh, f, tout, Sx, Sy, Pcoh, PSx, PSy] = LFP_LFPCoh(sig1,sig2,tapers,1000, .01, [0 200], 0, -100, 0, 4, .05);
figure
imagesc(tout,f,abs(Pcoh'))
axis xy
colorbar


figure
subplot(1,2,1)
plot(1:1001,sig1(1,:))
hold
plot(1:1001,sig1(2,:)+10,'r')
plot(1:1001,sig1(3,:)-10,'g')
plot(1:1001,sig1(4,:)-20,'k')
plot(1:1001,sig1(5,:)+20,'m')
title('sig1')
xlim([1 1001])

subplot(1,2,2)
plot(1:1001,sig2(1,:))
hold
plot(1:1001,sig2(2,:)+10,'r')
plot(1:1001,sig2(3,:)-10,'g')
plot(1:1001,sig2(4,:)-20,'k')
plot(1:1001,sig2(5,:)+20,'m')
xlim([1 1001])