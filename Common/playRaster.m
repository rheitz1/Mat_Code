function [] = playRaster(Spike,trl,TIME_WINDOW)

Target_ = evalin('caller','Target_');
EyeX_= evalin('caller','EyeX_'); %use just to figure out how long trials are in this mat file

%Fix spike train
Spike(find(Spike == 0)) = NaN;
Spike = Spike - Target_(1,1);

if nargin < 3; TIME_WINDOW = [-Target_(1,1) size(EyeX_,2)-Target_(1,1)-1]; end

if length(trl) > 1; error('Accepts only 1 trial'); end

contSpike = mySpk2Cont(Spike(trl,:),[TIME_WINDOW(1) TIME_WINDOW(2)],1000);
            
            
spikeSound = audioplayer(contSpike,1000);
play(spikeSound)

%need to wait for audioplayer to end. 
pause(length(TIME_WINDOW(1):TIME_WINDOW(2))/1000)