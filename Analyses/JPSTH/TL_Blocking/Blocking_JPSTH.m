%JPSTH for blocking
function [output] = Blocking_JPSTH(sig1,sig2)

Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');

plotFlag = 1;

ss2_rand = find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,6) == 3);
ss4_rand = find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,6) == 3);
ss8_rand = find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,6) == 3);
ss2_blk = find(Correct_(:,2) == 1 & Target_(:,6) == 0);
ss4_blk = find(Correct_(:,2) == 1 & Target_(:,6) == 1);
ss8_blk = find(Correct_(:,2) == 1 & Target_(:,6) == 2);

window = [-500 500];
binwidth = 5; %size of bins to count spikes
coinwidth = 20; %how many ms around main diagonal/2 do you want to average over

output.ss2_rand = getJPSTH(sig1,sig2,window,binwidth,coinwidth,ss2_rand,0);
output.ss4_rand = getJPSTH(sig1,sig2,window,binwidth,coinwidth,ss4_rand,0);
output.ss8_rand = getJPSTH(sig1,sig2,window,binwidth,coinwidth,ss8_rand,0);

output.ss2_blk = getJPSTH(sig1,sig2,window,binwidth,coinwidth,ss2_blk,0);
output.ss4_blk = getJPSTH(sig1,sig2,window,binwidth,coinwidth,ss4_blk,0);
output.ss8_blk = getJPSTH(sig1,sig2,window,binwidth,coinwidth,ss8_blk,0);


if plotFlag
    figure
    subplot(231)
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.ss2_rand.normalized_jpsth);
    axis xy
    title('SS2 Rand')
    %colorbar
    
    subplot(232)
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.ss4_rand.normalized_jpsth);
    axis xy
    title('SS4 Rand')
    %colorbar
    
    subplot(233)
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.ss8_rand.normalized_jpsth);
    axis xy
    title('SS8 Rand')
    %colorbar
    
    subplot(234)
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.ss2_blk.normalized_jpsth);
    axis xy
    title('SS2 Blocked')
    %colorbar
    
    subplot(235)
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.ss4_blk.normalized_jpsth);
    axis xy
    title('SS4 Blocked')
    %colorbar
    
    subplot(236)
    imagesc(window(1):binwidth:window(2),window(1):binwidth:window(2),output.ss8_blk.normalized_jpsth);
    axis xy
    title('SS8 Blocked')
    %colorbar
    

    equate_clim([1:3])
    equate_clim([4:6])
    
    subplot(231)
    colorbar
    subplot(232)
    colorbar
    subplot(233)
    colorbar
    subplot(234)
    colorbar
    subplot(235)
    colorbar
    subplot(236)
    colorbar
end