%find anti-RFs based on RF input
function anti_RF = getAntiRF(RF)

%============================
% NEW METHOD
anti_RF = mod(RF + 4,8);

%=============================
% OLD METHOD
% 
% index = 1;
% 
% if ismember(0,RF);
%     anti_RF(index) = 4;
%     index = index + 1;
% end
% 
% if ismember(1,RF)
%     anti_RF(index) = 5;
%     index = index + 1;
% end
% 
% if ismember(2,RF)
%     anti_RF(index) = 6;
%     index = index + 1;
% end
% 
% if ismember(3,RF)
%     anti_RF(index) = 7;
%     index = index + 1;
% end
% 
% if ismember(4,RF)
%     anti_RF(index) = 0;
%     index = index + 1;
% end
% 
% if ismember(5,RF)
%     anti_RF(index) = 1;
%     index = index + 1;
% end
% 
% if ismember(6,RF)
%     anti_RF(index) = 2;
%     index = index + 1;
% end
% 
% if ismember(7,RF)
%     anti_RF(index) = 3;
%     index = index + 1;
% end