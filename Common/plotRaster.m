function [] = plotRaster(Spike,trls,align)

% Old Method
% if nargin < 2
%     trls = 1:size(Spike,1);
% else
%     Spike = Spike(trls,:);
% end
% 
% %edit times
% Spike(find(Spike == 0)) = NaN;
% Spike = Spike - 500;
% Spike(find(Spike < -100)) = NaN;
% Spike(find(Spike > 500)) = NaN;
% 
% figure
% hold
% for trl = 1:length(trls)
%     if mod(trl,100) == 0
%         trl
%     end
%     plot(Spike(trl,:),trl,'k')
% end
if nargin < 3; align = 's'; end
if nargin < 2; trls = 1:size(Spike,1); end

Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');

Spike(find(Spike == 0)) = NaN;

if align == 's'
    Spike = Spike - Target_(1,1);
elseif align == 'r'
    Spike = Spike - repmat(SRT(:,1),1,size(Spike,2)) - Target_(1,1);
end

figure
plot(Spike(trls,:),1:length(trls),'k.')

if align == 's'
    xlim([-500 1000])
elseif align == 'r'
    xlim([-400 200]);
end